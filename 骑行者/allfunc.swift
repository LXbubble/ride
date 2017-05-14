//
//  allfunc.swift
//  骑行者
//
//  Created by apple on 17/3/25.
//  Copyright © 2017年 李响. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import JWT

public func loadcheck (name:String,psw:String) -> Bool {
    let namepattern = "［0-9a-zA-Z]{6,12}+$"
    let pswpattern = "\\w{6,20}+$"
    if checkpattern(str: name , pattern: namepattern)&&checkpattern(str:psw,pattern: pswpattern){
        return true
    }
    else {return false}
}


public func zhucecheck2(name:String,psw:String,nickname:String)->Bool{
    let namepattern = "［0-9a-zA-Z]{6,12}+$"
    let pswpattern = "\\w{6,20}+$"
    
    if !checkpattern(str: name , pattern: namepattern){return false}
    else if !checkpattern(str: psw, pattern: pswpattern){return false}
    else if nickname.characters.count == 0||nickname.characters.count>15 {return false}
    else {return true}
}

public func phonecheck(dic:Dictionary<String,String>)->Bool{
    let phonepattern = "^1[0-9]{10}$"
    let checkpatterns = "[0-9]+$"
    let pswpattern = "\\w{6,20}+$"
    if !checkpattern(str: dic["pn"]!, pattern: phonepattern){return false}
    else if !checkpattern(str: dic["cn"]!, pattern: checkpatterns){return false}
    else if !checkpattern(str: dic["psw"]!, pattern: pswpattern){return false}
    else if (dic["nickname"]?.characters.count)! == 0||(dic["nickname"]?.characters.count)! > 15{return false}
    else { return true}
}
public func checkpattern(str:String,pattern:String)->Bool{
    let predicate = NSPredicate(format: "SELF MATCHES %@", pattern)
    return predicate.evaluate(with: str)
    
}
public func readtoken()->Bool{
    let token = UserDefaults.standard.string(forKey: "token")
    if token == nil{
        
        return false
    }
    else {
        return true
    }
}

public func decodetoken(){
    let token = UserDefaults.standard.string(forKey: "token")
    do{
        let claims = try JWT.decode(token!, algorithm: .hs256("lx_cyclist".data(using: .utf8)!))
        UserDefaults.standard.set(claims["id"], forKey: "user_id")
        UserDefaults.standard.set(claims["role"], forKey: "user_role")
        UserDefaults.standard.set(claims["nickname"], forKey: "user_nickname")
    }catch{
        print("Failed to decode JWT: \(error)")
    }
}



