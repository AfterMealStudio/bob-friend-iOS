//
//  SignUpTextField.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/09/26.
//

import UIKit

final class SignUpTextField: UIView {

    var title: String = "" {
        didSet { titleLabel.text = title }
    }

    var placeholder: String = "" {
        didSet { textField.placeholder = placeholder }
    }

    var text: String? { textField.text }
    var checkAction: (() -> Void)?
    var textChanged: (() -> Void)?

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UILabel())

    private let textField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 20)
        $0.addBorder()
        return $0
    }(UITextField())

    private let noticeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .red
        $0.isHidden = true
        return $0
    }(UILabel())

    private let checkButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "MainColor1")
        $0.layer.cornerRadius = 5
        $0.isHidden = true
        return $0
    }(UIButton())

    init(hasCheckButton: Bool = false) {
        super.init(frame: .zero)
        checkButton.isHidden = !hasCheckButton
        layout()

        checkButton.addTarget(self, action: #selector(tappedCheckButton), for: .touchUpInside)
        textField.addTarget(self, action: #selector(changedTextFieldValue), for: .editingChanged)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func tappedCheckButton() {
        checkAction?()
    }

    @objc
    private func changedTextFieldValue() {
        resetNotice()
        textChanged?()
    }

    func showNoticeMessage(_ message: String, isValidate: Bool) {
        noticeLabel.isHidden = false
        noticeLabel.text = message
        noticeLabel.textColor = isValidate ? .blue : .red
    }

    func resetNotice() {
        noticeLabel.isHidden = false
        noticeLabel.text = nil
    }
}

// MARK: - layout

extension SignUpTextField {

    private func layout() {

        // MARK: title
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
        ])

        // MARK: textfield
        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            textField.heightAnchor.constraint(equalToConstant: 30)
        ])

        // MARK: noticeLabel
        addSubview(noticeLabel)
        NSLayoutConstraint.activate([
            noticeLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            noticeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            noticeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 30)
        ])

        if checkButton.isHidden == false {
            // MARK: duplicationCheckButton
            addSubview(checkButton)
            NSLayoutConstraint.activate([
                checkButton.widthAnchor.constraint(equalToConstant: 80),
                checkButton.topAnchor.constraint(equalTo: textField.topAnchor),
                checkButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
                checkButton.leftAnchor.constraint(equalTo: textField.rightAnchor, constant: 10),
                checkButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
            ])
        } else {
            textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        }

    }

}

// MARK: - use Canvas
 #if DEBUG
 import SwiftUI

 struct SignUpTextFieldRepresentable: UIViewRepresentable {
    typealias UIViewType = SignUpTextField

    func makeUIView(context: Context) -> SignUpTextField {
        let textField: SignUpTextField = {
            $0.title = "이메일 주소"
            return $0
        }(SignUpTextField(hasCheckButton: true))
        return textField
    }

    func updateUIView(_ uiView: SignUpTextField, context: Context) {

    }
 }

 @available(iOS 13.0.0, *)
 struct SignUpTextFieldRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTextFieldRepresentable()
            .frame(width: 375, height: 50)
            .previewLayout(.sizeThatFits)
    }
 }
 #endif
