//
//  SignUpTextField.swift
//  bob-friend-iOS
//
//  Created by sh.hong on 2021/09/25.
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

    private let checkButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())

    private let noticeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isHidden = true
        return $0
    }(UILabel())

    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func noticeMessage(_ message: String) {

    }
}

// MARK: - layout

extension SignUpTextField {

    private func layout() {

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
        ])

        addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor),
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            textField.heightAnchor.constraint(equalToConstant: 30),
            textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
        ])

        addSubview(noticeLabel)
        noticeLabel.isHidden = true
        NSLayoutConstraint.activate([
            noticeLabel.topAnchor.constraint(equalTo: textField.bottomAnchor),
            noticeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            noticeLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 30)
        ])
    }
}

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

struct SignUpTextFieldRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        SignUpTextFieldRepresentable()
            .frame(width: 375, height: 200)
            .previewLayout(.sizeThatFits)
    }
}
#endif
