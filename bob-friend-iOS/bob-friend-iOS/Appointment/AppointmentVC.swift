//
//  AppointmentVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/27.
//

import UIKit

class AppointmentVC: UIViewController {

    let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        return $0
    }(UIScrollView())

    let mapView: MTMapView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(MTMapView())

    let commentTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.allowsSelection = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return $0
    }(UITableView())

    var appointmentInfo: AppointmentModel? {
        didSet {
            layout()
            if let appointmentInfo = appointmentInfo {
                comments = appointmentInfo.comments
            }
        }
    }
    var comments: [CommentModel] = [] {
        didSet {
            var commentsAndReplies: [CommentsAndRepliesModel] = []
            for comment in comments {
                let refinedComment = CommentsAndRepliesModel(id: comment.id, author: comment.author.nickname, content: comment.content, parentId: nil, createdAt: comment.createdAt)
                commentsAndReplies.append(refinedComment)
                for reply in comment.replies {
                    let refinedReply = CommentsAndRepliesModel(id: reply.id, author: reply.author.nickname, content: reply.content, parentId: comment.id, createdAt: reply.createdAt)
                    commentsAndReplies.append(refinedReply)
                }
            }
            self.commentsAndReplies = commentsAndReplies
        }
    }

    var commentsAndReplies: [CommentsAndRepliesModel] = [] { didSet { commentTableView.reloadData() } }

    struct CommentsAndRepliesModel {
        let id: Int
        let author: String
        let content: String
        let parentId: Int?
        let createdAt: String
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // view
        view.backgroundColor = UIColor(named: "MainColor1")

        // navigationBar
        navigationController?.navigationBar.backgroundColor = UIColor(named: "MainColor1")
        navigationController?.navigationBar.isHidden = false
        let titleView: UILabel = {
            $0.text = "약속 내용"
            $0.textColor = .white
            return $0
        }(UILabel())
        navigationItem.titleView = titleView

        // commentTableView
        commentTableView.delegate = self
        commentTableView.dataSource = self
        registCommentTableView()

        // layout
//        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

}

// MARK: - layout
extension AppointmentVC {
    func layout() {
        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

        let scrollStackView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            $0.spacing = 10
            return $0
        }(UIStackView())

        scrollView.addSubview(scrollStackView)

        NSLayoutConstraint.activate([
            scrollStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 5),
            scrollStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            scrollStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 20),
            scrollStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -20)
        ])

        // MARK: - title layout
        let titleTextView: UITextView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = appointmentInfo?.title
            $0.font = UIFont.boldSystemFont(ofSize: 18)
            $0.isSelectable = false
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.sizeToFit()
            return $0
        }(UITextView())

        let titleView: AppointmentDetailView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(AppointmentDetailView(title: "약속 제목", contentView: titleTextView))

        scrollStackView.addArrangedSubview(titleView)

        // MARK: - content layout
        let contentTextView: UITextView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = appointmentInfo?.content
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.isSelectable = false
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.sizeToFit()
            return $0
        }(UITextView())

        let contentView: AppointmentDetailView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(AppointmentDetailView(title: "약속 내용", contentView: contentTextView))

        scrollStackView.addArrangedSubview(contentView)

        // divider
        scrollStackView.addArrangedSubview(DividerView())

        // MARK: - map / place / time layout

        let placeAndTimeContentView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIView())

        let placeFormLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "장소"
            $0.textColor = UIColor(named: "MainColor1")

            return $0
        }(UILabel())

        let timeFormLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "시간"
            $0.textColor = UIColor(named: "MainColor1")

            return $0
        }(UILabel())

        let placeLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = appointmentInfo?.restaurantName
            return $0
        }(UILabel())

        let timeLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = appointmentInfo?.appointmentTime
            return $0
        }(UILabel())

        placeAndTimeContentView.addSubview(mapView)
        placeAndTimeContentView.addSubview(placeFormLabel)
        placeAndTimeContentView.addSubview(placeLabel)
        placeAndTimeContentView.addSubview(timeFormLabel)
        placeAndTimeContentView.addSubview(timeLabel)

        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: placeAndTimeContentView.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: placeAndTimeContentView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: placeAndTimeContentView.trailingAnchor),
            mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor),

            placeFormLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor),
            placeFormLabel.leadingAnchor.constraint(equalTo: placeAndTimeContentView.leadingAnchor),
            placeFormLabel.widthAnchor.constraint(equalToConstant: 30),

            placeLabel.centerYAnchor.constraint(equalTo: placeFormLabel.centerYAnchor),
            placeLabel.leadingAnchor.constraint(equalTo: placeFormLabel.trailingAnchor, constant: 10),
            placeLabel.trailingAnchor.constraint(equalTo: placeAndTimeContentView.trailingAnchor),

            timeFormLabel.topAnchor.constraint(equalTo: placeFormLabel.bottomAnchor),
            timeFormLabel.leadingAnchor.constraint(equalTo: placeAndTimeContentView.leadingAnchor),
            timeFormLabel.widthAnchor.constraint(equalToConstant: 30),
            timeFormLabel.bottomAnchor.constraint(equalTo: placeAndTimeContentView.bottomAnchor),

            timeLabel.centerYAnchor.constraint(equalTo: timeFormLabel.centerYAnchor),
            timeLabel.leadingAnchor.constraint(equalTo: placeFormLabel.trailingAnchor, constant: 10),
            timeLabel.trailingAnchor.constraint(equalTo: placeAndTimeContentView.trailingAnchor)

        ])

        let placeAndTimeView: AppointmentDetailView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(AppointmentDetailView(title: "약속 장소 및 시간", contentView: placeAndTimeContentView))

        scrollStackView.addArrangedSubview(placeAndTimeView)

        // divider
        scrollStackView.addArrangedSubview(DividerView())

        // MARK: - members
        let currentPeople: Int = appointmentInfo?.currentNumberOfPeople ?? 0
        let totalPeople: Int = appointmentInfo?.totalNumberOfPeople ?? 0

        let memberLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "약속 인원(\(currentPeople)/\(totalPeople))"
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(named: "MainColor1")
            return $0
        }(UILabel())

        scrollStackView.addArrangedSubview(memberLabel)
        // divider
        scrollStackView.addArrangedSubview(DividerView())

        // MARK: - comment
        scrollStackView.addArrangedSubview(commentTableView)
        // TODO: 댓글들 개수에 따라 댓글들을 한번에 표시해야함
        // tableView의 스크롤이 아닌 상위 스크롤 뷰의 스크롤로 확인 가능하도록.
        commentTableView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
}

// MARK: - CommentTableView Delegate
extension AppointmentVC: UITableViewDelegate, UITableViewDataSource {
    private func registCommentTableView() {
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableView")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsAndReplies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableView", for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell() }
        let comment = commentsAndReplies[indexPath.row]
        cell.userName = comment.author
        cell.time = comment.createdAt
        cell.content = comment.content
        if comment.parentId != nil {
            cell.replyMode = true
        }

        return cell
    }

}

// MARK: - use Canvas
#if DEBUG
import SwiftUI

struct AppointmentVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = AppointmentVC

    func makeUIViewController(context: Context) -> AppointmentVC {
        return AppointmentVC()
    }

    func updateUIViewController(_ uiViewController: AppointmentVC, context: Context) {

    }

}

@available(iOS 13.0.0, *)
struct AppointmentVC_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            AppointmentVCRepresentable()
                .previewDevice("iPhone 11 Pro")
        }
    }
}
#endif
