//
//  FavoritesRouterProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 17.07.2025.
//

import UIKit

protocol FavoritesRouterProtocol: AnyObject {}

final class FavoritesRouter: FavoritesRouterProtocol {
    weak var viewController: UIViewController?
}
