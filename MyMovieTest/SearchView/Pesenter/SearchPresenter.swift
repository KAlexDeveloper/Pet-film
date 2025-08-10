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
    
    init(interactor: SearchInteractorProtocol, router: SearchRouterProtocol, favoriteService: FavoriteMovieStoring) {
        self.interactor = interactor
        self.router = router
        self.favoriteService = favoriteService
    }
}

extension SearchPresenter: SearchPresenterProtocol {
    
    func searchButtonTapped(with query: String) {
        view?.showLoading()
        Task {
            await interactor.searchMovies(query: query)
        }
        print("Presenter получил запрос: \(query)")
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
    }
    
    func isFavorite(id: Int) -> Bool {
        favoriteService.isFavorite(id: id)
    }
}

extension SearchPresenter: SearchInteractorOutputProtocol {
    func didReceiveMovies(_ movies: [Movie]) {
        print("Presenter: получены фильмы, скрываем loader")
        view?.hideLoading()
        view?.showMovies(movies)
    }
    
    func didFailToReceiveMovies(_ error: Error) {
        print("Presenter: ошибка \(error.localizedDescription), скрываем loader")
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
}
