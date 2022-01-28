//
//  LoadingView.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/17.
//

import UIKit

class LoadingView: UIView {

    private let indicatorView: UIActivityIndicatorView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIActivityIndicatorView())

    init() {
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 0xFF, green: 0xFF, blue: 0xFF, a: 0xDD)

        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {

        addSubview(indicatorView)
        NSLayoutConstraint.activate([
            indicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

    func startLoadingAnimation() {
        indicatorView.startAnimating()
    }

    func stopLoadingAnimation() {
        indicatorView.stopAnimating()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
