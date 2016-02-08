//
//  ImageCache.swift
//  PwnageChecker
//
//  Created by Vince Chan on 2/4/16.
//  Copyright © 2016 Vince Chan. All rights reserved.
//

import UIKit

// manage caching for images
class ImageCache {
    
    class func sharedInstance()->ImageCache {
        struct Singleton {
            static var sharedInstance = ImageCache()
        }
        return Singleton.sharedInstance
    }
    
    private var inMemoryCache = NSCache()
    
    func imageWithName(name: String) -> UIImage? {
        let path = pathForIdentifier(name)
        
        // First try the memory cache
        if let image = inMemoryCache.objectForKey(path) as? UIImage {
            return image
        }
        
        // Next Try the hard drive
        if let data = NSData(contentsOfFile: path) {
            return UIImage(data: data)
        }
        
        return nil
    }
    
    func storeImage(image: UIImage?, withName name: String) {
        let path = pathForIdentifier(name)
        
        // If the image is nil, remove images from the cache
        if image == nil {
            inMemoryCache.removeObjectForKey(path)
            
            do {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            } catch _ {}
            
            return
        }
        
        // Otherwise, keep the image in memory
        inMemoryCache.setObject(image!, forKey: path)
        
        // And in documents directory
        let data = UIImagePNGRepresentation(image!)!
        data.writeToFile(path, atomically: true)
    }
    
    // determine image file path given its identifier
    func pathForIdentifier(identifier: String) -> String {
        let documentsDirectoryURL: NSURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
        let fullURL = documentsDirectoryURL.URLByAppendingPathComponent(identifier)
        
        return fullURL.path!
    }
}