//
//  Network.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import Foundation
import Alamofire

final class Network {

    private let session: Session?

    init(_ session: Session = AF) {
        self.session = session
    }

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

    func checkEmailDuplicationRequest(email: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        request(api: .checkEmailDuplication(email: email), completion: completion)
    }

    func checkNicknameDuplicationRequest(nickname: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        request(api: .checkNicknameDuplication(nickname: nickname), completion: completion)
    }

    func signUpRequest(signUpInfo: SignUpModel, completion: @escaping (Result<SignUpResponseModel, AFError>) -> Void) {
        AF.request(API.signup.path, method: .post, parameters: signUpInfo, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseDecodable(of: SignUpResponseModel.self) { res in
            completion(res.result)
        }
    }

}

extension Network {

    private func request<D: Decodable>(api: API, type: D.Type, completion: @escaping (Result<D, Error>) -> Void) {
        session?.request(api.path).response { _ in
            // TODO: JSON Decoder를 가지고 파싱하는 함수 구현
        }

    }

    private func request(api: API, completion: @escaping (Result<Bool, Error>) -> Void) {
        session?.request(api.path).response { response in
            switch response.result {
            case .success(let data):
                if let data = data, let isValid = String(decoding: data, as: UTF8.self).bool {
                    completion(.success(isValid))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

extension String {
    fileprivate var bool: Bool? {
        switch self.lowercased() {
        case "true":
            return true
        case "false" :
            return false
        default:
            return nil
        }
    }
}
