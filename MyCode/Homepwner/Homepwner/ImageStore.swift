//
//  ImageStore.swift
//  Homepwner
//
//  Created by cm on 16/2/16.
//  Copyright © 2016年 cm. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    let cache = NSCache()
    
    func setImage(image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key)
    }
    
    func imageForKey(key: String) ->UIImage?{
        return cache.objectForKey(key) as? UIImage
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
    }
}
