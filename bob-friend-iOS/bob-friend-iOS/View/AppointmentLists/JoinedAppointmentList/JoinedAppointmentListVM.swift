//
//  JoinedAppointmentListVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2022/01/10.
//

import Foundation

class JoinedAppointmentListVM: AppointmentListVM {

    override func getAppointmentList() {
        if isLast { return }

        appointmentRepository.getAllAppointments(page: nextPage, type: .joined) { [weak self] result in
            switch result {
            case .success(let appointments):
                self?.didGetAppointments(appointments: appointments)
            case .failure:
                break
            }
        }

    }

}
