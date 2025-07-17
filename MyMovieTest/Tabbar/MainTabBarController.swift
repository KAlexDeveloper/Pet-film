//
//  MainTabBarController.swift
//  MyMovieTest
//
//  Created by сонный on 16.07.2025.
//

import UIKit

final class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupAppearance()
    }
    
    private func setupTabs() {
        let searchVC = AppBuilder.buildSearch()
        searchVC.tabBarItem = UITabBarItem(title: "Поиск", image: UIImage(systemName: "magnifyingglass"), selectedImage: UIImage(systemName: "magnifyingglass"))
        
        let favoritesVC = AppBuilder.buildFavorites()
        favoritesVC.tabBarItem = UITabBarItem(title: "Избранное", image: UIImage(systemName: "heart"), selectedImage: UIImage(systemName: "heart.fill"))
        
        viewControllers = [searchVC, favoritesVC]
    }
    
    private func setupAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .lightGray.withAlphaComponent(0.8) // цвет фона таббара

        // Настраиваем цвета иконок
        let normalColor = UIColor.myPinkOne
        let selectedColor = UIColor.myPinkSecond

        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor

        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: normalColor]
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: selectedColor]

        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
    }
}
