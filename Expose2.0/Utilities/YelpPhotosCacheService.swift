//
//  YelpPhotosCacheManager.swift
//  Expose
//
//  Created by Eyimofe Oladipo on 10/8/22.
//

import Foundation
import SwiftUI

class YelpPhotosCacheService {
    static let instance = YelpPhotosCacheService()
    private init(){
        
    }
    
    var photoCache: NSCache<NSString, UIImage> = {
        var cache =  NSCache<NSString, UIImage>()
        cache.countLimit = 50
        cache.totalCostLimit = 1024 * 1024 * 200 // 200mb
        return cache
    }()
    
    func add(key: String, value: UIImage){
        photoCache.setObject(value, forKey: key as NSString)
    }
    
    func get(key: String) -> UIImage?{
        return photoCache.object(forKey: key as NSString)
    }
    
}
  
