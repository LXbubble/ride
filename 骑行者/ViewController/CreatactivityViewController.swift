//
//  CreatactivityViewController.swift
//  骑行者
//
//  Created by apple on 17/5/12.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class CreatactivityViewController: UIViewController,UITextViewDelegate {

    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var adress: UITextField!
    @IBOutlet weak var placeholder1: UILabel!
   
    @IBOutlet weak var detail: UITextView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var timetext: UITextField!
    @IBOutlet weak var number: UITextField!
    
    var image : UIImage?
    
    var location : CLLocationCoordinate2D?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //键盘
        self.hideKeyboardWhenTappedAround()
        
        self.nickname.text = (UserDefaults.standard.string(forKey: "user_nickname"))!
          self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(self.creat))
        self.hideKeyboardWhenTappedAround()
         detail.delegate = self
      
        
        //创建日期选择器
        let datePicker = UIDatePicker(frame: CGRect(x:0, y:0, width:320, height:216))
        //将日期选择器区域设置为中文，则选择器日期显示为中文
        datePicker.locale = Locale(identifier: "zh_CN")
        //注意：action里面的方法名后面需要加个冒号“：”
        datePicker.addTarget(self, action: #selector(dateChanged),
                             for: .valueChanged)
        self.timetext.inputView = datePicker
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // 创建提醒
    func creatAlart(_ message:String){
        let alartController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alartController,animated:true,completion:nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1){
            self.presentedViewController?.dismiss(animated: false, completion:nil)
        }
    }
    func dateChanged(datePicker : UIDatePicker){
        //更新提醒时间文本框
        let formatter = DateFormatter()
        //日期样式
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.timetext.text = formatter.string(from: datePicker.date)
        print("shijian: \(datePicker.date)")
    }
    
    
    //设置地址
    @IBAction func setadress(_ sender: AnyObject) {
        let vc = adressMapViewController()
        vc.vcdelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        //self.present(vc, animated: true, completion: nil)
    }
    
    
    //完成创建
    func creat(){
        if self.name.text == ""{
            creatAlart("标题不能为空")
            
        }else if self.adress.text == ""{
            creatAlart("集合地点不能为空")
        }else if self.timetext.text == ""{
            creatAlart("请选择时间")
        }else if self.detail.text == "" {
            creatAlart("详细信息")
        }else if self.number.text == ""{
            creatAlart("联系电话不能为空")
        }else{
            var arry = [
                "name":self.name.text!,
                "token":(UserDefaults.standard.string(forKey: "token"))!,
                "nickname":self.nickname.text!,
                "detail":self.detail.text!,
                "time":self.timetext.text!,
                "adress":self.adress.text!,
                "number":self.number.text!,
                "user_id":(UserDefaults.standard.string(forKey: "user_id"))!,
                "latitude":(self.location?.latitude)!,
                "longtitude":(self.location?.longitude)!
                ] as [String : Any]
            print("数组：\(arry)")
            
            let data: Data? = UIImageJPEGRepresentation(self.image!, 0.8)
            photopost(data: data!){
                (data) in
                print("data:55",data)
                arry["pictures_id"] = data["id"].string!
                print("数组：\(arry)")
                let url = "activity/activitys/setactivity"
                Apost(url: url, body: arry)
                { data in
                    print("activitydata:\(data)")
                    if data.bool! {
                        let alert = UIAlertController(title: nil, message: "创建成功", preferredStyle: .alert)
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
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        placeholder1.isHidden = true
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if detail.text == "" {
            placeholder1.isHidden = false
        }
    }
    
    

}
