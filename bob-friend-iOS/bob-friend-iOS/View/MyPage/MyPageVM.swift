//
//  MyPageVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/16.
//

import Foundation

class MyPageVM {

    weak var delegate: MyPageDelegate?
    let network: Network = Network()

    func getMyProfile() {
        delegate?.startLoading()
        network.getUserInfoRequest { [weak self] result in
            self?.delegate?.stopLoading()
            switch result {
            case .success(let userInfo):
                if let userInfo = userInfo {
                    self?.delegate?.didGetUserInfo(userInfo: userInfo)
                }
            case .failure:
                break
            }

        }
    }

}

protocol MyPageDelegate: AnyObject {
    func startLoading()
    func stopLoading()

    func didGetUserInfo(userInfo: UserInfoModel)
}
