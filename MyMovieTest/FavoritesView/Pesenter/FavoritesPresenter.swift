//
//  FavoritesPresenterProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 17.07.2025.
//


protocol FavoritesPresenterProtocol: AnyObject {
    func viewDidLoad()
}

final class FavoritesPresenter: FavoritesPresenterProtocol {
    weak var view: FavoritesViewProtocol?

    func viewDidLoad() {
        view?.showEmptyMessage()
    }
}