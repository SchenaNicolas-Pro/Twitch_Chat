//
//  TwitchAPIEndpoint.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 07/10/2024.
//

import Foundation

enum TwitchAPIEndpoint {
    case userInfo
    case broadcasterInfo([String])
    case followedChannel(String, String?)
    case followedStreamers(String, String?)
    
    func url() -> URL {
        var components = URLComponents()
        var queryItems: [URLQueryItem] = []
        components.scheme = "https"
        components.host = "api.twitch.tv"
        
        switch self {
        case .userInfo:
            components.path = "/helix/users"
            
            return components.url!
            
        case let .broadcasterInfo(broadcasterID):
            let queryBroadcasterID = broadcasterID.map { URLQueryItem(name: "id", value: $0) }
            queryItems.append(contentsOf: queryBroadcasterID)
            components.path = "/helix/users"
            components.queryItems = queryItems
            
            return components.url!
            
        case let .followedChannel(userID, cursor):
            queryItems.append(URLQueryItem(name: "user_id", value: userID))
            if let cursor = cursor {
                queryItems.append(URLQueryItem(name: "after", value: cursor))
            }
            components.path = "/helix/channels/followed"
            components.queryItems = queryItems
            
            return components.url!
            
        case let .followedStreamers(userID, cursor):
            queryItems.append(URLQueryItem(name: "user_id", value: userID))
            if let cursor = cursor {
                queryItems.append(URLQueryItem(name: "after", value: cursor))
            }
            components.path = "/helix/streams/followed"
            components.queryItems = queryItems
            
            return components.url!
        }
    }
}
