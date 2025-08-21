//
//  DetailInteractorProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 21.08.2025.
//


import Foundation
import UIKit

protocol DetailInteractorOutputProtocol: AnyObject {
    func didReceiveMovieDetails(_ movie: Movie)
    func didFailToReceiveMovieDetails(_ error: Error)
    func didReceivePoster(_ image: UIImage?)
}

protocol DetailInteractorProtocol: AnyObject {
    var output: DetailInteractorOutputProtocol? { get set }
    func fetchMovieDetails(id: Int) async
    func fetchPoster(url: String) async
}

final class DetailInteractor: DetailInteractorProtocol {
    weak var output: DetailInteractorOutputProtocol?
    private let service: MovieServiceProtocol
    
    init(service: MovieServiceProtocol) {
        self.service = service
    }
    
    func fetchMovieDetails(id: Int) async {
        do {
            let movie = try await service.fetchMovieDetails(id: id)
            await MainActor.run {
                output?.didReceiveMovieDetails(movie)
            }
        } catch {
            await MainActor.run {
                output?.didFailToReceiveMovieDetails(error)
            }
        }
    }
    
    func fetchPoster(url: String) async {
        guard let url = URL(string: url) else {
            await MainActor.run {
                output?.didReceivePoster(nil)
            }
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let image = UIImage(data: data)
            await MainActor.run {
                output?.didReceivePoster(image)
            }
        } catch {
            await MainActor.run {
                output?.didReceivePoster(nil)
            }
        }
    }
}
