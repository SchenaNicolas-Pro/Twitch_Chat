//
//  UIImage+ToGrayScale.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 26/11/2024.
//

import UIKit

extension UIImage {
    func toGrayscale() -> UIImage? {
        guard let ciImage = CIImage(image: self) else { return nil }
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(0.0, forKey: kCIInputSaturationKey)
        
        guard let outputCIImage = filter?.outputImage,
              let cgImage = CIContext().createCGImage(outputCIImage, from: outputCIImage.extent) else {
            return nil
        }
        
        return UIImage(cgImage: cgImage)
    }
}
