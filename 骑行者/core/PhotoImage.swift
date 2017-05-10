
import Foundation
import Photos

class PhotoImage {
    
    // singleton
    static let instance = PhotoImage()
    private init(){}
    
    var selectedImage = [PHAsset]()
    
}
