//
//  TokenLoader.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 04/10/2024.
//

import Foundation

final class TokenLoader {
    private let session: URLSession
    private let client: NetworkClient
    
    init(session: URLSession = URLSession(configuration: .default),
         client: NetworkClient){
        self.session = session
        self.client = client
    }
    
    // MARK: - Access Token Loader
    func accessTokenLoader(authCode: String) async throws -> StoredToken {
        let url = TwitchAuthEndpoint.Token.accessCode(authCode).url()
        let token = try await fetchToken(url: url)
        return token
    }
    
    func accessTokenRefresher(refreshToken: String) async throws -> StoredToken {
        let url = TwitchAuthEndpoint.Token.refresh(refreshToken).url()
        let token = try await fetchToken(url: url)
        return token
    }
    
    private func fetchToken(url: URL) async throws -> StoredToken {
        let request = RequestBuilder(url: url)
            .setMethod(.post)
            .build()
        let responseJSON = try await client.send(request: request,
                                                 responseType: NetWorkToken.self)
        let storableToken = responseJSON.toStoredToken()
        
        return storableToken
    }
    
    // MARK: - Validate Token Request
    func validateTokenRequest(accessToken: String) async throws {
        let url = TwitchAuthEndpoint.validateTokenURL
        let request = RequestBuilder(url: url)
            .addHeader(forHTTPHeaderField: "Authorization", value: "OAuth \(accessToken)")
            .build()
        
        _ = try await client.send(request: request, responseType: EmptyResponse.self)
    }
    
    // MARK: - Revoke Token Request
    func revokingTokenRequest(accessToken: String) async throws {
        let url = TwitchAuthEndpoint.revokeTokenURL
        let bodyParameters = "client_id=\(APIConfigKey.clientID)&token=\(accessToken)"
        let request = RequestBuilder(url: url)
            .setMethod(.post)
            .addHeader(forHTTPHeaderField: "Content-Type", value: "application/x-www-form-urlencoded")
            .setBody(data: bodyParameters.data(using: .utf8)!)
            .build()
        
        _ = try await client.send(request: request, responseType: EmptyResponse.self)
    }
}
