//
//  MyCollectionViewCell.swift
//  骑行者
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    let width1  = UIScreen.main.bounds.width/3
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.frame = CGRect(x: 0, y: 0, width: width1, height: width1/4*3)
        // Initialization code
    }

}
