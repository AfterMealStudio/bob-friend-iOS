//
//  SignUpModel.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/09/16.
//

import Foundation

// TODO: - 서버의 api가 수정되면 username을 삭제해야함
struct SignUpModel: Codable {
    var email: String = ""
    let username: String = "temp_username"
    var nickname: String = ""
    var password: String = ""
    var sex: Gender.RawValue = ""
    var birth: String = ""
    var agree: Bool = true
}

enum Gender: String {
    case male = "MALE"
    case female = "FEMALE"
}

// TODO: - 서버의 api가 수정되면 username을 삭제해야함
struct SignUpResponseModel: Codable {
    let id: Int
    let email: String
    let username: String
    let nickname: String
    let birth: String
    let sex: String
    let reportCount: Int
    let active: Bool
}
