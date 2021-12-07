//
//  CommentWritingView.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/09.
//

import UIKit

class CommentWritingView: UIView {

    weak var delegate: CommentWritingViewDelegate?

    private var content: String = ""

    private let textBoxView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 5
        $0.backgroundColor = UIColor(rgb: 0xeeeeee)
        return $0
    }(UIView())

    private let commentView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(rgb: 0xeeeeee)
        return $0
    }(UITextView())

    private let sendButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 15
        $0.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
        $0.backgroundColor = UIColor(named: "MainColor3")
        $0.tintColor = UIColor(named: "MainColor2")
        $0.addTarget(self, action: #selector(didWriteButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    init() {
        super.init(frame: .zero)

        commentView.delegate = self

        backgroundColor = .white
        layout()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {
        addSubview(textBoxView)
        NSLayoutConstraint.activate([
            textBoxView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            textBoxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            textBoxView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])

        textBoxView.addSubview(commentView)
        NSLayoutConstraint.activate([
            commentView.topAnchor.constraint(equalTo: textBoxView.topAnchor, constant: 5),
            commentView.leadingAnchor.constraint(equalTo: textBoxView.leadingAnchor, constant: 5),
            commentView.trailingAnchor.constraint(equalTo: textBoxView.trailingAnchor, constant: -5),
            commentView.bottomAnchor.constraint(equalTo: textBoxView.bottomAnchor, constant: -5),
            commentView.heightAnchor.constraint(equalToConstant: 30)
        ])

        addSubview(sendButton)
        NSLayoutConstraint.activate([
            sendButton.widthAnchor.constraint(equalTo: sendButton.heightAnchor),
            sendButton.widthAnchor.constraint(equalToConstant: 30),
            sendButton.leadingAnchor.constraint(equalTo: textBoxView.trailingAnchor, constant: 10),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }

    @objc
    func didWriteButtonClicked() {
        delegate?.didWriteButtonClicked(content: content)
    }

    func setContentBlank() {
        content = ""
        commentView.text = ""
    }

}

extension CommentWritingView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        content = textView.text
    }
}

protocol CommentWritingViewDelegate: AnyObject {
    func didWriteButtonClicked(content: String)
}
