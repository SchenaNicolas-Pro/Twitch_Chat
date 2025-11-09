//
//  TokenService.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 16/12/2024.
//

import Foundation

final class TokenService {
    private let tokenLoader: TokenLoader
    private let tokenManager: TokenManager
    
    init(tokenLoader: TokenLoader, tokenManager: TokenManager) {
        self.tokenLoader = tokenLoader
        self.tokenManager = tokenManager
    }
    private var refreshTokenTimer: Timer?
    
    // MARK: - TokenLoader
    func loadAccessToken(authCode: String) async throws -> StoredToken {
        return try await tokenLoader.accessTokenLoader(authCode: authCode)
    }
    
    func validateToken(accessToken: String) async throws {
        try await tokenLoader.validateTokenRequest(accessToken: accessToken)
    }
    
    func revokingToken() async throws {
        let token = try getToken()
        try await tokenLoader.revokingTokenRequest(accessToken: token.accessToken)
    }
    
    // MARK: - TokenManager
    func saveToken(token: StoredToken) {
        let succeedSavingToken = self.tokenManager.saveToken(token: token)
        if succeedSavingToken {
            print("Successfully saved token")
        } else {
            print("Cannot save token")
        }
    }
    
    func getToken() throws -> StoredToken{
        return try tokenManager.getToken()
    }
    
    func getAccessToken() throws -> String {
        return try getToken().accessToken
    }
    
    func deleteToken() {
        let succeedDeletingToken = self.tokenManager.deleteToken()
        if succeedDeletingToken {
            print("Successfully deleted token")
        } else {
            print("Cannot delete token")
        }
    }
    
    func resumeSessionOrRefreshIfNeeded() async throws {
        let token = try getToken()
        try await validateOrRefreshToken(token: token)
        initializeAutoTokenRefresh(for: token)
    }
    
    // MARK: - Token Auto-Refresh System
    func initializeAutoTokenRefresh(for token: StoredToken, refreshInterval: TimeInterval = AppConstants.defaultRefreshInterval) {
        
        refreshTokenTimer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            Task {
                do {
                    try await self.validateOrRefreshToken(token: token, interval: refreshInterval)
                } catch {
                    self.invalidateAutoRefreshTokenTimer()
                }
            }
        }
    }
    
    func invalidateAutoRefreshTokenTimer() {
        self.refreshTokenTimer?.invalidate()
        self.refreshTokenTimer = nil
    }
    
    private func validateOrRefreshToken(token: StoredToken, interval: TimeInterval = AppConstants.defaultRefreshInterval) async throws {
        if shouldRefresh(token: token, interval: interval) {
            try await self.refreshAndSaveToken(token: token)
        } else {
            try await self.validateToken(accessToken: token.accessToken)
        }
    }
    
    private func shouldRefresh(token: StoredToken, interval: TimeInterval) -> Bool {
        return token.expiresIn.timeIntervalSinceNow <= interval
    }
    
    private func refreshAndSaveToken(token: StoredToken) async throws {
        let newToken = try await self.tokenLoader.accessTokenRefresher(refreshToken: token.refreshToken)
        try await self.validateToken(accessToken: newToken.accessToken)
        saveToken(token: newToken)
    }
}
