//
//  CALayer+Border.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/27.
//

import UIKit

extension UIView {

    func addBorder(_ arrEdge: UIRectEdge = .bottom, color: UIColor = .lightGray, width: CGFloat = 1.2) {

        if arrEdge.contains(.bottom) {
            let borderView = generateView(color: color)
            addSubview(borderView)

            NSLayoutConstraint.activate([
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                borderView.leftAnchor.constraint(equalTo: leftAnchor),
                borderView.rightAnchor.constraint(equalTo: rightAnchor),
                borderView.heightAnchor.constraint(equalToConstant: width)
            ])
        }

        if arrEdge.contains(.left) {
            let borderView = generateView(color: color)
            addSubview(borderView)

            NSLayoutConstraint.activate([
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                borderView.leftAnchor.constraint(equalTo: leftAnchor),//
                borderView.topAnchor.constraint(equalTo: topAnchor),
                borderView.widthAnchor.constraint(equalToConstant: width)
            ])
        }

        if arrEdge.contains(.right) {
            let borderView = generateView(color: color)
            addSubview(borderView)

            NSLayoutConstraint.activate([
                borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
                borderView.topAnchor.constraint(equalTo: topAnchor),
                borderView.rightAnchor.constraint(equalTo: rightAnchor),
                borderView.widthAnchor.constraint(equalToConstant: width)
            ])
        }

        if arrEdge.contains(.top) {
            let borderView = generateView(color: color)
            addSubview(borderView)

            NSLayoutConstraint.activate([
                borderView.topAnchor.constraint(equalTo: topAnchor),
                borderView.leftAnchor.constraint(equalTo: leftAnchor),
                borderView.rightAnchor.constraint(equalTo: rightAnchor),
                borderView.heightAnchor.constraint(equalToConstant: width)
            ])
        }

    }

    private func generateView(color: UIColor = .lightGray) -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = color

        return view
    }

    
}
