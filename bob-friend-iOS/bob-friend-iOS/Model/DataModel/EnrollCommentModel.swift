//
//  EnrollCommentModel.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/10.
//

import Foundation

struct EnrollCommentModel: Encodable {
    let content: String
}

struct EnrollCommentResponseModel: Decodable {
    let id: Int
    let author: User
}
