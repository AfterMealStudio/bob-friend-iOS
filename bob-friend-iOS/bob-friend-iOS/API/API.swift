//
//  API.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2022/01/20.
//

import Foundation
import Alamofire
import SwiftUI

protocol API {
    var path: String { get }
    var method: HTTPMethod { get }
}

enum AppointmentAPI: API {

    case createAppointment
    case getAppointment(id: Int)
    case getAppointments
    case getAllAppointmentLocations
    case getAppointmentsByPoint
    case joinAppointment(id: Int)
    case deleteAppointment(id: Int)
    case searchAppointments
    case reportAppointment(id: Int)
    case closeAppointment(id: Int)

    var path: String {
        let baseUrl: String = "http://117.17.102.143:8080/api"

        switch self {
        case .createAppointment:
            return baseUrl + "/recruitments"
        case .getAppointment(let id):
            return baseUrl + "/recruitments/\(id)"
        case .getAppointments:
            return baseUrl + "/recruitments"
        case .getAllAppointmentLocations:
            return baseUrl + "/recruitments/locations"
        case .getAppointmentsByPoint:
            return baseUrl + "/recruitments"
        case .joinAppointment(let id):
            return baseUrl + "/recruitments/\(id)"
        case .deleteAppointment(let id):
            return baseUrl + "/recruitments/\(id)"
        case .searchAppointments:
            return baseUrl + "/recruitments/search"
        case .reportAppointment(let id):
            return baseUrl + "/recruitments/\(id)/report"
        case .closeAppointment(let id):
            return baseUrl + "/recruitments/\(id)/close"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createAppointment: return .post
        case .getAppointment: return .get
        case .getAppointments: return .get
        case .getAllAppointmentLocations: return .get
        case .getAppointmentsByPoint: return .get
        case .joinAppointment: return .patch
        case .deleteAppointment: return .delete
        case .searchAppointments: return .get
        case .reportAppointment: return .patch
        case .closeAppointment: return .patch
        }
    }

}

enum CommentAPI: API {

    case createComment(appointmentID: Int)
    case deleteComment(appointmentID: Int, commentID: Int)
    case getComments(appointmentID: Int)
    case reportComments(appointmentID: Int, commentID: Int)

    case createRecomment(appointmentID: Int, commentID: Int)
    case deleteRecomment(appointmentID: Int, commentID: Int, recommentID: Int)
    case reportRecomment(appointmentID: Int, commentID: Int, recommentID: Int)

    var path: String {
        let baseUrl: String = "http://117.17.102.143:8080"

        switch self {
        case .createComment(let appointmentID):
            return baseUrl + "/recruitments/\(appointmentID)/comments"
        case .deleteComment(let appointmentID, let commentID):
            return baseUrl + "/recruitments/\(appointmentID)/comments/\(commentID)"
        case .getComments(let appointmentID):
            return baseUrl + "/recruitments/\(appointmentID)/comments"
        case .reportComments(let appointmentID, let commentID):
            return baseUrl + "/recruitments/\(appointmentID)/comments/\(commentID)/report"

        case .createRecomment(let appointmentID, let commentID):
            return baseUrl + "/recruitments/\(appointmentID)/comments/\(commentID)/replies"
        case .deleteRecomment(let appointmentID, let commentID, let recommentID):
            return baseUrl + "/recruitments/\(appointmentID)/comments/\(commentID)/replies/\(recommentID)"
        case .reportRecomment(let appointmentID, let commentID, let recommentID):
            return baseUrl + "/recruitments/\(appointmentID)/comments/\(commentID)/replies/\(recommentID)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .createComment: return .post
        case .deleteComment: return .delete
        case .getComments: return .get
        case .reportComments: return .patch

        case .createRecomment: return .post
        case .deleteRecomment: return .delete
        case .reportRecomment: return .patch
        }
    }

}

enum AuthAPI: API {

    case signUp
    case signIn
    case reissueToken
    case checkTokenValidate
    case retryVerifyEmail

    var path: String {
        let baseUrl: String = "http://117.17.102.143:8080/api/auth"

        switch self {
        case .signUp:
            return baseUrl + "/signup"
        case .signIn:
            return baseUrl + "/signin"
        case .reissueToken:
            return baseUrl + "/issue"
        case .checkTokenValidate:
            return baseUrl + "/validate"
        case .retryVerifyEmail:
            return baseUrl + "/verify/retry"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .signUp: return .post
        case .signIn: return .post
        case .reissueToken: return .post
        case .checkTokenValidate: return .get
        case .retryVerifyEmail: return .get
        }
    }

}

enum UserAPI: API {

    case changeUserInfo
    case deleteUser
    case getMyUserInfo
    case getOtherUserInfo(email: String)
    case checkEmailIsUsing(email: String)
    case checkNicknameIsUsing(nickname: String)
    case scoreRating(nickname: String)

    var path: String {
        let baseUrl: String = "http://117.17.102.143:8080/api"

        switch self {
        case .changeUserInfo:
            return baseUrl + "/user"
        case .deleteUser:
            return baseUrl + "/user"
        case .getMyUserInfo:
            return baseUrl + "/user"
        case .getOtherUserInfo(let email):
            return baseUrl + "/user/\(email)"
        case .checkEmailIsUsing(let email):
            return baseUrl + "/user/email/\(email)"
        case .checkNicknameIsUsing(let nickname):
            return baseUrl + "/user/nickname/\(nickname)"
        case .scoreRating(let nickname):
            return baseUrl + "/user/nickname/\(nickname)/score"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .changeUserInfo: return .put
        case .deleteUser: return .delete
        case .getMyUserInfo: return .get
        case .getOtherUserInfo: return .get
        case .checkEmailIsUsing: return .get
        case .checkNicknameIsUsing: return .get
        case .scoreRating: return .post
        }
    }

}

enum KakaoKeywordSearchAPI: API {

    case search

    var path: String {
        let baseUrl: String = "https://dapi.kakao.com/v2/local/search/keyword.json"
        switch self {
        case .search: return baseUrl
        }
    }

    var method: HTTPMethod {
        switch self {
        case .search: return .get
        }
    }

}
