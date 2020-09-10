//
//  ViewModelType.swift
//  SwiftDemo
//
//  Created by QiuZhaoHai on 2020/1/31.
//  Copyright © 2020 QiuZhaoHai. All rights reserved.
//

import Foundation
import NSObject_Rx

protocol ViewModelType: HasDisposeBag {
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}
