//
//  ImageHelper.swift
//  catalog
//
//  Created by Thomas Kötter on 21.03.16.
//  Copyright © 2016 Thomas Kötter. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    
    enum ImageHelperError: ErrorType {
        case connectionError
        case writeError
        case readError
    }
    
    var image = UIImage()
    let cache = NSCache()
    
    class var sharedLoader :ImageHelper {
        struct Static {
            static let instance :ImageHelper = ImageHelper()
        }
        return Static.instance
    }
    
    func getDocumentsPath() -> NSURL {
        let documentsPath = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsPath
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        let fileURL = getDocumentsPath().URLByAppendingPathComponent(filename)
        return fileURL.path!
    }
    
    func checkFileWithName(name: String) -> (Bool) {
        
        //check for Image on the local Storage
        let path = self.fileInDocumentsDirectory(name)
        return NSFileManager.defaultManager().isReadableFileAtPath(path)
    }

    func getImageFromURL(urlString :String, completionHandler: (completeImage :UIImage?, imageUrlString: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            
            //Reading Imagedata from Cache if aviable
            if let imagedata :NSData = self.cache.objectForKey(urlString) as? NSData {
                let image = UIImage(data: imagedata)
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(completeImage: image!, imageUrlString: urlString)
                })
            }
            
            //If no Image in Cache is aviable, load it from URL
            let downloadTask: NSURLSessionTask = NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: urlString)!, completionHandler: {
                (data :NSData?, response :NSURLResponse?, error :NSError? ) -> Void in
                if (error != nil){
                    completionHandler(completeImage: nil, imageUrlString: urlString)
                    return
                }
                if let data = data {
                    let image = UIImage(data: data)
                    self.cache.setObject(data, forKey: urlString)
                    dispatch_async(dispatch_get_main_queue(), {
                        completionHandler(completeImage: image!, imageUrlString: urlString)
                    })
                    return
                }
                return
            })
            downloadTask.resume()
        })
    }
    
    func getImageWithFilename(filename :String, completionHandler: (completeImage: UIImage, filename: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            
            //Check the Filename and give back the UIImage
            if (filename.lowercaseString.rangeOfString(".jpg") != nil) {
                
                // Define the specific path, image name
                let myImageName = filename
                let imagePath = self.fileInDocumentsDirectory(myImageName)
                guard let image = UIImage(contentsOfFile: imagePath) else {print("Image \(filename) not found"); return}
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(completeImage: image, filename: filename)
                })
                
            }
        })
    }
    
    func setImageWithName(name :String, image :UIImage, completionHandler: (imageURLString: String) -> ()) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            if (name.lowercaseString.rangeOfString(".jpg") != nil) {
                
                //save the Imagedata
                let imageData :NSData = UIImageJPEGRepresentation(image, 0.85)!
                imageData.writeToFile(self.fileInDocumentsDirectory(name), atomically: true)
                dispatch_async(dispatch_get_main_queue(), {
                    completionHandler(imageURLString: name as String)
                })
                
            }
        })
    }
}