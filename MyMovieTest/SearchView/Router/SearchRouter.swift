//
//  SearchRouter.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//


import UIKit

protocol SearchRouterProtocol: AnyObject {
    func openDetail(for movie: Movie)
    var viewController: UIViewController? { get set }
}

final class SearchRouter: SearchRouterProtocol {
    weak var viewController: UIViewController?
    
    func openDetail(for movie: Movie) {
        // Здесь позже подключу переход к деталям
        print("Open detail for: \(movie.title)")
    }
}
