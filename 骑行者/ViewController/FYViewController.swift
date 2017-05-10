//
//  FYViewController.swift
//  骑行者
//
//  Created by apple on 17/4/16.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

let FYScreenWidth:CGFloat = UIScreen.main.bounds.size.width
let FYScreenHeight:CGFloat = UIScreen.main.bounds.size.height
let FYTitleFont:UIFont = UIFont.systemFont(ofSize: 15)//标题的大小
let FYTitleHeight:CGFloat = 30.0//标题滚动视图的高度
let FYUnderlineHeight:CGFloat = 4.0//自定义滑动条的高度
let FYColer:UIColor = UIColor.red //标题选中的颜色
let FYNavigationHeight:CGFloat = 64//导航栏的高度
let FYButtonStartTag:Int = 2000
class FYViewController: UIViewController,UIScrollViewDelegate {

    var titleScrollView:UIScrollView?//标题滚动视图
    var contentScollView:UIScrollView?//管理子控制器View的滚动视图
    var selectButton:UIButton?//保存选中的按钮
    var titleSButtons:NSMutableArray = NSMutableArray.init()//保存标题按钮的数组
    var selectIndex:Int = 0//选中的下标
    var isIninttial:Bool = false//第一次加载的变量
    let btnScale:CGFloat = 0.0//用于做过度的效果
    var underline:UIView?//自定义的滑动条
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = UIColor.white
        setupTitleScrollViewFunction()
        setupContentScrollVewFunction()
        
    }
    
    
    
    
    
    
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !isIninttial {
            setupAllButtonTitle()
            setupUnderlineFunction()
            isIninttial = true
        }
    }
    
    func setupTitleScrollViewFunction() -> Void{
        //
        
        
        titleScrollView = UIScrollView.init(frame: CGRect(x: 0, y: FYNavigationHeight, width: FYScreenWidth, height: FYTitleHeight))
        titleScrollView?.showsHorizontalScrollIndicator = false
        titleScrollView?.scrollsToTop = false
        titleScrollView?.backgroundColor = UIColor.white
        self.view.addSubview(titleScrollView!)
        
    }
    func setupAllButtonTitle() -> Void {
        
        let count:Int = self.childViewControllers.count
        //let btnW:CGFloat = FYScreenWidth/CGFloat(count)
        let btnW:CGFloat = 60
        for  i  in 0..<count {
            let button:UIButton = UIButton.init(type: .custom)
            let btnX:CGFloat = CGFloat(i)*btnW
            button.frame = CGRect(x: btnX, y: 0, width: btnW, height: FYTitleHeight-5)
            button.tag = FYButtonStartTag+i
            button.titleLabel?.font = FYTitleFont
            let vc:UIViewController = self.childViewControllers[i]
            
            button.setTitleColor(UIColor.black, for: .normal)
            button.setTitleColor(UIColor.red, for: .selected)
            button.setTitle(vc.title, for: .normal)
            titleScrollView?.addSubview(button)
            titleSButtons.add(button)
            button.addTarget(self, action: #selector(titleclickAction(sender:)), for: .touchUpInside)
            
        }
        dealBtnClickAction(sender: titleSButtons[selectIndex] as! UIButton)
        
        titleScrollView?.contentSize = CGSize.init(width: CGFloat(count)*btnW, height: FYTitleHeight)
        contentScollView?.contentSize = CGSize.init(width: CGFloat(count)*FYScreenWidth, height: FYScreenWidth-FYTitleHeight-FYNavigationHeight)
        
    }
    func setupUnderlineFunction(){
        let firstTitleButton:UIButton = titleScrollView?.subviews.first as! UIButton
        
        let underlineView = UIView.init()
        underlineView.frame = CGRect.init(x: 0, y: FYTitleHeight-FYUnderlineHeight, width: 70, height: FYUnderlineHeight)
        underlineView.backgroundColor = FYColer
        titleScrollView?.addSubview(underlineView)
        underline = underlineView
        
        firstTitleButton.titleLabel?.sizeToFit()
        
        underline?.frame.size.width = (firstTitleButton.titleLabel?.frame.size.width)! + 10
        underline?.center.x = firstTitleButton.center.x
        
        let lineLayer = UIView.init()
        lineLayer.backgroundColor = UIColor.init(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.0)
        lineLayer.frame = CGRect.init(x: 0, y: FYTitleHeight-1, width: FYScreenWidth, height: 1)
        titleScrollView?.addSubview(lineLayer)
        
        
    }
    
    func setupContentScrollVewFunction() -> Void {
        //
        
        
        contentScollView = UIScrollView.init(frame: CGRect.init(x: 0, y: FYTitleHeight+FYNavigationHeight, width: FYScreenWidth, height: FYScreenHeight-FYTitleHeight-FYNavigationHeight))
        self.view.insertSubview(contentScollView!, at: 0)
        contentScollView?.showsHorizontalScrollIndicator = false
        contentScollView?.isPagingEnabled = true
        contentScollView?.bounces = false
        contentScollView?.alwaysBounceVertical = false
        contentScollView?.scrollsToTop = false
        contentScollView?.delegate = self
        
        
        
    }
    
    func titleclickAction(sender:UIButton) -> Void {
        
        dealBtnClickAction(sender: sender)
        
    }
    func setupTitleCenterFunction(sender:UIButton) -> Void {
        var offsetX:CGFloat = sender.center.x - FYScreenWidth*0.5
        if offsetX<0 {
            offsetX = 0
        }
        
        let maxoffsetX = (titleScrollView?.contentSize.width)! - FYScreenWidth
        if offsetX>maxoffsetX {
            offsetX = maxoffsetX
        }
        
        titleScrollView?.setContentOffset(CGPoint.init(x: offsetX, y: 0), animated: true)
        
    }
    
    func setupOneChildViewController(index:Int) -> Void {
        if index>=self.childViewControllers.count {
            return
        }
        let vc:UIViewController = self.childViewControllers[index]
        if (vc.view.superview != nil) {
            return
        }
        
        let offX = CGFloat(index)*FYScreenWidth
        vc.view.frame = CGRect.init(x: offX, y: 0, width: FYScreenWidth, height: (contentScollView?.frame.size.height)!)
        contentScollView?.addSubview(vc.view)
        
        
    }
    func adjustUnderLine(sender:UIButton) -> Void {
        underline?.frame.size.width = (sender.titleLabel?.frame.size.width)!+10
        underline?.center.x = sender.center.x
        
    }
    func selectTitleButton(sender:UIButton) -> Void {
        selectButton?.setTitleColor(UIColor.black, for: .normal)
        sender.setTitleColor(UIColor.red, for: .normal)
        let scale:CGFloat = 1 + btnScale
        
        selectButton?.transform = CGAffineTransform.identity
        sender.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        
        selectButton = sender
    }
    func dealBtnClickAction(sender:UIButton) -> Void {
        let index = sender.tag - FYButtonStartTag
        selectTitleButton(sender: sender)
        setupOneChildViewController(index: index)
        contentScollView?.contentOffset = CGPoint.init(x: CGFloat(index)*FYScreenWidth, y: 0)
        
        UIView.animate(withDuration: 0.25) {
            
            self.adjustUnderLine(sender: sender)
            
        }
        for i in 0..<titleSButtons.count{
            if !(i==index){
                let noSelectBtn:UIButton = titleSButtons[i] as! UIButton
                noSelectBtn.setTitleColor(UIColor.black, for: .normal)
                
            }
        }
        
        for i in 0..<childViewControllers.count{
            let chilaCtl:UIViewController = self.childViewControllers[i]
            if !chilaCtl.isViewLoaded {
                continue
            }
            
            let childVcView:UIView = chilaCtl.view
            if childVcView.isKind(of: UIScrollView.classForCoder()) {
                let scrollView:UIScrollView = childVcView as! UIScrollView
                scrollView.scrollsToTop = (i == index)
                if i == index {
                    
                }
            }
            
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let value = scrollView.contentOffset.x/FYScreenWidth
        let leftIndex:Int = Int(value)
        let rightIndex = leftIndex+1
        let scaleRight:CGFloat = scrollView.contentOffset.x/FYScreenWidth - CGFloat(leftIndex)
        let scaleLeft:CGFloat = 1 - scaleRight
        let leftTitleBtn:UIButton = self.titleSButtons[leftIndex] as! UIButton
        leftTitleBtn.dqButtonColorScale(scaleLeft)
        
        if rightIndex < self.titleSButtons.count {
            let rightTitleBtn:UIButton = self.titleSButtons[rightIndex] as! UIButton
            rightTitleBtn.dqButtonColorScale(scaleRight)
            rightTitleBtn.transform = CGAffineTransform.init(scaleX: scaleRight*self.btnScale+1, y: scaleRight*self.btnScale+1)
            
        }
        
        setupOneChildViewController(index: rightIndex)
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index:Int = Int(scrollView.contentOffset.x/FYScreenWidth)
        let button:UIButton = titleSButtons[index] as! UIButton
        dealBtnClickAction(sender: button)
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    


}
