//
//  UserInfoManager.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 24/10/2024.
//

import Foundation
import Security

final class UserInfoManager {
    
    // MARK: - Save User Info
    func saveUserInfo(userInfo: StoredUser) -> Bool {
        let encoder = JSONEncoder()
        
        guard let userInfoData = try? encoder.encode(userInfo) else { return false }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: APIConfigKey.keyChainUserInfoService,
            kSecAttrAccount: APIConfigKey.keyChainUserInfoAccount,
            kSecValueData: userInfoData
        ] as CFDictionary
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        return status == errSecSuccess
    }
    
    // MARK: - Get User Info
    func getUserInfo() throws -> StoredUser {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: APIConfigKey.keyChainUserInfoService,
            kSecAttrAccount: APIConfigKey.keyChainUserInfoAccount,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)
        
        guard status == errSecSuccess else {
            if status == errSecItemNotFound {
                throw KeychainError.itemNotFound
            } else {
                throw KeychainError.unknown(status)
            }
        }

        guard let userInfoData = result as? Data else {
            throw KeychainError.unexpectedData
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(StoredUser.self, from: userInfoData)
    }
    
    // MARK: - Delete User Info
    func deleteUserInfo() -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: APIConfigKey.keyChainUserInfoService,
            kSecAttrAccount: APIConfigKey.keyChainUserInfoAccount
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        return status == errSecSuccess
    }
}
