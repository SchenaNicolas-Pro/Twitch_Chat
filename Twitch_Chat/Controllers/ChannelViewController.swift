//
//  ChannelViewController.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 23/10/2024.
//

import UIKit

final class ChannelViewController: UIViewController {
    private let channelView = ChannelView()
    private var channels: [ChannelUIConfig] = [] {
        didSet {
            channelView.collectionView.reloadData()
            channelView.refreshControl.endRefreshing()
        }
    }
    var loadChannels: (() async throws -> [ChannelUIConfig])?
    var accessToChat: ((String) -> Void)?
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = channelView
        setupCollectionView()
        setupRefreshControl()
        loadImage()
    }
    
    // MARK: - UI Setup
    private func setupCollectionView() {
        channelView.collectionView.dataSource = self
        channelView.collectionView.delegate = self
        channelView.collectionView.register(ChannelCollectionViewCell.self, forCellWithReuseIdentifier: ChannelCollectionViewCell.identifier)
    }
    
    private func setupRefreshControl() {
        channelView.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    // MARK: - Actions
    @objc
    func refresh(send: UIRefreshControl) {
        loadImage()
    }
    
    // MARK: - Update Channel Image
    private func updateChannels(_ newChannels: [ChannelUIConfig]) {
        let sortedChannels = newChannels.sorted { $0.isLive && !$1.isLive }
        channels = sortedChannels
    }
    
    private func loadImage() {
        Task {
            do {
                guard let loadChannels = loadChannels else {
                    channelView.refreshControl.endRefreshing()
                    return
                }
                let loadedChannels = try await loadChannels()
                updateChannels(loadedChannels)
            }
            catch {
                presentAlert("Impossible to load channels")
                channelView.collectionView.refreshControl?.endRefreshing()
            }
        }
    }
}

// MARK: - CollectionView DataSource/Delegate
extension ChannelViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return channels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChannelCollectionViewCell.identifier, for: indexPath) as? ChannelCollectionViewCell else {
            return UICollectionViewCell()
        }
        let channel = channels[indexPath.item]
        cell.configure(channel: channel)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let totalSpacing = (10 * 3)
        let width = (collectionView.bounds.width - CGFloat(totalSpacing)) / 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let channelName = channels[indexPath.row]
        accessToChat?(channelName.channelName)
    }
}
