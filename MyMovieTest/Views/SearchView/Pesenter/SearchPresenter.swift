//
//  SearchPresenter.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import Foundation

protocol SearchPresenterProtocol: AnyObject {
    func searchButtonTapped(with query: String)
    func didSelectMovie(_ movie: Movie)
    func toggleFavorite(movie: Movie)
    func isFavorite(id: Int) -> Bool
}

final class SearchPresenter {
    weak var view: SearchViewProtocol?
    private let interactor: SearchInteractorProtocol
    private let router: SearchRouterProtocol
    private let favoriteService: FavoriteMovieStoring
    private let errorHandler: ErrorHandlerProtocol
    
    init(interactor: SearchInteractorProtocol,
         router: SearchRouterProtocol,
         favoriteService: FavoriteMovieStoring,
         errorHandler: ErrorHandlerProtocol) {
        self.interactor = interactor
        self.router = router
        self.favoriteService = favoriteService
        self.errorHandler = errorHandler
    }
}

extension SearchPresenter: SearchPresenterProtocol {
    func searchButtonTapped(with query: String) {
        view?.showLoading()
        Task {
            await interactor.searchMovies(query: query)
        }
    }
    
    func didSelectMovie(_ movie: Movie) {
        router.openDetail(for: movie)
    }
    
    func toggleFavorite(movie: Movie) {
        if favoriteService.isFavorite(id: movie.id) {
            favoriteService.delete(by: movie.id)
        } else {
            favoriteService.save(movie: movie)
        }
        NotificationCenter.default.post(name: .favoritesDidChange, object: nil)
    }
    
    func isFavorite(id: Int) -> Bool {
        favoriteService.isFavorite(id: id)
    }
}

extension SearchPresenter: SearchInteractorOutputProtocol {
    func didReceiveMovies(_ movies: [Movie]) {
        view?.hideLoading()
        view?.showMovies(movies)
    }
    
    func didFailToReceiveMovies(_ error: Error) {
        view?.hideLoading()
        let message = errorHandler.message(for: error)
        view?.showError(message)
    }
    
    func favoritesDidChange() {
        // Просто перерисовываем коллекцию
        if let vc = view as? SearchViewController {
            vc.collectionView.reloadData()
        }
    }
}
