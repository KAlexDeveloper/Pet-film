//
//  FavoritesRouterProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 17.07.2025.
//

import UIKit

protocol FavoritesRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    func openDetail(for movie: FavoriteMovieEntity)
}

final class FavoritesRouter: FavoritesRouterProtocol {
    weak var viewController: UIViewController?
    
    func openDetail(for movie: FavoriteMovieEntity) {
        print("Открыть детали для фильма: \(movie.title ?? "")")
        // переход к Detail-модулю
        let detailVC = AppBuilder.buildDetail(movieId: Int(movie.id)) // id уже Int
        viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
