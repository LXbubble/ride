//
//  newsdetailViewController.swift
//  骑行者
//
//  Created by apple on 17/5/8.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
class newsdetailViewController: UIViewController {
    
    
    let scwidth = UIScreen.main.bounds.size.width
    let scheight = UIScreen.main.bounds.size.height
    
    var data :JSON? = []
    



    @IBOutlet weak var votebutton: UIButton!
    @IBOutlet weak var fxbutton: UIButton!
    @IBOutlet weak var commenttext: UITextField!
    
    var keyBoardNeedLayout: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.votebutton.setImage(UIImage(icon: .FAThumbsOUp, size:CGSize(width:25,height:25) ,textColor:.gray ), for: .normal)
        self.fxbutton.setImage(UIImage(icon: .FAShareSquareO, size:CGSize(width:25,height:25) ,textColor:.gray ), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        if UserDefaults.standard.string(forKey: "user_role") == "manager"{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(icon: .FATrashO, size: CGSize(width:25,height:25)),style: .plain, target: self, action:#selector(self.deldetenews))
        }else {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(icon: .FAHeartO, size: CGSize(width:25,height:25)),style: .plain, target: self, action: nil)
        }
        
        }
    
    @IBAction func share(_ sender: AnyObject) {
        
        let alert = UIAlertController.init(title:  "分享到：", message: nil, preferredStyle: .actionSheet)
        let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
        let actionCamera = UIAlertAction.init(title: "QQ", style: .default) { (UIAlertAction) -> Void in
           //方法
            self.sharenews(type: SSDKPlatformType.typeQQ)
        }
        let actionPhoto = UIAlertAction.init(title: "新浪微博", style: .default) { (UIAlertAction) -> Void in
           //方法
            self.sharenews(type: SSDKPlatformType.typeSinaWeibo)
        }
        
        alert.addAction(actionCancel)
        alert.addAction(actionCamera)
        alert.addAction(actionPhoto)
        
        self.present(alert, animated: true, completion: nil)

        
    }
    func  sharenews(type:SSDKPlatformType){
        // 1.创建分享参数
        let shareParames = NSMutableDictionary()
        shareParames.ssdkSetupShareParams(byText: "分享内容分享内容分享内容分享内容分享内容分享内容分",
                                          images : UIImage(named: "good"),
                                          url : NSURL(string:"http://baidu.com") as URL!,
                                          title : "分享标题",
                                          type : SSDKContentType.image)
        
        //2.进行分享
        ShareSDK.share(type, parameters: shareParames) { (state : SSDKResponseState, nil, entity : SSDKContentEntity?, error :Error?) in

            if state == SSDKResponseState.success {
            let alert = UIAlertController.init(title:  "分享成功", message: nil, preferredStyle: .alert)
            let actionCancel = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
            }else if state == SSDKResponseState.fail{
                let alert = UIAlertController.init(title:  "分享失败", message:"\(error)", preferredStyle: .alert)
                let actionCancel = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
                alert.addAction(actionCancel)
                self.present(alert, animated: true, completion: nil)
            }else if state == SSDKResponseState.cancel {
                let alert = UIAlertController.init(title:  "取消分享", message:"\(error)", preferredStyle: .alert)
                let actionCancel = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
                alert.addAction(actionCancel)
                self.present(alert, animated: true, completion: nil)
            }else {
                let alert = UIAlertController.init(title:  "未知错误", message:"\(error)", preferredStyle: .alert)
                let actionCancel = UIAlertAction.init(title: "确定", style: .cancel, handler: nil)
                alert.addAction(actionCancel)
                self.present(alert, animated: true, completion: nil)
            }
//
//            switch state{
//                
//            case SSDKResponseState.success: print("分享成功")
//            case SSDKResponseState.fail:    print("授权失败,错误描述:\(error)")
//            case SSDKResponseState.cancel:  print("操作取消")
//            default:
//                break
//            }
            
        }
    }
    //点赞
    @IBAction func vote(_ sender: AnyObject) {
        
        
        if !readtoken(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "loadview") as! LoadViewController
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated:true)
        }else {
            let url = "information/information/vote/id/\((data?["id"].int)!)"
            Alamofire.request(urladd(url: url)).response{
                response in
                debugPrint(response)
                self.votebutton.setImage(UIImage(icon: .FAThumbsOUp, size:CGSize(width:25,height:25),textColor:.red), for: .normal)
                self.votebutton.isUserInteractionEnabled = false
            }
        }
    }
    
    
    //删除
    func deldetenews(){
        
        let alert = UIAlertController(title: "系统提示", message:"确定删除吗", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let creatAction = UIAlertAction(title: "确定", style:.default, handler: {
            action in
            let token = UserDefaults.standard.string(forKey: "token")
            print("token",token)
            let arr = ["token":token!]
            let url = "information/information/delnews/id/\((self.data?["id"].int)!)"
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
        
    
    
    
    
    
    //键盘弹起响应
    func keyboardWillShow(notification: NSNotification) {
        print("show")
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            
            let deltaY = intersection.height
            
            if keyBoardNeedLayout {
                UIView.animate(withDuration: duration, delay: 0.0,
                                           options: UIViewAnimationOptions(rawValue: curve),
                                           animations: { _ in
                                            self.view.frame = CGRect(x:0,y:-deltaY,width:self.view.bounds.width,height:self.view.bounds.height)
                                            self.keyBoardNeedLayout = false
                                            self.view.layoutIfNeeded()
                    }, completion: nil)
            }
            
            
        }
    }
    
    //键盘隐藏响应
    func keyboardWillHide(notification: NSNotification) {
        print("hide")
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            let intersection = frame.intersection(self.view.frame)
            
            let deltaY = intersection.height
            
            UIView.animate(withDuration: duration, delay: 0.0,
                                       options: UIViewAnimationOptions(rawValue: curve),
                                       animations: { _ in
                                        self.view.frame = CGRect(x:0,y:deltaY,width:self.view.bounds.width,height:self.view.bounds.height)
                                        self.keyBoardNeedLayout = true
                                        self.view.layoutIfNeeded()
                }, completion: nil)
            
        }
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
