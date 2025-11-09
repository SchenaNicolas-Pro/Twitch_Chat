//
//  FollowedChannelInfo.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 15/10/2024.
//

import Foundation

struct FollowedChannelInfo: Codable {
    let total: Int
    let data: [FollowedBroadcaster]
    let pagination: Pagination
}

struct FollowedBroadcaster: Codable {
    let broadcasterId: String
    let broadcasterLogin: String
    let broadcasterName: String
    let followedAt: String
}

struct Pagination: Codable {
    let cursor: String?
}

struct FollowedStreamInfo: Codable {
    let data: [StreamDetail]
    let pagination: Pagination
}

struct StreamDetail: Codable {
    let id: String
    let userId: String
    let userLogin: String
    let userName: String
    let gameId: String
    let gameName: String
    let type: String
    let title: String
    let viewerCount: Int
    let startedAt: String
    let language: String
    let thumbnailUrl: String
    let tagIds: [String]?
    let tags: [String]?
    let isMature: Bool
}
