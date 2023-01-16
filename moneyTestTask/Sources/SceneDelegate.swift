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
        
        let apiClient: ApiClientProtocol = ApiClient()
        let currencyShedulePresenter: CurrencyShedulePresenterProtocol = CurrencyShedulePresenter(apiClient: apiClient)
        let currencySheduleViewController = CurrencySheduleViewController(presenter: currencyShedulePresenter)
        let navigationController = UINavigationController(rootViewController: currencySheduleViewController)
        
        navigationController.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Color.black
        ]
        currencyShedulePresenter.navigationController = navigationController
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }
}
