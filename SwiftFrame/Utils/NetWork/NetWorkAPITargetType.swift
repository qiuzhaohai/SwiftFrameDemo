//
//  NetWorkAPITargetType.swift
//  SwiftDemo
//
//  Created by QiuZhaoHai on 2020/1/31.
//  Copyright © 2020 QiuZhaoHai. All rights reserved.
//

import UIKit
import Alamofire

public protocol NetWorkAPITargetType {
    
    var method: RequestMedType {get}
    
    var baseUrl: String {get}
    
    var path: String {get}
    
    var pararms: Dictionary<String, Any>{get}
    
    var headers: HTTPHeaders {get}
}
