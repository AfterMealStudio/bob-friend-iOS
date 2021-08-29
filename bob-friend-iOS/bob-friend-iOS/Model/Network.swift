//
//  Network.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import Foundation
import Alamofire

class Network {
    
    static let shared = Network()
    
    private init() {}
    
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


