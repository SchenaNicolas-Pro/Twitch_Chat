//
//  SignInView.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 11/09/2024.
//

import UIKit

final class SignInView: UIView {
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("Connexion", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemPurple
        button.layer.cornerRadius = 8
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        addSubview(signInButton)
        
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            signInButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            signInButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            signInButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
