//
//  SignUpModel.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/09/16.
//

import Foundation

struct SignUpModel: Codable {
    let email: String
    let nickname: String
    let password: String
    let sex: Gender
    let birth: String
    let agree: Bool
}

enum Gender: String, Codable {
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
