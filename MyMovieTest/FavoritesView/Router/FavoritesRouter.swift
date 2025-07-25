//
//  FavoritesRouterProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 17.07.2025.
//

import UIKit

protocol FavoritesRouterProtocol: AnyObject {
    func openDetail(for movie: FavoriteMovieEntity)
}

final class FavoritesRouter: FavoritesRouterProtocol {
    weak var viewController: UIViewController?

    func openDetail(for movie: FavoriteMovieEntity) {
        print("Открыть детали для фильма: \(movie.title ?? "")")
        // Здесь будет переход к Detail-модулю
    }
}
