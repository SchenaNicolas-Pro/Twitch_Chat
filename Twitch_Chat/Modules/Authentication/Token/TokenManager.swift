//
//  TokenManager.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 04/10/2024.
//

import Foundation
import Security

final class TokenManager {
    // MARK: - Save Token
    func saveToken(token: StoredToken) -> Bool {
        let encoder = JSONEncoder()
        
        guard let tokenData = try? encoder.encode(token) else { return false }
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: APIConfigKey.keyChainTokenService,
            kSecAttrAccount: APIConfigKey.keyChainTokenAccount,
            kSecValueData: tokenData
        ] as CFDictionary
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        return status == errSecSuccess
    }
    
    // MARK: - Get Token
    func getToken() throws -> StoredToken {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: APIConfigKey.keyChainTokenService,
            kSecAttrAccount: APIConfigKey.keyChainTokenAccount,
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

        guard let tokenData = result as? Data else {
            throw KeychainError.unexpectedData
        }
        
        let decoder = JSONDecoder()
        return try decoder.decode(StoredToken.self, from: tokenData)
    }
    
    // MARK: - Delete Token
    func deleteToken() -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: APIConfigKey.keyChainTokenService,
            kSecAttrAccount: APIConfigKey.keyChainTokenAccount
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        return status == errSecSuccess
    }
}
