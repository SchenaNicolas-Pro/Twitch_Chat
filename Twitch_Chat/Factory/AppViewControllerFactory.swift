//
//  AppViewControllerFactory.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 03/08/2025.
//

import UIKit

final class AppViewControllerFactory {
    
    // MARK: - Properties
    var onStateChange: ((AppState) -> Void)?
    
    private let appContainer: AppDependencyContainer
    
    init(appContainer: AppDependencyContainer) { self.appContainer = appContainer }

    // MARK: - Public Controllers
    lazy var tabBarController: TabBarController = {
        let tabBarController = TabBarController()
        tabBarController.viewControllers = [channelsNavigationController, deconnectionViewController]
        
        return tabBarController
    }()
    
    lazy var signInViewController: SignInViewController = {
        let viewController = SignInViewController()
        
        viewController.signInButton = { [weak self] in
            self?.signInFlow()
        }
        
        return viewController
    }()

    // MARK: - Private Controllers
    private lazy var channelsNavigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: channelViewController)
        navigationController.title = "Channels"
        navigationController.navigationBar.standardAppearance.backgroundColor = .black
        navigationController.navigationBar.scrollEdgeAppearance?.backgroundColor = .black
        return navigationController
    }()
    
    private lazy var channelViewController: ChannelViewController = {
        let viewController = ChannelViewController()
        
        viewController.loadChannels = { [weak self] in
            guard let self = self else { return [] }
            return try await self.getFollowedChannelList()
        }
        
        viewController.accessToChat = { [weak self] channelName in
            self?.openChat(forChannel: channelName)
        }
        
        return viewController
    }()
    
    private lazy var deconnectionViewController: DeconnectionViewController = {
        let viewController = DeconnectionViewController()
        viewController.title = "Deconnection"
        
        viewController.signOutButton = { [weak self] in
            self?.signOutFlow()
        }
        
        return viewController
    }()

    // MARK: - Auth Flow
    func needToSignIn(completion: @escaping (AppState) -> Void) {
        Task {
            do {
                try await appContainer.tokenService.resumeSessionOrRefreshIfNeeded()
                DispatchQueue.main.async {
                    self.onStateChange?(.authenticated)
                }
            } catch {
                appContainer.authService.resetAuthSession()
                DispatchQueue.main.async {
                    self.onStateChange?(.unauthenticated)
                }
            }
        }
    }
    
    private func signInFlow() {
        Task {
            do {
                try await appContainer.authService.performSignInFlow()
                DispatchQueue.main.async {
                    self.onStateChange?(.authenticated)
                }
            } catch {
                await MainActor.run {
                    self.deconnectionViewController.presentAlert("Impossible de se connecter")
                }
            }
        }
    }
    
    private func signOutFlow() {
        Task {
            do {
                try await appContainer.authService.performSignOutFlow()
                DispatchQueue.main.async {
                    self.onStateChange?(.unauthenticated)
                }
            } catch {
                await MainActor.run {
                    self.deconnectionViewController.presentAlert("Impossible de se déconnecter")
                }
            }
        }
    }
    
    // MARK: Channels
    private func getFollowedChannelList() async throws -> [ChannelUIConfig] {
        let sessionInfo = try appContainer.makeSessionInfo()
        let accessToken = sessionInfo.accessToken
        let userID = sessionInfo.userID
        
        let streamersInfo = try await appContainer.streamerMetadataService.loadFollowedStreamersInfo(userID: userID, accessToken: accessToken)
        
        return await loadImages(from: streamersInfo)
    }
    
    private func loadImages(from channels: [StreamerInfo]) async -> [ChannelUIConfig] {
        var configs: [ChannelUIConfig] = []
        
        await withTaskGroup(of: ChannelUIConfig?.self) { group in
            
            for channel in channels {
                group.addTask {
                    do {
                        let url = try self.appContainer.imageLoader.transformIntoURL(stringURL: channel.imageURL)
                        let image = try await self.appContainer.imageLoader.loadImage(from: url) ?? UIImage(systemName: "nosign")!
                        
                        return ChannelUIConfig(channelName: channel.name, image: image, isLive: channel.isLive)
                    } catch {
                        print("Error loading image for \(channel.name): \(error)")
                        return nil
                    }
                }
            }
            for await config in group {
                if let config = config {
                    configs.append(config)
                }
            }
        }
        return configs
    }
    
    // MARK: - Chat
    private func openChat(forChannel channel: String) {
        do {
            let sessionInfo = try appContainer.makeSessionInfo()
            let accessToken = sessionInfo.accessToken
            let userName = sessionInfo.userName
            appContainer.chatMessageStore.connectToChat(accessToken: accessToken,
                                                        channel: channel,
                                                        username: userName)
            
            let chatVC = TwitchChatViewController(chatMessageStore: appContainer.chatMessageStore, channelName: channel)
            chatVC.hidesBottomBarWhenPushed = true
            channelsNavigationController.pushViewController(chatVC, animated: true)
        }
        catch {
            print("Error: \(error)")
        }
    }
}
