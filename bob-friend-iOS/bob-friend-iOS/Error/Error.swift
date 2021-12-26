//
//  Error.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/26.
//

import Foundation

enum ResponedError: LocalizedError {
    case error
    case loginError

    var errorDescription: String? {
        switch self {
        case .error:
            return "오류 발생"
        case .loginError:
            return "로그인에 실패하였습니다."
        }
    }

}
