//
//  MoonCreatViewController.swift
//  骑行者
//
//  Created by apple on 17/5/2.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit
import Photos


class MoonCreatViewController: UIViewController,PhotoPickerControllerDelegate,UITextViewDelegate,UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    
    
    var selectModel = [PhotoImageModel]()
    var containerView = UIView()
    
    var triggerRefresh = false
    //存放照片资源的标志符
    var localId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //键盘
        self.hideKeyboardWhenTappedAround()
        self.view.addSubview(self.containerView)
        self.checkNeedAddButton()
        self.renderView()
        let keybutton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
        keybutton.addTarget(self, action: #selector(self.hidekeyboard), for: .touchUpInside)
        self.view.addSubview(keybutton)
        self.view.sendSubview(toBack: keybutton)
        self.automaticallyAdjustsScrollViewInsets = false
        moontext.delegate = self
        placeholdertext.isUserInteractionEnabled = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem (title: "完成", style: .plain, target: self, action: #selector(self.creatMoon))
        
        // Do any additional setup after loading the view.
    }
    
    // 键盘隐藏
    func hidekeyboard(){
       self.moontext.resignFirstResponder()
    }
    
    var images = [UIImage]()
    
    
    @IBOutlet weak var moontext: UITextView!
    @IBOutlet weak var placeholdertext: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func creatMoon(){
        if  self.moontext.text == ""{
            let alert = UIAlertController(title: "系统提示", message: "随便说点什么吧！", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler:nil )
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        } else{
            let arry = [
                "token":UserDefaults.standard.string(forKey: "token")!,
                "detail":self.moontext.text!,
                "user_id":UserDefaults.standard.string(forKey: "user_id")!,
                "type":"moon"
                ] as [String : Any]
            
            let url2  =  "information/information/setinformation"
            Apost(url:url2 , body: arry)
            {   data in
                print("data:qqq",data["id"].string,"2222222")
                print(data)
                if data["id"].string != nil {
                    //存图片
                    if self.selectModel.count > 0{
                        print("yyy",self.selectModel.count)
                        for i in 0..<self.selectModel.count-1 {
                            let itemModel = self.selectModel[i]
                            if let asset = itemModel.data {
                                print("yyy222")
                                PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: self.view.bounds.width, height: self.view.bounds.width/16*9), contentMode: PHImageContentMode.aspectFill, options: nil, resultHandler: { (image, info) -> Void in
                                    if image != nil && !(info![PHImageResultIsDegradedKey] as! Bool) {
                                      
                                        let picdata: Data? = UIImageJPEGRepresentation(image!, 0.8)
                                        let string = data["id"].string!
                                        let pid = Int(string)
                                          print("yyy,pid ",pid)
                                        photopost2(id:pid!,data: picdata!){
                                            data in
                                            print("yyy, data:",data["text"].string)
                                        }
                                    }
                                })
                            }
                        }
                    }
                    let alert = UIAlertController(title: "系统提示", message:"创建成功", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler:{
                        action in
                        self.navigationController?.popViewController(animated: true)
                        
                    })
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                    
                }else{
                    let alert = UIAlertController(title: "系统提示", message:"创建失败", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alert.addAction(cancelAction)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
    }
    
            //textview 相关协议
            func textViewDidEndEditing(_ textView: UITextView) {
                // print("<",1111,"><",moontext.text,">")
                if moontext.text == ""{
                    self.placeholdertext.isHidden = false
                }
            }
            func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
                placeholdertext.isHidden = true
                return true
            }
            
            
            
            
            
            private func checkNeedAddButton(){
                if self.selectModel.count < PhotoPickerController.imageMaxSelectedNum && !hasButton() {
                    selectModel.append(PhotoImageModel(type: ModelType.Button, data: nil))
                }
            }
            
            private func hasButton() -> Bool{
                for item in self.selectModel {
                    if item.type == ModelType.Button {
                        return true
                    }
                }
                return false
            }
            
            func removeElement(element: Int){
                
                self.selectModel.remove(at: element)
                renderView()
                
            }
            
            
            override func viewWillAppear(_ animated: Bool) {
                super.viewWillAppear(animated)
                UIApplication.shared.statusBarStyle = .default
                self.navigationController?.navigationBar.barStyle = .default
                
                if self.triggerRefresh {
                    self.triggerRefresh = false
                    self.updateView()
                }
                
            }
            
            private func updateView(){
                self.clearAll()
                self.checkNeedAddButton()
                self.renderView()
            }
            
            private func renderView(){
                for v in self.containerView.subviews{
                    v.removeFromSuperview()
                }
                
                if selectModel.count <= 0 {return;}
                
                let totalWidth = UIScreen.main.bounds.width
                let space:CGFloat = 10
                let lineImageTotal = 3
                
                let line = self.selectModel.count / lineImageTotal
                let lastItems = self.selectModel.count % lineImageTotal
                
                let lessItemWidth = (totalWidth - (CGFloat(lineImageTotal) + 1) * space)
                let itemWidth = lessItemWidth / CGFloat(lineImageTotal)
                
                for i in 0 ..< line {
                    let itemY = CGFloat(i+1) * space + CGFloat(i) * itemWidth
                    for j in 0 ..< lineImageTotal {
                        let itemX = CGFloat(j+1) * space + CGFloat(j) * itemWidth
                        let index = i * lineImageTotal + j
                        self.renderItemView(itemX: itemX, itemY: itemY, itemWidth: itemWidth, index: index)
                    }
                }
                
                // last line
                for i in 0..<lastItems{
                    let itemX = CGFloat(i+1) * space + CGFloat(i) * itemWidth
                    let itemY = CGFloat(line+1) * space + CGFloat(line) * itemWidth
                    let index = line * lineImageTotal + i
                    self.renderItemView(itemX: itemX, itemY: itemY, itemWidth: itemWidth, index: index)
                }
                
                let totalLine = ceil(Double(self.selectModel.count) / Double(lineImageTotal))
                let containerHeight = CGFloat(totalLine) * itemWidth + (CGFloat(totalLine) + 1) *  space
                self.containerView.frame = CGRect(x:0, y:165, width:totalWidth,  height:containerHeight)
            }
            
            private func renderItemView(itemX:CGFloat,itemY:CGFloat,itemWidth:CGFloat,index:Int){
                let itemModel = self.selectModel[index]
                let button = UIButton(frame: CGRect(x:itemX, y:itemY, width:itemWidth, height: itemWidth))
                button.backgroundColor = UIColor.red
                button.tag = index
                
                if itemModel.type == ModelType.Button {
                    button.backgroundColor = UIColor.clear
                    button.addTarget(self, action: #selector(self.eventAddImage), for: .touchUpInside)
                    button.contentMode = .scaleAspectFill
                    button.layer.borderWidth = 2
                    button.layer.borderColor = UIColor.init(red: 200/255, green: 200/255, blue: 200/255, alpha: 1).cgColor
                    button.setImage(UIImage(named: "image_select"), for: UIControlState.normal)
                } else {
                    
                    button.addTarget(self, action: #selector(self.eventPreview), for: .touchUpInside)
                    if let asset = itemModel.data {
                        let pixSize = UIScreen.main.scale * itemWidth
                        PHImageManager.default().requestImage(for: asset, targetSize: CGSize(width: pixSize, height: pixSize), contentMode: PHImageContentMode.aspectFill, options: nil, resultHandler: { (image, info) -> Void in
                            if image != nil {
                                button.setImage(image, for: UIControlState.normal)
                                button.contentMode = .scaleAspectFill
                                button.clipsToBounds = true
                            }
                        })
                    }
                }
                self.containerView.addSubview(button)
            }
            
            private func clearAll(){
                for subview in self.containerView.subviews {
                    if let view =  subview as? UIButton {
                        view.removeFromSuperview()
                    }
                }
            }
            
            // MARK: -  button event
            func eventPreview(button:UIButton){
                let preview = SinglePhotoPreviewViewController()
                let data = self.getModelExceptButton()
                preview.selectImages = data
                preview.sourceDelegate = self
                preview.currentPage = button.tag
                self.show(preview, sender: nil)
            }
            
            
            func eventAddImage() {
                self.moontext.resignFirstResponder()

                let alert = UIAlertController.init(title: nil, message: nil, preferredStyle: .actionSheet)
                
                // change the style sheet text color
                // alert.view.tintColor = UIColor.black
                
                let actionCancel = UIAlertAction.init(title: "取消", style: .cancel, handler: nil)
                let actionCamera = UIAlertAction.init(title: "拍照", style: .default) { (UIAlertAction) -> Void in
                    self.selectByCamera()
                }
                
                let actionPhoto = UIAlertAction.init(title: "从手机照片中选择", style: .default) { (UIAlertAction) -> Void in
                    self.selectFromPhoto()
                }
                
                alert.addAction(actionCancel)
                alert.addAction(actionCamera)
                alert.addAction(actionPhoto)
                
                self.present(alert, animated: true, completion: nil)
            }
            
            /**
             拍照获取
             */
            private func selectByCamera(){
                // todo take photo task
                if self.selectModel.count >=  PhotoPickerController.imageMaxSelectedNum{
                    let alertController = UIAlertController(title: "系统提示",
                                                            message: "最多选择6张图片", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.present(alertController, animated: true, completion: nil)
                }else{
                    if UIImagePickerController.isSourceTypeAvailable(.camera){
                        //创建图片控制器
                        let picker = UIImagePickerController()
                        //设置代理
                        picker.delegate = self
                        //设置来源
                        picker.sourceType = UIImagePickerControllerSourceType.camera
                        //允许编辑
                        picker.allowsEditing = true
                        //打开相机
                        self.present(picker, animated: true, completion: { () -> Void in
                            
                        })
                    }
                    else{
                        let alertController = UIAlertController(title: "系统提示",
                                                                message: "访问相机失败", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }
            
            //选择图片成功后代理
            public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
            {
                
                let pickedImage = info[UIImagePickerControllerOriginalImage] as! UIImage
                //self.selectModel.insert(PhotoImageModel(type: ModelType.Image, data: pickedImage), at: 0)
                
                PHPhotoLibrary.shared().performChanges({
                    let result = PHAssetChangeRequest.creationRequestForAsset(from: pickedImage)
                    let assetPlaceholder = result.placeholderForCreatedAsset
                    //保存标志符
                    self.localId = assetPlaceholder?.localIdentifier
                }) { (isSuccess: Bool, error: Error?) in
                    if isSuccess {
                        print("保存成功!")
                        //通过标志符获取对应的资源
                        let assetResult = PHAsset.fetchAssets(
                            withLocalIdentifiers: [self.localId], options: nil)
                        let asset = assetResult[0]
                        self.selectModel.insert(PhotoImageModel(type: ModelType.Image, data: asset), at: 0)
                        self.renderView()
                        //图片控制器退出
                        picker.dismiss(animated: true, completion:nil)
                    }
                }
                
                
                
            }
            
            /**
             从相册中选择图片
             */
            private func selectFromPhoto(){
                
                PHPhotoLibrary.requestAuthorization { (status) -> Void in
                    switch status {
                    case .authorized:
                        self.showLocalPhotoGallery()
                        break
                    default:
                        self.showNoPermissionDailog()
                        break
                    }
                }
            }
            
            private func showNoPermissionDailog(){
                let alert = UIAlertController.init(title: nil, message: "没有打开相册的权限", preferredStyle: .alert)
                alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            private func showLocalPhotoGallery(){
                let picker = PhotoPickerController(type: PageType.RecentAlbum)
                picker.imageSelectDelegate = self
                picker.modalPresentationStyle = .popover
                
                // max select number
                PhotoPickerController.imageMaxSelectedNum = 6
                
                // already selected image num
                let realModel = self.getModelExceptButton()
                PhotoPickerController.alreadySelectedImageNum = realModel.count
                
                self.show(picker, sender: nil)
            }
            
            func onImageSelectFinished(images: [PHAsset]) {
                self.renderSelectImages(images: images)
            }
            
            private func renderSelectImages(images: [PHAsset]){
                for item in images {
                    self.selectModel.insert(PhotoImageModel(type: ModelType.Image, data: item), at: 0)
                }
                self.renderView()
            }
            
            private func getModelExceptButton()->[PhotoImageModel]{
                var newModels = [PhotoImageModel]()
                for i in 0..<self.selectModel.count {
                    let item = self.selectModel[i]
                    if item.type != .Button {
                        newModels.append(item)
                    }
                }
                return newModels
            }
            
            
            
            
}
