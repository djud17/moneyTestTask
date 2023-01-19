//
//  SceneDelegate.swift
//  moneyTestTask
//
//  Created by Давид Тоноян  on 15.01.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let apiClient: ApiClientProtocol = ApiClient.shared
        let persistance: PersistanceProtocol = Persistance.shared
        let presenter: CurrencyShedulePresenterProtocol = CurrencyShedulePresenter(apiClient: apiClient,
                                                                                   persistance: persistance)
        let viewController = CurrencySheduleViewController(presenter: presenter)
        let navigationController = UINavigationController(rootViewController: viewController)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
