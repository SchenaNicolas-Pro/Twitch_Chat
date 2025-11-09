//
//  TwitchChatTableViewCell.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 02/12/2024.
//

import UIKit

final class TwitchChatTableViewCell: UITableViewCell {
    static let identifier = "TwitchChatTableViewCell"
    
    let chatUserName: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let chatUserMessage: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 0
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.addArrangedSubview(chatUserName)
        stackView.addArrangedSubview(chatUserMessage)
        stackView.transform = CGAffineTransform(rotationAngle: .pi)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let doubleTapGesture: UITapGestureRecognizer = {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.numberOfTapsRequired = 2
        
        return tapGesture
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .black
        addSubview(verticalStackView)
        addGestureRecognizer(doubleTapGesture)
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(message: IRCMessage) {
        chatUserName.text = "\(message.user):"
        chatUserName.textColor = UIColor(hex: message.tags["color"] ?? "FFFFFF")
        chatUserMessage.text = message.content
    }
}
