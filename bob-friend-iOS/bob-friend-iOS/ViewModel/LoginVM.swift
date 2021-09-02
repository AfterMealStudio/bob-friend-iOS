//
//  LoginVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import UIKit

class LoginVM {
    
    let network: Network = Network()
    var delegate: LoginDelegate?
    
    func login(id: String, pwd: String) {
        let loginInfo = LoginModel(username: id, password: pwd)
        
        network.loginRequest(loginInfo: loginInfo) { result in
            switch result {
            case .success(let token):
                self.delegate?.didSuccessLogin(token)
            case .failure(let err):
                self.delegate?.didFailLogin(err)
            }
            
        }
        
    }
    
    
}


protocol LoginDelegate {
    
    func didSuccessLogin(_ token: TokenModel)
    
    func didFailLogin(_ err: Error)
    
}