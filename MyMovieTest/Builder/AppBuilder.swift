//
//  SearchBuilder.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

//import UIKit
//
//final class SearchBuilder {
//    static func build() -> UIViewController {
//        let container = AppDIContainer.shared.container
//
//        let view = SearchViewController()
//
//        guard let interactor = container.resolve(SearchInteractorProtocol.self) as? SearchInteractor,
//              let router = container.resolve(SearchRouterProtocol.self) as? SearchRouter else {
//            fatalError("Не удалось разрешить зависимости")
//        }
//
//        // Создаем презентер руками!!!
//        let presenter = SearchPresenter(interactor: interactor, router: router)
//        presenter.view = view
//        interactor.output = presenter
//        router.viewController = view
//        view.presenter = presenter
//
//        return view
//    }
//}
import UIKit

final class AppBuilder {
    
    static func buildSearch() -> UIViewController {
        let container = AppDIContainer.shared.container
        let view = SearchViewController()

        guard let interactor = container.resolve(SearchInteractorProtocol.self) as? SearchInteractor,
              let router = container.resolve(SearchRouterProtocol.self) as? SearchRouter,
              let favoriteService = container.resolve(FavoriteMovieStoring.self) else {
            fatalError("Не удалось разрешить зависимости")
        }

        let presenter = SearchPresenter(interactor: interactor, router: router, favoriteService: favoriteService)
        presenter.view = view
        interactor.output = presenter
        router.viewController = view
        view.presenter = presenter

        return view
    }
    
    static func buildFavorites() -> UIViewController {
        let container = AppDIContainer.shared.container
        
        let view = FavoritesViewController()
        
        guard let interactor = container.resolve(FavoritesInteractorProtocol.self) as? FavoritesInteractor,
              let router = container.resolve(FavoritesRouterProtocol.self) as? FavoritesRouter else {
            fatalError("Не удалось разрешить зависимости для Favorites")
        }
        
        let presenter = FavoritesPresenter(interactor: interactor, router: router)
        presenter.view = view
        interactor.output = presenter
        router.viewController = view
        view.presenter = presenter
        
        return view
    }
}
