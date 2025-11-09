//
//  TwitchAuthURL.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 12/09/2024.
//

import Foundation

struct TwitchAuthEndpoint {    
    // MARK: - Validate / Revoke Token URL
    static let validateTokenURL = URL(string: "https://id.twitch.tv/oauth2/validate")!
    static let revokeTokenURL = URL(string: "https://id.twitch.tv/oauth2/revoke")!
    
    // MARK: - Authentication URL
    static func authenticationURL() -> URL {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "id.twitch.tv"
        components.path = "/oauth2/authorize"
        let queryResponseType = URLQueryItem(name: "response_type", value: "code")
        let queryClientID = URLQueryItem(name: "client_id", value: APIConfigKey.clientID)
        let queryRedirectURI = URLQueryItem(name: "redirect_uri", value: APIConfigKey.redirectURL)
        let queryScope = APIScope.authenticationURLQueryScope
        
        components.queryItems = [queryResponseType, queryClientID, queryRedirectURI, queryScope]
        
        return components.url!
    }
    
    // MARK: - Token URL Builder
    enum Token {
        case accessCode(String)
        case refresh(String)
        
        func url() -> URL {
            var components = URLComponents()
            components.scheme = "https"
            components.host = "id.twitch.tv"
            components.path = "/oauth2/token"
            let queryClientID = URLQueryItem(name: "client_id", value: APIConfigKey.clientID)
            let queryClientSecret = URLQueryItem(name: "client_secret", value: APIConfigKey.clientSecret)
            
            switch self {
            case let .accessCode(authCode):
                let queryCode = URLQueryItem(name: "code", value: authCode)
                let queryGrantType = URLQueryItem(name: "grant_type", value: "authorization_code")
                let queryRedirectURI = URLQueryItem(name: "redirect_uri", value: APIConfigKey.redirectURL)
                
                components.queryItems = [queryClientID, queryClientSecret, queryCode, queryGrantType, queryRedirectURI]
                
                return components.url!
                
            case let .refresh(refreshToken):
                let queryGrantType = URLQueryItem(name: "grant_type", value: "refresh_token")
                let queryRefreshToken = URLQueryItem(name: "refresh_token", value: refreshToken)
                
                components.queryItems = [queryClientID, queryClientSecret, queryGrantType, queryRefreshToken]
                
                return components.url!
            }
        }
    }
}
