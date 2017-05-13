//
//  comTableViewCell.swift
//  骑行者
//
//  Created by apple on 17/5/11.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

protocol DeleteCommentDelegate: class {
    func deletecom(tag: Int)
}

class comTableViewCell: UITableViewCell {

    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var comtext: UILabel!
    @IBOutlet weak var delbutton: UIButton!
    @IBOutlet weak var ceng: UILabel!
    
    var deletecomDelegate: DeleteCommentDelegate!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        self.selectionStyle = .none
        picture.layer.cornerRadius = picture.frame.size.width/2.0
        picture.layer.masksToBounds = true
        delbutton.setImage(UIImage(icon: .FATrashO, size: CGSize(width:15,height:15),textColor:.blue), for: .normal)
        delbutton.isHidden = false
        // Initialization code
    }

    @IBAction func deletecom(_ sender: AnyObject) {
        deletecomDelegate.deletecom(tag: delbutton.tag);
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
