//
//  ImageUtil.swift
//  BitMoon
//
//  Created by succorer on 2018. 11. 29..
//  Copyright © 2018년 PFXStudio. All rights reserved.
//

import UIKit
import CryptoSwift
import Alamofire

class ImageUtil: NSObject {
    static func imageFolderPath() -> URL {
        let paths = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        let imageFolder = paths[0].appendingPathComponent("images")
        do
        {
            try FileManager.default.createDirectory(at: imageFolder, withIntermediateDirectories: true, attributes: nil)
        }
        catch let error as NSError
        {
            print("Unable to create directory \(error.debugDescription)")
        }
        
        return imageFolder
    }
    
    static func save(image: UIImage, fileName: String) {
        let data = image.pngData()
        let encodingFileName = fileName.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let fullPathURL = ImageUtil.imageFolderPath().appendingPathComponent(encodingFileName!)
        do
        {
            try data!.write(to: fullPathURL)
        }
        catch let error as NSError
        {
            print("Unable to save image \(error.debugDescription)")
        }
        
        print("image saved : \(fullPathURL)")
    }
    
    static func load(fileName: String) -> UIImage? {
        let fullPathURL = ImageUtil.imageFolderPath().appendingPathComponent(fileName)
        let path = fullPathURL.absoluteString.replacingOccurrences(of: "file://", with: "")
        if FileManager.default.fileExists(atPath: path) == false {
            return nil
        }
        
        return UIImage(contentsOfFile: path)
    }
    
    static func deleteAll() {
        do {
            try FileManager.default.removeItem(at: ImageUtil.imageFolderPath())
        }
        catch let error as NSError {
            print("Unable to save image \(error.debugDescription)")
        }
    }
    
    static func requestLoad(fileName:String?, remoteIconUrl: URL?, completion: @escaping ((UIImage?) -> Void)) {
        if fileName == nil {
            return
        }
        
        if remoteIconUrl == nil {
            return
        }
        
        let image = self.load(fileName: fileName!)
        if image != nil {
            completion(image)
            return
        }
        
        Alamofire.request(remoteIconUrl!, method: .get).responseImage { response in
            guard let image = response.result.value else {
                // Handle error
                completion(nil)
                return
            }
            
            // Do stuff with your image
            self.save(image: image, fileName: fileName!)
            completion(image)
        }
    }
    
    static func bundleImage(bundleName: String, fileName: String) -> UIImage? {
        if let bundlePath = Bundle.main.path(forResource: bundleName, ofType: "bundle") {
            let bundle = Bundle(path: bundlePath)
            return UIImage(named: fileName, in: bundle, compatibleWith: nil)
        }
        
        return nil
    }
}
