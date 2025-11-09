//
//  URLRequest+twitchGET.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 01/08/2025.
//

import Foundation

extension URLRequest {
    static func twitchGET(url: URL, accessToken: String) -> URLRequest {
        return RequestBuilder(url: url)
            .setMethod(.get)
            .addHeader(forHTTPHeaderField: "Authorization", value: "Bearer \(accessToken)")
            .addHeader(forHTTPHeaderField: "Client-Id", value: APIConfigKey.clientID)
            .build()
    }
}
