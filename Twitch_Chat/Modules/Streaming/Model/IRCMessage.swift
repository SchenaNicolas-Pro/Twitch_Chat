//
//  IRCMessage.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 29/07/2025.
//

import Foundation

struct IRCMessage: Hashable {
    let id: UUID
    let tags: [String: String]
    let user: String
    let content: String
}
