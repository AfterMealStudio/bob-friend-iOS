//
//  MainMapVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/12.
//

import Foundation
import Alamofire

class MainMapVM {

    private let appointmentRepository: AppointmentRepository = AppointmentRepositoryImpl()
    private let kakaoPlaceSearchRepository: KakaoPlaceSearchRepository = KakaoPlaceSearchRepositoryImpl()

    weak var delegate: MainMapDelegate?

    func searchPlace(keyword: String, page: Int = 1) {
        kakaoPlaceSearchRepository.searchPlace(keyword: keyword, page: page) { [weak self] result in
            switch result {
            case .success(let searchResultData):
                self?.delegate?.didSearchPlace(searchResults: searchResultData)
            case .failure(let error):
                self?.delegate?.occuredSearchError(errMessage: error.localizedDescription)
            }
        }
    }

    func getAllAppointmentLocations() {
        appointmentRepository.getAllAppointmentLocations { [weak self] result in
            switch result {
            case .success(let locations):
                self?.delegate?.didGetAppointmentLocations(locations: locations)
            case .failure(let error):
                self?.delegate?.occuredSearchError(errMessage: error.localizedDescription)
            }

        }
    }

}

protocol MainMapDelegate: AnyObject {
    func didSearchPlace(searchResults: KakaoKeywordSearchResultModel)
    func didGetAppointmentLocations(locations: AppointmentLocationListModel)

    func occuredSearchError(errMessage: String)

}
