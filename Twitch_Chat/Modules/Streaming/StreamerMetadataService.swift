//
//  StreamerMetadataService.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 01/08/2025.
//

import Foundation
final class StreamerMetadataService {
    private let client: NetworkClient
    
    init(client: NetworkClient) {
        self.client = client
    }
    
    func loadFollowedStreamersInfo(userID: String, accessToken: String) async throws -> [StreamerInfo] {
        let liveStreamList = try await fetchAllFollowedStreams(userID: userID, accessToken: accessToken)
        let liveStreamIDs = liveStreamList.map {$0.userId}
        
        let channelDetailsList = try await fetchBroadcasterDetails(userID: userID, accessToken: accessToken)
        
        let channelConfigs = channelDetailsList.map { channel in
            StreamerInfo(
                name: channel.displayName,
                imageURL: channel.profileImageUrl,
                isLive: liveStreamIDs.contains(channel.id)
            )
        }
        return channelConfigs
    }
    
    private func fetchBroadcasterDetails(userID: String, accessToken: String) async throws -> [NetworkUserDetail] {
        let followedChannelList = try await fetchAllFollowedChannels(userID: userID, accessToken: accessToken)
        let broadcasterID = followedChannelList.map {$0.broadcasterId}
        let url = TwitchAPIEndpoint.broadcasterInfo(broadcasterID).url()
        let request = URLRequest.twitchGET(url: url, accessToken: accessToken)
        let userInfo = try await client.send(request: request, responseType: NetworkUserInfo.self)
        
        return userInfo.data
    }
    
    private func fetchAllFollowedChannels(userID: String, accessToken: String)  async throws -> [FollowedBroadcaster] {
        var url = TwitchAPIEndpoint.followedChannel(userID, nil).url()
        var allFollowedChannels: [FollowedBroadcaster] = []
        var paginationCursor: String? = nil
        
        repeat {
            let info = try await fetchStreams(url: url,
                                              accessToken: accessToken,
                                              type: FollowedChannelInfo.self)
            
            allFollowedChannels.append(contentsOf: info.data)
            
            paginationCursor = info.pagination.cursor
            url = TwitchAPIEndpoint.followedChannel(userID, paginationCursor).url()
            
        } while paginationCursor != nil
        
        return allFollowedChannels
    }
    
    private func fetchAllFollowedStreams(userID: String, accessToken: String)  async throws -> [StreamDetail] {
        var url = TwitchAPIEndpoint.followedStreamers(userID, nil).url()
        var allFollowedStreams: [StreamDetail] = []
        var paginationCursor: String? = nil
        
        repeat {
            let info = try await fetchStreams(url: url,
                                              accessToken: accessToken,
                                              type: FollowedStreamInfo.self)
            
            allFollowedStreams.append(contentsOf: info.data)
            
            paginationCursor = info.pagination.cursor
            url = TwitchAPIEndpoint.followedStreamers(userID, paginationCursor).url()
            
        } while paginationCursor != nil
        
        return allFollowedStreams
    }
    
    // MARK: - Generic fetch function
    private func fetchStreams<T: Decodable>(url: URL, accessToken: String, type: T.Type) async throws -> T {
        let request = URLRequest.twitchGET(url: url, accessToken: accessToken)
        
        return try await client.send(request: request,
                                     responseType: type)
    }
}
