//
//  SearchBarView.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/04.
//

import UIKit

class SearchBarView: UIView {

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
        $0.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        $0.tintColor = .white
        return $0
    }(UIButton())

    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

        addSubview(button)
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalTo: textFieldContainer.heightAnchor),
            button.widthAnchor.constraint(equalTo: textFieldContainer.heightAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
            button.leadingAnchor.constraint(equalTo: textFieldContainer.trailingAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])
    }

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
