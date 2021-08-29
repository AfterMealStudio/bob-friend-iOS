//
//  LoginProtocol.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import Foundation

@objc protocol Login {
    func didSuccessLogin(_ notification: NSNotification) -> Void
    
    func didFailLogin(_ notification: NSNotification) -> Void
}
