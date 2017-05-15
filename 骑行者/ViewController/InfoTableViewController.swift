//
//  InfoTableViewController.swift
//  骑行者
//
//  Created by apple on 17/5/15.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import SWRevealViewController
import SwiftyJSON
import Alamofire


class InfoTableViewController: UITableViewController,UIImagePickerControllerDelegate ,UINavigationControllerDelegate {

    @IBOutlet weak var upic: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var gender: UILabel!
    @IBOutlet weak var age: UILabel!
    
    
    var data: JSON?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.isUserInteractionEnabled = true
        if !readtoken() {load()}
        self.navigationItem.leftBarButtonItem?.target = self.revealViewController()
//        self.navigationItem.leftBarButtonItem?.image = UIImage(icon: .FABars, size: CGSize(width: 30, height: 30),textColor:.black)
        self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
        self.revealViewController().tapGestureRecognizer()
        self.revealViewController().panGestureRecognizer()
        
            }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func load()
        
    {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loadview") as! LoadViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated:true)
    }
    
    
    //获取user信息
    func getdata(){
        let id = UserDefaults.standard.string(forKey: "user_id")
        let url = "user/userinfo/readuserinfo/id/\(id)"
        Aget(url: url)
        {data in
            
            self.data = data
        }
    }
    //设置用户信息
    func setsuerinfo()
    {
        self.upic.getbyid(id: (data?["id"].int!)!)
        self.nickname.text = data?["nickname"].string!
        self.age.text = "\(data?["age"].int!)"
        self.city.text = data?["city"].string!
        self.gender.text = data?["city"].string
    }
    
//设置头像
    func  setupic(){
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
        self.upic.image = pickedImage
        let data: Data? = UIImageJPEGRepresentation(pickedImage, 0.8)
        let url = "user/userinfo/setupic/id/\(self.data?["id"].int!)"
        let URL = urladd(url: url)
        Alamofire.request(URL,method: .post,parameters:[:], encoding:data!).response
            {
                response in
                print("\(response.data)")
            }
        
        
        //UIImageWriteToSavedPhotosAlbum(pickedImage, nil, nil, nil)
        picker.dismiss(animated: true, completion: nil)
    }


    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        
        
    }


   

}
