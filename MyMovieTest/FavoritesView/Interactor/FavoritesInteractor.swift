//
//  FavoritesInteractorProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 17.07.2025.
//
import Foundation

protocol FavoritesInteractorOutputProtocol: AnyObject {
    func didLoadFavorites(_ movies: [FavoriteMovieEntity])
}

protocol FavoritesInteractorProtocol: AnyObject {
    var output: FavoritesInteractorOutputProtocol? { get set }
    func fetchFavorites()
    func toggleFavorite(movie: Movie)
}

final class FavoritesInteractor: FavoritesInteractorProtocol {
    weak var output: FavoritesInteractorOutputProtocol?
    private let storage: FavoriteMovieStoring
    
    init(storage: FavoriteMovieStoring) {
        self.storage = storage
    }
    
    func fetchFavorites() {
        // Получаем из хранилища (Core Data)
        let items = storage.fetchAll()
        // Возвращаем результат в main thread
        DispatchQueue.main.async { [weak self] in
            self?.output?.didLoadFavorites(items)
        }
    }
    func toggleFavorite(movie: Movie) {
        if storage.isFavorite(id: movie.id) {
            storage.delete(by: movie.id)
        } else {
            storage.save(movie: movie)
        }
        // уведомляем всех, что избранное изменилось
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
        
        fetchFavorites()
    }
}
