//
//  UIViewController+PresentAlert.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 04/10/2024.
//

import UIKit

extension UIViewController {
    func presentAlert(_ message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
