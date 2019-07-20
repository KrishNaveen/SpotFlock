//
//  ImageManager.swift
//  Spotflock
//
//  Created by Naveenkrishna Manda on 19/07/19.
//  Copyright © 2019 Naveenkrishna Manda. All rights reserved.
//

import UIKit

class ImageManager {
    fileprivate let imageCache = NSCache<NSString, UIImage>()
    public fileprivate(set) static var sharedInstance = ImageManager()
    
    func getImage(from url: String?, onCompletion:@escaping (_ image: UIImage?) -> Void) {
        guard let urlString = url, let imageURL = URL(string: urlString) else {
            onCompletion(nil)
            return
        }
        if let image = imageCache.object(forKey: urlString as NSString) {
            onCompletion(image)
        } else {
            onCompletion(nil)
            URLSession.shared.dataTask(with: imageURL) { [unowned self, urlString] (data, response, error) in
                guard response?.isSuccess ?? false,
                    let data = data,
                    let image = UIImage(data: data) else {
                        onCompletion(nil)
                        return
                }
                self.imageCache.setObject(image, forKey: urlString as NSString)
                onCompletion(image)
            }.resume()
        }
    }
}
