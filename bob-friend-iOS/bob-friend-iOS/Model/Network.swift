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

        var method: HTTPMethod {
            switch self {
            case .login: return .post
            case .checkEmailDuplication(email: _): return .get
            case .checkNicknameDuplication(nickname: _): return .get
            case .signup: return .post
            }
        }
    }

    func loginRequest(loginInfo: LoginModel, completion: @escaping (Result<TokenModel?, Error>) -> Void) {
        request(api: API.login, type: TokenModel.self, parameter: loginInfo, completion: completion)
    }

    func checkEmailDuplicationRequest(email: String, completion: @escaping (Result<DuplicationCheckResultModel?, Error>) -> Void) {
        request(api: .checkEmailDuplication(email: email), type: DuplicationCheckResultModel.self, completion: completion)
    }

    func checkNicknameDuplicationRequest(nickname: String, completion: @escaping (Result<DuplicationCheckResultModel?, Error>) -> Void) {
        request(api: .checkNicknameDuplication(nickname: nickname), type: DuplicationCheckResultModel.self, completion: completion)
    }

    func signUpRequest(signUpInfo: SignUpModel, completion: @escaping (Result<SignUpResponseModel?, Error>) -> Void) {
        request(api: .signup, type: SignUpResponseModel.self, parameter: signUpInfo, completion: completion)
    }

}

extension Network {

    private func request<E: Encodable, D: Decodable>(api: API, type: D.Type, parameter: E, encoder: ParameterEncoder = JSONParameterEncoder(), completion: @escaping (Result<D?, Error>) -> Void) {

        session?.request(api.path, method: api.method, parameters: parameter, encoder: encoder).response { [weak self] response in
            switch response.result {
            case .success(let data):
                let jsonData = self?.decodeJSONData(data: data, type: type)
                completion(.success(jsonData))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    private func request<D: Decodable>(api: API, type: D.Type, completion: @escaping (Result<D?, Error>) -> Void) {

        session?.request(api.path, method: api.method).response { [weak self] response in
            switch response.result {
            case .success(let data):
                let jsonData = self?.decodeJSONData(data: data, type: type)
                completion(.success(jsonData))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    private func decodeJSONData<D: Decodable>(data: Data?, type: D.Type) -> D? {
        let decoder = JSONDecoder()
        guard let data = data, let jsonData = try? decoder.decode(type, from: data) else { return nil }
        return jsonData
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
