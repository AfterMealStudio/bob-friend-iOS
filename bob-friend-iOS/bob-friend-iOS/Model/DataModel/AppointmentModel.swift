//
//  AppointmentModel.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/27.
//

import Foundation

struct AppointmentModel: Decodable {
    let id: Int
    let title: String
    let content: String
    let author: User
    let members: [User]
    let totalNumberOfPeople: Int
    let currentNumberOfPeople: Int
    let full: Bool
    let restaurantName: String
    let restaurantAddress: String
    let latitude: Float
    let longitude: Float
//    let sexRestriction
    let appointmentTime: String?
    let createdAt: String

    struct User: Decodable {
        let nickname: String
    }

}

struct AppointmentListModel: Decodable {
    let content: [AppointmentModel]
    let first: Bool
    let last: Bool
    let totalPages: Int
}
