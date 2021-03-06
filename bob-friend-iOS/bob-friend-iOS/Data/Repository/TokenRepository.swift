//
//  TokenRepository.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/23.
//

import Foundation

protocol TokenRepository {
    func getToken() -> String?
    func saveToken(token: TokenModel)
}

class TokenRepositoryImpl: TokenRepository {
    func getToken() -> String? {
        return Network.accessToken
    }

    func saveToken(token: TokenModel) {
        Network.accessToken = token.accessToken
        Network.refreshToken = token.refreshToken
    }

}
