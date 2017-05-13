//
//  activityTableViewCell.swift
//  骑行者
//
//  Created by apple on 17/5/13.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class activityTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var joincount: UILabel!
    @IBOutlet weak var bkimage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    //绘制单元格底部横线
    override func draw(_ rect: CGRect) {
        //线宽
        let lineWidth = 1 / UIScreen.main.scale
        //线偏移量
        let lineAdjustOffset = 1 / UIScreen.main.scale / 2
        //线条颜色
        let lineColor = UIColor(red: 0xe0/255, green: 0xe0/255, blue: 0xe0/255, alpha: 1)
        
        //获取绘图上下文
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        //创建一个矩形，它的所有边都内缩固定的偏移量
        let drawingRect = self.bounds.insetBy(dx: lineAdjustOffset, dy: lineAdjustOffset)
        
        //创建并设置路径
        let path = CGMutablePath()
        path.move(to: CGPoint(x: drawingRect.minX, y: drawingRect.maxY))
        path.addLine(to: CGPoint(x: drawingRect.maxX, y: drawingRect.maxY))
        
        //添加路径到图形上下文
        context.addPath(path)
        
        //设置笔触颜色
        context.setStrokeColor(lineColor.cgColor)
        //设置笔触宽度
        context.setLineWidth(lineWidth)
        
        //绘制路径
        context.strokePath()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
