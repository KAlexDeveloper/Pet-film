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
        
        // Создаём презентер вручную
        let presenter = SearchPresenter(interactor: interactor, router: router, favoriteService: favoriteService)
        presenter.view = view
        
        // Соединяем компоненты
        interactor.output = presenter
        router.viewController = view
        view.presenter = presenter
        
        return view
    }
    
    static func buildFavorites() -> UIViewController {
        let view = FavoritesViewController()
        let container = AppDIContainer.shared
        
        // Получаем зависимости из контейнера
        let interactor = container.resolveFavoritesInteractor()
        let router = container.resolveFavoritesRouter()
        
        // Создаём презентер вручную
        let presenter = FavoritesPresenter(interactor: interactor, router: router)
        presenter.view = view
        
        // Соединяем компоненты
        interactor.output = presenter
        router.viewController = view
        view.presenter = presenter
        
        return view
    }
}

