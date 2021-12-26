//
//  LoginRepository.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/23.
//

import Foundation

protocol LoginRepository {
    func login(_ loginInfo: LoginModel, completion: ((Result<TokenModel, Error>) -> Void)?)
}

class LoginRepositoryImpl: LoginRepository {
    let network: Network = Network()

    func login(_ loginInfo: LoginModel, completion: ((Result<TokenModel, Error>) -> Void)? = nil) {

        network.loginRequest(loginInfo: loginInfo) { result in
            guard let completion = completion else { return }

            switch result {
            case .success(let token):
                guard let token = token else {
                    completion(Result.failure(ResponedError.loginError))
                    return
                }
                completion(Result.success(token))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }

    }

}
