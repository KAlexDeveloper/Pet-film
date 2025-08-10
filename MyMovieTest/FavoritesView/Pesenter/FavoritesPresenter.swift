//
//  FavoritesPresenterProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 17.07.2025.
//

import Foundation

protocol FavoritesPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didSelectMovie(_ movie: FavoriteMovieEntity)
    func toggleFavorite(movie: Movie)
}

final class FavoritesPresenter: FavoritesPresenterProtocol {
    weak var view: FavoritesViewProtocol?
    private let interactor: FavoritesInteractorProtocol
    private let router: FavoritesRouterProtocol
    
    init(interactor: FavoritesInteractorProtocol, router: FavoritesRouterProtocol) {
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        interactor.fetchFavorites()
    }
    
    func didSelectMovie(_ movie: FavoriteMovieEntity) {
        router.openDetail(for: movie)
    }
    
    func toggleFavorite(movie: Movie) {
        interactor.toggleFavorite(movie: movie)
        // interactor.fetchFavorites() вызывается внутри toggleFavorite -> при завершении output вернёт новые данные
    }
}

extension FavoritesPresenter: FavoritesInteractorOutputProtocol {
    func didLoadFavorites(_ movies: [FavoriteMovieEntity]) {
        if movies.isEmpty {
            view?.showEmptyMessage()
        } else {
            view?.show(favorites: movies)
        }
    }
}
