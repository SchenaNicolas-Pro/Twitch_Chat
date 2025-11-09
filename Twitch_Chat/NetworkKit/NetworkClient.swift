//
//  NetworkClient.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 01/08/2025.
//

import Foundation

public final class NetworkClient {
    private let session: URLSession
    
    init(session: URLSession = URLSession(configuration: .default)){
        self.session = session
    }
    
    public func send<T: Decodable>(
        request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw NetworkError.httpStatus(httpResponse.statusCode)
        }
        
        if data.isEmpty {
            if T.self == EmptyResponse.self {
                return EmptyResponse() as! T
            } else {
                throw NetworkError.decoding(NSError(domain: "EmptyData", code: -1))
            }
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decoding(error)
        }
    }
}
