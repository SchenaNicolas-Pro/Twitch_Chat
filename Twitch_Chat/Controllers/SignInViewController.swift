//
//  SignInViewController.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 11/09/2024.
//

import UIKit

final class SignInViewController: UIViewController {
    private let signInView = SignInView()
    var signInButton: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = signInView
        signInView.signInButton.addTarget(self, action: #selector(signInButtonTapIn), for: .touchUpInside)
    }
    
    @objc
    func signInButtonTapIn() {
        signInButton?()
    }
}
