//
//  AppDIContainer.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import Swinject
import UIKit
import CoreData

final class AppDIContainer {
    
    static let shared = AppDIContainer()
    let container: Container
    
    private init() {
        container = Container()
        registerDependencies()
    }
    
    private func registerDependencies() {
// MARK: - Сервисы
        container.register(MovieServiceProtocol.self) { _ in
            MovieService()
        }
        
        container.register(FavoriteMovieStoring.self) { _ in
            CoreDataService()
        }
        
// MARK: - Search Module
        container.register(SearchInteractorProtocol.self) { resolver in
            let service = resolver.resolve(MovieServiceProtocol.self)!
            let favoriteService = resolver.resolve(FavoriteMovieStoring.self)!
            return SearchInteractor(service: service, favoriteService: favoriteService)
        }
        
        container.register(SearchRouterProtocol.self) { _ in
            SearchRouter()
        }
        
// MARK: - Favorites Module
        container.register(FavoritesInteractorProtocol.self) { resolver in
            let storage = resolver.resolve(FavoriteMovieStoring.self)!
            return FavoritesInteractor(storage: storage)
        }
        
        container.register(FavoritesRouterProtocol.self) { _ in
            FavoritesRouter()
        }
    }

// MARK: - Вспомогательные методы для получения VC
    func resolveSearchInteractor() -> SearchInteractorProtocol {
        container.resolve(SearchInteractorProtocol.self)!
    }
    
    func resolveFavoritesInteractor() -> FavoritesInteractorProtocol {
        container.resolve(FavoritesInteractorProtocol.self)!
    }
    
    func resolveSearchRouter() -> SearchRouterProtocol {
        container.resolve(SearchRouterProtocol.self)!
    }
    
    func resolveFavoritesRouter() -> FavoritesRouterProtocol {
        container.resolve(FavoritesRouterProtocol.self)!
    }
    
    func resolveFavoriteStorage() -> FavoriteMovieStoring {
        container.resolve(FavoriteMovieStoring.self)!
    }
}


