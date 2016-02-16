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
        
        let imageUrl = imageUrlForKey(key)
        if let imageData = UIImageJPEGRepresentation(image, 0.5) {
            imageData.writeToURL(imageUrl, atomically: true)
        }
    }
    
    func imageForKey(key: String) ->UIImage?{
        if let cacheImage = cache.objectForKey(key) as? UIImage {
            return cacheImage
        }
        
        let imageUrl = imageUrlForKey(key)
        guard let diskImage = UIImage(contentsOfFile: imageUrl.path!) else {
            return nil
        }
        cache.setObject(diskImage, forKey: key)
        return diskImage
    }
    
    func deleteImageForKey(key: String) {
        cache.removeObjectForKey(key)
        do{
            try NSFileManager.defaultManager().removeItemAtURL(imageUrlForKey(key))
        } catch {
            
        }
    }
    
    func imageUrlForKey(key: String)->NSURL {
        let docPaths = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return (docPaths.first?.URLByAppendingPathComponent(key))!
    }
}
