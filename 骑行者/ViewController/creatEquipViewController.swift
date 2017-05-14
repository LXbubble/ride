//
//  creatEquipViewController.swift
//  骑行者
//
//  Created by apple on 17/5/14.
//  Copyright © 2017年 李响. All rights reserved.
//
import UIKit
import Alamofire
import Photos
import SwiftyJSON

    class creatEquipViewController: UIViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate{
        

        @IBOutlet weak var name: UITextField!

        @IBOutlet weak var url: UITextField!
        @IBOutlet weak var newsimage: UIImageView!
       
        
        override func viewDidLoad() {
            
            //键盘
            self.hideKeyboardWhenTappedAround()
            super.viewDidLoad()
            let keybutton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            keybutton.addTarget(self, action: #selector(self.hidekeyboard), for: .touchUpInside)
            self.view.addSubview(keybutton)
            self.view.sendSubview(toBack: keybutton)

            newsimage.isUserInteractionEnabled = true
            let tapGR = UITapGestureRecognizer(target: self, action:#selector(self.addimage))
            newsimage.addGestureRecognizer(tapGR)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(self.creatnews))
            
            
            // Do any additional setup after loading the view.
        }
        
        // 键盘隐藏
        func hidekeyboard(){
            self.view.endEditing(true)
        }
        //完成创建
        
        func creatnews(){
            let image1 = self.newsimage.image
            if image1 == UIImage(named: "plus"){
                
                let alert = UIAlertController(title: "系统提示", message:"请选择一张图片", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }else if self.name.text == "" || self.url.text == ""{
                
                let alert = UIAlertController(title: "系统提示", message: "信息不能为空", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler:nil )
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
                
            }else if (self.name.text?.characters.count)! > 45{
                let alert = UIAlertController(title: "系统提示", message: "标题过长", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler:nil )
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            else{
                
                var arry = [
                    "token":UserDefaults.standard.string(forKey: "token")!,
                    "name":self.name.text!,
                    "url":self.url.text!,
                    ] as [String : Any]
                
                
                
                let data: Data? = UIImageJPEGRepresentation(image1!, 0.8)
                photopost(data: data!){
                    (data) in
                    print("data:55",data)
                    arry["pictures_id"] = data["id"].string!
                    let url2  =  "information/equips/setequip"
                    
                    Apost(url:url2 , body: arry)
                    {   data in
                        
                        let alert = UIAlertController(title: "创建成功", message:nil, preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: {
                            action in
                            self.navigationController?.popViewController(animated: true)
                            
                        })
                        alert.addAction(cancelAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
        
        
        func addimage(){
            let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
            
            // change the style sheet text color
            alert.view.tintColor = UIColor.black
            
            let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
            let actionCamera = UIAlertAction.init(title: "拍照", style: .default) { (UIAlertAction) -> Void in
                self.takephoto()
            }
            
            let actionPhoto = UIAlertAction.init(title: "从手机照片中选择", style: .default) { (UIAlertAction) -> Void in
                self.pickerphoto()
            }
            
            alert.addAction(actionCancel)
            alert.addAction(actionCamera)
            alert.addAction(actionPhoto)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        
        //拍摄照片
        func takephoto(){
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                //创建图片控制器
                let picker = UIImagePickerController()
                //设置代理
                picker.delegate = self
                //设置来源
                picker.sourceType = UIImagePickerControllerSourceType.camera
                //允许编辑
                picker.allowsEditing = true
                //打开相机
                self.present(picker, animated: true, completion: { () -> Void in
                    
                })
            }else{
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "访问相机失败", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        
        //相册选择图片
        func pickerphoto(){
            //判断设置是否支持图片库
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                //初始化图片控制器
                let picker = UIImagePickerController()
                //设置代理
                picker.delegate = self
                //指定图片控制器类型
                picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
                //弹出控制器，显示界面
                self.present(picker, animated: true, completion: {
                    () -> Void in
                })
            }else{
                let alertController = UIAlertController(title: "系统提示",
                                                        message: "访问相册失败", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
        //选择图片成功后代理
        public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
        {
            
            let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
            self.newsimage.image = pickedImage
            //UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
            picker.dismiss(animated: true, completion: nil)
        }
        
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        
        

}
