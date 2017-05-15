//
//  userViewController.swift
//  骑行者
//
//  Created by apple on 17/5/15.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import SWRevealViewController


class userViewController: UIViewController {

    @IBOutlet weak var leftbtn: UIBarButtonItem!
    @IBOutlet weak var menubtn: UIButton!
    @IBAction func leftbtnpress(_ sender: AnyObject) {
         revealViewController().revealToggle(sender)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
      
            self.navigationItem.leftBarButtonItem?.target = self.revealViewController()
            self.navigationItem.leftBarButtonItem?.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer());
        
        
        
        
        // Do any additional setup after loading the view.
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
