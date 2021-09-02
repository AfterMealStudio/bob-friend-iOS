//
//  CALayer+Border.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/27.
//

import UIKit

extension CALayer {
    
    func addBorder(_ arrEdge: UIRectEdge = .bottom, color: UIColor = .lightGray, width: CGFloat = 1.2) {
        let border = CALayer()
        switch arrEdge {
        case .top:
            border.frame = CGRect(x: .zero, y: .zero, width: frame.width, height: width)
        case .bottom:
            border.frame = CGRect(x: .zero, y: frame.height - width, width: frame.width, height: width)
        case .left:
            border.frame = CGRect(x: .zero, y: .zero, width: width, height: frame.height)
        case .right:
            border.frame = CGRect(x: frame.width - width, y: .zero, width: width, height: frame.height)
        default:
            break
        }
    }
}
