//
//  FavoritesViewController.swift
//  MyMovieTest
//
//  Created by сонный on 16.07.2025.
//


import UIKit

protocol FavoritesViewProtocol: AnyObject {
    func showEmptyMessage()
}

final class FavoritesViewController: UIViewController, FavoritesViewProtocol {

    var presenter: FavoritesPresenterProtocol!

    private let label: UILabel = {
        let lbl = UILabel()
        lbl.text = ""
        lbl.textAlignment = .center
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        presenter.viewDidLoad()
    }

    func showEmptyMessage() {
        label.text = "Избранное (пока пусто)"
    }
}
