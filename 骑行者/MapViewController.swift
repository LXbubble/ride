//
//  MapViewController.swift
//  骑行者
//
//  Created by apple on 17/4/3.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,BMKMapViewDelegate,BMKGeneralDelegate{
    
    var mapView: BMKMapView?
    
    // 创建时设定属性
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.setFAIcon(icon: .FABicycle)
        self.tabBarItem.title = "骑行"
    }
    //加载时设定
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tabBarItem.title = "骑行"
//        self.tabBarItem.setFAIcon(icon: .FABicycle, size: CGSize(width:30,height:30))
        

        mapView = BMKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.view.addSubview(mapView!)
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView?.viewWillAppear()
        mapView?.delegate = self // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView?.viewWillDisappear()
        mapView?.delegate = nil // 不用时，置nil
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
