//
//  SearchInteractor.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import Foundation

protocol SearchInteractorProtocol: AnyObject {
    func searchMovies(query: String) async
    var output: SearchInteractorOutputProtocol? { get set }
}

protocol SearchInteractorOutputProtocol: AnyObject {
    func didReceiveMovies(_ movies: [Movie])
    func didFailToReceiveMovies(_ error: Error)
    func favoritesDidChange() 
}

final class SearchInteractor: SearchInteractorProtocol {
    weak var output: SearchInteractorOutputProtocol?
    private let service: MovieServiceProtocol
    private let favoriteService: FavoriteMovieStoring
    
    init(service: MovieServiceProtocol,
         favoriteService: FavoriteMovieStoring) {
        self.service = service
        self.favoriteService = favoriteService
        
        // Подписка на изменения избранного
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChangeNotification),
            name: .favoritesDidChange,
            object: nil
        )
    }
    
    func searchMovies(query: String) async {
        do {
            let movies = try await service.searchMovies(query: query)
            await MainActor.run {
                output?.didReceiveMovies(movies)
            }
        } catch {
            await MainActor.run {
                output?.didFailToReceiveMovies(error)
            }
        }
    }
    
    @objc private func favoritesDidChangeNotification() {
        DispatchQueue.main.async { [weak self] in
            self?.output?.favoritesDidChange()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
