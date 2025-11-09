//
//  TwitchIRCClient.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 12/08/2025.
//

import Foundation
import Network

final class TwitchIRCClient {
    private var connection: NWConnection
    var onMessageReceived: ((String) -> Void)?

    init() {
        self.connection = NWConnection(
            host: "irc.chat.twitch.tv",
            port: 6667,
            using: .tcp
        )
    }
    
    func connect() {
        connection = NWConnection(
                        host: "irc.chat.twitch.tv",
                        port: 6667,
                        using: .tcp)
        connection.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("IRC connection ready")
            case .failed(let error):
                print("IRC connection failed: \(error)")
            default:
                break
            }
        }
        connection.start(queue: .main)
        startReceivingMessages()
    }

    func disconnect() {
        connection.cancel()
    }

    func sendRaw(_ command: String) {
        guard let data = command.data(using: .utf8) else { return }
        connection.send(content: data, completion: .contentProcessed { error in
            if let error = error {
                print("Error sending: \(error)")
            }
        })
    }

    private func startReceivingMessages() {
        connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { [weak self] data, _, _, error in
            if let data = data, let message = String(data: data, encoding: .utf8) {
                self?.onMessageReceived?(message)
            }
            if error == nil {
                self?.startReceivingMessages()
            }
        }
    }
}
