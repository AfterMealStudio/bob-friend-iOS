//
//  LoginVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import UIKit

class LoginVM: Login {
    
    init(_ vc: UIViewController) {
        enrollObserver(vc: vc)
    }
    
    
    func login(id: String, pwd: String) {
        
        let loginInfo = LoginModel(username: id, password: pwd)
        
        Network.shared.loginRequest(loginInfo: loginInfo) { result in
            switch result {
            case .success(let token):
                NotificationCenter.default.post(name: Notification.Name("LoginSuccess"), object: token)
                break
            case .failure(let err):
                NotificationCenter.default.post(name: Notification.Name("LoginFailure"), object: err)
                print("login error : \(err)")
                break
            }
            
        }
        
    }
    
    
    func enrollObserver(vc: UIViewController) {
        NotificationCenter.default.addObserver(vc, selector: #selector(didSuccessLogin(_:)), name: NSNotification.Name("LoginSuccess"), object: nil)
        NotificationCenter.default.addObserver(vc, selector: #selector(didFailLogin), name: NSNotification.Name("LoginFailure"), object: nil)
    }
    
    
    @objc func didSuccessLogin(_ notification: NSNotification) {}
    
    @objc func didFailLogin(_ notification: NSNotification) {}
    
    
}
