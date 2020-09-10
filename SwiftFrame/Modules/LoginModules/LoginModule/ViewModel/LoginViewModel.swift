//
//  LoginViewModel.swift
//  SwiftDemo
//
//  Created by QiuZhaoHai on 2020/1/12.
//  Copyright © 2020 QiuZhaoHai. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LoginViewModel: ViewModelType {
    
    private let loginRelay = BehaviorRelay<[LoginModel]>(value: [LoginModel].init())
    
    func transform(input: Input) -> Output {
        let dic = ["url":"http://qrpay.uomg.com"] as [String : Any]

        self.login(params: dic);
        return Output.init(loginInfo: loginRelay.asObservable())
    }
    
    func login(params: Dictionary<String, Any>) -> Void {
        
        NetWorkRequestManager.singleton.requestByTargetType(targetType: NetWorkAPIManager.getQQLevel(params: params), model: NetWorkNormalModel.self, success: { [weak self](baseModel, json) in
            print("ok" + self.debugDescription)
        }) { [weak self](error) in
            print(error.message + self.debugDescription)
            
        }
    }
}

extension LoginViewModel {
    
    struct Input {
    }

    struct Output {
        let loginInfo: Observable<[LoginModel]>
    }
}

