//
//  Network.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import Foundation
import Alamofire

class Network {

    // 싱글톤을 썼지만, VM에서는 사용할때 꼭 싱글톤 일 필요가 있을까??
    static let shared = Network()

    // 필요 없는 init을 만들었네.
    private init() {}

    // 해당 프로퍼티는 private로 접근 제어자를 해주는게 좋지 않을까?(외부에서 접근할 이유가 없기 때문에)
    let baseUrl: String = Bundle.main.infoDictionary!["API_BASE_URL"] as! String

    enum API: String {
        case login = "api/signin"
    }

    func loginRequest(loginInfo: LoginModel, completion: @escaping (Result<TokenModel, AFError>) -> Void) {
        let url = baseUrl + API.login.rawValue

        AF.request(url, method: .post, parameters: loginInfo, encoder: JSONParameterEncoder.default).validate(statusCode: 200..<300).responseDecodable(of: TokenModel.self) { res in
            completion(res.result)
        }
    }
}
