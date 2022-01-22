//
//  UserRepository.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/26.
//

import Foundation

protocol UserRepository {
    func getUserInfo(_ accessToken: String, completion: ((Result<UserInfoModel, Error>) -> Void)?)
    func setMyInfoAtDevice(_ userInfo: UserInfoModel)
    func withdrawalMembership(password: String, completion: ((Result<Void, Error>) -> Void)?)
}

class UserRepositoryImpl: UserRepository {
    let network: Network = Network()

    func getUserInfo(_ accessToken: String, completion: ((Result<UserInfoModel, Error>) -> Void)? = nil) {
        network.getMyUserInfoRequest { result in
            guard let completion = completion else { return }

            switch result {
            case .success(let userInfo):
                if let userInfo = userInfo {
                    completion(Result.success(userInfo))
                    return
                }
                completion(Result.failure(ResponedError.error))
            case .failure(let error):
                completion(Result.failure(error))
            }

        }
    }

    func setMyInfoAtDevice(_ userInfo: UserInfoModel) {
        UserInfo.myInfo = userInfo
    }

    func withdrawalMembership(password: String, completion: ((Result<Void, Error>) -> Void)?) {

        network.withdrawalMembership(password: password) { result in

            guard let completion = completion else { return }

            switch result {
            case .success(let data):
                if let data = data {
                    completion(.success(data))
                    return
                }
                completion(.failure(ResponedError.error))
            case .failure(let error):
                completion(.failure(error))
                return
            }

        }
    }

}

struct WithdrawalMembershipModel: Encodable {
    let password: String
}
