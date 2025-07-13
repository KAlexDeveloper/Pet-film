//
//  SearchBuilder.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import UIKit

final class SearchBuilder {
    static func build() -> UIViewController {
        let container = AppDIContainer.shared.container

        let view = SearchViewController()

        guard let presenter = container.resolve(SearchPresenter.self),
              let interactor = container.resolve(SearchInteractorProtocol.self) as? SearchInteractor,
              let router = container.resolve(SearchRouterProtocol.self) as? SearchRouter else {
            fatalError("Не удалось разрешить зависимости")
        }

        presenter.view = view
        interactor.output = presenter
        router.viewController = view
        view.presenter = presenter

        return view
    }
}
