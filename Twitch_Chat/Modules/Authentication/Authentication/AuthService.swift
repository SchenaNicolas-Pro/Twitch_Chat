//
//  AuthService.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 16/12/2024.
//

import Foundation

final class AuthService {
    private let tokenService: TokenService
    private let userInfoService: UserInfoService
    private let authLoader: AuthLoader
    
    init(tokenService: TokenService, userInfoService: UserInfoService, authLoader: AuthLoader) {
        self.tokenService = tokenService
        self.userInfoService = userInfoService
        self.authLoader = authLoader
    }
    
    // MARK: - SignIn Process
    func performSignInFlow() async throws {
        let authCode = try await self.authenticateUser()
        let token = try await tokenService.loadAccessToken(authCode: authCode)
        try await tokenService.validateToken(accessToken: token.accessToken)
        let userInfo = try await userInfoService.loadUserInfo(accessToken: token.accessToken)
        tokenService.saveToken(token: token)
        userInfoService.saveUserInfo(userInfo: userInfo)
        tokenService.initializeAutoTokenRefresh(for: token)
    }
    
    //MARK: - SignOut Process
    func performSignOutFlow() async throws {
        try await tokenService.revokingToken()
        resetAuthSession()
    }
    
    func resetAuthSession() {
        self.tokenService.invalidateAutoRefreshTokenTimer()
        self.tokenService.deleteToken()
        self.userInfoService.deleteUserInfo()
    }
    
    // MARK: - Authentication
    private func authenticateUser() async throws -> String {
        return try await withCheckedThrowingContinuation { continuation in
            authLoader.authLoader { code in
                if let code = code {
                    continuation.resume(returning: code)
                } else {
                    continuation.resume(throwing: NetworkError.invalidResponse)
                }
            }
        }
    }
}
