//
//  newsTableViewCell.swift
//  骑行者
//
//  Created by apple on 17/5/6.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class newsTableViewCell: UITableViewCell {

    @IBOutlet weak var backview: UIView!
    @IBOutlet weak var backimage: UIImageView!
    @IBOutlet weak var newstitle: UILabel!
    @IBOutlet weak var userpic: UIImageView!
    @IBOutlet weak var usernickname: UILabel!
    @IBOutlet weak var votecount: UILabel!
    @IBOutlet weak var commentcount: UILabel!
    @IBOutlet weak var commentimage: UIImageView!
    @IBOutlet weak var voteimage: UIImageView!


    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userpic.layer.cornerRadius = userpic.frame.size.width/2.0
        userpic.layer.masksToBounds = true
        commentimage.image = UIImage(icon: .FACommenting, size: CGSize(width:20,height:20), textColor: UIColor.white)
        voteimage.image = UIImage(icon: .FAThumbsUp, size: CGSize(width:20,height:20), textColor: .white)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
