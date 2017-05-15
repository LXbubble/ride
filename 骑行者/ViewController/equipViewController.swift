//
//  equipViewController.swift
//  骑行者
//
//  Created by apple on 17/5/13.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import SwiftyJSON
import SWRevealViewController


class equipViewController: UIViewController ,UITableViewDelegate,UITableViewDataSource{
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.tabBarItem.setFAIcon(icon: .FAShoppingBag)
        self.tabBarItem.title = "装备"
    }
    
    //拉刷新控制器
    let  refreshControl = UIRefreshControl()

    var data:JSON?
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
               //添加刷新
        refreshControl.addTarget(self, action: #selector(reloaddata),
                                 for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "下拉刷新数据")
       
        loaddata()
        
        if UserDefaults.standard.string(forKey: "user_role") == "manager"{
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image:UIImage(icon: .FAPlusSquareO, size: CGSize(width:25,height:25)),style:.plain, target: self, action:#selector(self.setequip))
        }
    }
    
    func loaddata (){
        let url = "information/equips/getequip"
        Aget(url: url){
            data in
            self.data = data
            self.tableView.reloadData()
            self.settable()
        }
        
    }
    func reloaddata (){
        let url = "information/equips/getequip"
        Aget(url: url){
            data in
            self.data = data
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
        
    }

        func settable() {
          
            tableView.addSubview(self.refreshControl)
            
            self.tableView!.delegate = self
            self.tableView!.dataSource = self
            tableView.tableFooterView = UIView()
            //设置表格背景色
            self.tableView!.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255,
                                                      blue: 0xf0/255, alpha: 1)
            //去除单元格分隔线
//            self.tableView!.separatorStyle = .none
            
            //创建一个重用的单元格
            self.tableView!.register(UINib(nibName:"equipTableViewCell", bundle:nil),
                                     forCellReuseIdentifier:"equipcell")
        }
    
    
    //在本例中，只有一个分区
    
    private func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.data?.array?.count)!
    }
    
    //单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
        -> CGFloat {
            return 70
    }
    
    //创建各单元显示内容(创建参数indexPath指定的单元）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "equipcell")
            as! equipTableViewCell
        cell.equipimage.getbyid(id: (self.data?[indexPath.row]["pictures_id"].int)!)
        cell.name.text = data?[indexPath.row]["name"].string
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = webViewController()
        vc.urlString = data?[indexPath.row]["url"].string!
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    //添加装备
    func setequip(){
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "createquip") as! creatEquipViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
       
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
