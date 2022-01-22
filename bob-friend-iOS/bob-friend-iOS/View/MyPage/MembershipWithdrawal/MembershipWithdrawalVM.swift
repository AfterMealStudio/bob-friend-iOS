//
//  MembershipWithdrawalVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2022/01/18.
//

import Foundation
import Alamofire

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

protocol APIpro {
    var path: String { get }
    var method: HTTPMethod { get }
}

enum testAPI: APIpro {
    case hey

    var path: String {
        switch self {
        case .hey:
            return "api/"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .hey:
            return .get
        }
    }

}

let b: () -> Void = {
    let a = testAPI.hey
    a.method
    a.path
}
