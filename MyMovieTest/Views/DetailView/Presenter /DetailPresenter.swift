//
//  DetailPresenterProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 21.08.2025.
//


import Foundation
import UIKit

protocol DetailPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapBack()
}

final class DetailPresenter {
    weak var view: DetailViewProtocol?
    private let interactor: DetailInteractorProtocol
    private let router: DetailRouterProtocol
    private let errorHandler: ErrorHandlerProtocol
    private let movieId: Int
    
    init(
        interactor: DetailInteractorProtocol,
        router: DetailRouterProtocol,
        errorHandler: ErrorHandlerProtocol,
        movieId: Int
    ) {
        self.interactor = interactor
        self.router = router
        self.errorHandler = errorHandler
        self.movieId = movieId
    }
}

extension DetailPresenter: DetailPresenterProtocol {
    func viewDidLoad() {
        Task {
            await interactor.fetchMovieDetails(id: movieId)
        }
    }
    
    func didTapBack() {
        router.popViewController()
    }
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func didReceiveMovieDetails(_ movie: Movie) {
        view?.showMovieDetails(movie)
        
        if let posterUrl = movie.posterUrl, !posterUrl.isEmpty {
            Task { await interactor.fetchPoster(url: posterUrl) }
        } else {
            view?.updatePoster(nil)
        }
    }
    
    func didFailToReceiveMovieDetails(_ error: Error) {
        let message = errorHandler.message(for: error)
        view?.showError(message)
    }
    
    func didReceivePoster(_ image: UIImage?) {
        view?.updatePoster(image)
    }
}

