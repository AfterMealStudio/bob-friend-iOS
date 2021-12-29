//
//  SearchResultAppointmentVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/02.
//

import UIKit

class SearchResultAppointmentVC: AppointmentListVC {

    init(searchWord: String, selectedTime: (String, String)?, searchType: SearchCategory, onlyEnterable: Bool) {

        super.init()
        appointmentListVM = SearchResultAppointmentVM()

        guard let appointmentListVM = appointmentListVM as? SearchResultAppointmentVM else { return }

        appointmentListVM.searchWord = searchWord
        appointmentListVM.selectedTime = selectedTime
        appointmentListVM.searchType = searchType
        appointmentListVM.onlyEnterable = onlyEnterable

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - SearchBarView Delegate
extension SearchResultAppointmentVC {

    override func didBeginEditing() {
        view.endEditing(true)
        navigationController?.popViewController(animated: true)
    }

}
