//
//  LoginViewController.swift
//  SwiftDemo
//
//  Created by QiuZhaoHai on 2020/1/11.
//  Copyright © 2020 QiuZhaoHai. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    // MARK: - attributes
    
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    // MARK: - function
    
    private func bindViewModel() {
//        let input = LoginViewModel.Input.init()
//        let output = loginViewModel.transform(input: input)
    }

    // MARK: - lazy load
    
    lazy var loginViewModel: LoginViewModel = {
        let loginViewModel: LoginViewModel = LoginViewModel()
        return loginViewModel
    }()
}
