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
        
        // ✅ Регистрация интерактора
        container.register(SearchInteractorProtocol.self) { resolver in
            let service = resolver.resolve(MovieServiceProtocol.self)!
            return SearchInteractor(service: service)
        }
        
        // ✅ Регистрация роутера
        container.register(SearchRouterProtocol.self) { _ in
            SearchRouter()
        }
        // ❌ Не регистрируем Presenter
        // Мы собираем его вручную в билдере, чтобы избежать проблем с циклическими зависимостями
    }
}
