//
//  SceneDelegate.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 11/09/2024.
//

import UIKit
import Network

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    private lazy var appContainer = AppDependencyContainer()
    
    private lazy var appViewControllerFactory: AppViewControllerFactory = {
        let factory = AppViewControllerFactory(appContainer: appContainer)
        factory.onStateChange = { [weak self] newState in
            self?.switchRootViewController(for: newState)
        }
        
        return factory
    }()
    
    // MARK: - Window + Scene
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        appViewControllerFactory.needToSignIn { [weak self] initialState in
            self?.switchRootViewController(for: initialState)
        }
        window?.makeKeyAndVisible()
    }
    
    // MARK: - Switch screen presentation
    private func switchRootViewController(for state: AppState) {
        guard let window = self.window else { return }

        let rootViewController: UIViewController = {
            switch state {
            case .authenticated: return appViewControllerFactory.tabBarController
            case .unauthenticated: return appViewControllerFactory.signInViewController
            }
        }()

        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromBottom,
                          animations: {
                              window.rootViewController = rootViewController
                          },
                          completion: nil)
    }
}
