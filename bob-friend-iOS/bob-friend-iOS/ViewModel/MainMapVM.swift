//
//  MainMapVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/12.
//

import Foundation
import Alamofire

class MainMapVM {

    let network: Network = Network()
    weak var delegate: MainMapDelegate?

    func requestPlaceSearch(keyword: String, page: Int = 1, completion: @escaping (Result<KakaoKeywordSearchResultModel, AFError>) -> Void) {
        network.kakaoKeywordSearchRequest(keyword: keyword, page: page) { [weak self] result in
            switch result {
            case .success(let data):
                self?.delegate?.mainMap(searchResults: data)
            case . failure(_):
                self?.delegate?.occuredError()
            }

        }
    }
}

protocol MainMapDelegate: AnyObject {

    func mainMap(searchResults: KakaoKeywordSearchResultModel)
    func occuredError()

}
