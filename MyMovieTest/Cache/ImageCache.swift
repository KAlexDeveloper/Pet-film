//
//  ImageCache.swift
//  MyMovieTest
//
//  Created by сонный on 18.08.2025.
//


import UIKit

final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {}
    
    func image(for urlString: String) -> UIImage? {
        return cache.object(forKey: urlString as NSString)
    }
    
    func setImage(_ image: UIImage, for urlString: String) {
        cache.setObject(image, forKey: urlString as NSString)
    }
}