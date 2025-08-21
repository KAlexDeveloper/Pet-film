//
//  DetailRouterProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 21.08.2025.
//


import UIKit

protocol DetailRouterProtocol: AnyObject {
    func popViewController()
    func showError(from view: DetailViewProtocol?, message: String)
}

final class DetailRouter: DetailRouterProtocol {
    weak var viewController: UIViewController?
    
    func popViewController() {
        viewController?.navigationController?.popViewController(animated: true)
    }
    
    func showError(from view: DetailViewProtocol?, message: String) {
        guard let viewController = view as? UIViewController else { return }
        let alert = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ок", style: .default) { _ in
            self.popViewController()
        })
        viewController.present(alert, animated: true)
    }
}
