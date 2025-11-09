//
//  TwitchChatService.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 14/10/2024.
//

import Foundation
import Network

final class TwitchChatService {
    private let client = TwitchIRCClient()
    private let parser = TwitchIRCParser()

    private var currentChannel = ""
    private var pendingSelfMessage = ""

    var onNewMessage: ((IRCMessage) -> Void)?

    init() {
        client.onMessageReceived = { [weak self] raw in
            self?.handleRawMessage(raw)
        }
    }

    func connect(accessToken: String, channel: String, username: String) {
        currentChannel = channel
        client.connect()

        send("PASS oauth:\(accessToken)")
        send("NICK \(username)")
        send("CAP REQ :twitch.tv/commands twitch.tv/tags")
        send("JOIN #\(channel)")
    }

    func disconnect() {
        send("PART #\(currentChannel)")
        client.disconnect()
        currentChannel = ""
    }

    func sendMessage(_ message: String) {
        guard !currentChannel.isEmpty else { return }
        pendingSelfMessage = message
        send("PRIVMSG #\(currentChannel) :\(message)")
    }

    private func send(_ command: String) {
        client.sendRaw(command + "\r\n")
    }

    private func handleRawMessage(_ raw: String) {
        if raw.hasPrefix("PING") {
            client.sendRaw(raw.replacingOccurrences(of: "PING", with: "PONG"))
            return
        }

        if raw.contains("USERSTATE") {
            let tags = parser.parseMessage(raw)?.tags ?? [:]
            let msg = IRCMessage(id: UUID(), tags: tags, user: tags["display-name"] ?? "You", content: pendingSelfMessage)
            onNewMessage?(msg)
            return
        }

        if let parsed = parser.parseMessage(raw) {
            onNewMessage?(parsed)
        }
    }
}
