//
//  NetWorkBaseModel.swift
//  SwiftDemo
//
//  Created by QiuZhaoHai on 2020/1/30.
//  Copyright © 2020 QiuZhaoHai. All rights reserved.
//

import UIKit
import ObjectMapper

struct NetWorkBaseModel<T: Mappable>: Mappable {
    
    var status: Int = 100 // 编码
    var msg: String = "" // 返回信息
    var data: [T]? // 返回数据
    var dataAny: String? // 返回数据
    var dataStr: [String]? // 返回数据
    var dicData: T? // 返回数据
    var success: Int = 1 // 1 成功
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        // 凭项目情况设定
        status <- map["code"]
        msg <- map["msg"]
        success <- map["success"]
        data <- map["info"]
        dataStr <- map["data"]
        data <- map["data.data"]
        data <- map["Data"]
        dataAny <- map["Data"]
        dataAny <- map["data"]
        dicData <- map["info"]
        dicData <- map["data.data"]
        dicData <- map["Data"]
    }
    
    
}

struct NetWorkNormalModel: Mappable {
    
    init?(map: Map) {
        
    }
    
    init() {
        
    }
    
    mutating func mapping(map: Map) {
        
    }
}
