//
//  SearchResultAppointmentVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/04.
//

import Foundation

class SearchResultAppointmentVM {

    private let appointmentRepository: AppointmentRepository = AppointmentRepositoryImpl()

    weak var delegate: SearchResultAppointmentDelegate?

    var searchWord: String = ""
    var selectedTime: (String, String)?
    var searchType: SearchCategory = .all
    var onlyEnterable: Bool = false

    private var nextPage = 0
    var isLast = false

    func getAppointmentList() {
        if isLast { return }

        appointmentRepository.getSearchAppointments(searchWord: searchWord, selectedTime: selectedTime, onlyEnterable: onlyEnterable, searchType: searchType, page: nextPage) { [weak self] result in
            switch result {
            case .success(let appointmentList):
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
