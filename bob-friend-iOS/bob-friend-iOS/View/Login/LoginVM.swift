//
//  LoginVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import UIKit
import SwiftUI

class LoginVM {

    private let loginRepository: LoginRepository = LoginRepositoryImpl()
    private let tokenRepository: TokenRepository = TokenRepositoryImpl()
    private let userRepository: UserRepository = UserRepositoryImpl()

    weak var delegate: LoginDelegate?

    private var email = "" { didSet { loginInfo.email = email } }
    private var password = "" { didSet { loginInfo.password = password } }

    private var loginInfo: LoginModel

    init() {
        loginInfo = LoginModel(email: email, password: password)
    }

    func login() {
        delegate?.didStartLoading()

        loginRepository.login(loginInfo) { [weak self] result in
            self?.delegate?.didStopLoading()

            switch result {
            case .success(let token):
                self?.tokenRepository.saveToken(token: token)
                self?.delegate?.didSuccessLogin()
            case .failure(let error):
                self?.delegate?.didFailLogin(errMessage: error.localizedDescription)
            }

        }
    }

    func setMyInfo() {
        let token = tokenRepository.getToken()
        guard let token = token else { return }
        userRepository.getMyUserInfo(token) { [weak self] result in
            switch result {
            case .success(let myInfo):
                self?.userRepository.setMyInfoAtDevice(myInfo)
                self?.delegate?.didSetMyInfoAtDevice()
            case .failure(let error):
                self?.delegate?.didFailToSetMyInfoAtDevice(errMessage: error.localizedDescription)
            }
        }

    }

    func setEmail(_ email: String) {
        self.email = email
    }

    func setPassword(_ password: String) {
        self.password = password
    }

}

protocol LoginDelegate: AnyObject, LoadingAnimation {
    func didSuccessLogin()
    func didFailLogin(errMessage: String)

    func didSetMyInfoAtDevice()
    func didFailToSetMyInfoAtDevice(errMessage: String)
}
