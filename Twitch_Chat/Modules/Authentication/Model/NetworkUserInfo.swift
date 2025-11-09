//
//  UserInfo.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 23/10/2024.
//

import Foundation

struct NetworkUserInfo: Decodable {
    let data: [NetworkUserDetail]
}

struct NetworkUserDetail: Decodable {
    let id: String
    let login: String
    let displayName: String
    let type: String
    let broadcasterType: String
    let description: String
    let profileImageUrl: String
    let offlineImageUrl: String
    let viewCount: Int
    let email: String?
    let createdAt: String
}

struct StoredUser: Codable {
    let id: String
    let name: String
}

// MARK: - Extension Token
extension NetworkUserDetail {
    func toStoredUser() -> StoredUser {
        return StoredUser(id: self.id, name: self.displayName)
    }
}
