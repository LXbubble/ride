//
//  leftTableViewController.swift
//  骑行者
//
//  Created by apple on 17/5/15.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class leftTableViewController: UITableViewController {

    @IBOutlet weak var upic: UIImageView!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var islight: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        islight.isOn = UserDefaults.standard.bool(forKey: "islight")
        islight.addTarget(self, action: #selector(switchDidChange), for:.valueChanged)
        upic.isUserInteractionEnabled = true
        upic.layer.cornerRadius = upic.frame.size.width/2.0
        upic.layer.masksToBounds = true
        let tapOne = UITapGestureRecognizer(target: self, action: #selector(self.load))
        upic.addGestureRecognizer(tapOne)
        if readtoken(){
            let id = Int(UserDefaults.standard.string(forKey: "user_id")!)
            self.upic.getbyid(id:id!)
            self.nickname.text = UserDefaults.standard.string(forKey: "user_nickname")!
        }
    }
    func switchDidChange(){
        UserDefaults.standard.set(islight.isOn, forKey: "islight")
    }
    //登出
    func loadout() {
        UserDefaults.standard.removeObject(forKey: "token")
         UserDefaults.standard.removeObject(forKey: "user_id")
         UserDefaults.standard.removeObject(forKey: "user_nickname")
         UserDefaults.standard.removeObject(forKey: "user_role")
        self.dismiss(animated: true, completion: nil)
    }
    
    //登录唤醒
    func load(){
        if !readtoken() {
            self.revealViewController().revealToggle(animated: true)
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "loadview") as! LoadViewController
            let tbc = self.revealViewController().frontViewController as! UITabBarController
            let nc = tbc.selectedViewController! as! UINavigationController
            vc.hidesBottomBarWhenPushed = true
            nc.pushViewController(vc, animated:true)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath)
        if indexPath == [1,1]{
            print("1242353434")
            
            self.revealViewController().revealToggle(animated: true)
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let tvc = sb.instantiateViewController(withIdentifier: "infotvc") as! InfoTableViewController
            let tbc = self.revealViewController().frontViewController as! UITabBarController
            let nc = tbc.selectedViewController! as! UINavigationController
            nc.pushViewController(tvc,animated: true)
//            performSegue(withIdentifier: "userinfo", sender: nil)
        }else if indexPath == [1,5]{
            loadout()
        }
        
        
        
        
    }
}
