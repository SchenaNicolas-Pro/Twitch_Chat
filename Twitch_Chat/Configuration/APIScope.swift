//
//  APIScope.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 23/10/2024.
//

import Foundation

enum APIScope {
    // MARK: - Scope
    static let chatRead = "chat:read"
    static let chatWrite = "chat:edit"
    static let followsList = "user:read:follows"
    static let userInfo = "user:read:email"
    
    static let authenticationURLQueryScope = URLQueryItem(name: "scope", value: "\(APIScope.chatRead) \(APIScope.chatWrite) \(APIScope.followsList) \(APIScope.userInfo)")
}
