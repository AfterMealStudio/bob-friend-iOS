//
//  Network.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import Foundation
import Alamofire

class Network {

    private enum API {
        case login
        case checkEmailDuplication(email: String)
        case checkNicknameDuplication(nickname: String)
        case signup

        var path: String {
            let baseUrl: String = "http://117.17.102.143:8080/"

            switch self {
            case .login:
                return baseUrl + "api/signin"
            case .checkEmailDuplication(let email):
                return baseUrl + "api/email/\(email)"
            case .checkNicknameDuplication(let nickname):
                return baseUrl + "api/nickname/\(nickname)"
            case .signup:
                return baseUrl + "api/signup"
            }
        }
    }

    func loginRequest(loginInfo: LoginModel, completion: @escaping (Result<TokenModel, AFError>) -> Void) {
        AF.request(API.login.path, method: .post, parameters: loginInfo, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseDecodable(of: TokenModel.self) { res in
            completion(res.result)
        }
    }

    func checkEmailDuplicationRequest(email: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(API.checkEmailDuplication(email: email).path, method: .get).validate(statusCode: 200..<300).response { res in
            completion(res.result)
        }
    }

    func checkNicknameDuplicationRequest(nickname: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        AF.request(API.checkNicknameDuplication(nickname: nickname).path, method: .get).validate(statusCode: 200..<300).response { res in
            completion(res.result)
        }
    }

    func signUpRequest(signUpInfo: SignUpModel, completion: @escaping (Result<SignUpResponseModel, AFError>) -> Void) {
        AF.request(API.signup.path, method: .post, parameters: signUpInfo, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseDecodable(of: SignUpResponseModel.self) { res in
            completion(res.result)
        }
    }

}
