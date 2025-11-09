//
//  AppDependencyContainer.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 01/08/2025.
//

import Foundation
import UIKit

final class AppDependencyContainer {
    
    // MARK: - Network Services
    private lazy var client = NetworkClient()
    private lazy var userInfoLoader = UserInfoLoader(client: client)
    private lazy var tokenLoader = TokenLoader(client: client)
    private lazy var authLoader = AuthLoader()
    
    // MARK: - Manager Services
    private lazy var userInfoManager = UserInfoManager()
    private lazy var tokenManager = TokenManager()
    private lazy var twitchChatService = TwitchChatService()
    
    
    // MARK: Authentification
    lazy var userInfoService = UserInfoService(
        userInfoLoader: userInfoLoader,
        userInfoManager: userInfoManager
    )
    
    lazy var tokenService = TokenService(
        tokenLoader: tokenLoader,
        tokenManager: tokenManager
    )
    
    lazy var authService = AuthService(
        tokenService: tokenService,
        userInfoService: userInfoService,
        authLoader: authLoader
    )
    
    // MARK: - Configuration
    lazy var chatMessageStore = ChatMessageStore(twitchChatService: twitchChatService)
    lazy var streamerMetadataService = StreamerMetadataService(client: client)
    lazy var imageLoader = ImageLoader()

    // MARK: - Session Info Factory
    func makeSessionInfo() throws -> SessionInfo {
        let user = try userInfoService.getUserInfo()
        let userID = user.id
        let userName = user.name
        let token = try tokenService.getAccessToken()
        
        return SessionInfo(
            userID: userID,
            userName: userName,
            accessToken: token
        )
    }
}
