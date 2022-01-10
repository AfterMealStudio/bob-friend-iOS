//
//  SearchResultAppointmentVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/04.
//

import Foundation

class SearchResultAppointmentVM: AppointmentListVM {

    var searchWord: String = ""
    var selectedTime: (String, String)?
    var searchType: SearchCategory = .all
    var onlyEnterable: Bool = false

    override func getAppointmentList() {
        if isLast { return }

        appointmentRepository.getSearchAppointments(searchWord: searchWord, selectedTime: selectedTime, onlyEnterable: onlyEnterable, searchType: searchType, page: nextPage) { [weak self] result in
            switch result {
            case .success(let appointments):
                self?.didGetAppointments(appointments: appointments)
            case .failure:
                break
            }

        }
    }

}

enum SearchCategory: String {
    case all
    case title
    case content
    case place
}
