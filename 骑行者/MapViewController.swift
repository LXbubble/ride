//
//  MapViewController.swift
//  骑行者
//
//  Created by apple on 17/4/3.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class MapViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate{
   
    @IBOutlet weak var paishe: UIButton!
   
    @IBOutlet weak var begin: UIButton!
    @IBOutlet weak var infoview: UIView!
    var userlocation:CLLocationCoordinate2D?
    var mapView: MAMapView!
    var search: AMapSearchAPI!
    var annotation = MAPointAnnotation()
    var locationManager = AMapLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
    self.delbtn.isHidden = true
        self.navigationController?.isNavigationBarHidden = true
        begin.layer.cornerRadius = begin.frame.size.width/2.0
        begin.layer.masksToBounds = true
        self.tabBarItem.method(for: #selector(self.showinfo(_:)))
        self.infoview.isHidden = true
        // Do any additional setup after loading the view, typically from a nib.
        //self.title = "Swift Demo"
        
        
       //设置定位
        locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.locationTimeout = 2
        
        locationManager.reGeocodeTimeout = 2
        
     
        
        AMapServices.shared().apiKey = "a598628551f523cbc19fc1939e2f8e23"
        
        initMapView()
        initSearch()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.setFAIcon(icon: .FABicycle)
        self.tabBarItem.title = "骑行"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        mapView.zoomLevel = 14
        mapView.showsScale = true
        
        
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = MAUserTrackingMode.follow
        getlocation()
        
        
    }
    
    @IBAction func showinfo(_ sender: AnyObject) {
        self.infoview.isHidden = false
    }
   
    
    
    func initMapView() {
       
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.distanceFilter = 3.0
        mapView.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        self.view.addSubview(mapView!)
        self.view.sendSubview(toBack: mapView!)
    }
    
    @IBOutlet weak var relocation: UIButton!
    @IBOutlet weak var delbtn: UIButton!
    
    @IBAction func delline(_ sender: AnyObject) {
        mapView.remove(self.polyline)
        mapView.removeAnnotation(self.annotation)
        self.delbtn.isHidden = true
    }
    

    @IBAction func reloaction(_ sender: AnyObject) {
        getlocation()
    }
    func getlocation(){
        
        //单次定位
        
        locationManager.requestLocation(withReGeocode: false, completionBlock: { [weak self] (location: CLLocation?, reGeocode: AMapLocationReGeocode?, error: Error?) in
            print("单次定位开启：")
            print("dingwei:error:\(error)")
            if let error = error {
                let error = error as NSError
                print("error：\(error)");
                if error.code == AMapLocationErrorCode.locateFailed.rawValue {
                    //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                    print("定位错误:{\(error.code) - \(error.localizedDescription)};")
                    return
                }
                else if error.code == AMapLocationErrorCode.reGeocodeFailed.rawValue
                    || error.code == AMapLocationErrorCode.timeOut.rawValue
                    || error.code == AMapLocationErrorCode.cannotFindHost.rawValue
                    || error.code == AMapLocationErrorCode.badURL.rawValue
                    || error.code == AMapLocationErrorCode.notConnectedToInternet.rawValue
                    || error.code == AMapLocationErrorCode.cannotConnectToHost.rawValue {
                    
                    //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                    print("逆地理错误:{\(error.code) - \(error.localizedDescription)};")
                }
                else {
                    print("单次定位信息:\(location)")
                }
            }
            
            if let location = location {
                print("定位成功location:%@", location)
                self?.mapView.setCenter(location.coordinate, animated: true)
               self?.userlocation = location.coordinate
            }
            
            if let reGeocode = reGeocode {
                print("reGeocode:%@", reGeocode)
            }
            })
        
        
        print("userlocation: \(mapView.userLocation!)")
        
    }
    func initSearch() {
        //        AMap
        search = AMapSearchAPI()
        search.delegate = self
    }
    
    // 标记点击
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
         print("点击了大头针222222")
        let startCoordinate        = userlocation!
        let destinationCoordinate  = self.annotation.coordinate
        let request = AMapRidingRouteSearchRequest()
        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))
        
    }
    
    //获取当前时间
    func getnowdate()->String{
        //获取当前时间
        let now = Date()
        // 创建一个日期格式器
        let dformatter = DateFormatter()
        dformatter.dateFormat = "yyyy－MM－dd HH:mm:ss"
        return ("\(dformatter.string(from: now))")
     }

    
    //骑行数据
    @IBOutlet weak var ridetime: UILabel!
    @IBOutlet weak var arspeedL: UILabel!
    @IBOutlet weak var maxspeedL: UILabel!
    @IBOutlet weak var prspeedL: UILabel!
    @IBOutlet weak var distence: UILabel!
    
    //开始骑行或结束骑行
    var polyline:MAPolyline?
    var polyline1:MAPolyline?
    var inttime:Int = 0
    var isbegin:Bool = false
    var distencecount:Double = 0.0
    var maxspeed:Double = 0.0
    var arspeed:Double = 0.0
    var prspeed:Double = 0.0
    var timer : Timer?
    var begintime :String?
    var lastcoordinate :CLLocationCoordinate2D?
    //坐标数组
    var coordinateArray: [CLLocationCoordinate2D] = []
    
    @IBAction func rideAction(_ sender: AnyObject) {
        if self.isbegin{
            //结束
            
            let alertController = UIAlertController(title: "结束骑行",
                                                    message: "设置纪录名称", preferredStyle: .alert)
            alertController.addTextField {
                (textField: UITextField!) -> Void in
                textField.text =  self.getnowdate()
            }
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                let name = alertController.textFields?.first!
                self.setrecord(name:(name?.text)!)
            })
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
            //开始
        else {
            self.begintime = getnowdate()
            self.begin.setTitle("骑行中", for: .normal)
            self.beginTimer()
            self.isbegin = true
        }
    }

    // 保存骑行纪录
    func setrecord(name:String){
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
        }else{
            let screenshotImage = self.mapView.takeSnapshot(in: self.view.bounds)
            let data: Data? = UIImageJPEGRepresentation(screenshotImage!, 0.8)
            photopost(data: data!){
                (data) in
                let arry = ["name":name,
                            "begintime":self.begintime!,
                            "arspeed":self.arspeedL.text!,
                            "maxspeed":self.maxspeedL.text!,
                            "ridetime":self.ridetime.text!,
                            "distence":self.distence.text!,
                            "user_id":(UserDefaults.standard.string(forKey: "user_id"))!,
                            "pictures_id":data["id"].string!] as [String : Any]
                print("骑行数据:\(arry)")
                let url = "information/records/setrecord"
                Apost(url: url, body: arry){
                    data in
                    if data.bool! {
                        self.begin.setTitle("开始骑行", for: .normal)
                        self.timer?.invalidate()
                        self.isbegin = false
                        self.resettext()
                    }
                }
            }
        }
    }
    
    
       //地图位置更新
    func mapView(_ mapView: MAMapView!, didUpdate userLocation: MAUserLocation!, updatingLocation: Bool) {
        // 地图每次有位置更新时的回调
        if updatingLocation{
            self.userlocation = userLocation.coordinate
        }
        
        
        if updatingLocation && self.isbegin {
            // 获取新的定位数据
           print("自动更新数据:\((userLocation.location)!)")
            if self.coordinateArray.count == 0 {
                let coordinate = userLocation.coordinate
                // 添加到保存定位点的数组
                self.coordinateArray.append(coordinate)
                self.lastcoordinate = coordinate
               
            }else {
                let coordinate = userLocation.coordinate
                // 添加到保存定位点的数组
                self.coordinateArray.append(coordinate)
                
                updataPath()
                //distence 计算
//                let point1 = CLLocationCoordinate2D(latitude:(self.lastcoordinate?.latitude)! , longitude: (self.lastcoordinate?.longitude)!)
//                let point2 = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
                let distence1 = MAMetersBetweenMapPoints(MAMapPointForCoordinate(self.lastcoordinate!),MAMapPointForCoordinate(coordinate))
                print("移动距离：\(distence1)")
                self.distencecount += distence1
                 print("距离：\(self.distencecount)")
                if userLocation.location.speed > 0{
                self.prspeed =  userLocation.location.speed
                print("即时速度：\(self.prspeed)")
                }
                self.arspeed =  (self.distencecount/Double(self.inttime))
                print("平均速度：\(self.arspeed)")
                if  userLocation.location.speed > self.maxspeed {
                    self.maxspeed = userLocation.location.speed
                }
                self.lastcoordinate = coordinate
            }
        }
    }

    
    //计时器
    func beginTimer(){
        
       self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.settext), userInfo: nil, repeats: true)
    }
    
    //设置信息
    func settext(){
        self.inttime += 1
        self.ridetime.text = intdate(inttime)
        self.arspeedL.text = "\(String(format: "%.1f", self.arspeed))"
        self.prspeedL.text = "\(self.prspeed)"
        self.distence.text = "\(String(format: "%.1f", (self.distencecount)/1000)) km"
        self.maxspeedL.text = "\(self.maxspeed)"
    }
    //初始化数据
    func resettext(){
        self.inttime = 0
        self.ridetime.text = "0:00:00"
        self.arspeedL.text = "0.0"
        self.prspeedL.text = "0.0"
        self.distence.text = "0.0"
        self.maxspeedL.text = "0.0"
        self.coordinateArray.removeAll()
    }
    //更新数据
    func updataPath(){
        
        // 每次获取到新的定位点重新绘制路径
        // 移除掉除之前的overlay
        self.mapView.remove(polyline1)
        
        self.polyline1 = MAPolyline(coordinates: &self.coordinateArray, count: UInt(self.coordinateArray.count))
        self.mapView.add(polyline1)
        
        // 将最新的点定位到界面正中间显示
//        let lastCoord = self.coordinateArray[self.coordinateArray.count - 1]
//        self.mapView.setCenter(lastCoord, animated: true)
 
    }
    
    
 // 绘制路径回调
    func mapView(_ mapView: MAMapView!, rendererFor overlay: MAOverlay!) -> MAOverlayRenderer! {
        if overlay.isKind(of: MAPolyline.self) {
            let polylineView = MAPolylineRenderer(overlay: overlay)
            polylineView?.lineWidth = 6
            polylineView?.strokeColor = UIColor(red: 4 / 255.0, green:  181 / 255.0, blue:  108 / 255.0, alpha: 1.0)
            return polylineView
        }
        
            return nil

    }
    
    
    
    
    

    
    //骑行路线规划
    func setline(){
        let startCoordinate        = userlocation!
        let destinationCoordinate  = self.annotation.coordinate
        let request = AMapRidingRouteSearchRequest()
        request.origin = AMapGeoPoint.location(withLatitude: CGFloat(startCoordinate.latitude), longitude: CGFloat(startCoordinate.longitude))
        request.destination = AMapGeoPoint.location(withLatitude: CGFloat(destinationCoordinate.latitude), longitude: CGFloat(destinationCoordinate.longitude))
       //发起路线请求
        search.aMapRidingRouteSearch(request)
    }
    //路线请求回调
    
    func onRouteSearchDone(_ request: AMapRouteSearchBaseRequest!, response: AMapRouteSearchResponse!) {
        if response.count > 0 {
            print("路线规划信息：\(response.route.paths[0])")
            //MAnaviro
            var coorarr : [CLLocationCoordinate2D] = []
            
            for i in response.route.paths[0].steps{
                
                coorarr +=  i.polyline.components(separatedBy: ";").map()
                    { x in
                        let co = x.components(separatedBy: ",")
                        return CLLocationCoordinate2D(latitude: Double(co[1])!, longitude: Double(co[0])!)
                }
            }
            self.mapView.remove(self.polyline)
            self.polyline = MAPolyline(coordinates: &coorarr, count: UInt(coorarr.count))
            self.mapView.add(polyline)
            self.delbtn.isHidden = false
        }
    }
    
    
    
    
    
    //
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            let dhbutton  = UIButton(type: .detailDisclosure)
            dhbutton.setImage(UIImage(named:"导航"), for:.normal)
            dhbutton.addTarget(self, action: #selector(self.setline), for: .touchUpInside)
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = dhbutton
            
          // let idx = annotation.index(of: annotation as! MAPointAnnotation)
            annotationView!.pinColor = MAPinAnnotationColor(rawValue: 1000)!
            
            return annotationView!
        }
        
        return nil
    }
    // 发起逆地理编码请求

    func searchReGeocodeWithCoordinate(coordinate: CLLocationCoordinate2D!) {
        let regeo: AMapReGeocodeSearchRequest = AMapReGeocodeSearchRequest()
        regeo.location = AMapGeoPoint.location(withLatitude: CGFloat(coordinate.latitude), longitude: CGFloat(coordinate.longitude))
        self.search!.aMapReGoecodeSearch(regeo)
    }
    
    func mapView(_ mapView: MAMapView!, didTouchPois pois: [Any]!) {
        self.infoview.isHidden = true
    }
    
    //MARK:- MAMapViewDelegate
    func mapView(_ mapView: MAMapView!, didLongPressedAt coordinate: CLLocationCoordinate2D) {
        // 长按地图触发回调，在长按点进行逆地理编码查询
        searchReGeocodeWithCoordinate(coordinate: coordinate)
    }
    
    //MARK:- AMapSearchDelegate
    private func AMapSearchRequest(request: AnyObject!, didFailWithError error: Error!) {
        print("request :\(request), error: \(error)")
    }
    
    // 逆地理查询回调
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest, response: AMapReGeocodeSearchResponse) {
        
        print("response :\(response.formattedDescription())----------------------------------------------------------")
        
        if (response.regeocode != nil) {
            
            let coordinate = CLLocationCoordinate2DMake(Double(request.location.latitude), Double(request.location.longitude))
            annotation.coordinate = coordinate
            annotation.title = response.regeocode.formattedAddress
            annotation.subtitle = response.regeocode.addressComponent.province
            mapView!.addAnnotation(annotation)
            self.delbtn.isHidden = false
        }
    }
    
    
    
}
