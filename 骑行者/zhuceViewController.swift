//
//  zhuceViewController.swift
//  骑行者
//
//  Created by apple on 17/3/29.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import JWT
import Alamofire
import SwiftyJSON
import Font_Awesome_Swift


class zhuceViewController: UIViewController ,UITextFieldDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        zhucebtn.isUserInteractionEnabled = false
        zhucebtn.backgroundColor = UIColor.gray
        
        //设置textfield 左侧图标
        name.setLeftViewFAIcon(icon: .FAUserCircle, leftViewMode: .always)
        psw.setLeftViewFAIcon(icon: .FALock, leftViewMode: .always)
        nickname.setLeftViewFAIcon(icon: .FAUserSecret, leftViewMode: .always)
        //设置textfield tag
        name.tag = 1
        psw.tag = 2
        nickname.tag = 3
        //添加监测
        name.delegate = self
        psw.delegate = self
        nickname.delegate = self
        psw.addTarget(self, action: #selector(zhuceViewController.textFieldDidChange(sender:)), for: .editingChanged)
        name.addTarget(self, action: #selector(zhuceViewController.textFieldDidChange(sender:)), for: .editingChanged)
        nickname.addTarget(self, action: #selector(zhuceViewController.textFieldDidChange(sender:)), for: .editingChanged)
        
    }
    //textfield内容监听 确定登录按钮是否可选
    
    func textFieldDidChange(sender:UITextField) {
        let name = self.name.text! as String
        let psw  = self.psw.text! as String
        let nickname = self.nickname.text! as String
        if zhucecheck2(name: name , psw: psw ,nickname:nickname) {
            zhucebtn.isUserInteractionEnabled = true
            zhucebtn.backgroundColor = UIColor.blue
        }
        else{
            zhucebtn.isUserInteractionEnabled = false
            zhucebtn.backgroundColor = UIColor.gray
            
        }
    }
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var psw: UITextField!
    @IBOutlet weak var zhucebtn: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    //注册
    
    @IBAction func zhuce(_ sender: AnyObject) {
        let name = self.name.text! as String
        let password = self.psw.text! as String
        let nickname = self.nickname.text! as String
        let body = ["name":name,"password":password,"nickname":nickname,"role":"user"]
        let url :String = "user/load/register"
        //post 请求
        Apost(url:url,body:body){ (data) in
            if data["token"].string != nil  {
                let token:String = data["token"].string!
                UserDefaults.standard.set(token, forKey:"token")
                decodetoken()
                let alartController = UIAlertController(title: nil, message: "注册成功", preferredStyle: .alert)
                self.present(alartController,animated:true,completion:nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                    self.presentedViewController?.dismiss(animated: false, completion:nil)
                }
            }
            else if data["error"].string != nil {
                let alartController = UIAlertController(title: nil, message: data["error"].string, preferredStyle: .alert)
                self.present(alartController,animated:true,completion:nil)
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
                    self.presentedViewController?.dismiss(animated: false, completion:nil)
                }
            }
        }
    }
    
    
    //键盘隐藏
    @IBAction func hideKeyBoard(_ sender: AnyObject) {
        name.resignFirstResponder()
        psw.resignFirstResponder()
        nickname.resignFirstResponder()
    }
    
    //键盘 done 按钮反应
    
    func textFieldShouldReturn(_ textField:UITextField)->Bool{
        
        textField.resignFirstResponder()
        return true
    }
    
    
    
}
