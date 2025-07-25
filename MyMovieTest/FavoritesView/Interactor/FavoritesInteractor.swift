//
//  FavoritesInteractorProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 17.07.2025.
//


// MARK: - Interactor Protocol
protocol FavoritesInteractorProtocol: AnyObject {
    func fetchFavorites()
}

// MARK: - Interactor Output Protocol
protocol FavoritesInteractorOutputProtocol: AnyObject {
    func didLoadFavorites(_ movies: [FavoriteMovieEntity])
}

final class FavoritesInteractor: FavoritesInteractorProtocol {
    weak var output: FavoritesInteractorOutputProtocol?
    private let storage: FavoriteMovieStoring

    init(storage: FavoriteMovieStoring) {
        self.storage = storage
    }

    func fetchFavorites() {
        let items = storage.fetchAll()
        output?.didLoadFavorites(items)
    }
}


