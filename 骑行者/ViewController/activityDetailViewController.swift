//
//  activityDetailViewController.swift
//  骑行者
//
//  Created by apple on 17/5/13.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class activityDetailViewController: UIViewController {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var number: UILabel!
    @IBOutlet weak var nickname: UILabel!
    @IBOutlet weak var adress: UILabel!
    @IBOutlet weak var detail: UILabel!
    @IBOutlet weak var jioncollection: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
