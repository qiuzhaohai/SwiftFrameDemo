//
//  NetWorkAPIManager.swift
//  SwiftDemo
//
//  Created by QiuZhaoHai on 2020/1/31.
//  Copyright © 2020 QiuZhaoHai. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper

let URL_HEADER = "https://"
// DEV环境
let URL_DOMAIN = "api.uomg.com/"

// UAT环境
//let URL_DOMAIN = ""
// PRO环境
//let URL_DOMAIN = ""
// 虚拟目录
let URL_VIRTUAL_DIR = "api/"

// baseUrl
let DOMAIN = URL_HEADER + URL_DOMAIN + URL_VIRTUAL_DIR


enum NetWorkAPIManager {
    case login(params:Dictionary<String, Any>)
    case logon(params:Dictionary<String, Any>)
    case logout(params:Dictionary<String, Any>)
    case getQQLevel(params:Dictionary<String, Any>)
}

extension NetWorkAPIManager: NetWorkAPITargetType {
    
    var baseUrl: String {
        switch self {
        default:
            return DOMAIN
        }
    }
    
    var modelType: Mappable.Type {
        return NetWorkNormalModel.self
    }
    
    var method: RequestMedType {
        switch self {
            case .getQQLevel(_):
                return .post
            default:
                return .post
        }
    }
    
    var path: String {
        switch self {
            case .login(_):
                return "login"
            case .logon(_):
                return "logon"
            case .logout(_):
                return "logout"
            case .getQQLevel(_):
                return "get.title"
        }
    }
    
    var pararms: Dictionary<String, Any> {
        switch self {
            case .getQQLevel(let parprms):
                return parprms
            default:
                return [:]
        }
    }
    
    var headers: HTTPHeaders {
        return ["Content-Type":"application/json;charset=utf-8"]
    }
}
