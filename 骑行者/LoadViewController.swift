//
//  LoadViewController.swift
//  骑行者
//
//  Created by apple on 17/3/25.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import JWT
import Alamofire
import SwiftyJSON
import Font_Awesome_Swift




class LoadViewController: UIViewController,UITextFieldDelegate,TencentSessionDelegate{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let rightbtn = UIBarButtonItem(title: "跳过", style: .plain, target: self, action: #selector(LoadViewController.tiaoguo(_:)))
        self.navigationItem.rightBarButtonItem = rightbtn
        
    }
    
    
    var _tencentOAuth:TencentOAuth!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if readtoken(){
            decodetoken()
            self.change()
        }
        
        
        
        //设置qq appid   1106017496
        _tencentOAuth = TencentOAuth.init(appId: "1106017496", andDelegate:self )
        //设置导航返回按钮
        let backbtn = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = backbtn
        
        //第三方登录图标设置成圆形
        qqbtn.layer.cornerRadius = qqbtn.frame.size.width/2.0
        qqbtn.layer.masksToBounds = true
        wbbtn.layer.cornerRadius = wbbtn.frame.size.width/2.0
        wbbtn.layer.masksToBounds = true
        
        //设置textfield 左侧图标
        username.setLeftViewFAIcon(icon: .FAUserCircle, leftViewMode: .always)
        userpsw.setLeftViewFAIcon(icon: .FALock, leftViewMode: .always)
        
        
        //初始化按钮
        loadbtn.isUserInteractionEnabled = false
        loadbtn.backgroundColor = UIColor.gray
        //添加监测、设置代理
        
        userpsw.delegate = self
        userpsw.tag = 1
        username.delegate = self
        username.tag = 0
        userpsw.addTarget(self, action: #selector(LoadViewController.textFieldDidChange(sender:)), for: .editingChanged)
        username.addTarget(self, action: #selector(LoadViewController.textFieldDidChange(sender:)), for: .editingChanged)
        
        //self.navigationController?.isNavigationBarHidden = true
        //username.layer.borderColor = UIColor.white.cgColor
        //username.layer.borderWidth = 1
        
    }
    
    @IBOutlet weak var loadbtn: UIButton!
    @IBOutlet weak var wbbtn: UIButton!
    @IBOutlet weak var qqbtn: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var userpsw: UITextField!
    
    
    //跳过登录--页面切换
    func tiaoguo (_ sender:AnyObject){
        self.performSegue(withIdentifier: "TiaoGuo", sender: nil)
    }
    
    func change(){
        self.performSegue(withIdentifier: "TiaoGuo", sender: nil)
    }
    
    
    
    
    
    //键盘 done 按钮反应
    
    func textFieldShouldReturn(_ textField:UITextField)->Bool{
        
        
        if let nextTextFiled = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField{
            nextTextFiled.becomeFirstResponder()
        }
        else {
            textField.resignFirstResponder()
        }
        return false
    }
    
    // 创建提醒
    func creatAlart(message:String){
        let alartController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alartController,animated:true,completion:nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
            self.presentedViewController?.dismiss(animated: false, completion:nil)
        }
    }
    
    //qq登录
    
    @IBAction func qqlogin(_ sender: AnyObject) {
        //设置权限列表
        let permissions = ["get_user_info","get_simple_userinfo"];
        //登陆
        _tencentOAuth.authorize(permissions)
        
    }
    
    //登陆完成调用
    func tencentDidLogin() {
        if !_tencentOAuth.accessToken.isEmpty {
            _tencentOAuth.getUserInfo()
        }else {
            creatAlart(message:"登录失败")
        }
    }
    
    //登录失败后的回调
    
    func tencentDidNotLogin(_ cancelled:Bool) {
        if cancelled {
            creatAlart(message: "用户取消登录")
        }else{
            print("登录失败!")
        }
    }
    func tencentDidNotNetWork() {
        creatAlart(message: "没有网络，无法登录")
    }
    
    //取得用户信息的回调
    
    func getUserInfoResponse(_ response: APIResponse!) {
        
        let data = response.jsonResponse
        print("qqdata:\(data)")
        let name :String = _tencentOAuth.openId
        let nickname:String = data?["nickname"] as! String
        let gender:String = data?["gender"] as!String
        let city : String = data?["city"] as! String
        var body = ["name":name,"nickname":nickname,"city":city,"gender":gender]
        let figureurl = data?["figureurl"] as! String
        Alamofire.request(figureurl).response{
            response in
            let data = response.data
            photopost(data: data!){
                data in
                body["pictures_id"] = (data["id"].string)!
                let url:String = "user/load/qqload"
                Apost(url: url, body: body) { (data) in
                    if let token = data["token"].string {
                        print("qq信息录入成功")
                        UserDefaults.standard.set(token, forKey:"token")
                        decodetoken()
                        //登录成功，界面跳转
                        self.change()
                        
                    }else {
                        print("false")
                    }
                }
            }
        }
    }
    
    
    
    
    //键盘隐藏
    @IBAction func hidekeyboard(_ sender: AnyObject) {
        username.resignFirstResponder()
        userpsw.resignFirstResponder()
    }
    
    
    //textfield内容监听 确定登录按钮是否可选
    
    func textFieldDidChange(sender:UITextField) {
        let name = username.text! as String
        let psw  = userpsw.text! as String
        if loadcheck(name: name, psw: psw) {
            loadbtn.isUserInteractionEnabled = true
            loadbtn.backgroundColor = UIColor.blue
        }
        else{
            loadbtn.isUserInteractionEnabled = false
            loadbtn.backgroundColor = UIColor.gray
            
        }
        
        
    }
    //用户名密码登录
    @IBAction func Load(_ sender: AnyObject) {
        
        //检测text是否输入内容
        let body = ["name" : self.username.text! as String, "psw" : self.userpsw.text! as String ]
        let url:String = "user/load/firstload"
        //post 请求
        Apost(url: url, body:body) { (data) in
            if data["error"].string == "1"{
                self.creatAlart(message: data["text"].string!)
            }
            else if data["error"].string == "0" {
                let token:String = data["token"].string!
                UserDefaults.standard.set(token, forKey:"token")
                decodetoken()
                self.change()
                
            }
            else{
                self.creatAlart(message: "未知错误")
            }
            
        }
       
    }
    
    
}
