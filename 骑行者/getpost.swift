//
//  get\post.swift
//  骑行者
//
//  Created by apple on 17/3/27.
//  Copyright © 2017年 李响. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire
//post 请求

func Apost (url:String,body:Parameters,next: @escaping (JSON)->())
{
    let URL = urladd(url: url)
    
     Alamofire.request(URL,method: .post, parameters:body,encoding:JSONEncoding.default).responseJSON
            {
                response in
                debugPrint(response)
                next(JSON(data: response.data!))
            }
    
}
func Aget (url:String,next: @escaping (JSON)->())
{
    let URL = urladd(url: url)
    
    Alamofire.request(URL,method: .get).responseJSON
        {
            response in
            debugPrint(response)
            next(JSON(data: response.data!))
    }
    
}


// url 修改
func urladd(url:String)->String{
    //let urltitle:String = "http://localhost:8888/"
    
    let urltitle:String = "http://60.176.44.121:8888/"
    let URL = urltitle + url
    return URL
}


func photoget (id:Int,next: @escaping (Data)->())
{   let url = "picture/pictures/readpictures/id/\(id)"
    let URL = urladd(url: url)
    Alamofire.request(URL,method: .get).response
        {   
            response in
            debugPrint(response)
            next(response.data!)
    }
    
}



extension Data: ParameterEncoding {
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try urlRequest.asURLRequest()
        request.httpBody = self
        return request
    }
    
}
func photopost2 (id:Int,data:Data,next: @escaping (JSON)->())
{
    let url = "picture/pictures/setmoonpic/id/\(id)"
    let URL = urladd(url: url)
    Alamofire.request(URL,method: .post,parameters:[:], encoding:data).responseJSON
        {
            response in
            debugPrint(response)
            //print(response.data)
            next(JSON(data: response.data!))
    }
}

func photopost (data:Data,next: @escaping (JSON)->())
{
    let url = "picture/pictures/setpictures"
    let URL = urladd(url: url)
    Alamofire.request(URL,method: .post,parameters:[:], encoding:data).responseJSON
        {
            response in
            debugPrint(response)
            //print(response.data)
            next(JSON(data: response.data!))
    }
}
