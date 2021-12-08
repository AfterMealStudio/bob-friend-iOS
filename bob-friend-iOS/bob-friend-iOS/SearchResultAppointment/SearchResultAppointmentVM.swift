//
//  SearchResultAppointmentVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/04.
//

import Foundation

class SearchResultAppointmentVM {

    private let network: Network = Network()
    weak var delegate: SearchResultAppointmentDelegate?

    private var nextPage = 0
    var isLast = false

    func getAppointmentList(searchWord: String, selectedTime: (String, String)?, onlyEnterable: Bool, searchType: SearchCategory) {
        if isLast { return }
        network.getSearchAppointmentListRequest(searchWord: searchWord, selectedTime: selectedTime, onlyEnterable: onlyEnterable, category: .all, page: nextPage) { [weak self] result in
            switch result {
            case .success(let appointmentList):
                guard let appointmentList = appointmentList else {
                    return
                }
                self?.nextPage += 1
                self?.isLast = appointmentList.last
                self?.delegate?.didGetAppointments(appointmentList.content)
            case .failure:
                break
            }
        }

    }

    func setToInit() {
        nextPage = 0
        isLast = false
    }

}

protocol SearchResultAppointmentDelegate: AnyObject {
    func didGetAppointments(_ appointments: [AppointmentSimpleModel])
}

enum SearchCategory: String {
    case all
    case title
    case content
    case place
}
