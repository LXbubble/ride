//
//  NewsViewController.swift
//  骑行者
//
//  Created by apple on 17/4/3.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController,SliderGalleryControllerDelegate {
   
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.setFAIcon(icon: .FAHome)
        self.tabBarItem.title = "主页"
    }

    @IBOutlet weak var imageview: UIImageView!
    
        //获取屏幕宽度
        let screenWidth =  UIScreen.main.bounds.size.width
        
        //图片轮播组件
        var sliderGallery : SliderGalleryController!
        
        //图片集合
        var images = ["http://bizhi.zhuoku.com/bizhi2008/0516/3d/3d_desktop_13.jpg",
                      "http://tupian.enterdesk.com/2012/1015/zyz/03/5.jpg",
                      "http://img.web07.cn/UpImg/Desk/201301/12/desk230393121053551.jpg",
                      "http://wallpaper.160.com/Wallpaper/Image/1280_960/1280_960_37227.jpg",
                      "http://bizhi.zhuoku.com/wall/jie/20061124/cartoon2/cartoon014.jpg"]
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //初始化图片轮播组件
            sliderGallery = SliderGalleryController()
            sliderGallery.delegate = self
            sliderGallery.view.frame = CGRect(x: 0, y: 0, width: screenWidth,
                                              height: screenWidth/4*3);
            
            //将图片轮播组件添加到当前视图
            self.addChildViewController(sliderGallery)
            self.view.addSubview(sliderGallery.view)
            
            //添加组件的点击事件
            let tap = UITapGestureRecognizer(target: self,
                                             action: #selector(NewsViewController.handleTapAction(_:)))
            sliderGallery.view.addGestureRecognizer(tap)
        }
        
        //图片轮播组件协议方法：获取内部scrollView尺寸
        func galleryScrollerViewSize() -> CGSize {
            return CGSize(width: screenWidth, height:screenWidth/4*3)
        }
        
        //图片轮播组件协议方法：获取数据集合
        func galleryDataSource() -> [String] {
            return images
        }
        
        //点击事件响应
        func handleTapAction(_ tap:UITapGestureRecognizer)->Void{
            //获取图片索引值
            let index = sliderGallery.currentIndex
            //弹出索引信息
            let alertController = UIAlertController(title: "您点击的图片索引是：",
                                                    message: "\(index)", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        
        //“刷新数据”按钮点击
//        @IBAction func reloadBtnTap(_ sender: AnyObject) {
//            images = ["http://tupian.enterdesk.com/2012/1015/zyz/03/5.jpg",
//                      "http://img.web07.cn/UpImg/Desk/201301/12/desk230393121053551.jpg",
//                      "http://bizhi.zhuoku.com/wall/jie/20061124/cartoon2/cartoon014.jpg"]
//            sliderGallery.reloadData()
//        }
    
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
        }
    }
    
