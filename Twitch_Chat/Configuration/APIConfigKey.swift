//
//  APIConfigKey.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 12/09/2024.
//

import Foundation

enum APIConfigKey {
    // MARK: - oAuth
    static var clientID: String {
        Bundle.main.infoDictionary?["CLIENT_ID"] as? String ?? ""
    }

    static var clientSecret: String {
        Bundle.main.infoDictionary?["CLIENT_SECRET"] as? String ?? ""
    }

    static var redirectURL: String {
        Bundle.main.infoDictionary?["REDIRECT_URL"] as? String ?? ""
    }

    static let callbackURLScheme = "chat"
    
    // MARK: - KeyChain
    static let keyChainTokenService = "com.Twitch_Chat.token"
    static let keyChainTokenAccount = "userToken"
    static let keyChainUserInfoService = "com.Twitch_Chat.userInfo"
    static let keyChainUserInfoAccount = "userInfo"
}
