//
//  NetWorkMacro.swift
//  SwiftDemo
//
//  Created by QiuZhaoHai on 2020/1/31.
//  Copyright © 2020 QiuZhaoHai. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import SwiftyJSON

// 成功
typealias NetSuccessBlock<T: Mappable> = (_ value: NetWorkBaseModel<T>, JSON) -> Void
// 失败
typealias NetFailedBlock = (AFSErrorInfo) -> Void
// 进度
typealias AFSProgressBlock = (Double) -> Void
// 报错信息
struct AFSErrorInfo {
    var code = 0
    var message = ""
    var error = NSError()
}
// 请求类型
public enum RequestMedType: Int {
    case post = 0
    case get = 1
    case bodyPost = 2
    case uploadImage = 3
    case uploadMp4 = 4
}
