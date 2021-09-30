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

    private let emailTextField: SignUpTextField = {
        $0.title = "이메일 주소"
        $0.placeholder = "이메일 주소"
        return $0
    }(SignUpTextField(hasCheckButton: true))

    private let nicknameTextField: SignUpTextField = {
        $0.title = "닉네임"
        $0.placeholder = "닉네임"
        return $0
    }(SignUpTextField(hasCheckButton: true))

    private let passwordTextField: SignUpTextField = {
        $0.title = "비밀번호"
        $0.placeholder = "비밀번호"
        return $0
    }(SignUpTextField())

    private let passwordCheckTextField: SignUpTextField = {
        $0.title = "비밀번호 확인"
        $0.placeholder = "비밀번호 확인"
        return $0
    }(SignUpTextField())

    private let birthTextField: SignUpTextField = {
        $0.title = "생년월일"
        $0.placeholder = "ex)1990-01-01"
        return $0
    }(SignUpTextField())

    private let genderView: SignUpGenderSelectView = {
        $0.title = "성별"
        $0.gender = .male
        return $0
    }(SignUpGenderSelectView())

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

    var signUpVM: SignUpVM = SignUpVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        signUpVM.delegate = self

        // layout
        configureLayout()

        // keyboard
        enrollKeyboardNotification()
        enrollRemoveKeyboard()

        // configure action
        emailTextField.checkAction = { [weak self] in
            guard let email = self?.emailTextField.text, email.isEmpty == false else {
                self?.signUpNoticeHandeler(.blankEmail)
                return
            }
            self?.signUpVM.checkEmail(email: email)
        }

        nicknameTextField.checkAction = { [weak self] in
            guard let nickname = self?.nicknameTextField.text, nickname.isEmpty == false else {
                self?.signUpNoticeHandeler(.blankNickname)
                return
            }
            self?.signUpVM.checkNickname(nickname: nickname)
        }

        emailTextField.textChanged = { [weak self] in self?.signUpVM.resetEmail() }

    }

}

// MARK: - VM delegate

extension SignUpVC: SignUpDelegate {

    func showNotice(_ notice: SignUpNotice) {
        signUpNoticeHandeler(notice)
    }

    // 회원가입에 성공했는가
    func didSuccessSignUp(_ didSuccess: Bool) {
        switch didSuccess {
        case true:
            let alertController = UIAlertController(title: "회원가입에 성공하였습니다", message: nil, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                self?.dismiss(animated: true) { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }

            alertController.addAction(okBtn)

            DispatchQueue.main.async {
                [weak self] in
                self?.present(alertController, animated: true, completion: nil)
            }

        case false:
            let alertController = UIAlertController(title: "회원가입에 실패하였습니다", message: nil, preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
                self?.dismiss(animated: true, completion: nil)
            }

            alertController.addAction(okBtn)

            DispatchQueue.main.async {
                [weak self] in
                self?.present(alertController, animated: true, completion: nil)
            }

        }
    }

    // 오류 발생
    func occuredNetworkError() {}

}

// MARK: 추가 NoticeLabel 조작사항

extension SignUpVC {

    func signUpNoticeHandeler(_ signUpNotice: SignUpNotice) {
        switch signUpNotice {
        // emailNotice
        case .blankEmail, .notEmailForm, .duplicateEmail, .validEmail, .notCheckedEmail, .checkedEmail:
            emailTextField.showNoticeMessage(signUpNotice.message, isValidate: signUpNotice.isValidate)
        // nicknameNotice
        case .blankNickname, .duplicateNickname, .validNickname, .notCheckedNickname, .checkedNickname:
            nicknameTextField.showNoticeMessage(signUpNotice.message, isValidate: signUpNotice.isValidate)
        // passwordNotice
        case .invalidPassword, .validPassword:
            passwordTextField.showNoticeMessage(signUpNotice.message, isValidate: signUpNotice.isValidate)
        // passwordCheckNotice
        case .notSamePasswordAndPasswordCheck, .samePasswordAndPasswordCheck:
            passwordCheckTextField.showNoticeMessage(signUpNotice.message, isValidate: signUpNotice.isValidate)
        // birthNotice
        case .notBirthdayForm, .validBrith:
            birthTextField.showNoticeMessage(signUpNotice.message, isValidate: signUpNotice.isValidate)
        }
    }
}

// MARK: - button event

extension SignUpVC {

    @objc
    func finishButtonClicked() {
        let gender = genderView.gender
        signUpVM.signUp(email: emailTextField.text ?? "",
                        nickname: nicknameTextField.text ?? "",
                        password: passwordTextField.text ?? "",
                        passwordCheck: passwordCheckTextField.text ?? "",
                        birth: birthTextField.text ?? "",
                        gender: gender,
                        agree: true)
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

        // MARK: - 이메일 / 닉네임 / 비밀번호 / 비밀번호 확인 / 생년월일

        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(nicknameTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordCheckTextField)
        stackView.addArrangedSubview(birthTextField)

        // MARK: - 성별

        stackView.addArrangedSubview(genderView)

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
