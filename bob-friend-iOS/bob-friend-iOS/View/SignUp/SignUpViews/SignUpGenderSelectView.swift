//
//  SignUpGenderSelectView.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/09/26.
//

import UIKit

final class SignUpGenderSelectView: UIView {

    var title: String = "" {
        didSet { titleLabel.text = title }
    }

    var gender: Gender = .male {
        didSet {
            switch gender {
            case .male:
                maleButton.isSelected = true
                femaleButton.isSelected = false
            case .female:
                maleButton.isSelected = false
                femaleButton.isSelected = true
            case .none:
                maleButton.isSelected = false
                femaleButton.isSelected = false
            }
        }
    }

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UILabel())

    private let maleButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("  남자", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        $0.tintColor = UIColor(named: "MainColor1")
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(maleButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let femaleButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("  여자", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        $0.tintColor = UIColor(named: "MainColor1")
        $0.isEnabled = true
        $0.addTarget(self, action: #selector(femaleButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let genderNoticeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 10)
        $0.textColor = .red
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

    @objc
    func maleButtonClicked() {
        gender = .male
    }

    @objc
    func femaleButtonClicked() {
        gender = .female
    }

}

// MARK: - layout

extension SignUpGenderSelectView {

    func layout() {

        heightAnchor.constraint(equalToConstant: 50).isActive = true

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
        ])

        let buttonStackView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            return $0
        }(UIStackView())

        addSubview(buttonStackView)
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            buttonStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30),
            buttonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
        ])

        let genderButtons = [maleButton, femaleButton]
        for i in 0..<2 {
            let genderButton = genderButtons[i]
            let contentView: UIView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                return $0
            }(UIView())

            contentView.addSubview(genderButton)
            NSLayoutConstraint.activate([
                genderButton.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 5),
                genderButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
                genderButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
            buttonStackView.addArrangedSubview(contentView)
        }

    }

}

// MARK: - use canvas
#if DEBUG
import SwiftUI

struct SignUpGenderSelectViewRepresentable: UIViewRepresentable {
    typealias UIViewType = SignUpGenderSelectView

    func makeUIView(context: Context) -> SignUpGenderSelectView {
        SignUpGenderSelectView()
    }

    func updateUIView(_ uiView: SignUpGenderSelectView, context: Context) {

    }
}

struct SignUpGenderSelectViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        SignUpGenderSelectViewRepresentable()
            .frame(width: 375, height: 200)
            .previewLayout(.sizeThatFits)
    }
}
#endif
