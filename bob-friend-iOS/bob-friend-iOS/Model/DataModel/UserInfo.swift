//
//  UserInfo.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/15.
//

import Foundation

struct UserInfoModel: Decodable {
    let id: Int
    let email: String
    let nickname: String
    let birth: String
}

class UserInfo {
    static var myInfo: UserInfoModel?
}
