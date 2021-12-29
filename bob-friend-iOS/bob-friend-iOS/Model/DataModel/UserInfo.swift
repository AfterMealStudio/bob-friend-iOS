//
//  UserInfo.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/15.
//

import Foundation

struct User: Decodable {
    let id: Int
    let nickname: String
    let rating: Double
}

struct UserInfoModel: Decodable {
    let id: Int
    let email: String
    let nickname: String
    let age: Int
    let sex: Gender
    let rating: Float
}

class UserInfo {
    static var myInfo: UserInfoModel?
}
