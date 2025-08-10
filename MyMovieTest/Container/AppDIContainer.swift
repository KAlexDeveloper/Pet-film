//
//  AppDIContainer.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import Swinject

final class AppDIContainer {
    
    static let shared = AppDIContainer()
    let container: Container
    
    private init() {
        container = Container()
        registerDependencies()
    }
    
    private func registerDependencies() {
        // ✅ Регистрация сервиса
        container.register(MovieServiceProtocol.self) { _ in
            MovieService()
        }
        
        // ✅ Регистрация интерактора Search
        container.register(SearchInteractorProtocol.self) { resolver in
            let service = resolver.resolve(MovieServiceProtocol.self)!
            return SearchInteractor(service: service)
        }
        
        // ✅ Регистрация роутера Search
        container.register(SearchRouterProtocol.self) { _ in
            SearchRouter()
        }
        
        // ✅ CoreData
        container.register(FavoriteMovieStoring.self) { _ in CoreDataService() }
        
        // ✅ Favorites-модуль
        container.register(FavoritesRouterProtocol.self) { _ in
            FavoritesRouter()
        }
        
        container.register(FavoritesInteractorProtocol.self) { resolver in
            let storage = resolver.resolve(FavoriteMovieStoring.self)!
            return FavoritesInteractor(storage: storage)
        }
    }
}
