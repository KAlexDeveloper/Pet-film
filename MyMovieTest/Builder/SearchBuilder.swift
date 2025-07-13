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

        let presenter = container.resolve(SearchPresenterProtocol.self)!
        let interactor = container.resolve(SearchInteractorProtocol.self)!
        let router = container.resolve(SearchRouterProtocol.self)!

        if let castedPresenter = presenter as? SearchPresenter,
           let castedInteractor = interactor as? SearchInteractor,
           let castedRouter = router as? SearchRouter {
            castedPresenter.view = view
            castedInteractor.output = castedPresenter
            castedRouter.viewController = view

            view.presenter = castedPresenter
        }

        return view
    }
}
