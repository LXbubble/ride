

import Foundation
import UIKit

extension UICollectionView {
    func aapl_indexPathsForElementsInRect(rect: CGRect) -> [IndexPath]? {
        let allLayoutAttributes = self.collectionViewLayout.layoutAttributesForElements(in: rect)
        if allLayoutAttributes == nil || allLayoutAttributes!.count == 0 {
            return nil
        }
        var indexPaths = [IndexPath]()
        for layoutAttributes in allLayoutAttributes! {
            let indexPath = layoutAttributes.indexPath
            indexPaths.append(indexPath)
        }
        return indexPaths;
    }
}
