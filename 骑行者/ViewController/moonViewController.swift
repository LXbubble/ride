//
//  moonViewController.swift
//  骑行者
//
//  Created by apple on 17/5/9.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import Photos


class moonViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    
    var data: JSON? = []
    
    var tableView:UITableView?
    
    var refreshControl = UIRefreshControl()
    
    //用了记录当前是否允许加载新数据（正则加载的时候会将其设为false，放置重复加载）
    var loadMoreEnable = true
    //表格底部用来提示数据加载的视图
    var loadMoreView:UIView?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refreshControl.addTarget(self, action: #selector(self.refreshdata),
                                      for: .valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString(string: "数据刷新中")
        //获取数据
        self.getdata(id: 0)
        self.tableView?.reloadData()
    
    }
    

    
    //重新加载数据
    func refreshdata(){
        self.loadMoreEnable = true
        self.tableView?.tableFooterView?.isHidden = false
        let url:String = "information/information/getmoon"
        let URL = urladd(url: url)
        Alamofire.request(URL,method: .get).responseJSON{
            response in
            self.data = JSON(response.data!)
            self.tableView?.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    // 设置tableView
    func settableView(){
        self.tableView = UITableView(frame: UIScreen.main.bounds,style:.plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        //设置表格背景色
        
        self.tableView!.backgroundColor = UIColor(red: 0xf0/255, green: 0xf0/255,
                                                  blue: 0xf0/255, alpha: 1)
        //去除单元格分隔线
        self.tableView!.separatorStyle = .none
        
        //创建一个重用的单元格
        self.tableView!.register(UINib(nibName:"MoonTableViewCell", bundle:nil),
                                 forCellReuseIdentifier:"mooncell")
        
        //设置estimatedRowHeight属性默认值
        self.tableView!.estimatedRowHeight = 240
        //rowHeight属性设置为UITableViewAutomaticDimension
        self.tableView!.rowHeight = UITableViewAutomaticDimension
        
        //self.tableView?.contentSize = CGSize(width: self.view.bounds.size.width, height: CGFloat((self.data?.array?.count)!*20))
        self.tableView?.frame = CGRect(x:0,y:0,width: self.view.bounds.size.width, height: self.view.bounds.size.height-(self.tabBarController?.tabBar.frame.height)!-5)
        
        self.view.addSubview(self.tableView!)
        
        //添加下拉刷新
        self.tableView?.addSubview(self.refreshControl)
        //上拉刷新
        self.setupInfiniteScrollingView()
        self.tableView?.tableFooterView = self.loadMoreView
    }
    
    //获取数据
    func getdata (id:Int){
        let url:String = "information/information/getmoon/id/\(id)"
        let URL = urladd(url: url)
        
        Alamofire.request(URL,method: .get).responseJSON{
            response in
            self.data = JSON(response.data!)
            self.settableView()
            debugPrint(response)
        }
    }
    
    //上拉加载数据
    func loadmoredata(id:Int){
        
        loadMoreEnable = false
        
        let url:String = "information/information/getmoon/id/\(id)"
        let URL = urladd(url: url)
        Alamofire.request(URL,method: .get).responseJSON{
            response in
            let data1 = self.data!.arrayObject!
            let data2 = JSON(response.data).arrayObject!
            if data2.count >= 10 {
                self.loadMoreEnable = true
            }else {
                self.tableView?.tableFooterView?.isHidden = true
            }
            self.data = JSON( data1 + data2)
            self.tableView?.reloadData()
        }
        
    }
    
    //上拉刷新视图
    private func setupInfiniteScrollingView() {
        self.loadMoreView = UIView(frame: CGRect(x:0,y: (self.tableView?.contentSize.height)!,
                                                 width:(self.tableView?.bounds.size.width)!,height:40))
        self.loadMoreView!.autoresizingMask = UIViewAutoresizing.flexibleWidth
        self.loadMoreView!.backgroundColor = UIColor.white
        
        //添加中间的环形进度条
        let activityViewIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityViewIndicator.color = UIColor.darkGray
        let indicatorX = self.loadMoreView!.frame.size.width/2-activityViewIndicator.frame.width/2
        let indicatorY = self.loadMoreView!.frame.size.height/2-activityViewIndicator.frame.height/2
        activityViewIndicator.frame = CGRect(x:indicatorX, y:indicatorY,
                                             width:activityViewIndicator.frame.width,
                                             height:activityViewIndicator.frame.height)
        activityViewIndicator.startAnimating()
        self.loadMoreView!.addSubview(activityViewIndicator)
    }
    
    
    
    
    //在本例中，只有一个分区
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    

    //返回表格行数（也就是返回控件数）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (data?.array?.count)!
        
    }
    
    

    
    //单元格数据设置
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mooncell", for: indexPath) as! MoonTableViewCell
        cell.picture.getbyid(id: (data?[indexPath.row]["pid"].int)!)
        cell.name.text = data?[indexPath.row]["nickname"].string!
        cell.time.text = data![indexPath.row]["update_time"].string!
        cell.detailtext.text = data?[indexPath.row]["detail"].string!
        let vtc = (data?[indexPath.row]["votecount"].int)!
        let cmt = (data?[indexPath.row]["comcount"].int)!
        cell.comcount.text = "\(cmt)"
        cell.votecount.text = "\(vtc)"
        cell.selectedBackgroundView?.backgroundColor = .white
        cell.votebutton.tag = indexPath.row
        cell.frame = tableView.bounds
        print("bounds \(tableView.bounds)")
        cell.layoutIfNeeded()
        cell.loaddata(data: (JSON(data?[indexPath.row]["infopic"].array)))
        cell.navi = self.navigationController
        //当拉到底部加载新数据
        if (loadMoreEnable && indexPath.row == (data?.array?.count)!-1){
            loadMoreEnable = false
            let id = (self.data?[indexPath.row]["id"].int)!
            if  id >= 10 {
                loadmoredata(id: id)
            }
        }
        return cell
        
    }
    
    // 点击单元格
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("点击了\(indexPath.row)")
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier:"moondetail") as! MoonDetailViewController
        vc.hidesBottomBarWhenPushed = true
        vc.data = (self.data?[indexPath.row])!
        self.navigationController?.pushViewController(vc, animated:true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
}
