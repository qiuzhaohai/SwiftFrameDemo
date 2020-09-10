//
//  RegexExprMacro.swift
//  SwiftDemo
//
//  Created by QiuZhaoHai on 2020/1/19.
//  Copyright © 2020 QiuZhaoHai. All rights reserved.
//

import UIKit


/// 常用的正则表达式
enum RegexExpr: String {
//    匹配邮箱
    case Email = "^([a-z0-9_\\.-]+)@([\\da-z\\.-]+)\\.([a-z\\.]{2,6})$"
//    匹配电话号码 (11)
    case PhoneNumber = "1\\d{10}"
//    匹配密码 (6 ~ 16)
    case Password = "^[a-z0-9_-]{6,16}$"
//    匹配URL
    case URL = "^(https?:\\/\\/)?([\\da-z\\.-]+)\\.([a-z\\.]{2,6})([\\/\\w \\.-]*)*\\/?$"
//    匹配IP地址
    case IPAddress = "^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$"
}
