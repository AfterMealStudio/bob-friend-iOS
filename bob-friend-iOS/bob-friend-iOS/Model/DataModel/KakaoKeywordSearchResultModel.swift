//
//  KakaoKeywordSearchResultModel.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/11.
//

import Foundation

struct KakaoKeywordSearchResultModel: Decodable {

    let meta: Meta
    let documents: [Document]

    struct Meta: Decodable {
        let is_end: Bool
    }

    struct Document: Decodable {
        let place_name: String
        let road_address_name: String
        let address_name: String
        let x: String
        let y: String
    }
}
