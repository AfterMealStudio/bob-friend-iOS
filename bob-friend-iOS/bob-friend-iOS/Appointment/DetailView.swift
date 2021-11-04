//
//  DetailView.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/02.
//

import UIKit

extension AppointmentVC {

    class AppointmentDetailView: UIView {

        var title: String = "" { didSet { titleLabel.text = title } }

        private let titleLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(named: "MainColor1")
            return $0
        }(UILabel())

        var contentView: UIView = UIView()

        init(title: String = "", contentView: UIView = UIView()) {
            super.init(frame: .zero)

            self.contentView = contentView
            self.contentView.translatesAutoresizingMaskIntoConstraints = false

            self.title = title
            titleLabel.text = title

            layout()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func layout() {
            addSubview(titleLabel)
            NSLayoutConstraint.activate([
                titleLabel.topAnchor.constraint(equalTo: topAnchor),
                titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

                titleLabel.heightAnchor.constraint(equalToConstant: 20)
            ])

            addSubview(contentView)
            NSLayoutConstraint.activate([
                contentView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }

    }

    class DividerView: UIView {

        init() {
            super.init(frame: .zero)
            translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = .black
            heightAnchor.constraint(equalToConstant: 1.2).isActive = true
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

    }

}
