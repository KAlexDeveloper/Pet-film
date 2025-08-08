//
//  SceneDelegate.swift
//  MyMovieTest
//
//  Created by сонный on 10.07.2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = MainTabBarController()
        self.window = window
        window.makeKeyAndVisible()
        
        do {
            let key = "kinopoiskApiKey"
            let keychain = KeychainManager.shared

            if (try? keychain.getToken(for: key)) == nil {
                try keychain.saveToken("FMQ970S-76N461V-GYGMDYK-TSQT6ZQ", for: key)
                print("✅ Токен сохранён")
            } else {
                print("🔑 Токен уже есть")
            }
        } catch {
            print("❌ Ошибка при работе с токеном: \(error.localizedDescription)")
        }
    }


//    func scene(_ scene: UIScene,
//                   willConnectTo session: UISceneSession,
//                   options connectionOptions: UIScene.ConnectionOptions) {
//            
//            guard let windowScene = (scene as? UIWindowScene) else { return }
//
//            // Создаем окно
//            let window = UIWindow(windowScene: windowScene)
//            
//            // Собираем SearchViewController
//            let searchVC = SearchBuilder.build()
//            
//            // Оборачиваем в UINavigationController
//            let navController = UINavigationController(rootViewController: searchVC)
//            
//            // Настраиваем окно
//            window.rootViewController = navController
//            window.makeKeyAndVisible()
//            
//            // Сохраняем ссылку
//            self.window = window
//        }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

