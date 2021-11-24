//
//  AppointmentListVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/27.
//

import Foundation

class AppointmentListVM {

    private let network: Network = Network()
    weak var delegate: AppointmentListDelegate?

    private var nextPage = 0
    var isLast = false

    func getAppointmentList() {
        if isLast { return }
        network.getAppointmentListRequest(page: nextPage) { [weak self] result in
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

protocol AppointmentListDelegate: AnyObject {
    func didGetAppointments(_ appointments: [AppointmentSimpleModel])
}
