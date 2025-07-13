//
//  SearchInteractor.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import Foundation

protocol SearchInteractorProtocol: AnyObject {
    func searchMovies(query: String) async
}
protocol SearchInteractorOutputProtocol: AnyObject {
    func didReceiveMovies(_ movies: [Movie])
    func didFailToReceiveMovies(_ error: Error)
}

final class SearchInteractor: SearchInteractorProtocol {
    weak var output: SearchInteractorOutputProtocol?
    private let service: MovieServiceProtocol
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func searchMovies(query: String) async {
        do {
            let movies = try await service.searchMovies(query: query, page: 1, limit: 10 )
            await MainActor.run {
                output?.didReceiveMovies(movies)
            }
            print("Movies получены: \(movies.count)")
        } catch {
            await MainActor.run {
                output?.didFailToReceiveMovies(error)
            }
            print("Ошибка: \(error.localizedDescription)")
        }
    }
}
