//
//  ImageLoader.swift
//  Twitch_Chat
//
//  Created by Nicolas Schena on 25/11/2024.
//

import UIKit

final class ImageLoader {
    private let cache = NSCache<NSURL, UIImage>()
    
    func loadImage(from url: URL) async throws -> UIImage? {
        if let cachedImage = cache.object(forKey: url as NSURL) {
            return cachedImage
        }
        
        let data = try Data(contentsOf: url)
        guard let image = UIImage(data: data) else { return nil }
        cache.setObject(image, forKey: url as NSURL)
        return image
    }
}

extension ImageLoader {
    func transformIntoURL(stringURL: String) throws -> URL {
        guard let url = URL(string: stringURL) else { throw ImageLoaderError.wrongURL }
        return url
    }
}
