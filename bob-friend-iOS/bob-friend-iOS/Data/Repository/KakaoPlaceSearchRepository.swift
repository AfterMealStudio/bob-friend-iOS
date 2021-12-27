//
//  KakaoPlaceSearchRepository.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/27.
//

import Foundation

protocol KakaoPlaceSearchRepository {
    func searchPlace(keyword: String, page: Int, completion: ((Result<KakaoKeywordSearchResultModel, Error>) -> Void)?)
}

class KakaoPlaceSearchRepositoryImpl: KakaoPlaceSearchRepository {
    let network: Network = Network()

    func searchPlace(keyword: String, page: Int = 1, completion: ((Result<KakaoKeywordSearchResultModel, Error>) -> Void)? = nil) {

        network.kakaoKeywordSearchRequest(keyword: keyword, page: page) { result in
            guard let completion = completion else { return }

            switch result {
            case .success(let searchResult):
                guard let searchResult = searchResult else {
                    completion(Result.failure(ResponedError.searchError))
                    return
                }
                completion(Result.success(searchResult))
            case .failure(let error):
                completion(Result.failure(error))
            }
        }

    }

}
