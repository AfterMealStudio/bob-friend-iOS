//
//  AppointmentListTableViewCell.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/25.
//

import UIKit

class AppointmentListTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = " "
        return $0
    }(UILabel())

    let userLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = " "
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())

    let peopleCntLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = " "
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())

    let commentCntLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = " "
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())

    let dateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = " "
        $0.textAlignment = .right
        $0.textColor = .lightGray
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())

    private let peopleIcon: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "person")
        $0.tintColor = .black
        return $0
    }(UIImageView())

    private let commentIcon: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "text.bubble")
        $0.tintColor = .black
        return $0
    }(UIImageView())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}

extension AppointmentListTableViewCell {

    private func layout() {

        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15)
        ])

        addSubview(userLabel)
        NSLayoutConstraint.activate([
            userLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            userLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            userLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 15)
        ])

        addSubview(peopleIcon)
        NSLayoutConstraint.activate([
            peopleIcon.widthAnchor.constraint(equalToConstant: 20),
            peopleIcon.heightAnchor.constraint(equalToConstant: 20),
            peopleIcon.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 2),
            peopleIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            peopleIcon.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])

        addSubview(peopleCntLabel)
        NSLayoutConstraint.activate([
            peopleCntLabel.leadingAnchor.constraint(equalTo: peopleIcon.trailingAnchor, constant: 5),
            peopleCntLabel.centerYAnchor.constraint(equalTo: peopleIcon.centerYAnchor)
        ])
        peopleCntLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        peopleCntLabel.setNeedsLayout()
        peopleCntLabel.layoutIfNeeded()
        if peopleCntLabel.frame.width < 50 {
            peopleCntLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        }

        addSubview(commentIcon)
        NSLayoutConstraint.activate([
            commentIcon.widthAnchor.constraint(equalToConstant: 20),
            commentIcon.heightAnchor.constraint(equalToConstant: 20),
            commentIcon.leadingAnchor.constraint(equalTo: peopleCntLabel.trailingAnchor, constant: 5),
            commentIcon.centerYAnchor.constraint(equalTo: peopleIcon.centerYAnchor)
        ])

        addSubview(commentCntLabel)
        NSLayoutConstraint.activate([
            commentCntLabel.leadingAnchor.constraint(equalTo: commentIcon.trailingAnchor, constant: 5),
            commentCntLabel.centerYAnchor.constraint(equalTo: peopleIcon.centerYAnchor)
        ])

        addSubview(dateLabel)
        NSLayoutConstraint.activate([
            dateLabel.centerYAnchor.constraint(equalTo: peopleIcon.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            dateLabel.widthAnchor.constraint(equalToConstant: 90),
            dateLabel.leadingAnchor.constraint(equalTo: commentCntLabel.trailingAnchor)
        ])
    }

}

// MARK: - use Canvas
#if DEBUG
import SwiftUI

struct AppointmentListCellRepresentable: UIViewRepresentable {
    typealias UIViewControllerType = AppointmentListTableViewCell

    func makeUIView(context: Context) -> AppointmentListTableViewCell {
        return AppointmentListTableViewCell()
    }

    func updateUIView(_ uiView: AppointmentListTableViewCell, context: Context) {

    }

}

@available(iOS 13.0.0, *)
struct AppointmentListTableViewCell_Preview: PreviewProvider {
    static var previews: some View {
        AppointmentListCellRepresentable()
            .frame(width: nil, height: 100)
            .previewLayout(.sizeThatFits)

    }
}
#endif
