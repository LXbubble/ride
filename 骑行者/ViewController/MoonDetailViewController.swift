//
//  MoonDetailViewController.swift
//  骑行者
//
//  Created by apple on 17/5/10.
//  Copyright © 2017年 李响. All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire


class MoonDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate {
    
    let scwidth = UIScreen.main.bounds.size.width
    let scheight = UIScreen.main.bounds.size.height
    
    var data :JSON? = []
    var comdata : JSON? = []
    var moontableView : UITableView?
    var comtableView : UITableView?
    var scrollView = UIScrollView()
    
    var bkimage : UIImageView?
    
    @IBOutlet weak var votebutton: UIButton!
    @IBOutlet weak var fxbutton: UIButton!
    @IBOutlet weak var commenttext: UITextField!
    
    var keyBoardNeedLayout: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        let hidebutton = UIButton(frame: CGRect(x: 0, y: 0, width: scwidth, height: scheight))
        hidebutton.addTarget(self, action: #selector(self.hidekeyboard), for: .touchUpInside)
        self.view.addSubview(hidebutton)
        self.view.sendSubview(toBack: hidebutton)
        settableView()
        commenttext.delegate = self
        
        self.navigationItem.title = "详情"
        self.votebutton.setImage(UIImage(icon: .FAThumbsOUp, size:CGSize(width:25,height:25),textColor:.gray), for: .normal)
        self.fxbutton.setImage(UIImage(icon: .FAShareSquareO, size:CGSize(width:25,height:25) ,textColor:.gray ), for: .normal)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        if Int(UserDefaults.standard.string(forKey: "user_id")!) == (data?["user_id"].int)! || UserDefaults.standard.string(forKey: "user_role") == "manager" {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(icon: .FATrashO, size: CGSize(width:25,height:25)),style: .plain, target: self, action:#selector(self.deldetenews))
        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        getcomments()
           }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let h = (moontableView?.contentSize.height)!
        print("gaodu:\(h)")
        self.moontableView?.frame =   CGRect(x:0,y:0,width: self.view.bounds.size.width, height:(moontableView?.contentSize.height)!)
         self.comtableView?.frame = CGRect(x:0,y:h+10,width: self.view.bounds.size.width, height:(comtableView?.contentSize.height)!)
        let h2 = ((self.comtableView?.frame.origin.y)! +  (self.comtableView?.frame.height)!)
        scrollView.contentSize = CGSize(width: scwidth, height: h2)
    }
   
    func getcomments(){
        let url = "information/comment/getcomments/id/\((self.data?["id"].int)!)"
        Aget(url: url){
            data in
            self.comdata = data
            self.comtableView?.reloadData()
            print("评论数据：\(data)")
        }
    }
    
    
    
    //键盘done 设置  发送评论
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.commenttext.text == ""{
            self.commenttext.resignFirstResponder()
            return true
        }else if !readtoken()
        {   self.commenttext.resignFirstResponder()
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "loadview") as! LoadViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated:true)
            return true
        }
            else{
            let arr = ["token":(UserDefaults.standard.string(forKey: "token"))!,"user_id":(UserDefaults.standard.string(forKey: "user_id"))!,"information_id":(data?["id"].int)!,"detail":(self.commenttext.text)!] as [String : Any]
            let url = "information/comment/setcomments"
            Apost(url: url, body: arr){
                data in
                print("评论data:\(data)")
                if data.bool! == true{
                    self.comtableView?.reloadData()
                    self.commenttext.resignFirstResponder()
                    self.commenttext.text = ""
                }
            }
            return true
        }
        
    }
    
    
    // 设置tableView
   //CGRect(x: 0, y: 100, width: self.view.bounds.size.width, height: scheight/3)
    func settableView(){
        self.moontableView = UITableView(frame: UIScreen.main.bounds,style:.plain)
       
        self.moontableView!.delegate = self
        self.moontableView!.dataSource = self
        //设置表格背景色
        self.moontableView!.backgroundColor = .white
        //去除单元格分隔线
        self.moontableView?.isScrollEnabled = false
        self.moontableView!.separatorStyle = .none
        //创建一个重用的单元格
        self.moontableView!.register(UINib(nibName:"MoonTableViewCell", bundle:nil),
                                 forCellReuseIdentifier:"mooncell")
        //设置不能点击
        self.moontableView?.isUserInteractionEnabled = true
        //设置estimatedRowHeight属性默认值
        self.moontableView!.estimatedRowHeight = 200
            //rowHeight属性设置为UITableViewAutomaticDimension
        self.moontableView!.rowHeight = UITableViewAutomaticDimension
       
        //设置评论 comtableview
        self.comtableView = UITableView(frame:UIScreen.main.bounds, style: .plain)
        self.comtableView!.delegate = self
        self.comtableView!.dataSource = self
//        self.comtableView!.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255,
//                                                     blue: 0xf0/255, alpha: 1)
       
        self.comtableView?.isScrollEnabled = false
        self.comtableView!.register(UINib(nibName:"comTableViewCell", bundle:nil),
                                    forCellReuseIdentifier:"comcell")
        self.comtableView!.estimatedRowHeight = 240
        self.comtableView!.rowHeight = UITableViewAutomaticDimension
        self.comtableView!.separatorStyle = .none
        // 设置滚动视图
        scrollView.frame = CGRect(x:0,y:(self.navigationController?.navigationBar.frame.height)!+30,width: self.view.bounds.size.width, height:scheight-110)
        scrollView.alwaysBounceVertical = true
        
        let hidebutton = UIButton(frame: CGRect(x: 0, y: 0, width: scwidth, height: scheight))
        hidebutton.addTarget(self, action: #selector(self.hidekeyboard), for: .touchUpInside)
        scrollView.addSubview(hidebutton)
        scrollView.sendSubview(toBack: hidebutton)
        scrollView.addSubview(self.moontableView!)
        scrollView.addSubview(self.comtableView!)
        self.view.addSubview(scrollView)
//        self.view.addSubview(self.moontableView!)
//        self.view.addSubview(self.comtableView!)
        

    }
    
    //隐藏键盘
    func hidekeyboard(){
            self.commenttext.resignFirstResponder()
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
        shareParames.ssdkSetupShareParams( byText:data?["detail"].string!,
                                           images : nil,
                                           url :nil,
                                           title : data?["nickname"].string!,
                                           type : SSDKContentType.text)
        
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
                self.votebutton.setImage(UIImage(icon: .FAThumbsOUp, size:CGSize(width:25,height:25),textColor:UIColor.red), for: .normal)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == moontableView {
             print("返回cell1行")
            return 1
           
        }else {
            print("返回cell\((comdata?.array?.count)!)行")
            return (comdata?.array?.count)!
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == moontableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "mooncell", for: indexPath) as! MoonTableViewCell
            cell.picture.getbyid(id: (data?["pid"].int)!)
            cell.name.text = data?["nickname"].string!
            cell.time.text = data!["update_time"].string!
            cell.detailtext.text = data?["detail"].string!
            let vtc = (data?["votecount"].int)!
            let cmt = (data?["comcount"].int)!
            cell.comcount.text = "\(cmt)"
            cell.votecount.text = "\(vtc)"
            cell.selectedBackgroundView?.backgroundColor = .white
//            cell.votecount.isHidden = true
//            cell.votebutton.isHidden = true
//            cell.comcount.isHidden = true
//            cell.comment.isHidden = true
            cell.frame = (moontableView?.bounds)!
            //print("bounds \(tableView.bounds)")
            cell.navi = self.navigationController
            cell.layoutIfNeeded()
            cell.loaddata(data: (JSON(data?["infopic"].array)))
           // print("设置cell信息")
            
            return cell
        }else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "comcell", for: indexPath) as! comTableViewCell
            cell.picture.getbyid(id:(comdata?[indexPath.row]["pid"].int)!)
            cell.nickname.text = comdata?[indexPath.row]["nickname"].string!
            cell.time.text = comdata?[indexPath.row]["update_time"].string!
            cell.comtext.text = comdata?[indexPath.row]["detail"].string!
            cell.frame = (comtableView?.bounds)!
            cell.selectedBackgroundView?.backgroundColor = .white
            cell.layoutIfNeeded()
            return cell
        }
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
}

