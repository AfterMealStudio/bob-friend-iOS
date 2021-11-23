//
//  WriteAppointmentVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/23.
//

import Foundation

class WriteAppointmentVM {
    let network: Network = Network()
    weak var delegate: WriteAppointmentDelegate?

    func enrollAppointment(appointment: AppointmentEnrollModel) {

        network.enrollAppointment(appointment: appointment) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didEnrollAppointment()
            case .failure:
                break
            }
        }

    }

}

protocol WriteAppointmentDelegate: AnyObject {
    func didEnrollAppointment()
}
