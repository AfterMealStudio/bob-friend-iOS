//
//  AppointmentVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/09.
//

import Foundation

class AppointmentVM {

    private let network: Network = Network()
    weak var delegate: AppointmentDelegate?

    func enrollComment(appointmentID: Int, content: String) {
        let enrollCommentModel: EnrollCommentModel = EnrollCommentModel(content: content)
        network.enrollCommentRequest(appointmentID: appointmentID, comment: enrollCommentModel) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didEnrollComment()
            case .failure:
                break
            }
        }
    }

}

protocol AppointmentDelegate: AnyObject {
    func didEnrollComment()
}
