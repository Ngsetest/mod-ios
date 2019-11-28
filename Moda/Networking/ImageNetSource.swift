//
//  ImageNetSource.swift
//  Moda
//
//  Created by Ruslan Lutfullin on 4/24/18.
//  Copyright © 2018 moda. All rights reserved.
//

import AlamofireImage
import ImageSlideshow


@objcMembers
class ImageNetSource: NSObject, InputSource {
    /// url to load
    var url: URL
    
    /// placeholder used before image is loaded
    var placeholder: UIImage?
    
    /// Initializes a new source with a URL
    /// - parameter url: a url to load
    /// - parameter placeholder: a placeholder used before image is loaded
    init(url: URL, placeholder: UIImage? = nil) {
        self.url = url
        self.placeholder = placeholder
        super.init()
    }
    
    /// Initializes a new source with a URL string
    /// - parameter urlString: a string url to load
    /// - parameter placeholder: a placeholder used before image is loaded
    init?(urlString: String, placeholder: UIImage? = nil) {
        if let validUrl = URL(string: urlString) {
            self.url = validUrl
            self.placeholder = placeholder
            super.init()
        } else {
            return nil
        }
    }
    
    func load(to imageView: UIImageView, with callback: @escaping (UIImage?) -> Void) {
        imageView.af_setImage(withURL: self.url, placeholderImage: self.placeholder, filter: nil, progress: nil) { response in
            callback(response.result.value)
        }
    }
    
    func cancelLoad(on imageView: UIImageView) {
        imageView.af_cancelImageRequest()
    }
}
