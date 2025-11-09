//
//  ChannelCollectionViewCell.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 28/10/2024.
//

import UIKit

final class ChannelCollectionViewCell: UICollectionViewCell {
    static let identifier = "ChannelCollectionViewCell"
    
    private let channelImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 2
        image.layer.borderColor = UIColor.white.cgColor
        
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private let channelLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layoutIfNeeded()
        channelImageView.layer.cornerRadius = channelImageView.bounds.width / 3
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(channelImageView)
        contentView.addSubview(channelLabel)
        backgroundColor = .black
        
        NSLayoutConstraint.activate([
            channelImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            channelImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            channelImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            channelImageView.heightAnchor.constraint(equalTo: channelImageView.widthAnchor)
        ])
        
        NSLayoutConstraint.activate([
            channelLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            channelLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(channel: ChannelUIConfig) {
        channelLabel.text = channel.channelName
        channelImageView.image = nil
        
        if self.channelLabel.text == channel.channelName {
            self.channelImageView.image = channel.isLive ? channel.image : channel.image.toGrayscale()
        }
    }
}
