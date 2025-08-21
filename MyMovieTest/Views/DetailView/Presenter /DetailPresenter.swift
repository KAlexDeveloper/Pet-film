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
}

final class DetailPresenter {
    weak var view: DetailViewProtocol?
    private let interactor: DetailInteractorProtocol
    private let errorHandler: ErrorHandlerProtocol
    private let movieId: Int
    
    init(interactor: DetailInteractorProtocol,
         errorHandler: ErrorHandlerProtocol,
         movieId: Int) {
        self.interactor = interactor
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
}

extension DetailPresenter: DetailInteractorOutputProtocol {
    func didReceiveMovieDetails(_ movie: Movie) {
        view?.showMovieDetails(movie)
        
        if let posterUrl = movie.posterUrl {
            Task {
                await interactor.fetchPoster(url: posterUrl)
            }
        } else {
            view?.updatePoster(nil) // если постера нет → заглушка
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
