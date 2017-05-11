//
//  comTableViewCell.swift
//  骑行者
//
//  Created by apple on 17/5/11.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class comTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comtext: UILabel!
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        picture.layer.cornerRadius = picture.frame.size.width/2.0
        picture.layer.masksToBounds = true

        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
