//
//  SearchBuilder.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import UIKit

final class AppBuilder {
    
    static func buildSearch() -> UIViewController {
        let view = SearchViewController()
        let container = AppDIContainer.shared
        
        // Получаем зависимости из контейнера
        let interactor = container.resolveSearchInteractor()
        let router = container.resolveSearchRouter()
        let favoriteService = container.resolveFavoriteStorage()
        let errorHandler = container.container.resolve(ErrorHandlerProtocol.self)!
        
        // Создаём презентер вручную
        let presenter = SearchPresenter(
            interactor: interactor,
            router: router,
            favoriteService: favoriteService,
            errorHandler: errorHandler
        )
        presenter.view = view
        
        // Соединяем компоненты
        if let interactor = interactor as? SearchInteractor {
            interactor.output = presenter
        }
        if let router = router as? SearchRouter {
            router.viewController = view
        }
        view.presenter = presenter
        
        return view
    }
    
    static func buildFavorites() -> UIViewController {
        let view = FavoritesViewController()
        let container = AppDIContainer.shared
        
        // Получаем зависимости из контейнера
        let interactor = container.resolveFavoritesInteractor()
        let router = container.resolveFavoritesRouter()
        let errorHandler = container.container.resolve(ErrorHandlerProtocol.self)!
        
        // Создаём презентер вручную
        let presenter = FavoritesPresenter(
            interactor: interactor,
            router: router,
            errorHandler: errorHandler
        )
        presenter.view = view
        
        // Соединяем компоненты
        if let interactor = interactor as? FavoritesInteractor {
            interactor.output = presenter
        }
        if let router = router as? FavoritesRouter {
            router.viewController = view
        }
        view.presenter = presenter
        
        return view
    }
    
    static func buildDetail(movieId: Int) -> UIViewController {
        let view = DetailViewController()
        let container = AppDIContainer.shared
        
        // Получаем зависимости из контейнера
        let interactor = container.resolveDetailInteractor()
        let router = container.resolveDetailRouter()
        let errorHandler = container.container.resolve(ErrorHandlerProtocol.self)!
        
        // Создаём презентер вручную
        let presenter = DetailPresenter(
            interactor: interactor,
            router: router,
            errorHandler: errorHandler,
            movieId: movieId
        )
        presenter.view = view
        
        // Соединяем компоненты
        if let interactor = interactor as? DetailInteractor {
            interactor.output = presenter
        }
        if let router = router as? DetailRouter {
            router.viewController = view
        }
        view.presenter = presenter
        
        return view
    }
}
