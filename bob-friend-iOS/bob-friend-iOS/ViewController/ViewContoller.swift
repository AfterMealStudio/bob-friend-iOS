//
//  ViewContoller.swift
//  bob-friend-iOS
//
//  Created by sh.hong on 2021/09/03.
//

import UIKit

final class ViewContoller: UIViewController {

    private let button: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("로그인 페이지 이동", for: .normal)
        $0.setTitleColor(.blue, for: .normal)
        return $0
    }(UIButton())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])

        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
    }

    @objc
    private func tapButton(_ button: UIButton) {
        present(LoginVC(), animated: true)
    }
}
