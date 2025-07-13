//
//  SearchRouter.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//


import UIKit

protocol SearchRouterProtocol: AnyObject {
    func openDetail(for movie: Movie)
}

final class SearchRouter: SearchRouterProtocol {
    weak var viewController: UIViewController?
    
    func openDetail(for movie: Movie) {
        // Здесь позже подключим переход к деталям
        print("Open detail for: \(movie.title)")
    }
}
