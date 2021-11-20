//
//  AppointmentVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/27.
//

import UIKit

class AppointmentVC: UIViewController {

    let appointmentID: Int

    private let appointmentDetailTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.allowsSelection = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        $0.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    private var headerViews: [UITableViewHeaderFooterView?] = []

    private let commentWritingView: CommentWritingView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(CommentWritingView())

    private let appointmentVM: AppointmentVM = AppointmentVM()

    private var replyWritngInfo: ReplyWritingInfo? {
        willSet {
            if let replyWritngInfo = replyWritngInfo {
                let cell = appointmentDetailTableView.cellForRow(at: replyWritngInfo.index) as? CommentTableViewCell
                cell?.replyWritingMode = false
            }
        }

        didSet {
            if let replyWritngInfo = replyWritngInfo {
                let cell = appointmentDetailTableView.cellForRow(at: replyWritngInfo.index) as? CommentTableViewCell
                cell?.replyWritingMode = true
            }
        }
    }

    struct ReplyWritingInfo {
        let commentID: Int
        let index: IndexPath
    }

    init(appointmentID: Int) {
        self.appointmentID = appointmentID
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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

        let moreFunctionButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didMoreFunctionButtonClicked))
        navigationItem.rightBarButtonItem = moreFunctionButton

        // setting AppointmentVM
        appointmentVM.delegate = self

        // setting tableView
        appointmentDetailTableView.delegate = self
        appointmentDetailTableView.dataSource = self
        registAppointmentDetailTableView()

        // set appointment
        appointmentVM.getAppointment(appointmentID) { [weak self] appointment in

            // set headerData
            guard let section0Header = self?.headerViews[0] as? TitleContentView else { return }
            section0Header.title = appointment.title
            section0Header.content = appointment.content

            guard let section1Header = self?.headerViews[1] as? MapPlaceTimeView else { return }
            section1Header.place = appointment.restaurantName
            section1Header.time = appointment.appointmentTime ?? ""

            guard let section2Header = self?.headerViews[2] as? MemberJoinView else { return }
            section2Header.nowMemberCount = appointment.currentNumberOfPeople
            section2Header.fullMemberCount = appointment.totalNumberOfPeople

            self?.appointmentDetailTableView.reloadData()
        }

        // commentWritingView
        commentWritingView.delegate = self

        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    // MARK: - layout
    func layout() {
        let safeArea = view.safeAreaLayoutGuide
        // backgroundView
        let backgroundView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .white
            return $0
        }(UIView())

        view.addSubview(backgroundView)
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

        // appointmentDetailTableView
        view.addSubview(appointmentDetailTableView)
        NSLayoutConstraint.activate([
            appointmentDetailTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            appointmentDetailTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 10),
            appointmentDetailTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10)
        ])

        // commentWritingView
        view.addSubview(commentWritingView)
        NSLayoutConstraint.activate([
            commentWritingView.topAnchor.constraint(equalTo: appointmentDetailTableView.bottomAnchor),
            commentWritingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            commentWritingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            commentWritingView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

    }

    // MARK: - NavigationBar button event
    @objc
    func didMoreFunctionButtonClicked() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let reportAction = UIAlertAction(title: "신고하기", style: .default) { [weak self] _ in
            guard let appointmentID = self?.appointmentID else { return }
            self?.appointmentVM.reportAppointment(appointmentID: appointmentID)
        }
        let deleteAction = UIAlertAction(title: "삭제하기", style: .default) { [weak self] _ in
            guard let appointmentID = self?.appointmentID else { return }
            self?.appointmentVM.deleteAppointment(appointmentID: appointmentID)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)

        guard let authorID = appointmentVM.appointmentInfo?.author.id, let userID = UserInfo.myInfo?.id else { return }

        if userID == authorID {
            actionSheet.addAction(deleteAction)
        } else {
            actionSheet.addAction(reportAction)
        }
        actionSheet.addAction(cancelAction)
        present(actionSheet, animated: true, completion: nil)

    }

}

// MARK: - appointmentDetailTableView
extension AppointmentVC: UITableViewDelegate, UITableViewDataSource {
    func registAppointmentDetailTableView() {

        appointmentDetailTableView.register(MemberListCell.self, forCellReuseIdentifier: "MemberListCell")
        appointmentDetailTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentReplyCell")

        appointmentDetailTableView.register(TitleContentView.self, forHeaderFooterViewReuseIdentifier: "TitleContentHeader")
        appointmentDetailTableView.register(MapPlaceTimeView.self, forHeaderFooterViewReuseIdentifier: "MapPlaceTimeHeader")
        appointmentDetailTableView.register(MemberJoinView.self, forHeaderFooterViewReuseIdentifier: "MemberJoinHeader")
        appointmentDetailTableView.register(CommentView.self, forHeaderFooterViewReuseIdentifier: "CommentHeader")

        appointmentDetailTableView.register(DivderFooterView.self, forHeaderFooterViewReuseIdentifier: "DividerFooter")

    }

    func numberOfSections(in tableView: UITableView) -> Int {
        /// 0: title content
        /// 1: map place time
        /// 2: member join
        /// 3: comments
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return 0
        case 1: return 0
        case 2: return appointmentVM.appointmentInfo?.members.count ?? 0
        case 3: return appointmentVM.commentsAndReplies.count
        default: return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemberListCell") as? MemberListCell else { return MemberListCell() }
            guard let member = appointmentVM.appointmentInfo?.members[indexPath.row] else { return MemberListCell() }
            cell.username = member.nickname
            cell.rating = String(member.rating)
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentReplyCell", for: indexPath) as? CommentTableViewCell else { return CommentTableViewCell() }

            cell.delegate = self

            let comment = appointmentVM.commentsAndReplies[indexPath.row]

            if UserInfo.myInfo?.id == comment.author.id {
                cell.contentsOwner = .my
            } else { cell.contentsOwner = .other }

            cell.tableIndex = indexPath

            cell.commentID = comment.id
            cell.userName = comment.author.nickname
            cell.time = comment.createdAt
            cell.content = comment.content
            if let parentID = comment.parentId {
                cell.commentMode = .reply(cell: cell, commentID: parentID)
            } else { cell.commentMode = .comment(cell: cell) }

            return cell

        default: return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "TitleContentHeader")
            headerViews.append(header ?? nil)
            return header
        case 1:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MapPlaceTimeHeader")
            headerViews.append(header ?? nil)
            return header
        case 2:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MemberJoinHeader")
            headerViews.append(header ?? nil)
            return header
        case 3:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CommentHeader")
            headerViews.append(header ?? nil)
            return header
        default:
            let header: UITableViewHeaderFooterView? = nil
            headerViews.append(header ?? nil)
            return header
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0, 1:
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: "DividerFooter")
        case 2:
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: "DividerFooter")
        default:
            return nil
        }
    }

}

// MARK: - CommentTableViewCell Delegate
extension AppointmentVC: CommentTableViewCellDelegate {
    func didTurnOnReplyWritingMode(commentID: Int, tableIndex: IndexPath) {
        replyWritngInfo = ReplyWritingInfo(commentID: commentID, index: tableIndex)
    }

    func didCommentReportClicked(commentID: Int) {
        appointmentVM.reportComment(appointmentID: appointmentID, commentID: commentID)
    }

    func didReplyReportClicked(commentID: Int, replyID: Int) {
        appointmentVM.reportReply(appointmentID: appointmentID, commentID: commentID, replyID: replyID)
    }

    func didDeleteCommentClicked(commentID: Int) {
        appointmentVM.deleteComment(appointmentID: appointmentID, commentID: commentID)
    }

    func didDeleteReplyClicked(commentID: Int, replyID: Int) {
        appointmentVM.deleteReply(appointmentID: appointmentID, commentID: commentID, replyID: replyID)
    }

}

// MARK: - AppointmentDelegate
extension AppointmentVC: AppointmentDelegate {
    func didSetCommentsAndRepliesData() {
        appointmentDetailTableView.reloadData()
    }

    func didEnrollComment() {
        viewDidLoad()
    }

    func didReportAppointment() {
        viewDidLoad()
    }

    func didDeleteAppointment() {
        navigationController?.popViewController(animated: true)
    }

    func didReportCommentOrReply() {
        viewDidLoad()
    }

    func didDeleteCommentOrReply() {
        viewDidLoad()
    }

}

// MARK: - CommentWritingView Delegate
extension AppointmentVC: CommentWritingViewDelegate {
    func didWriteButtonClicked(content: String) {
        guard let appointmentID = appointmentVM.appointmentInfo?.id else { return }

        if let replyWritngInfo = replyWritngInfo {
            appointmentVM.enrollReply(appointmentID: appointmentID, commentID: replyWritngInfo.commentID, content: content)
        } else {
            appointmentVM.enrollComment(appointmentID: appointmentID, content: content)
        }

    }
}

// MARK: - use Canvas
#if DEBUG
import SwiftUI

struct AppointmentVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = AppointmentVC

    func makeUIViewController(context: Context) -> AppointmentVC {
        return AppointmentVC(appointmentID: 1)
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

// MARK: - Section Header and Footer Views
extension AppointmentVC {
    // MARK: TitleContentView
    private class TitleContentView: UITableViewHeaderFooterView {

        var title: String = " " { didSet { titleTextView.text = title } }
        var content: String = " " { didSet { contentTextView.text = content } }

        private let titleTextView: UITextView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = " "
            $0.font = UIFont.boldSystemFont(ofSize: 18)
            $0.isSelectable = false
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.sizeToFit()
            return $0
        }(UITextView())

        private let contentTextView: UITextView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = " "
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.isSelectable = false
            $0.isEditable = false
            $0.isScrollEnabled = false
            $0.sizeToFit()
            return $0
        }(UITextView())

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            commonInit()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func commonInit() {
            backgroundColor = .white
            layout()
        }

        func layout() {
            let titleView: AppointmentDetailView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                return $0
            }(AppointmentDetailView(title: "약속 제목", contentView: titleTextView))

            let contentView: AppointmentDetailView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                return $0
            }(AppointmentDetailView(title: "약속 내용", contentView: contentTextView))

            self.contentView.addSubview(titleView)
            self.contentView.addSubview(contentView)

            NSLayoutConstraint.activate([
                titleView.topAnchor.constraint(equalTo: self.contentView.topAnchor),
                titleView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                titleView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),

                contentView.topAnchor.constraint(equalTo: titleView.bottomAnchor),
                contentView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
                contentView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
                contentView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor)
            ])
        }
    }

    // MARK: MapPlaceTimeView
    private class MapPlaceTimeView: UITableViewHeaderFooterView {

        var place: String = " " { didSet { placeLabel.text = place } }
        var time: String = " " { didSet { timeLabel.text = time } }

        private let mapView: MTMapView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(MTMapView())

        private let placeLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = " "
            $0.sizeToFit()
            return $0
        }(UILabel())

        private let timeLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = " "
            $0.sizeToFit()
            return $0
        }(UILabel())

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            commonInit()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func commonInit() {
            backgroundColor = .white
            layout()
        }

        func layout() {
            let placeAndTimeContentView: UIView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                return $0
            }(UIView())

            let placeFormLabel: UILabel = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = "장소"
                $0.textColor = UIColor(named: "MainColor1")
                $0.sizeToFit()
                return $0
            }(UILabel())

            let timeFormLabel: UILabel = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = "시간"
                $0.textColor = UIColor(named: "MainColor1")
                $0.sizeToFit()
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

            contentView.addSubview(placeAndTimeView)
            NSLayoutConstraint.activate([
                placeAndTimeView.topAnchor.constraint(equalTo: contentView.topAnchor),
                placeAndTimeView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                placeAndTimeView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                placeAndTimeView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            ])
        }

    }

    // MARK: MemberJoinView
    private class MemberJoinView: UITableViewHeaderFooterView {

        var nowMemberCount: Int = 0 { didSet { memberView?.title = "약속인원(\(nowMemberCount)/\(fullMemberCount))"
        } }
        var fullMemberCount: Int = 0 { didSet { memberView?.title = "약속인원(\(nowMemberCount)/\(fullMemberCount))" } }

        private var memberView: AppointmentDetailView?

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            commonInit()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func commonInit() {
            backgroundColor = .white
            layout()
        }

        func layout() {
            let view: UIView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.heightAnchor.constraint(equalToConstant: 0).isActive = true
                return $0
            }(UIView())

            memberView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                return $0
            }(AppointmentDetailView(title: "약속인원(\(nowMemberCount)/\(fullMemberCount))", contentView: view))

            guard let memberView = memberView else { return }
            contentView.addSubview(memberView)
            NSLayoutConstraint.activate([
                memberView.topAnchor.constraint(equalTo: contentView.topAnchor),
                memberView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                memberView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                memberView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }

    }

    // MARK: CommentView
    private class CommentView: UITableViewHeaderFooterView {

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            commonInit()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func commonInit() {
            backgroundColor = .white
            layout()
        }

        func layout() {
            let view: UIView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.heightAnchor.constraint(equalToConstant: 0).isActive = true
                return $0
            }(UIView())

            let commentView: AppointmentDetailView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                return $0
            }(AppointmentDetailView(title: "댓글", contentView: view))

            contentView.addSubview(commentView)

            NSLayoutConstraint.activate([
                commentView.topAnchor.constraint(equalTo: contentView.topAnchor),
                commentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                commentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                commentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }

    }

    private class DivderFooterView: UITableViewHeaderFooterView {

        override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            commonInit()
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        func commonInit() {
            backgroundColor = .white
            layout()
        }

        func layout() {
            let dividerView: DividerView = DividerView()
            contentView.addSubview(dividerView)
            NSLayoutConstraint.activate([
                dividerView.topAnchor.constraint(equalTo: contentView.topAnchor),
                dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])
        }
    }

}

class MemberListCell: UITableViewCell {

    var username: String = "" { didSet { usernameLabel.text = username} }
    var rating: String = "" { didSet { ratingLabel.text = rating} }

    private let usernameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = " "
        return $0
    }(UILabel())

    private let ratingLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = " "
        return $0
    }(UILabel())

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {

        contentView.addSubview(usernameLabel)
        contentView.addSubview(ratingLabel)

        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            usernameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            usernameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            usernameLabel.widthAnchor.constraint(equalToConstant: 100),

            ratingLabel.leadingAnchor.constraint(equalTo: usernameLabel.trailingAnchor),
            ratingLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            ratingLabel.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor)

        ])

    }
}
