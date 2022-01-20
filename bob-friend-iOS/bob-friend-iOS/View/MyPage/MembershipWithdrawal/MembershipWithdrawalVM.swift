//
//  MembershipWithdrawalVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2022/01/18.
//

import Foundation

class MembershipWithdrawalVM {
    let userRepository: UserRepository = UserRepositoryImpl()

    weak var delegate: MembershipWithdrawalProtocol?
    var password: String? = ""

    func withdrawal() {
        if password == "" || password == nil {
            delegate?.didNotFilledPassword()
            return
        }
        guard let password = password else { return }
        userRepository.withdrawalMembership(password: password) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didWithdrawalAccount()
            case .failure:
                self?.delegate?.didFailWithdrawalAccount()
            }
        }

    }

}

protocol MembershipWithdrawalProtocol: AnyObject {
    func didNotFilledPassword()

    func didWithdrawalAccount()
    func didFailWithdrawalAccount()
}
