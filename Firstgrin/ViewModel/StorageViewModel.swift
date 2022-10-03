//
//  StorageViewModel.swift
//  Firstgrin
//
//  Created by Sazza on 28/9/22.
//

import Foundation
import UIKit

class StorageViewModel: ObservableObject{
    private var storage = FirebaseManager.shared.storage
    let queue = OperationQueue()
    
    // fetch image from firebase
    func imageFrom(url: String, completion: @escaping (UIImage?, String?) -> Void) {
        let urlString = url
        let storageRef = self.storage.reference(forURL: url)
        //   let serialQueue = DispatchQueue(label: "Decode Queue")
        
        let image: UIImage? = UIImage(systemName: "xmark")
        
        //        queue.maxConcurrentOperationCount = 4
        //        DispatchQueue.global().async {
        //        serialQueue.async {
        self.queue.addOperation {
            // Returns Cached Image from here
            if let cacheImage = ImageCache.shared.getCache(urlString: urlString){
                let downImage = self.resizedImage(at: cacheImage)
                completion(downImage, urlString)
                return
            }
            // First time fetch image from firebase and saves in cache
            else {
                // Image fetching max limit 20 MB.
                storageRef.getData(maxSize: 20 * 1024 * 1024)  { data, error in
                    if error != nil {
                        print("Error: Image could not download!")
                        completion(nil, urlString)
                        print(error?.localizedDescription as Any)
                    } else {
                        // Optional binding
                        if let data = data, let image = UIImage(data: data) {
                            let downImage = self.resizedImage(at: image)
                            if let downImage = downImage{
                                ImageCache.shared.setCache(urlString: urlString, imageToCache: downImage)
                                completion(downImage, urlString)
                            } else {
                                ImageCache.shared.setCache(urlString: urlString, imageToCache: image)
                                completion(image, urlString)
                            }
                            
                        } else {
                            completion(image!, urlString)
                        }
                    }
                }
            }
        }
        //        queue.waitUntilAllOperationsAreFinished()
    }
    
    // Resize Image for screen size
    func resizedImage(at image: UIImage) -> UIImage? {
//        guard let image = UIImage(contentsOfFile: url.path) else {
//            return nil
//        }
        let myImageWidth = image.size.width
        let myImageHeight = image.size.height
        let myViewWidth = UIScreen.screenWidth

        let ratio = myViewWidth/myImageWidth
        let scaledHeight = myImageHeight * ratio

        let size = CGSize(width: myViewWidth, height: scaledHeight)

        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { (context) in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
}
