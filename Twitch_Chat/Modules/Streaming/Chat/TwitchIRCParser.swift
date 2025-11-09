//
//  TwitchIRCParser.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 12/08/2025.
//

import Foundation

final class TwitchIRCParser {
    func parseMessage(_ raw: String) -> IRCMessage? {
        let tags = parseTags(from: raw)
        let user = parseUser(from: raw)
        let content = parseContent(from: raw)
        
        guard !user.isEmpty || !content.isEmpty else { return nil }
        return IRCMessage(id: UUID(), tags: tags, user: user, content: content)
    }
    
    private func parseTags(from message: String) -> [String: String] {
        let regex = #"@([^ ]+)"#
        guard let range = message.range(of: regex, options: .regularExpression) else { return [:] }
        
        return String(message[range])
            .replacingOccurrences(of: "@", with: "")
            .split(separator: ";")
            .reduce(into: [String: String]()) { dict, pair in
                let parts = pair.split(separator: "=", maxSplits: 1).map(String.init)
                if parts.count == 2 {
                    dict[parts[0]] = parts[1]
                }
            }
    }
    
    private func parseUser(from message: String) -> String {
        let regex = #":([^ ]+)!"#
        guard let range = message.range(of: regex, options: .regularExpression) else { return "" }
        return String(message[range])
            .replacingOccurrences(of: ":", with: "")
            .split(separator: "!")
            .first
            .map(String.init) ?? ""
    }
    
    private func parseContent(from message: String) -> String {
        let regex = #"PRIVMSG #[^ ]+ :(.*)"#
        guard let range = message.range(of: regex, options: .regularExpression) else { return "" }
        return String(message[range]).components(separatedBy: " :").last ?? ""
    }
}
