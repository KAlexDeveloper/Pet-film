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
        container.register(MovieServiceProtocol.self) { _ in
            MovieService()
        }
        
        container.register(SearchInteractorProtocol.self) { resolver in
            let service = resolver.resolve(MovieServiceProtocol.self)!
            return SearchInteractor(service: service)
        }
        
        container.register(SearchRouterProtocol.self) { _ in
            SearchRouter()
        }
        // 👉 Регистрируем конкретный класс
        container.register(SearchPresenter.self) { resolver in
            let interactor = resolver.resolve(SearchInteractorProtocol.self)!
            let router = resolver.resolve(SearchRouterProtocol.self)!
            return SearchPresenter(view: nil, interactor: interactor, router: router)
        }
        
        // 👉 Опционально регистрируем под протокол
        container.register(SearchPresenterProtocol.self) { resolver in
            resolver.resolve(SearchPresenter.self)!
        }
    }
}
