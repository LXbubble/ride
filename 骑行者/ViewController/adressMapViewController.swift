//
//  adressMapViewController.swift
//  骑行者
//
//  Created by apple on 17/5/13.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class adressMapViewController: UIViewController,MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate {

    var mapView: MAMapView!
    
    var search: AMapSearchAPI!
    
    var annotation = MAPointAnnotation()
    
    var locationManager = AMapLocationManager()
    
    var vcdelegate:CreatactivityViewController?
    
    var adresstext = UITextField(frame: CGRect(x: 0, y:60, width:UIScreen.main.bounds.width, height: 30))
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title:"完成",style:.plain, target:self, action: #selector(self.setadress))
        adresstext.borderStyle = .roundedRect
        self.view.addSubview(adresstext)
        self.view.bringSubview(toFront: adresstext)
        adresstext.isHidden = true
        
        reloaction()
        //设置定位
        locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        locationManager.locationTimeout = 2
        
        locationManager.reGeocodeTimeout = 2

        AMapServices.shared().apiKey = "a598628551f523cbc19fc1939e2f8e23"
        
        initMapView()
        initSearch()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        mapView.zoomLevel = 14
        mapView.showsScale = true
//        mapView.showsUserLocation = true
//        mapView.userTrackingMode = MAUserTrackingMode.follow
    }
    
    func setadress(){
        vcdelegate?.adress.text = self.adresstext.text
        vcdelegate?.image = self.mapView.takeSnapshot(in:CGRect(x: 0, y: 100, width:UIScreen.main.bounds.width , height:UIScreen.main.bounds.width/4 ))
        vcdelegate?.location = annotation.coordinate
        self.navigationController?.popViewController(animated: true)
        
    }
    
    func initMapView() {
        
        mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        self.view.addSubview(mapView!)
        self.view.sendSubview(toBack: mapView!)
    }
    
    
     func reloaction() {
        
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
                print("location:%@", location)
                self?.mapView.setCenter(location.coordinate, animated: true)
            }
            
            if let reGeocode = reGeocode {
                print("reGeocode:%@", reGeocode)
            }
            })
        
    }
    
    func initSearch() {
        //        AMap
        search = AMapSearchAPI()
        search.delegate = self
    }
    
    
    func mapView(_ mapView: MAMapView!, didSelect view: MAAnnotationView!) {
        print("点击了大头针222222")
        
    }
    
    
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        
        if annotation.isKind(of: MAPointAnnotation.self) {
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
            
            if annotationView == nil {
                annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
            }
            
            annotationView!.canShowCallout = true
            annotationView!.animatesDrop = true
            annotationView!.isDraggable = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
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
            self.adresstext.isHidden = false
            self.adresstext.text = response.regeocode.formattedAddress
        }
    }

}
