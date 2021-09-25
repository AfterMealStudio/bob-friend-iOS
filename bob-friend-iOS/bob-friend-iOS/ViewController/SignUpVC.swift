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

    private let emailCheckTextField: SignUpTextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "이메일 주소"
        $0.title = "이메일 주소"
        return $0
    }(SignUpTextField())

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

    private let nicknameNoticeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 10)

        $0.textColor = .red
        $0.isHidden = true

        return $0
    }(UILabel())

    private let passwordTextField: SignUpTextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "비밀번호"
        $0.title = "비밀번호"
        return $0
    }(SignUpTextField())

    private let passwordCheckTextField: SignUpTextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "비밀번호 확인"
        $0.title = "비밀번호 확인"
        return $0
    }(SignUpTextField())

    private let birthTextField: SignUpTextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "ex)1990-01-01"
        $0.title = "생년월일"
        return $0
    }(SignUpTextField())

    private let genderNoticeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 10)

        $0.textColor = .red
        $0.isHidden = true

        return $0
    }(UILabel())

    private let maleButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        $0.tintColor = UIColor(named: "MainColor1")
        $0.isEnabled = true
        $0.isSelected = true

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
        emailCheckTextField.isHidden = false
        emailCheckTextField.noticeMessage("이메일 형식에 맞게 써 주세요.")
    }

    // 이메일 중복인가
    func emailDidDuplicate(_ didDuplicate: Bool) {
//        switch didDuplicate {
//        case true:
//            emailNoticeLabel.isHidden = false
//            emailNoticeLabel.textColor = .red
//            emailNoticeLabel.text = "중복된 이메일입니다."
//        case false:
//            emailNoticeLabel.isHidden = false
//            emailNoticeLabel.textColor = .blue
//            emailNoticeLabel.text = "사용 가능한 이메일입니다."
//        }
    }

    // 닉네임 중복인가
    func nicknameDidDuplicate(_ didDuplicate: Bool) {
        switch didDuplicate {
        case true:
            nicknameNoticeLabel.isHidden = false
            nicknameNoticeLabel.textColor = .red
            nicknameNoticeLabel.text = "중복된 닉네임입니다."
        case false:
            nicknameNoticeLabel.isHidden = false
            nicknameNoticeLabel.textColor = .blue
            nicknameNoticeLabel.text = "사용 가능한 닉네임입니다."
        }
    }

    // 중복검사를 받은 이메일인가
    func emailDidCheckForSignUp(_ didChecked: Bool) {
//        switch didChecked {
//        case true:
//            emailNoticeLabel.isHidden = true
//            break
//        case false:
//            emailNoticeLabel.isHidden = false
//            emailNoticeLabel.textColor = .red
//            emailNoticeLabel.text = "이메일 중복검사를 받으세요."
//        }
    }

    // 중복검사를 받은 닉네임인가
    func nicknameDidCheckForSignUp(_ didChecked: Bool) {
        switch didChecked {
        case true:
            nicknameNoticeLabel.isHidden = false
            break
        case false:
            nicknameNoticeLabel.isHidden = false
            nicknameNoticeLabel.textColor = .red
            nicknameNoticeLabel.text = "닉네임 중복검사를 받으세요."
        }
    }

    // 비밀번호가 적합한가
    func passwordValidataionDidCheckForSignUp(_ isValid: Bool) {
//        switch isValid {
//        case true:
//            passwordNoticeLabel.isHidden = true
//            break
//        case false:
//            passwordNoticeLabel.isHidden = false
//            passwordNoticeLabel.textColor = .red
//            passwordNoticeLabel.text = "영어, 숫자, 특수문자(!@#$%)를 포함하여 8자 이상이어야 합니다."
//        }
    }

    // 비밀번호 확인이 비밀번호와 같은가
    func passwordDidCheckSameForSignUp(_ isSamePasswordAndPasswordCheck: Bool) {
//        switch isSamePasswordAndPasswordCheck {
//        case true:
//            passwordCheckNoticeLabel.isHidden = false
//            break
//        case false:
//            passwordCheckNoticeLabel.isHidden = false
//            passwordCheckNoticeLabel.textColor = .red
//            passwordCheckNoticeLabel.text = "비밀번호와 다릅니다."
//
//        }
    }

    // 생일이 지정된 형식으로 작성되었는가
    func birthValidationDidCheckForSignUp(_ isValid: Bool) {
//        switch isValid {
//        case true:
//            birthNoticeLabel.isHidden = true
//            break
//        case false:
//            birthNoticeLabel.isHidden = false
//            birthNoticeLabel.textColor = .red
//            birthNoticeLabel.text = "yyyyMMdd의 형식으로 올바른 날짜를 입력해주세요. ex) 19900101"
//        }
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
//        emailNoticeLabel.isHidden = false
//        emailNoticeLabel.textColor = .red
//        emailNoticeLabel.text = "이메일을 입력해주세요."
    }

    func nicknameNotFillIn() {
        nicknameNoticeLabel.isHidden = false
        nicknameNoticeLabel.textColor = .red
        nicknameNoticeLabel.text = "닉네임을 입력해주세요."
    }

    func passwordNotFillIn() {
//        passwordNoticeLabel.isHidden = false
//        passwordNoticeLabel.textColor = .red
//        passwordNoticeLabel.text = "비밀번호를 입력해주세요."
    }
}

// MARK: - button event

extension SignUpVC {

    @objc
    func emailCheckButtonClicked() {
        if let email = emailCheckTextField.text {
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
    func maleButtonClicked() {
        maleButton.isSelected = true
        femaleButton.isSelected = false
    }

    @objc
    func femaleButtonClicked() {
        femaleButton.isSelected = true
        maleButton.isSelected = false

    }

    @objc
    func finishButtonClicked() {
        let gender: Gender = maleButton.isSelected == true ? .male : .female
        signUpVM.signUp(email: emailCheckTextField.text ?? "",
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

        stackView.addArrangedSubview(emailCheckTextField)

        let stackFactorList: [(String, UITextField, UIButton?, UILabel)] = [
            ("닉네임", nicknameTextField, nicknameCheckButton, nicknameNoticeLabel)
        ]

        for i in 0..<stackFactorList.count {
            let str = stackFactorList[i].0
            let textField = stackFactorList[i].1
            let checkButton = stackFactorList[i].2
            let noticeLabel = stackFactorList[i].3

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

            sectionView.addSubview(noticeLabel)
            noticeLabel.isHidden = true
            NSLayoutConstraint.activate([
                noticeLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
                noticeLabel.leftAnchor.constraint(equalTo: sectionView.leftAnchor, constant: 30),
                noticeLabel.rightAnchor.constraint(equalTo: sectionView.rightAnchor, constant: 30)
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

        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(passwordCheckTextField)
        stackView.addArrangedSubview(birthTextField)

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
