//
//  LoginVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import UIKit

class LoginVM: Login {
    
    let network: Network = Network()
    
    init(_ object: Login) {
        weak var object = object
        
        if object != nil {
            enrollObserver(object: object!)
        }
        
    }
    
    
    func login(id: String, pwd: String) {
        
        let loginInfo = LoginModel(username: id, password: pwd)
        
        network.loginRequest(loginInfo: loginInfo) { result in
            switch result {
            case .success(let token):
                NotificationCenter.default.post(name: Notification.Name("LoginSuccess"), object: token)
            case .failure(let err):
                NotificationCenter.default.post(name: Notification.Name("LoginFailure"), object: err)
            }
            
        }
        
    }
    
    
    func enrollObserver(object: Login) {
        NotificationCenter.default.addObserver(object, selector: #selector(didSuccessLogin(_:)), name: NSNotification.Name("LoginSuccess"), object: nil)
        NotificationCenter.default.addObserver(object, selector: #selector(didFailLogin), name: NSNotification.Name("LoginFailure"), object: nil)
    }
    
    
    @objc func didSuccessLogin(_ notification: Notification) {}
    
    @objc func didFailLogin(_ notification: Notification) {}
    
    
}
