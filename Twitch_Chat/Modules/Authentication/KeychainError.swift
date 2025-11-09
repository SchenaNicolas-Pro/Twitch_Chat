//
//  KeychainError.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 04/08/2025.
//

import Foundation

enum KeychainError: Error {
    case itemNotFound
    case unexpectedData
    case unknown(OSStatus)
}
