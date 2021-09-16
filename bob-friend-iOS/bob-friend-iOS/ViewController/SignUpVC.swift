//
//  SignUpVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/09/13.
//

import UIKit

class SignUpVC: UIViewController {

    private let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIScrollView())

    private var scrollViewContentLayoutBottomConstraint: NSLayoutConstraint?

    private let emailTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "이메일 주소"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.addBorder()
        return $0
    }(UITextField())

    private let emailCheckButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "MainColor1")
        $0.layer.cornerRadius = 5

        $0.addTarget(self, action: #selector(emailCheckButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let usernameTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "username"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.addBorder()
        return $0
    }(UITextField())

    private let usernameCheckButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "MainColor1")
        $0.layer.cornerRadius = 5

        $0.addTarget(self, action: #selector(usernameCheckButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let nicknameTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "닉네임"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.addBorder()
        return $0
    }(UITextField())

    private let nicknameCheckButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "MainColor1")
        $0.layer.cornerRadius = 5

        $0.addTarget(self, action: #selector(nicknameCheckButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let passwordTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "비밀번호"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.addBorder()
        return $0
    }(UITextField())

    private let passwordCheckTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "비밀번호 확인"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.addBorder()
        return $0
    }(UITextField())

    private let birthTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "ex)1990-01-01"
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.addBorder()
        return $0
    }(UITextField())

    private let maleButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        $0.tintColor = UIColor(named: "MainColor1")
        $0.isEnabled = true

        $0.addTarget(self, action: #selector(maleButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let femaleButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        $0.tintColor = UIColor(named: "MainColor1")
        $0.isEnabled = true

        $0.addTarget(self, action: #selector(femaleButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let finishButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("가입하기", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.red, for: .highlighted)
        $0.backgroundColor = UIColor(named: "MainColor1")
        $0.layer.cornerRadius = 5

        $0.addTarget(self, action: #selector(finishButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    override func viewDidLoad() {
        super.viewDidLoad()

        // layout
        configureLayout()

        // keyboard
        enrollKeyboardNotification()
        enrollRemoveKeyboard()
    }

}

// MARK: - button event

extension SignUpVC {

    @objc
    func emailCheckButtonClicked() {
        print("email check click")
    }

    @objc
    func usernameCheckButtonClicked() {
        print("username check click")
    }

    @objc
    func nicknameCheckButtonClicked() {
        print("nickname check click")
    }

    @objc
    func maleButtonClicked() {
        print("male click")
        maleButton.isSelected = true
        femaleButton.isSelected = false
    }

    @objc
    func femaleButtonClicked() {
        print("female click")
        femaleButton.isSelected = true
        maleButton.isSelected = false

    }

    @objc
    func finishButtonClicked() {
        print("finish click")
    }

}

// MARK: - layout

extension SignUpVC {

    func configureLayout() {
        view.backgroundColor = .white

        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
        ])

        let scrollStackView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = 15
            return $0
        }(UIStackView())

        scrollView.addSubview(scrollStackView)

        scrollViewContentLayoutBottomConstraint = scrollView.contentLayoutGuide.bottomAnchor.constraint(equalTo: scrollStackView.bottomAnchor)

        if let scrollViewContentLayoutBottomConstraint = scrollViewContentLayoutBottomConstraint {
            NSLayoutConstraint.activate([
                scrollStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
                scrollViewContentLayoutBottomConstraint,
                scrollStackView.leftAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leftAnchor),
                scrollStackView.rightAnchor.constraint(equalTo: scrollView.frameLayoutGuide.rightAnchor)
            ])
        }

        addSubViewsToStack(scrollStackView)

    }

    func addSubViewsToStack(_ stackView: UIStackView) {

        // MARK: - 회원가입 타이틀

        let titleLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "회원가입"
            $0.textAlignment = .center
            $0.font = UIFont.boldSystemFont(ofSize: 30)
            $0.textColor = UIColor(named: "MainColor1")
            return $0
        }(UILabel())

        stackView.addArrangedSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.heightAnchor.constraint(equalToConstant: 80),
            titleLabel.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            titleLabel.rightAnchor.constraint(equalTo: stackView.rightAnchor)
        ])

        // MARK: - 이메일 / username / 닉네임 / 비밀번호 / 비밀번호 확인 / 생년월일

        let stackFactorList: [(String, UITextField, UIButton?)] = [
            ("이메일 주소", emailTextField, emailCheckButton),
            ("username", usernameTextField, usernameCheckButton),
            ("닉네임", nicknameTextField, nicknameCheckButton),
            ("비밀번호", passwordTextField, nil),
            ("비밀번호 확인", passwordCheckTextField, nil),
            ("생년월일", birthTextField, nil)
        ]

        for i in 0..<stackFactorList.count {
            let str = stackFactorList[i].0
            let textField = stackFactorList[i].1
            let checkButton = stackFactorList[i].2

            let sectionView: UIView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                return $0
            }(UIView())

            stackView.addArrangedSubview(sectionView)

            let sectionLabel: UILabel = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.font = UIFont.systemFont(ofSize: 15)
                $0.text = str
                return $0
            }(UILabel())

            sectionView.addSubview(sectionLabel)
            NSLayoutConstraint.activate([
                sectionLabel.topAnchor.constraint(equalTo: sectionView.topAnchor),
                sectionLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 30),
                sectionLabel.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -30)
            ])

            sectionView.addSubview(textField)
            NSLayoutConstraint.activate([
                textField.topAnchor.constraint(equalTo: sectionLabel.bottomAnchor, constant: 5),
                textField.bottomAnchor.constraint(equalTo: sectionView.bottomAnchor),
                textField.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 30),
                textField.heightAnchor.constraint(equalToConstant: 30)
            ])

            if let checkButton = checkButton {
                sectionView.addSubview(checkButton)
                NSLayoutConstraint.activate([
                    checkButton.widthAnchor.constraint(equalToConstant: 80),
                    checkButton.topAnchor.constraint(equalTo: textField.topAnchor),
                    checkButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
                    checkButton.leftAnchor.constraint(equalTo: textField.rightAnchor, constant: 10),
                    checkButton.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -30)
                ])
            } else {
                textField.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: -30).isActive = true
            }

        }

        // MARK: - 성별

        let genderView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIView())

        stackView.addArrangedSubview(genderView)
        NSLayoutConstraint.activate([
            genderView.heightAnchor.constraint(equalToConstant: 50)
        ])

        let genderLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.text = "성별"
            return $0
        }(UILabel())

        genderView.addSubview(genderLabel)
        NSLayoutConstraint.activate([
            genderLabel.topAnchor.constraint(equalTo: genderView.topAnchor),
            genderLabel.leftAnchor.constraint(equalTo: genderView.leftAnchor, constant: 30),
            genderLabel.rightAnchor.constraint(equalTo: genderView.rightAnchor, constant: -30)
        ])

        let genderSubView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fillProportionally
            return $0
        }(UIStackView())

        genderView.addSubview(genderSubView)
        NSLayoutConstraint.activate([
            genderSubView.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 5),
            genderSubView.leftAnchor.constraint(equalTo: genderView.leftAnchor, constant: 30),
            genderSubView.rightAnchor.constraint(equalTo: genderView.rightAnchor, constant: -30)
        ])

        for i in 0..<2 {
            let genderInfo = [(maleButton, "남자"), (femaleButton, "여자")]
            let btn = genderInfo[i].0
            let str = genderInfo[i].1

            let contentView: UIView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                return $0
            }(UIView())

            genderSubView.addArrangedSubview(contentView)

            contentView.heightAnchor.constraint(equalToConstant: 30).isActive = true

            contentView.addSubview(btn)
            view.bringSubviewToFront(btn)
            NSLayoutConstraint.activate([
                btn.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
                btn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                btn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])

            let contentLabel: UILabel = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = str
                return $0
            }(UILabel())
            contentView.addSubview(contentLabel)
            NSLayoutConstraint.activate([
                contentLabel.leftAnchor.constraint(equalTo: btn.rightAnchor, constant: 10),
                contentLabel.centerYAnchor.constraint(equalTo: btn.centerYAnchor)
            ])

        }

        // MARK: - 가입하기 버튼

        if let lastView = stackView.arrangedSubviews.last {
            stackView.setCustomSpacing(15+50, after: lastView)
        }

        stackView.addArrangedSubview(finishButton)
        NSLayoutConstraint.activate([
            finishButton.leftAnchor.constraint(equalTo: stackView.leftAnchor, constant: 30),
            finishButton.rightAnchor.constraint(equalTo: stackView.rightAnchor, constant: -30),
            finishButton.heightAnchor.constraint(equalToConstant: 40)
        ])

    }

}

// MARK: - keyboard event

extension SignUpVC {

    private func enrollKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardWillShow(_ sender: Notification) {

        if let scrollViewContentLayoutBottomConstraint = scrollViewContentLayoutBottomConstraint, scrollViewContentLayoutBottomConstraint.constant == 0 {
            guard let userInfo = sender.userInfo,
                  let keyboardFrame: NSValue = userInfo[ UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            scrollViewContentLayoutBottomConstraint.constant += keyboardHeight
        }

    }

    @objc
    private func keyboardWillHide(_ sender: Notification) {

        if let scrollViewContentLayoutBottomConstraint = scrollViewContentLayoutBottomConstraint, scrollViewContentLayoutBottomConstraint.constant != 0 {
            guard let userInfo = sender.userInfo,
                  let keyboardFrame: NSValue = userInfo[ UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            scrollViewContentLayoutBottomConstraint.constant -= keyboardHeight
        }

    }

    private func removeKeyboard() {
        view.endEditing(true)
    }

    private func enrollRemoveKeyboard() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOtherMethod))
        scrollView.addGestureRecognizer(singleTapGestureRecognizer)

    }

    @objc
    private func tapOtherMethod(sender: UITapGestureRecognizer) {
        removeKeyboard()
    }

}

// MARK: - use Canvas
#if DEBUG
import SwiftUI

struct SignUpVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = SignUpVC

    func makeUIViewController(context: Context) -> SignUpVC {
        return SignUpVC()
    }

    func updateUIViewController(_ uiViewController: SignUpVC, context: Context) {

    }

}

@available(iOS 13.0.0, *)
struct ViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpVCRepresentable()
                .previewDevice("iPhone 11 Pro")
        }
    }
}
#endif
