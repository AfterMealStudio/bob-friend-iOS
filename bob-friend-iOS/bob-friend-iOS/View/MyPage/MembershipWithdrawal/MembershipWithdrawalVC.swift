//
//  MembershipWithdrawalVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2022/01/18.
//

import UIKit

class MembershipWithdrawalVC: UIViewController {

    private let passwordTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.borderStyle = .roundedRect
        $0.placeholder = "비밀번호를 입력해주세요"
        return $0
    }(UITextField())

    private let membershipWithdrawalVM = MembershipWithdrawalVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        membershipWithdrawalVM.delegate = self

        // set default UI
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "회원탈퇴"

        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = UIColor(named: "MainColor1")
        navigationAppearance.titleTextAttributes =  [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationAppearance

        // navigation button
        let withdrawalButton: UIBarButtonItem = UIBarButtonItem(title: "탈퇴하기", style: .plain, target: self, action: #selector(didWithdrawalButtonClicked))
        navigationItem.rightBarButtonItem = withdrawalButton

        layout()
    }

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        let passwordLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "비밀번호"
            $0.textColor = .gray
            $0.font = UIFont.systemFont(ofSize: 12)
            return $0
        }(UILabel())

        view.addSubview(passwordLabel)
        NSLayoutConstraint.activate([
            passwordLabel.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 15),
            passwordLabel.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15)
        ])

        view.addSubview(passwordTextField)
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: passwordLabel.leadingAnchor),
            passwordTextField.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 30)
        ])

    }

    @objc
    func didWithdrawalButtonClicked() {
        membershipWithdrawalVM.password = passwordTextField.text
        membershipWithdrawalVM.withdrawal()
    }

}

extension MembershipWithdrawalVC: MembershipWithdrawalProtocol {
    func didNotFilledPassword() {
        let alertContrller = UIAlertController(title: "비밀번호 미입력", message: "회원탈퇴를 위해서는 비밀번호를 입력해주세요.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertContrller.addAction(okButton)
        present(alertContrller, animated: true, completion: nil)
    }

    func didWithdrawalAccount() {
        let alertContrller = UIAlertController(title: "탈퇴 완료", message: "회원탈퇴가 이루어졌습니다.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.tabBarController?.dismiss(animated: true, completion: nil)
        }
        alertContrller.addAction(okButton)
        present(alertContrller, animated: true, completion: nil)
    }

    func didFailWithdrawalAccount() {
        let alertContrller = UIAlertController(title: "탈퇴 실패", message: "회원탈퇴에 실패하였습니다.", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertContrller.addAction(okButton)
        present(alertContrller, animated: true, completion: nil)
    }
}
