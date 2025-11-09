//
//  UserInfoService.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 16/12/2024.
//

import Foundation

final class UserInfoService {
    private let userInfoLoader: UserInfoLoader
    private let userInfoManager: UserInfoManager
    
    init(userInfoLoader: UserInfoLoader, userInfoManager: UserInfoManager) {
        self.userInfoLoader = userInfoLoader
        self.userInfoManager = userInfoManager
    }
 
    func loadUserInfo(accessToken: String) async throws -> StoredUser {
        return try await userInfoLoader.getUserInfo(accessToken: accessToken)
    }
    
    func saveUserInfo(userInfo: StoredUser) {
        let succeedSavingUser = self.userInfoManager.saveUserInfo(userInfo: userInfo)
        if succeedSavingUser {
            print("Successfully saved user informations")
        } else {
            print("Cannot save user informations")
        }
    }
    
    func getUserInfo() throws -> StoredUser {
        return try userInfoManager.getUserInfo()
    }
    
    func deleteUserInfo() {
        let succeedDeletingUser = self.userInfoManager.deleteUserInfo()
        if succeedDeletingUser {
            print("Successfully deleted user informations")
        } else {
            print("Cannot delete user informations")
        }
    }
}
