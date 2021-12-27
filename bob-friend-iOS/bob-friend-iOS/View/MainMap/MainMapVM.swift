//
//  MainMapVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/12.
//

import Foundation
import Alamofire

class MainMapVM {

    private let kakaoPlaceSearchRepository: KakaoPlaceSearchRepository = KakaoPlaceSearchRepositoryImpl()

    weak var delegate: MainMapDelegate?

    func searchPlace(keyword: String, page: Int = 1) {
        kakaoPlaceSearchRepository.searchPlace(keyword: keyword, page: page) { [weak self] result in
            switch result {
            case .success(let searchResultData):
                self?.delegate?.mainMap(searchResults: searchResultData)
            case .failure(let error):
                self?.delegate?.occuredSearchError(errMessage: error.localizedDescription)
            }
        }
    }

}

protocol MainMapDelegate: AnyObject {
    func mainMap(searchResults: KakaoKeywordSearchResultModel)
    func occuredSearchError(errMessage: String)
}
