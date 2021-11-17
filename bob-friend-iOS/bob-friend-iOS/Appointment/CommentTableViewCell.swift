//
//  CommentTableViewCell.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/02.
//

import UIKit
import SwiftUI

class CommentTableViewCell: UITableViewCell {

    var tableIndex: IndexPath?

    var commentID: Int = 0
    var userName: String = " " { didSet { userNameLabel.text = userName } }
    var time: String = " " { didSet { timeLabel.text = time } }
    var content: String = " " {
        didSet {
            contentTextView.text = content
            contentTextView.sizeToFit()
        }
    }
    var viewLeadingConstraint: NSLayoutConstraint?
    var commentMode: CommentMode? {
        didSet {
            backgroundColor = commentMode?.bgColor
            contentTextView.backgroundColor = commentMode?.bgColor
            switch commentMode {
            case .comment:
                viewLeadingConstraint?.isActive = false
                viewLeadingConstraint = commentMode?.viewLeadingConstraint
                viewLeadingConstraint?.isActive = true
            case .reply:
                viewLeadingConstraint?.isActive = false
                viewLeadingConstraint = commentMode?.viewLeadingConstraint
                viewLeadingConstraint?.isActive = true
            case .none:
                break
            case .some:
                break
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

    private let moreFunctionButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let buttonImage = UIImage(systemName: "ellipsis")
        $0.setImage(buttonImage, for: .normal)
        $0.tintColor = .lightGray
        return $0
    }(UIButton())

    private let timeLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .lightGray
        return $0
    }(UILabel())

    private let contentTextView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isSelectable = false
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.sizeToFit()
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UITextView())

    weak var delegate: CommentTableViewCellDelegate?

    var contentsOwner: ContentsOwner = .other {
        didSet {
            moreFunctionButton.addTarget(self, action: #selector(didMoreFunctionButtonClicked), for: .touchUpInside)
        }
    }

    var replyWritingMode: Bool? {
        didSet {
            switch replyWritingMode {
            case true:
                backgroundColor = UIColor(named: "MainColor4")
                contentTextView.backgroundColor = UIColor(named: "MainColor4")
            case false:
                backgroundColor = .white
                contentTextView.backgroundColor = .white
            default:
                break
            }
        }
    }

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commentMode = .comment(cell: self)
        layout()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - layout
    func layout() {
        contentView.addSubview(view)
        viewLeadingConstraint = commentMode?.viewLeadingConstraint
        guard let viewLeadingConstraint = viewLeadingConstraint else { return }
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            viewLeadingConstraint,
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
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

        view.addSubview(moreFunctionButton)
        NSLayoutConstraint.activate([
            moreFunctionButton.centerYAnchor.constraint(equalTo: userNameLabel.centerYAnchor),
            moreFunctionButton.leadingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: 10),
            moreFunctionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),

            moreFunctionButton.widthAnchor.constraint(equalToConstant: 15),
            moreFunctionButton.heightAnchor.constraint(equalTo: moreFunctionButton.widthAnchor)
        ])

        view.addSubview(contentTextView)
        NSLayoutConstraint.activate([
            contentTextView.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 2),
            contentTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            contentTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            contentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10)
        ])
    }

    // MARK: moreFunctionButton Event
    @objc
    func didMoreFunctionButtonClicked() {

        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let replyAction = UIAlertAction(title: "대댓글달기", style: .default) { [weak self] _ in
            guard let commentID = self?.commentID, let tableIndex = self?.tableIndex else { return }
            self?.replyWritingMode = true
            self?.delegate?.didTurnOnReplyWritingMode(commentID: commentID, tableIndex: tableIndex)
        }
        let reportAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            guard let commentMode = self?.commentMode, let commentID = self?.commentID else { return }
            switch commentMode {
            case .comment:
                self?.delegate?.didCommentReportClicked(commentID: commentID)
            case .reply:
                self?.delegate?.didReplyReportClicked(commentID: commentMode.parentID, replyID: commentID)
            }
        }
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { [weak self] _ in
            guard let commentMode = self?.commentMode, let commentID = self?.commentID else { return }
            switch commentMode {
            case .comment:
                self?.delegate?.didDeleteCommentClicked(commentID: commentID)
            case .reply:
                self?.delegate?.didDeleteReplyClicked(commentID: commentMode.parentID, replyID: commentID)
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        guard let commentMode = commentMode else { return }

        switch commentMode {
        case .comment:
            actionSheet.addAction(replyAction)
        default:
            break
        }

        switch contentsOwner {
        case .my:
            actionSheet.addAction(deleteAction)
        case .other:
            actionSheet.addAction(reportAction)
        }

        actionSheet.addAction(cancelAction)

        delegate?.present(actionSheet, animated: true, completion: nil)

    }

}

// MARK: - Enums
extension CommentTableViewCell {

    enum CommentMode {
        case comment(cell: CommentTableViewCell)
        case reply(cell: CommentTableViewCell, commentID: Int)

        var viewLeadingConstraint: NSLayoutConstraint {
            switch self {
            case .comment(let cell):
                return cell.view.leadingAnchor.constraint(equalTo: cell.leadingAnchor)
            case .reply(let cell, _):
                return cell.view.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 30)
            }
        }

        var bgColor: UIColor {
            switch self {
            case .comment:
                return .white
            case .reply:
                return UIColor(rgb: 0xefefef)
            }
        }

        var parentID: Int {
            switch self {
            case .comment:
                return 0
            case .reply(_, let commentID):
                return commentID
            }
        }

    }

    enum ContentsOwner {
        case my
        case other
    }

}

// MARK: - CommentTableViewCell Delegate
protocol CommentTableViewCellDelegate: UIViewController {

    func didCommentReportClicked(commentID: Int)
    func didReplyReportClicked(commentID: Int, replyID: Int)
    func didDeleteCommentClicked(commentID: Int)
    func didDeleteReplyClicked(commentID: Int, replyID: Int)
    func didTurnOnReplyWritingMode(commentID: Int, tableIndex: IndexPath)

}
