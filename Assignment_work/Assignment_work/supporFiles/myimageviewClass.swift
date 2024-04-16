//
//  myimageviewClass.swift
//  Assignment_work
//
//  Created by vartika krishna on 15/04/24.
//

import UIKit


//////////////////////////////////////////
// Cache Image view
//////////////////////////////////////////

class myimageviewClass: UIImageView {
    
    static var cache = NSCache<AnyObject, UIImage>()
    var url: URL?
    
    func loadImages(from url: URL) {
        self.url = url
        
        if let cachedImage = myimageviewClass.cache.object(forKey: url as AnyObject) {
            self.image = cachedImage
            print("You get image from cache")
        }else{
            URLSession.shared.dataTask(with: url) { (data, respnse, error) in
                if let error = error {
                    print("Error: \(error)")
                }else if let data = data {
                    if url == self.url{
                        DispatchQueue.main.async {
                            self.image = UIImage(data: data)
                            let imageToCache = self.image ?? UIImage(named: "noimage")
                            myimageviewClass.cache.setObject(imageToCache!, forKey: url as AnyObject)
                            print("You get image from \(url)")
                        }
                    }else{
                        print("URL Not Found!")
                    }
                }
            }.resume()
        }
    }
}
//////////////////////////////////////////
// For center crop
//////////////////////////////////////////

extension UIImage {
    func centerCropped(to size: CGSize) -> UIImage? {
        let cgImage = self.cgImage!
        let contextImage: UIImage = UIImage(cgImage: cgImage)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var width: CGFloat = size.width
        var height: CGFloat = size.height

        // See what size is longer and then set the width and height to the longer size
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            width = contextSize.height
            height = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            width = contextSize.width
            height = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: width, height: height)

        // Create bitmap image from context using the rect
        let imageRef: CGImage = cgImage.cropping(to: rect)!

        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: self.scale, orientation: self.imageOrientation)

        return image
    }
}

