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
        
        container.register(ErrorHandlerProtocol.self) { _ in
            ErrorHandler()
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
        
        // MARK: - Detail Module
        container.register(DetailInteractorProtocol.self) { resolver in
            let service = resolver.resolve(MovieServiceProtocol.self)!
            return DetailInteractor(service: service)
        }
        
        container.register(DetailRouterProtocol.self) { _ in
            DetailRouter()
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
    
    // MARK: - Detail
    func resolveDetailInteractor() -> DetailInteractorProtocol {
        container.resolve(DetailInteractorProtocol.self)!
    }
    
    func resolveDetailRouter() -> DetailRouterProtocol {
        container.resolve(DetailRouterProtocol.self)!
    }
    
}
