//
//  AppointmentModel.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/27.
//

import Foundation

struct AppointmentSimpleModel: Decodable {
    let id: Int
    let title: String
    let content: String
    let author: User
    let amountOfComments: Int
    let totalNumberOfPeople: Int
    let currentNumberOfPeople: Int
    let full: Bool
//    let sexRestriction
//    let appointmentTime: String?
    let createdAt: String

    struct User: Decodable {
        let nickname: String
    }

}

struct AppointmentModel: Decodable {
    let id: Int
    let title: String
    let content: String
    let author: User
    let members: [User]
    let amountOfComments: Int
    let comments: [CommentModel]
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
        let id: Int
        let nickname: String
        let rating: Double
    }

}

struct CommentModel: Decodable {
    let id: Int
    let author: User?
    let content: String?
    let replies: [Reply]
    let createdAt: String

    struct User: Decodable {
        let id: Int
        let nickname: String
    }

    struct Reply: Decodable {
        let id: Int
        let author: User
        let content: String
        let createdAt: String
    }
}

struct AppointmentListModel: Decodable {
    let content: [AppointmentSimpleModel]
    let first: Bool
    let last: Bool
    let totalPages: Int
}
