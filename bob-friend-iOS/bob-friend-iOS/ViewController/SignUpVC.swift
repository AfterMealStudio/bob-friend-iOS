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
        $0.configure(hasDuplicationCheckButton: true)
        $0.title = "이메일 주소"
        $0.placeholder = "이메일 주소"
        $0.addTargetToDuplicationCheckButton(action: #selector(emailCheckButtonClicked))
        return $0
    }(SignUpTextField())

    private let nicknameTextField: SignUpTextField = {
        $0.configure(hasDuplicationCheckButton: true)
        $0.title = "닉네임"
        $0.placeholder = "닉네임"
        $0.addTargetToDuplicationCheckButton(action: #selector(nicknameCheckButtonClicked))
        return $0
    }(SignUpTextField())

    private let passwordTextField: SignUpTextField = {
        $0.configure(hasDuplicationCheckButton: false)
        $0.title = "비밀번호"
        $0.placeholder = "비밀번호"
        return $0
    }(SignUpTextField())

    private let passwordCheckTextField: SignUpTextField = {
        $0.configure(hasDuplicationCheckButton: false)
        $0.title = "비밀번호 확인"
        $0.placeholder = "비밀번호 확인"
        return $0
    }(SignUpTextField())

    private let birthTextField: SignUpTextField = {
        $0.configure(hasDuplicationCheckButton: false)
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
    }

}

// MARK: - VM delegate

extension SignUpVC: SignUpDelegate {

    // 이메일 형식에 맞지 않음
    func emailRequireValidForm() {
        emailTextField.notice(msg: "이메일 형식에 맞게 써 주세요.", false)
        emailTextField.showNoticeLabel()
    }

    // 이메일 중복인가
    func emailDidDuplicate(_ didDuplicate: Bool) {
        switch didDuplicate {
        case true:
            emailTextField.notice(msg: "중복된 이메일입니다.", false)
            emailTextField.showNoticeLabel()
        case false:
            emailTextField.notice(msg: "사용 가능한 이메일입니다.", true)
            emailTextField.showNoticeLabel()
        }
    }

    // 닉네임 중복인가
    func nicknameDidDuplicate(_ didDuplicate: Bool) {
        switch didDuplicate {
        case true:
            nicknameTextField.notice(msg: "중복된 닉네임이니다.", false)
            nicknameTextField.showNoticeLabel()
        case false:
            nicknameTextField.notice(msg: "사용 가능한 닉네임입니다.", true)
            nicknameTextField.showNoticeLabel()
        }
    }

    // 중복검사를 받은 이메일인가
    func emailDidCheckForSignUp(_ didChecked: Bool) {
        switch didChecked {
        case true:
            emailTextField.hideNoticeLabel()
        case false:
            emailTextField.notice(msg: "이메일 중복검사를 받으세요.", false)
            emailTextField.showNoticeLabel()
        }
    }

    // 중복검사를 받은 닉네임인가
    func nicknameDidCheckForSignUp(_ didChecked: Bool) {
        switch didChecked {
        case true:
            nicknameTextField.hideNoticeLabel()
        case false:
            nicknameTextField.notice(msg: "닉네임 중복검사를 받으세요.", false)
            nicknameTextField.showNoticeLabel()
        }
    }

    // 비밀번호가 적합한가
    func passwordValidataionDidCheckForSignUp(_ isValid: Bool) {
        switch isValid {
        case true:
            passwordTextField.hideNoticeLabel()
        case false:
            passwordTextField.notice(msg: "영어, 숫자, 특수문자(!@#$%)를 포함하여 8자 이상이어야 합니다.", false)
            passwordTextField.showNoticeLabel()
        }
    }

    // 비밀번호 확인이 비밀번호와 같은가
    func passwordDidCheckSameForSignUp(_ isSamePasswordAndPasswordCheck: Bool) {
        switch isSamePasswordAndPasswordCheck {
        case true:
            passwordCheckTextField.hideNoticeLabel()
        case false:
            passwordCheckTextField.notice(msg: "비밀번호와 다릅니다.", false)
            passwordCheckTextField.showNoticeLabel()
        }
    }

    // 생일이 지정된 형식으로 작성되었는가
    func birthValidationDidCheckForSignUp(_ isValid: Bool) {
        switch isValid {
        case true:
            birthTextField.hideNoticeLabel()
        case false:
            birthTextField.notice(msg: "yyyyMMdd의 형식으로 올바른 날짜를 입력해주세요. ex) 19900101", false)
            birthTextField.showNoticeLabel()
        }
    }

    // 동의했는가
    func agreementDidCheck(_ didAgree: Bool) {

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
    func errorOccured() {
    }

}

// MARK: 추가 NoticeLabel 조작사항

extension SignUpVC {
    func emailNotFillIn() {
        emailTextField.notice(msg: "이메일을 입력해주세요.", false)
        emailTextField.showNoticeLabel()
    }

    func nicknameNotFillIn() {
        nicknameTextField.notice(msg: "닉네임을 입력해주세요.", false)
        nicknameTextField.showNoticeLabel()
    }

    func passwordNotFillIn() {
        passwordTextField.notice(msg: "비밀번호를 입력해주세요.", false)
        passwordTextField.showNoticeLabel()
    }
}

// MARK: - button event

extension SignUpVC {

    @objc
    func emailCheckButtonClicked() {
        if let email = emailTextField.text {
            if email == "" { emailNotFillIn(); return }
            signUpVM.checkEmail(email: email)
        }
    }

    @objc
    func nicknameCheckButtonClicked() {
        if let nickname = nicknameTextField.text {
            if nickname == "" { nicknameNotFillIn(); return }
            signUpVM.checkNickname(nickname: nickname)
        }
    }

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
