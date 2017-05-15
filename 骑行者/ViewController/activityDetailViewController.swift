//
//  activityDetailViewController.swift
//  骑行者
//
//  Created by apple on 17/5/13.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import SwiftyJSON


class activityDetailViewController : UIViewController , AMapSearchDelegate , MAMapViewDelegate ,UICollectionViewDelegate,UICollectionViewDataSource{

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var jioncollection: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var jionact: UIButton!
    @IBOutlet weak var adressview: UIView!
    @IBOutlet weak var jioncount: UILabel!

    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var id : Int?
    var jiondata:JSON?
    var coordinate : CLLocationCoordinate2D?
    var data:JSON?
    var isjionbool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        //jionact.backgroundColor
        jioncollection.delegate = self
        jioncollection.dataSource = self
        jioncollection.backgroundColor = .white
        loaddata()
        loadjiondata()
        AMapServices.shared().apiKey = "a598628551f523cbc19fc1939e2f8e23"
       
        //判断是否已加入活动
        if readtoken(){
            isjion()
        }
        
        //判断是否可删除
        if readtoken() && (UserDefaults.standard.string(forKey: "user_id"))! == "\(data?["user_id"].int!)" {
           if  (UserDefaults.standard.string(forKey: "user_role"))! == "manager" {
                self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(icon: .FATrashO, size: CGSize(width:25,height:25)),style: .plain, target: self, action:#selector(self.deleteactivity))
            }
        }
        
    }
    //设置数据
    func setdata(){
        name.text = data?["name"].string!
        time.text = data?["time"].string!
        number.text = data?["number"].string!
        nickname.text = data?["nickname"].string!
        adress.text = data?["adress"].string!
        detail.text = data?["detail"].string!
        jioncount.text = "已有\((data?["jioncount"].int)!)人参加"
        self.coordinate = CLLocationCoordinate2D(latitude: (data?["latitude"].double)!, longitude: (data?["longtitude"].double)!)
        initMapView()
        initSearch()
    }
    func loaddata(){
        let url = "activity/activitys/getact/id/\(self.id!)"
        Aget(url: url){
            data in
            self.data = data
            self.setdata()
        }
    }
    
    func loadjiondata(){
        let url = "activity/activitys/getjionuser/id/\(self.id!)"
        Aget(url: url){
            data in
            self.jiondata = data
            self.jioncollection.reloadData()
        }
    }
    //判断是否加入活动
    func isjion(){
        let arry = ["user_id": (UserDefaults.standard.string(forKey: "user_id"))!,
                    "activity_id":self.id! ] as [String : Any]
        let url = "activity/activitys/isjion"
        Apost(url: url, body: arry){
            data in
            if data.bool! {
                self.jionact.setTitle("已加入", for: .normal)
                self.jionact.setTitleColor(.gray, for: .normal)
                self.isjionbool = true
            }
        }
        
    }
    @IBAction func jionactivity(_ sender: AnyObject) {
        if !readtoken(){
            let alertController  = UIAlertController(title: "系统提示", message: "请先登录", preferredStyle: .alert)
             let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler:{
                action in
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "loadview") as! LoadViewController
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated:true)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else {
           let arry = ["user_id": (UserDefaults.standard.string(forKey: "user_id"))!,
                             "activity_id":self.id! ] as [String : Any]
            let url = "activity/activitys/deljion"
            Apost(url: url, body: arry){
                data in
                if self.isjionbool == true  {
                    self.jionact.setTitle("加入活动", for: .normal)
                    self.jionact.setTitleColor(.blue, for: .normal)
                    self.isjionbool = false

                    
                }else {
                    self.jionact.setTitle("已加入", for: .normal)
                    self.jionact.setTitleColor(.gray, for: .normal)
                    self.isjionbool = true
                                   }
                self.loadjiondata()
                self.loaddata()
            }
        }

    }
    
     //删除
    func deleteactivity(){
        let alert = UIAlertController(title: "系统提示", message:"确定删除吗", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let creatAction = UIAlertAction(title: "确定", style:.default, handler: {
            action in
            let token = UserDefaults.standard.string(forKey: "token")
            print("token",token)
            let arr = ["token":token!]
            let url = "activity/activitys/delactivity/id/\(self.id!)"
            print(url)
            //let URL = urladd(url: url)
            
            Apost(url: url, body: arr)
            {   data in
                print("删除成功:\(data)")
                if data.bool! == true {
                    let alert = UIAlertController(title: "系统提示", message:"删除成功", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: {
                        action in
                        self.navigationController?.popViewController(animated: true)
                        
                    })
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        alert.addAction(creatAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)

          }
    
    //地图
    func initMapView() {
        
        mapView = MAMapView(frame: self.adressview.bounds)
        mapView.delegate = self
        mapView.zoomLevel = 15
        mapView.centerCoordinate = self.coordinate!
        let annotation = MAPointAnnotation()
        annotation.coordinate = coordinate!
        annotation.title = self.adress.text!
        annotation.subtitle = nil
        mapView!.addAnnotation(annotation)
        self.adressview.addSubview(mapView!)
       
        
       // mapView.setCenter(self.coordinate!, animated: true)
        
    }
    
    func initSearch() {
        //        AMap
        search = AMapSearchAPI()
        search.delegate = self
    }
    
    //collection 
     func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if jiondata?.array?.count == nil {
            return 0
        }else
        {
            return (jiondata?.array?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = (self.jioncollection.dequeueReusableCell(
            withReuseIdentifier: "piccell", for: indexPath)) as UICollectionViewCell
        (cell.contentView.viewWithTag(1) as! UIImageView).getbyid(id:(jiondata?[indexPath.row]["pid"].int)!)
        (cell.contentView.viewWithTag(1) as! UIImageView).layer.cornerRadius = (cell.contentView.viewWithTag(1) as! UIImageView).frame.size.width/2.0
        (cell.contentView.viewWithTag(1) as! UIImageView).layer.masksToBounds = true
        return cell
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
}
