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
class newsdetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource ,UITextFieldDelegate,DeleteCommentDelegate{
    
    
    let scwidth = UIScreen.main.bounds.size.width
    let scheight = UIScreen.main.bounds.size.height
    var comdata:JSON? = []
    var data :JSON? = []
    var infoid :Int?
    var iscollect = false
    var bkimage: UIImageView?
    
    
    var comtableView:UITableView?
    
    
    @IBOutlet weak var votebutton: UIButton!
    @IBOutlet weak var fxbutton: UIButton!
    @IBOutlet weak var commenttext: UITextField!
    
    @IBOutlet weak var upicture: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var newstitle: UILabel!
    @IBOutlet weak var backimage: UIImageView!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var toolbar: UIToolbar!
    
    
    
    
    
    
    var keyBoardNeedLayout: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.upicture.isUserInteractionEnabled = true
         let tapGR2 = UITapGestureRecognizer(target: self, action: #selector(self.showuserinfo))
        self.upicture.addGestureRecognizer(tapGR2)
        
        self.backimage?.isUserInteractionEnabled = true
        /////添加tapGuestureRecognizer手势
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(self.imagetap))
        self.backimage?.addGestureRecognizer(tapGR)
        
        self.nickname.sizeToFit()
        
        upicture.layer.cornerRadius = upicture.frame.size.width/2.0
        upicture.layer.masksToBounds = true
        self.hideKeyboardWhenTappedAround()
        //设置数据
        setdata()
        getcomments()
        settable()
        self.commenttext.delegate = self
        self.bkimage?.getbyid(id: data!["pictures_id"].int!)
        self.votebutton.setImage(UIImage(icon: .FAThumbsOUp, size:CGSize(width:25,height:25) ,textColor:.gray ), for: .normal)
        self.fxbutton.setImage(UIImage(icon: .FAShareSquareO, size:CGSize(width:25,height:25) ,textColor:.gray ), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide(notification:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        
        if UserDefaults.standard.string(forKey: "user_role") == "manager"{
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(icon: .FATrashO, size: CGSize(width:25,height:25)),style: .plain, target: self, action:#selector(self.deldetenews))
        }else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(named:"heartOL"),style: .plain, target: self, action: #selector(collectnews))
            didcollect(){
                bool in
                if bool {
                    self.navigationItem.rightBarButtonItem?.tintColor = .red
                    self.iscollect = true
                }else {
                    self.navigationItem.rightBarButtonItem?.tintColor = .gray
                }
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        
        super.viewWillLayoutSubviews()
        self.detail.sizeToFit()
        self.nickname.sizeToFit()
        let h1 = self.detail.frame.origin.y + self.detail.frame.height
        self.comtableView?.frame = CGRect(x:0,y:h1+5,width: self.view.bounds.size.width, height:(comtableView?.contentSize.height)!)
        let h2 = ((self.comtableView?.frame.origin.y)! + (comtableView?.contentSize.height)!)
        print("8888:self\(self.comtableView?.frame.height)")
        scrollView.contentSize = CGSize(width: scwidth, height: h2+30)
        scrollView.layoutIfNeeded()
    }
    
    //设置tableview
    func settable(){
        //设置评论 comtableview
        self.comtableView = UITableView(frame:UIScreen.main.bounds, style: .plain)
        self.comtableView!.delegate = self
        self.comtableView!.dataSource = self
        self.comtableView!.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255,
                                                     blue: 0xf0/255, alpha: 1)
        //self.comtableView?.tableFooterView = UIView()
        self.comtableView?.isScrollEnabled = false
        self.comtableView!.register(UINib(nibName:"comTableViewCell", bundle:nil),
                                    forCellReuseIdentifier:"comcell")
        self.comtableView!.estimatedRowHeight = 100
        self.comtableView!.rowHeight = UITableViewAutomaticDimension
        // 设置滚动视图
        scrollView.alwaysBounceVertical = true
        let hidebutton = UIButton(frame: CGRect(x: 0, y: 0, width: scwidth, height: scheight))
        hidebutton.addTarget(self, action: #selector(self.hidekeyboard), for: .touchUpInside)
        scrollView.frame = CGRect(x:0,y:0,width: self.view.bounds.size.width, height:scheight-45)
        scrollView.addSubview(hidebutton)
        scrollView.sendSubview(toBack: hidebutton)
        scrollView.addSubview(self.comtableView!)
    }
    
    //头像点击       -----------------------------------------------
    
    
    func showuserinfo(){
        
    }
    
    
    
    
    //图片点击
    func imagetap(){
        let previewVC = ImagePreviewVC( data:nil ,index:0)
        previewVC.image = self.backimage.image
        self.navigationController?.pushViewController(previewVC, animated: true)
    }
    
    //设置数据
    func setdata(){
        self.upicture.getbyid(id: (data?["pid"].int)!)
        self.nickname.text = data!["nickname"].string
        self.backimage.getbyid(id: (data?["pictures_id"].int)!)
        self.newstitle.text = data?["name"].string
        self.detail.text = data?["detail"].string
    }
    
    //重新加载数据
    func reloaddata(){
        let url = "information/information/getnewsbyid/id/\((self.infoid)!)"
        Aget(url: url){
            data in
            self.data = data[0]
        }
        
    }
    // 获取评论数据
    func getcomments(){
        let url = "information/comment/getcomments/id/\((self.data?["id"].int)!)"
        Aget(url: url){
            data in
            self.comdata = data
            self.comtableView?.reloadData()
            self.viewWillLayoutSubviews()
            print("评论数据：\(data)")
        }
    }
    
    //判断是否收藏
    func didcollect(next: @escaping (Bool)->()){
        if readtoken(){
            let url = "information/information/iscollect"
            let arr = ["information_id":(self.data?["id"].int)!,"user_id":(UserDefaults.standard.string(forKey: "user_id"))!] as [String : Any]
            print(arr)
            Apost(url: url, body: arr){ data in
                next(data.bool!)
            }
        }else {
            next (false)
        }
    }
    
    //收藏
    func collectnews(){
        if readtoken(){
            let url = "information/information/collect"
            let arr = ["information_id":(self.data?["id"].int)!,"user_id":(UserDefaults.standard.string(forKey: "user_id"))!] as [String : Any]
            print(arr)
            Apost(url: url, body: arr){ data in
                print("收藏：\(data)")
                if data.bool! == true {
                    if self.iscollect == false{
                        self.navigationItem.rightBarButtonItem?.tintColor = .red
                        self.iscollect = true
                    }else{
                        self.navigationItem.rightBarButtonItem?.tintColor = .gray
                        self.iscollect = false
                    }
                }else{
                    print("收藏出错")
                }
            }
        } else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "loadview") as! LoadViewController
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated:true)
        }
    }
    //分享
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
        shareParames.ssdkSetupShareParams(byText: data?["detail"].string,
                                          images : bkimage?.image,
                                          url : nil,
                                          title : data?["name"].string,
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
    
    //comtableView 代理
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(indexPath.row)")
        
        self.commenttext.text  = "回复@\((comdata?[indexPath.row]["nickname"].string)!):   "
        self.commenttext.becomeFirstResponder()

        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (comdata?.array?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "comcell", for: indexPath) as! comTableViewCell
        cell.picture.getbyid(id:(comdata?[indexPath.row]["pid"].int)!)
        cell.nickname.text = comdata?[indexPath.row]["nickname"].string!
        cell.time.text = comdata?[indexPath.row]["update_time"].string!
        cell.comtext.text = comdata?[indexPath.row]["detail"].string!
        let index = indexPath.row + 1
        cell.ceng.text = "\(index)楼"
        cell.delbutton.tag = indexPath.row
        cell.deletecomDelegate = self
        if readtoken(){
        if(UserDefaults.standard.string(forKey:"user_id") == "\(comdata?[indexPath.row]["uid"].int)!)")||(UserDefaults.standard.string(forKey: "user_role") == "manager"){
            
            print(comdata?[indexPath.row])
            print("userid:\(UserDefaults.standard.string(forKey:"user_id"))","user_id:\(comdata?[indexPath.row]["uid"].int)",UserDefaults.standard.string(forKey: "user_role"))
            cell.delbutton.isHidden = false }
        }
        cell.frame = (comtableView?.bounds)!
        cell.layoutIfNeeded()
        return cell
    }
    
    
    
    //键盘done 设置  发送评论
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.commenttext.text == ""{
            //self.commenttext.resignFirstResponder()
            self.view.endEditing(true)
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
                    self.commenttext.resignFirstResponder()
                    
                    
                    self.getcomments()
                    self.commenttext.text = ""
                }
            }
            return true
        }
        
    }
    
    
    //删除评论
    func deletecom(tag: Int) {
        let alert = UIAlertController(title: "系统提示", message:"确定删除吗", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        let creatAction = UIAlertAction(title: "确定", style:.default, handler: {
            action in
            
            print("deletecom \(tag)")
            let url = "information/comment/delcomments"
            let arr = ["token":(UserDefaults.standard.string(forKey: "token")!),"id":(self.comdata?[tag]["id"].int)!] as [String : Any]
            Apost(url: url, body: arr){
                data in
                if data.bool! {
                    self.getcomments()
                }
            }
            }
        )
        alert.addAction(creatAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    //隐藏键盘
    func hidekeyboard(){
        self.commenttext.resignFirstResponder()
    }
    
    
    //键盘弹起响应
    func keyboardWillShow(notification: NSNotification) {
        print("kbd:show")
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            
            let frame = value.cgRectValue
            
            let h = self.toolbar.frame.height
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIViewAnimationOptions(rawValue: curve),
                           animations: { _ in
                            self.toolbar.frame = CGRect(x:0,y:self.view.bounds.height-frame.height-h,width:self.view.bounds.width,height:h)
                            self.scrollView.frame = CGRect(x:0,y:self.scrollView.frame.origin.y,width:self.view.bounds.width,height:self.view.bounds.height-frame.height-h-self.scrollView.frame.origin.y)
                            //self.toolbar.frame = CGRect(x:0,y:self.scheight-45-frame.height,width:self.view.bounds.width,height:45)
                }, completion: nil)
            
            
            
        }
    }
    
    //键盘隐藏响应
    func keyboardWillHide(notification: NSNotification) {
        print("kbd:hide")
        if let userInfo = notification.userInfo,
            
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let h = self.toolbar.frame.height
            UIView.animate(withDuration: duration, delay: 0.0,
                           options: UIViewAnimationOptions(rawValue: curve),
                           animations: { _ in
                            self.toolbar.frame = CGRect(x:0,y:self.view.bounds.height-h,width:self.view.bounds.width,height:h)
                            
                            self.scrollView.frame = CGRect(x:0,y:self.scrollView.frame.origin.y,width:self.view.bounds.width,height:self.view.bounds.height-h-self.scrollView.frame.origin.y)
                           
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
