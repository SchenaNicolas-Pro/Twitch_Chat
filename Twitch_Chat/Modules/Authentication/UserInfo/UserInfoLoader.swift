//
//  UserInfoLoader.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 23/10/2024.
//

import Foundation

final class UserInfoLoader {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func getUserInfo(accessToken: String) async throws -> StoredUser {
        let url = TwitchAPIEndpoint.userInfo.url()
        let request = URLRequest.twitchGET(url: url, accessToken: accessToken)
        let userInfo = try await client.send(request: request, responseType: NetworkUserInfo.self)
        guard let storableUser = userInfo.data.first?.toStoredUser() else {
            throw NetworkError.undecodableData
        }
        
        return storableUser
    }
}
