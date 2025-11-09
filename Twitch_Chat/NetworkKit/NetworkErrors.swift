//
//  NetworkErrors.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 17/09/2024.
//

import Foundation

// MARK: - Error case
enum NetworkError: Error {
    case invalidResponse
    case httpStatus(Int)
    case decoding(Error)
    case unknown(Error)
    case undecodableData
}
