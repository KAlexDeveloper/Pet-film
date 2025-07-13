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
}

final class SearchPresenter {
    weak var view: SearchViewProtocol?
    private let interactor: SearchInteractorProtocol
    private let router: SearchRouterProtocol
    
    init(view: SearchViewProtocol?, interactor: SearchInteractorProtocol, router: SearchRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
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
