//
//  LoginVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import UIKit

class LoginVM {

    let network: Network = Network()
    weak var delegate: LoginDelegate?

    func login(id: String, pwd: String) {
        let loginInfo = LoginModel(email: id, password: pwd)

        network.loginRequest(loginInfo: loginInfo) { [weak self] result in
            switch result {
            case .success(let token):
                if let token = token {
                    self?.delegate?.didSuccessLogin(token)
                    Network.token = token.token
                } else { self?.delegate?.didFailLogin(nil) }
            case .failure(let err):
                self?.delegate?.didFailLogin(err)
            }

        }

    }

    func getUserInfo() {
        network.getUserInfoRequest { result in
            switch result {
            case .success(let myInfo):
                if let myInfo = myInfo {
                    UserInfo.myInfo = myInfo
                }
            case .failure:
                break
            }

        }
    }

}

protocol LoginDelegate: AnyObject {

    func didSuccessLogin(_ token: TokenModel)

    func didFailLogin(_ err: Error?)

}
