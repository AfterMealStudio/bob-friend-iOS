//
//  AppointmentEnrollModel.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/23.
//

import Foundation

struct AppointmentEnrollModel: Encodable {
    let title: String
    let content: String
    let totalNumberOfPeople: Int
    let restaurantName: String
    let restaurantAddress: String
    let latitude: Double
    let longitude: Double
    let sexRestriction: Gender
    let appointmentTime: String
    let ageRestrictionStart: Int?
    let ageRestrictionEnd: Int?
}
