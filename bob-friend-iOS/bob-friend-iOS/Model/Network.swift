//
//  Network.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import Foundation
import Alamofire

class Network {

    private let baseUrl: String = "http://117.17.102.143:8080/"

    private enum API: String {
        case login = "api/signin"
        case checkEmailDuplication = "api/email"
        // TODO: - 서버의 api가 수정되면 username -> nickname 수정 필요. 실제로 지금은 nickname이 아닌 username을 비교하고 있음
        case checkNicknameDuplication = "api/username"
        case signup = "api/signup"
    }

    func loginRequest(loginInfo: LoginModel, completion: @escaping (Result<TokenModel, AFError>) -> Void) {
        let url = baseUrl + API.login.rawValue

        AF.request(url, method: .post, parameters: loginInfo, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseDecodable(of: TokenModel.self) { res in

            completion(res.result)

        }
    }

    func checkEmailDuplicationRequest(email: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        let url = baseUrl + API.checkEmailDuplication.rawValue + "/\(email)"
        AF.request(url, method: .get).validate(statusCode: 200..<300).response { res in
            completion(res.result)
        }
    }

    func checkNicknameDuplicationRequest(nickname: String, completion: @escaping (Result<Data?, AFError>) -> Void) {
        let url = baseUrl + API.checkNicknameDuplication.rawValue + "/\(nickname)"
        AF.request(url, method: .get).validate(statusCode: 200..<300).response { res in
            completion(res.result)
        }
    }

    func signUpRequest(signUpInfo: SignUpModel, completion: @escaping (Result<SignUpResponseModel, AFError>) -> Void) {
        let url = baseUrl + API.signup.rawValue

        AF.request(url, method: .post, parameters: signUpInfo, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseDecodable(of: SignUpResponseModel.self) { res in
            completion(res.result)
        }
    }

}
