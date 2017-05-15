//
//  TabBarController.swift
//  骑行者
//
//  Created by apple on 17/4/3.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isToolbarHidden = true
        //self.viewControllers?[0].tabBarItem.setFAIcon(icon: .FABicycle, size: CGSize(width:30,height:30))
         //self.viewControllers?[1].tabBarItem.setFAIcon(icon: .FABicycle, size: CGSize(width:30,height:30))
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
