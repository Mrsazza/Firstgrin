import Foundation
import UIKit
import DataCache
fileprivate let ONE_HUNDRED_MEGABYTES = 1024 * 1024 * 100 * 100

class ImageCache: NSCache<AnyObject, Cache> {
    static let shared = ImageCache()
    private override init() {
        super.init()
        self.setMaximumLimit()
    }
    func setCache(urlString : String, imageToCache image : UIImage){
        DataCache.instance.write(image: image, forKey: "\(urlString.sha256)")
    }
    func getCache(urlString : String) -> UIImage?{
        return DataCache.instance.readImage(forKey: "\(urlString.sha256)")
    }
    func removeCache(){
        DataCache.instance.cleanAll()
        removeAllObjects()
    }
}

extension ImageCache {
    func setMaximumLimit(size: Int = ONE_HUNDRED_MEGABYTES) {
        totalCostLimit = size
    }
}


class Cache: NSObject , NSDiscardableContent {

    public var image: UIImage!

    func beginContentAccess() -> Bool {
        return true
    }

    func endContentAccess() {

    }

    func discardContentIfPossible() {

    }

    func isContentDiscarded() -> Bool {
        return false
    }
}
