//
//  LoginProtocol.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import Foundation

// @objc를 왜 붙여야 하는지, 이유가 없다면 뺴도 되지 않을까?
@objc protocol Login {
    func didSuccessLogin(_ notification: NSNotification) -> Void
    func didFailLogin(_ notification: NSNotification) -> Void
}
