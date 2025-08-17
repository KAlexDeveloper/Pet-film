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
    private let errorHandler: ErrorHandlerProtocol
    
    init(interactor: FavoritesInteractorProtocol,
         router: FavoritesRouterProtocol,
         errorHandler: ErrorHandlerProtocol) {   
        self.interactor = interactor
        self.router = router
        self.errorHandler = errorHandler
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(favoritesDidChange),
            name: .favoritesDidChange,
            object: nil
        )
    }
    
    func viewDidLoad() {
        interactor.fetchFavorites()
    }
    
    func didSelectMovie(_ movie: FavoriteMovieEntity) {
        router.openDetail(for: movie)
    }
    
    func toggleFavorite(movie: Movie) {
        interactor.toggleFavorite(movie: movie)
    }
    
    @objc private func favoritesDidChange() {
        interactor.fetchFavorites()
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
