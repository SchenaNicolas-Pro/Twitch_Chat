//
//  UIImage+RotationToContextualActionImage.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 27/01/2025.
//

import UIKit

extension UIImage {
    func rotatedImageForContextualActions(systemName: String) -> UIImage? {
        guard let systemImage = UIImage(systemName: systemName) else { return nil }
        let newImage = UIImage(cgImage: (systemImage.cgImage)!, scale: 2.0, orientation: .down)
        return newImage
    }
}
