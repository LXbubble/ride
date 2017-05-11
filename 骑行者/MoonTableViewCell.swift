//
//  MoonTableViewCell.swift
//  骑行者
//
//  Created by apple on 17/4/6.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import Photos
import SwiftyJSON

class MoonTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource,UINavigationControllerDelegate {
    
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var detailtext: UILabel!
    @IBOutlet weak var collectionVIew: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var votebutton: UIButton!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var votecount: UILabel!
    @IBOutlet weak var comcount: UILabel!
    
    var navi : UINavigationController!
    
    let width1 = (UIScreen.main.bounds.width-30)/3
    var data : JSON = []
    override func awakeFromNib() {
        
        
        super.awakeFromNib()
        picture.layer.cornerRadius = picture.frame.size.width/2.0
        picture.layer.masksToBounds = true
        
        //设置collectionView的代理
        self.collectionVIew.delegate = self
        self.collectionVIew.dataSource = self
        
        
        let layout = self.collectionVIew.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width:width1,height:width1/4*3)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
  
        // 注册CollectionViewCell
        self.collectionVIew.register(UINib(nibName:"MyCollectionViewCell", bundle:nil),
                                     forCellWithReuseIdentifier: "moonimagecell")
 
    }
    
    @IBAction func vote(_ sender: AnyObject) {
        print("\(votebutton.tag)")
    }
    //加载数据
    func loaddata(data:JSON){
        self.data = data
        //collectionView重新加载数据
        self.collectionVIew.reloadData()
        
        //更新collectionView的高度约束
        let contentSize = self.collectionVIew.collectionViewLayout.collectionViewContentSize
        collectionViewHeight.constant = contentSize.height
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        
        let previewVC = ImagePreviewVC( data: self.data  , index: indexPath.row)
        self.navi.pushViewController(previewVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.array!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "moonimagecell",
                                                                 for: indexPath) as! MyCollectionViewCell
        cell.imageView.getbyid(id: data[indexPath.row]["pictures_id"].int!)
        return cell
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
