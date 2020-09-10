//
//  RegularCheckTool.swift
//  SwiftDemo
//
//  Created by QiuZhaoHai on 2020/1/18.
//  Copyright © 2020 QiuZhaoHai. All rights reserved.
//

import UIKit

public class RegularMatchTool {
    
    let regex : NSRegularExpression
    
    /// 正则校验初始化
    /// - Parameter pattern: 检验类型的正则表达式
    init(_ pattern: String) throws {
        try regex = NSRegularExpression(pattern: pattern, options: .caseInsensitive)
    }
    
    /// 正则校验
    /// - Parameter input: 校验的字符串
    /// Return Bool
    func match(_ input: String) -> Bool {
        let matches = regex.matches(in: input, options: [], range: NSMakeRange(0, input.utf16.count))
        return matches.count > 0
    }
}

// 声明中位运算符必须声明precedencegroup
precedencegroup RegularMatchPrec {
    associativity: none
    higherThan: DefaultPrecedence
}

// 声明 正则校验中间操作运算符
infix operator =^: RegularMatchPrec

/// 正则表达式中位运算符方法
/// - Parameters:
///   - object: 检验的字符串
///   - template: 正则表达式
/// Return Bool
public func =^(object: String, template: String) -> Bool {
    do {
        return try RegularMatchTool(template).match(object)
    } catch _ {
        return false
    }
}

