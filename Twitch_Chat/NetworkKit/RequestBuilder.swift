//
//  RequestBuilder.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 01/08/2025.
//

import Foundation

public struct RequestBuilder {
    private var url: URL
    private var method: HTTPMethod = .get
    private var headers: [String: String] = [:]
    private var body: Data?

    public init(url: URL) {
        self.url = url
    }

    public func setMethod(_ method: HTTPMethod) -> RequestBuilder {
        var copy = self
        copy.method = method
        return copy
    }

    public func addHeader(forHTTPHeaderField: String, value: String) -> RequestBuilder {
        var copy = self
        copy.headers[forHTTPHeaderField] = value
        return copy
    }
    
    public func setBody(data: Data) -> RequestBuilder {
        var copy = self
        copy.body = data
        return copy
    }
    
    public func build() -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        request.httpBody = body
        return request
    }
}
