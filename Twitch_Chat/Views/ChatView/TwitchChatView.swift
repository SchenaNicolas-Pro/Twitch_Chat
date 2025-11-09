//
//  TwitchChatView.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 07/10/2024.
//

import UIKit

final class TwitchChatView: UIView {
    var messageTextFieldBottomConstraint: NSLayoutConstraint!
    let dimissKeyboardTapGesture = UITapGestureRecognizer()
    
    let messageTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Envoyer un message"
        textField.font = .systemFont(ofSize: 16)
        textField.returnKeyType = .send
        textField.borderStyle = .roundedRect
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        return textField
    }()
    
    let catchUpChatButton: UIButton = {
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold)
        let image = UIImage(systemName: "arrow.down.circle", withConfiguration: largeConfig)
        let button = UIButton()
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 0.9)
        button.layer.cornerRadius = 8
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let tableview: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = .black
        tableview.transform = CGAffineTransform(rotationAngle: .pi)
        
        tableview.translatesAutoresizingMaskIntoConstraints = false
        return tableview
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableview)
        addSubview(catchUpChatButton)
        addSubview(messageTextField)
        addGestureRecognizer(dimissKeyboardTapGesture)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableview.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableview.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableview.bottomAnchor.constraint(equalTo: messageTextField.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            catchUpChatButton.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -16),
            catchUpChatButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            catchUpChatButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        messageTextFieldBottomConstraint = messageTextField.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            messageTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            messageTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            messageTextFieldBottomConstraint,
            messageTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
