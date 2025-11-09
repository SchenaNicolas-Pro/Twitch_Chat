//
//  NetWorkToken.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 01/10/2024.
//

import Foundation

struct NetWorkToken: Decodable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String
    let scope: [String]
    let tokenType: String
}

struct StoredToken: Codable {
    let accessToken: String
    let expiresIn: Date
    let refreshToken: String
    let scope: [String]
    let tokenType: String
}

// MARK: - Extension Token
extension NetWorkToken {
    func toStoredToken() -> StoredToken {
        let expirationDate = Date(timeIntervalSinceNow: TimeInterval(expiresIn))
        return StoredToken(accessToken: self.accessToken,
                             expiresIn: expirationDate,
                             refreshToken: self.refreshToken,
                             scope: self.scope,
                             tokenType: self.tokenType)
    }
}
