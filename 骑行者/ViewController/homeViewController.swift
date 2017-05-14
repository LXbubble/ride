//
//  homeViewController.swift
//  骑行者
//
//  Created by apple on 17/4/16.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class homeViewController: FYViewController {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.setFAIcon(icon: .FAHome)
        self.tabBarItem.title = "主页"
    }
    
    var popMenu:SwiftPopMenu!
    
    let KSCREEN_WIDTH:CGFloat = UIScreen.main.bounds.size.width
    
    
    @IBOutlet weak var write: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.navigationItem.rightBarButtonItem = UIBarButtonItem( barButtonSystemItem:.add, target: self, action: #selector(self.showMenu))
        
        
        
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        let item = UIBarButtonItem(title: "返回", style: .plain, target: self, action: nil)
        self.navigationItem.backBarButtonItem = item
        
        let news : UIViewController = newsViewController()
        news.title = "文章"
        
        let moon:UIViewController = moonViewController()
        moon.title = "心情"
        
        let activity :UIViewController = activityViewController()
        activity.title = "活动"
        self.addChildViewController(news)
        self.addChildViewController(moon)
        self.addChildViewController(activity)
    }

    func showMenu() {
        //frame 为整个popview相对整个屏幕的位置  箭头距离右边位置，默认15
        //popMenu =  SwiftPopMenu(frame: CGRect(x: KSCREEN_WIDTH - 155, y: 51, width: 150, height: 112))
        
        popMenu = SwiftPopMenu(frame:  CGRect(x: KSCREEN_WIDTH - 135, y: 51, width: 100, height: 112), arrowMargin: 12)
        popMenu.popData = [(icon:"edit",title:"心情"),
                            (icon:"wz",title:"文章"),
                            (icon:"bicycle",title:"活动")]
        //点击菜单
        popMenu.didSelectMenuBlock = { [weak self](index:Int)->Void in
            self?.popMenu.dismiss()
            if !readtoken(){
                let alertController  = UIAlertController(title: "系统提示", message: "请先登录", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
                let okAction = UIAlertAction(title: "确定", style: .default, handler:{
                    action in
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "loadview") as! LoadViewController
                    vc.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(vc, animated:true)
                })
                alertController.addAction(cancelAction)
                alertController.addAction(okAction)
                self?.present(alertController, animated: true, completion: nil)
                
            }
            else {
                if index == 0 {
                    self?.performSegue(withIdentifier: "creatmoon", sender: nil)
                }else if index == 1{
                    if UserDefaults.standard.string(forKey: "user_role") != "manager"
                    {
                        let alertController  = UIAlertController(title: "系统提示", message: "没有权限\(UserDefaults.standard.string(forKey: "user_role"))", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self?.present(alertController, animated: true, completion: nil)
                    }else {
                        self?.performSegue(withIdentifier: "creatnews", sender: nil)
                    }
                }else if index == 2{
                    self?.performSegue(withIdentifier: "creatactivity", sender: nil)
                }
            }
        }
        
        popMenu.show()
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}
