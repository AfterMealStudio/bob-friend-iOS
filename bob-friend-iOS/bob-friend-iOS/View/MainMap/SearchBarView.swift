//
//  SearchBarView.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/04.
//

import UIKit

class SearchBarView: UIView {

    weak var delegate: SearchBarViewDelegate?

    var text: String {
        get { return textField.text ?? "" }
        set(value) { textField.text = value }
    }

    var displayMode: DisplayMode = .buttonHiddenMode {
        didSet { didSetDisplayMode() }
    }

    enum DisplayMode {
        case buttonHiddenMode
        case buttonAppearedMode
    }

    private let textFieldContainer: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .white
        return $0
    }(UIView())

    private let textField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Search"
        $0.backgroundColor = .white
        return $0
    }(UITextField())

    private let button: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(systemName: "chevron.down.circle")
        $0.setImage(buttonImage, for: .normal)
        $0.tintColor = .white
        return $0
    }(UIButton())

    private var textFieldContainerTrailingToButtonConstraint: NSLayoutConstraint?
    private var textFieldContainerTrailingToViewConstraint: NSLayoutConstraint?

    init() {
        super.init(frame: .zero)

        layout()
        didSetDisplayMode()

        button.addTarget(self, action: #selector(didButtonClicked), for: .touchUpInside)

        textField.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc
    private func didButtonClicked() {
        delegate?.didButtonClicked?()
    }

    func didSetDisplayMode() {
        switch displayMode {
        case .buttonHiddenMode:
            button.isHidden = true
            textFieldContainerTrailingToViewConstraint?.isActive = true
            textFieldContainerTrailingToButtonConstraint?.isActive = false
        case .buttonAppearedMode:
            button.isHidden = false
            textFieldContainerTrailingToViewConstraint?.isActive = false
            textFieldContainerTrailingToButtonConstraint?.isActive = true
        }
    }

}

// MARK: - layout

extension SearchBarView {

    private func layout() {
        backgroundColor = UIColor(named: "MainColor1")

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 50)
        ])

        addSubview(textFieldContainer)
        NSLayoutConstraint.activate([
            textFieldContainer.heightAnchor.constraint(equalToConstant: 30),
            textFieldContainer.centerYAnchor.constraint(equalTo: centerYAnchor),
            textFieldContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10)
        ])

        textFieldContainer.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.heightAnchor.constraint(equalTo: textFieldContainer.heightAnchor),
            textField.centerYAnchor.constraint(equalTo: textFieldContainer.centerYAnchor),
            textField.leadingAnchor.constraint(equalTo: textFieldContainer.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: -10)
        ])

        textFieldContainerTrailingToButtonConstraint = textFieldContainer.trailingAnchor.constraint(equalTo: button.leadingAnchor, constant: -10)

        textFieldContainerTrailingToViewConstraint = textFieldContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)

        addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalTo: textFieldContainer.heightAnchor),
            button.widthAnchor.constraint(equalTo: textFieldContainer.heightAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

}

// MARK: - textField Delegate
extension SearchBarView: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        delegate?.didBeginEditing?()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.didReturnKeyInput?()
        return true
    }
}

// MARK: - Delegate

@objc protocol SearchBarViewDelegate: AnyObject {
    @objc optional func didReturnKeyInput()
    @objc optional func didBeginEditing()
    @objc optional func didButtonClicked()
}

// MARK: - use Canvas
 #if DEBUG
 import SwiftUI

 struct SearchBarViewRepresentable: UIViewRepresentable {
    typealias UIViewType = SearchBarView

    func makeUIView(context: Context) -> SearchBarView {
        return SearchBarView()
    }

    func updateUIView(_ uiView: SearchBarView, context: Context) {

    }
 }

 @available(iOS 13.0.0, *)
 struct SearchBarViewRepresentable_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarViewRepresentable()
            .frame(width: 375, height: 50)
            .previewLayout(.sizeThatFits)
    }
 }
 #endif
