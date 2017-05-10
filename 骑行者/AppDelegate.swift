//
//  AppDelegate.swift
//  骑行者
//
//  Created by apple on 17/3/25.
//  Copyright © 2017年 李响. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,BMKGeneralDelegate{
    
    
    //重写openURL
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
         SMSSDK.registerApp("1ca0cc9ac805e", withSecret: "9d8c9a9332ce0e857d08ef9986b597b")
          return TencentOAuth.handleOpen(url)
    }

    
    var window: UIWindow?
    var _mapManager: BMKMapManager?

    //shareSDK 设置
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
      
        
        _mapManager = BMKMapManager()
        // 如果要关注网络及授权验证事件，请设定generalDelegate参数
        let ret = _mapManager?.start("6TAggWs1uc2sLFLkwX0IcUYm", generalDelegate: self)
        if ret == false {
            NSLog("manager start failed!")
        }
        
        //   AMapServices.shared().apiKey = "a598628551f523cbc19fc1939e2f8e23"
        
        //第一次启动判断
        //增加标识，用于判断是否是第一次启动应用...
        if (!(UserDefaults.standard.bool(forKey: "everLaunched"))) {
            UserDefaults.standard.set(true, forKey:"everLaunched")
            let guideViewController = GuideViewController()
            self.window!.rootViewController = guideViewController
            print("guideview launched!")
        }
        
        /**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。
         *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */
        
        ShareSDK.registerApp("1ca0c70803606", activePlatforms:[
            SSDKPlatformType.typeSinaWeibo.rawValue,
            SSDKPlatformType.typeQQ.rawValue],
                             onImport: { (platform : SSDKPlatformType) in
                                switch platform
                                {
                                case SSDKPlatformType.typeSinaWeibo:
                                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                                case SSDKPlatformType.typeQQ:
                                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                                default:
                                    break
                                }
                                
        }) { (platform : SSDKPlatformType, appInfo : NSMutableDictionary?) in
            
            switch platform
            {
            case SSDKPlatformType.typeSinaWeibo:
                //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                appInfo?.ssdkSetupSinaWeibo(byAppKey: "568898243",
                                            appSecret : "38a4f8204cc784f81f9f0daaf31e02e3",
                                            redirectUri : "http://www.sharesdk.cn",
                                            authType : SSDKAuthTypeBoth)
                
            case SSDKPlatformType.typeQQ:
                //设置QQ应用信息
                appInfo?.ssdkSetupQQ(byAppId: "1106017496",
                                     appKey : "auwl4l94jfK2w6zQ",
                                     authType : SSDKAuthTypeBoth)
            default:
                break
            }
            
        }
        
        return true
    }
    
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
           }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
           }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
}


