//
//  ImageStore.swift
//  swap
//
//  Created by Mohammad Arish Khan on 22/12/21.
//

import UIKit

struct ImageStore {
    
    static func delete(imageNamed name: String) {                     // for delete stored image
        guard let imagePath = ImageStore.path(for: name) else {
            return
        }
        
        try? FileManager.default.removeItem(at: imagePath)
    }
    
    static func retrieve(imageNamed name: String) -> UIImage? {           //call image by ts name
        guard let imagePath = ImageStore.path(for: name) else {
            return nil
        }
        
        return UIImage(contentsOfFile: imagePath.path)
    }
    
    static func store(image: UIImage, name: String) throws {
        
        guard let imageData = image.pngData() else {            //Returns a data object that contains the                                                                        specified image in PNG form
            throw NSError(domain: "com.minor.swap", code: 0, userInfo: [NSLocalizedDescriptionKey: "The image could not be created"])
        }
        
        guard let imagePath = ImageStore.path(for: name) else {
            throw NSError(domain: "com.minor.swap", code: 0, userInfo: [NSLocalizedDescriptionKey: "The image path could not be retrieved"])
        }
        
        try imageData.write(to: imagePath)           //store image data on path
    }
                                                      //generating url of image
    private static func path(for imageName: String, fileExtension: String = "png") -> URL? {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent("\(imageName).\(fileExtension)")
    }
}
