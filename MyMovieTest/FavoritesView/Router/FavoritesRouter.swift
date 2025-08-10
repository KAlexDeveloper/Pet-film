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
        // Здесь будет переход к Detail-модулю
        // Например:
        // let detailVC = DetailBuilder.build(with: movie.id)
        // viewController?.navigationController?.pushViewController(detailVC, animated: true)
    }
}
