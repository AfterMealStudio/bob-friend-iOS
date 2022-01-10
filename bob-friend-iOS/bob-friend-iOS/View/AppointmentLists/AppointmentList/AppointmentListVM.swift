//
//  AppointmentListVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/27.
//

import Foundation

class AppointmentListVM {

    let appointmentRepository: AppointmentRepository = AppointmentRepositoryImpl()

    weak var delegate: AppointmentListDelegate?

    var nextPage = 0
    var isLast = false

    func getAppointmentList() {
        if isLast { return }

        appointmentRepository.getAllAppointments(page: nextPage, type: .all) { [weak self] result in
            switch result {
            case .success(let appointments):
                self?.didGetAppointments(appointments: appointments)
            case .failure:
                break
            }
        }

    }

    func didGetAppointments(appointments: AppointmentListModel) {
        nextPage += 1
        isLast = appointments.last
        delegate?.didGetAppointments(appointments.content)
    }

    func setToInit() {
        nextPage = 0
        isLast = false
    }

}

protocol AppointmentListDelegate: AnyObject {
    func didGetAppointments(_ appointments: [AppointmentSimpleModel])
}
