//
//  DetailRouterProtocol.swift
//  MyMovieTest
//
//  Created by сонный on 21.08.2025.
//


import UIKit

protocol DetailRouterProtocol: AnyObject {}

final class DetailRouter: DetailRouterProtocol {
    weak var viewController: UIViewController?
}