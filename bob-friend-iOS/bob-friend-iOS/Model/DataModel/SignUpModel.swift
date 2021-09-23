//
//  SignUpModel.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/09/16.
//

import Foundation

struct SignUpModel: Codable {
    var email: String = ""
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

struct SignUpResponseModel: Codable {
    let id: Int
    let email: String
    let nickname: String
    let birth: String
    let sex: String
    let reportCount: Int
    let accumulatedReports: Int
    let agree: Bool
    let active: Bool
}
