//
//  equipTableViewCell.swift
//  骑行者
//
//  Created by apple on 17/5/13.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class equipTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var equipimage: UIImageView!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       equipimage.layer.cornerRadius = equipimage.frame.size.width/2.0
        equipimage.layer.masksToBounds = true

        // Configure the view for the selected state
    }
    
}
