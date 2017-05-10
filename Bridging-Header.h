//
//  Bridging-Header.h
//  骑行者
//
//  Created by apple on 17/3/25.
//  Copyright © 2017年 李响. All rights reserved.
//



#ifndef Bridging_Header_h
#define Bridging_Header_h
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "UIButton+ColorScale.h"

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//新浪微博SDK头文件
#import "WeiboSDK.h"
//新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"
#import <SMS_SDK/SMSSDK.h>


#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiinterface.h>
#import <TencentOpenAPI/QQApiinterfaceObject.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentmessageObject.h>
#import <TencentOpenAPI/TencentOAuthObject.h>

// 
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
//#import < BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件

#endif /* Bridging_Header_h */
