//
//  phoneRegisterViewController.swift
//  骑行者
//
//  Created by apple on 17/4/1.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import JWT
import Alamofire
import SwiftyJSON
import Font_Awesome_Swift


class phoneRegisterViewController: UIViewController,UITextFieldDelegate{
    
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var checkNumber: UITextField!
    @IBOutlet weak var psw: UITextField!
    @IBOutlet weak var nickname: UITextField!
    @IBOutlet weak var registerbtn: UIButton!
    @IBOutlet weak var checkbtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //设置textfield 左侧图标
        nickname.setLeftViewFAIcon(icon: .FAUserSecret, leftViewMode: .always)
        phoneNumber.setLeftViewFAIcon(icon: .FAMobile, leftViewMode: .always,size:CGSize(width: 30, height: 35))
        checkNumber.setLeftViewFAIcon(icon: .FAStickyNoteO, leftViewMode: .always)
        psw.setLeftViewFAIcon(icon: .FALock, leftViewMode: .always)
        
        
        SMSSDK.registerApp("1ca0cc9ac805e", withSecret: "9d8c9a9332ce0e857d08ef9986b597bc")
        //代理设置
        phoneNumber.delegate = self
        checkNumber.delegate = self
        psw.delegate = self
        nickname.delegate = self
        //textfield 添加监测
        phoneNumber.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        checkNumber.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        psw.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        nickname.addTarget(self, action: #selector(self.textFieldDidChange(sender:)), for: .editingChanged)
        //初始化注册按钮
        registerbtn.isUserInteractionEnabled = false
        registerbtn.backgroundColor = UIColor.gray
        checkbtn.isUserInteractionEnabled = false
        checkbtn.setTitleColor(UIColor.gray, for: .normal)
        
        checkbtn.addTarget(self, action: #selector(self.checkbtnClick(sender:)), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    //获取验证码
    @IBAction func getNumber(_ sender: AnyObject) {
        let pn = phoneNumber.text!
        
        SMSSDK.getVerificationCode(by: SMSGetCodeMethodSMS, phoneNumber: pn, zone: "86", customIdentifier: nil){
            (error: Error?) -> Void in
            if(error == nil){
                let message = "获取成功"
                self.creatAlart(message: message)
            }
            else{
                let message = "获取失败,请重试"
                self.creatAlart(message: message)
                print(error)
            }
            
        }
        
    }
    
    //手机号注册 以及验证码验证
    @IBAction func phoneRegister(_ sender: AnyObject) {
        let code = checkNumber.text!
        let pn = phoneNumber.text!
        print("code:",code)
        SMSSDK.commitVerificationCode(code, phoneNumber: pn, zone: "86"){
            (userinfo:SMSSDKUserInfo?,error: Error?)-> Void in
            if (error == nil) {
                
                let body = ["name":self.phoneNumber.text!,"password":self.psw.text!,"nickname":self.nickname.text!,"role":"user"]
                let url :String = "user/load/register"
                //post 请求
                Apost(url:url,body:body){ (data) in
                    if data["token"].string != nil  {
                        let token:String = data["token"].string!
                        UserDefaults.standard.set(token, forKey:"token")
                        decodetoken()
                        self.performSegue(withIdentifier: "TiaoGuo", sender: nil)
                    }
                        
                    else if data["error"].string != nil {
                        self.creatAlart(message: "手机号已注册")
                        print("cccccccccccc2")
                    }
                }
            }
            else {
                print(userinfo)
                print(pn)
                print("1112223444556")
                print(code)
                print(error)
                print(error.debugDescription)
                self.creatAlart(message: "验证失败，请重试")
            }
        }
        
    }
    
    
    
    
    
    // 创建提醒
    func creatAlart(message:String){
        let alartController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alartController,animated:true,completion:nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2){
            self.presentedViewController?.dismiss(animated: false, completion:nil)
        }
    }
    
    //获取验证码按钮的改变
    var remainingSeconds: Int = 0 {
        willSet {
            checkbtn.setTitle("\(newValue)秒", for: .normal)
            if newValue <= 0 {
                checkbtn.setTitle("重新获取", for: .normal)
                isCounting = false
            }
        }
    }
    var countdownTimer: Timer?
    var isCounting = false {
        willSet {
            if newValue {
                countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTime), userInfo: nil, repeats: true)
                remainingSeconds = 60
                checkbtn.setTitleColor(UIColor.gray, for: .normal)
                phoneNumber.isUserInteractionEnabled = false
            } else {
                countdownTimer?.invalidate()
                countdownTimer = nil
                checkbtn.backgroundColor = UIColor.white
                phoneNumber.isUserInteractionEnabled = true
            }
            checkbtn.isEnabled = !newValue
        }
    }
    func updateTime(timer: Timer) {
        // 计时开始时，逐秒减少remainingSeconds的值
        remainingSeconds -= 1
    }
    
    func checkbtnClick(sender: UIButton) {
        // 启动倒计时
        isCounting = true
    }
    //textfield 内容监听，确定按键是否可以点击
    
    
    func textFieldDidChange(sender:UITextField){
        let phonepattern = "^1[0-9]{10}$"
        let dic : Dictionary<String,String> = ["pn":self.phoneNumber.text!,"cn":checkNumber.text!,"psw":psw.text!,"nickname":nickname.text!]
        
        if checkpattern(str: dic["pn"]!, pattern: phonepattern){
            checkbtn.isUserInteractionEnabled = true
            checkbtn.setTitleColor(UIColor.blue, for: .normal)
        }else{ checkbtn.isUserInteractionEnabled = false
            checkbtn.setTitleColor(UIColor.gray, for: .normal)}
        
        if phonecheck(dic: dic ){
            registerbtn.isUserInteractionEnabled = true
            registerbtn.backgroundColor = UIColor.blue
        }else {registerbtn.isUserInteractionEnabled = false
            registerbtn.backgroundColor = UIColor.gray}
    }
    
    //键盘隐藏
    @IBAction func hideKeyBoard(_ sender: AnyObject) {
        phoneNumber.resignFirstResponder()
        psw.resignFirstResponder()
        nickname.resignFirstResponder()
        checkNumber.resignFirstResponder()
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
