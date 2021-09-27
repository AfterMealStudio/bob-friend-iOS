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

    private var hasDuplicationCheckButton: Bool = false

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

    private let duplicationCheckButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "MainColor1")
        $0.layer.cornerRadius = 5
        return $0
    }(UIButton())

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(hasDuplicationCheckButton: Bool) {
        self.hasDuplicationCheckButton = hasDuplicationCheckButton
//        if let buttonAction = buttonAction {
//            duplicationCheckButton.addTarget(self, action: buttonAction, for: .touchUpInside)
//        }
        layout()
    }

    func addTargetToDuplicationCheckButton(action: Selector) {
        duplicationCheckButton.addTarget(self, action: action, for: .touchUpInside)
    }

}

// MARK: - noticeLabel control

extension SignUpTextField {
    func hideNoticeLabel() {
        noticeLabel.isHidden = true
    }

    func showNoticeLabel() {
        noticeLabel.isHidden = false
    }

    func notice(msg: String, _ isPositive: Bool) {
        noticeLabel.text = msg
        if isPositive { noticeLabel.textColor = .blue } else { noticeLabel.textColor = .red }
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

        if hasDuplicationCheckButton {
            // MARK: duplicationCheckButton
            addSubview(duplicationCheckButton)
            NSLayoutConstraint.activate([
                duplicationCheckButton.widthAnchor.constraint(equalToConstant: 80),
                duplicationCheckButton.topAnchor.constraint(equalTo: textField.topAnchor),
                duplicationCheckButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
                duplicationCheckButton.leftAnchor.constraint(equalTo: textField.rightAnchor, constant: 10),
                duplicationCheckButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
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
        SignUpTextField()
    }

    func updateUIView(_ uiView: SignUpTextField, context: Context) {

    }
 }

 @available(iOS 13.0.0, *)
 struct SignUpTextFieldRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTextFieldRepresentable()
            .frame(width: 375, height: 200)
            .previewLayout(.sizeThatFits)
    }
 }
 #endif
