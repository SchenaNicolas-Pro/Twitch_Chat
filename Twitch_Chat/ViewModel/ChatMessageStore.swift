//
//  ChatMessageStore.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 12/08/2025.
//

import Foundation

final class ChatMessageStore {
    private let twitchChatService: TwitchChatService
    var onMessagesAppended: ((IRCMessage) -> Void)?
    
    private(set) var chatUserMessages: [IRCMessage] = []
    private(set) var highlightedUsers: [String] = []
    
    init(twitchChatService: TwitchChatService) {
        self.twitchChatService = twitchChatService
        twitchChatService.onNewMessage = { [weak self] message in
            guard let self = self else { return }
            self.appendNewMessage(with: message)
            
            DispatchQueue.main.async {
                self.onMessagesAppended?(message)
            }
        }
    }
    
    private func appendNewMessage(with message: IRCMessage) {
        chatUserMessages.insert(message, at: 0)
        if chatUserMessages.count >= 500 {
            chatUserMessages.removeLast()
        }
    }
    
    func connectToChat(accessToken: String, channel: String, username: String) {
        twitchChatService.connect(accessToken: accessToken, channel: channel, username: username)
    }
    
    func sendMessage(with message: String) {
        twitchChatService.sendMessage(message)
    }
    
    func disconnectFromChat() {
        twitchChatService.disconnect()
    }
    
    func clearMessage() {
        chatUserMessages.removeAll()
    }
    
    func removeMessage(withID id: UUID) {
        if let index = chatUserMessages.firstIndex(where: { $0.id == id }) {
            chatUserMessages.remove(at: index)
        }
    }
    
    func highlightUserMessages(user: String) {
        if highlightedUsers.contains(user) {
            highlightedUsers.removeAll { $0 == user }
        } else {
            highlightedUsers.append(user)
        }
    }
    
    func isUserHighlighted(_ user: String) -> Bool {
        highlightedUsers.contains(user)
    }
}
