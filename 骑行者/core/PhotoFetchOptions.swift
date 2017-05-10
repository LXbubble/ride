
import UIKit
import Photos

class PhotoFetchOptions: PHFetchOptions {
    static let shareInstance: PhotoFetchOptions = PhotoFetchOptions()
    private override init() {
        super.init()
        self.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
        self.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    }
}
