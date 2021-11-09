//
//  CommentTableViewCell.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/02.
//

import UIKit

class CommentTableViewCell: UITableViewCell {

    var userName: String = " " { didSet { userNameLabel.text = userName } }
    var time: String = " " { didSet { timeLabel.text = time } }
    var content: String = " " {
        didSet {
            contentTextField.text = content
            contentTextField.sizeToFit()
        }
    }
    var viewLeadingConstraint: NSLayoutConstraint?
    var replyMode: Bool = false {
        didSet {
            if replyMode {
                backgroundColor = UIColor(rgb: 0xefefef)
                contentTextField.backgroundColor = UIColor(rgb: 0xefefef)
                if let viewLeadingConstraint = viewLeadingConstraint {
                    viewLeadingConstraint.isActive = false
                }
                view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
            }
        }
    }

    private let view: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())

    private let userNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    private let reportButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("신고하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        $0.setTitleColor(.lightGray, for: .normal)
        return $0
    }(UIButton())

    private let timeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .lightGray
        return $0
    }(UILabel())

    private let contentTextField: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isSelectable = false
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.sizeToFit()
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UITextView())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        addSubview(view)
        viewLeadingConstraint = view.leadingAnchor.constraint(equalTo: leadingAnchor)
        guard let viewLeadingConstraint = viewLeadingConstraint else { return }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor),
            viewLeadingConstraint,
            view.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        view.addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            userNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10)
        ])
        userNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)

        view.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: userNameLabel.trailingAnchor, constant: 10)
        ])

        view.addSubview(reportButton)
        NSLayoutConstraint.activate([
            reportButton.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            reportButton.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 10),
            reportButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])

        view.addSubview(contentTextField)
        NSLayoutConstraint.activate([
            contentTextField.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2),
            contentTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            contentTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}