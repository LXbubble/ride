
import Foundation
import Photos

struct ImageModel {
    var fetchResult: PHFetchResult<PHObject>
    var label: String?
    var assetType: PHAssetCollectionSubtype
    var id : Int?
    
    init(result: PHFetchResult<PHObject>,label: String?, assetType: PHAssetCollectionSubtype){
        self.fetchResult = result
        self.label = label
        self.assetType = assetType
    }
}

