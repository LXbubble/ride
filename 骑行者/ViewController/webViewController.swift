//
//  webViewController.swift
//  骑行者
//
//  Created by apple on 17/5/14.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

class webViewController: UIViewController {
    
    
    var urlString: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = UIWebView(frame: self.view.bounds)
        webView.scalesPageToFit = true
        self.view.addSubview(webView)
        let url = URL(string: urlString!)
        webView.loadRequest(URLRequest(url:url!))
        
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
