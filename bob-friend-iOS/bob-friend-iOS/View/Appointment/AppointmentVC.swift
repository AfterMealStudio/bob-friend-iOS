//
//  AppointmentVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/27.
//

import UIKit
import NMapsMap

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
    private var footerViews: [UITableViewHeaderFooterView?] = []

    private let commentWritingView: CommentWritingView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(CommentWritingView())

    var commentWritingViewBottomConstraint: NSLayoutConstraint?
    var commentWritingViewKeyboardBottomConstraint: NSLayoutConstraint?

    let loadingView: LoadingView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(LoadingView())

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

    let refreshControl: UIRefreshControl = UIRefreshControl()

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
        navigationItem.title = "약속 내용"

        let moreFunctionButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(didMoreFunctionButtonClicked))
        navigationItem.rightBarButtonItem = moreFunctionButton

        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = UIColor(named: "MainColor1")
        navigationAppearance.titleTextAttributes =  [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationAppearance

        // setting AppointmentVM
        appointmentVM.delegate = self

        // setting tableView
        appointmentDetailTableView.delegate = self
        appointmentDetailTableView.dataSource = self
        registAppointmentDetailTableView()
        appointmentDetailTableView.refreshControl = refreshControl
        appointmentDetailTableView.refreshControl?.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)

        // set appointment
        appointmentVM.getAppointment(appointmentID) { [weak self] appointment in

            // set headerData
            guard let section0Header = self?.headerViews[0] as? TitleContentView else { return }
            section0Header.title = appointment.title
            section0Header.content = appointment.content

            guard let section1Header = self?.headerViews[1] as? MapPlaceTimeView else { return }
            section1Header.place = appointment.restaurantName
            section1Header.time = appointment.appointmentTime ?? ""
            section1Header.marker = NMFMarker(position: NMGLatLng(lat: appointment.latitude, lng: appointment.longitude))

            guard let section2Header = self?.headerViews[2] as? MemberJoinView else { return }
            section2Header.nowMemberCount = appointment.currentNumberOfPeople
            section2Header.fullMemberCount = appointment.totalNumberOfPeople

            // set footerData
            guard let section2Footer = self?.footerViews[2] as? MemberJoinFooterView else { return }
            if appointment.ageRestrictionStart == nil && appointment.ageRestrictionEnd == nil {
                section2Footer.age = "제한 없음"
            } else {
                var ageRestrictionStartString = " "
                var ageRestrictionEndString = " "
                if let ageRestrictionStart = appointment.ageRestrictionStart {
                    ageRestrictionStartString = String(ageRestrictionStart)
                }
                if let ageRestrictionEnd = appointment.ageRestrictionEnd {
                    ageRestrictionEndString = String(ageRestrictionEnd)
                }
                section2Footer.age = "\(ageRestrictionStartString) ~ \(ageRestrictionEndString)"
            }

            switch appointment.sexRestriction {
            case .male:
                section2Footer.gender = "남자만"
            case .female:
                section2Footer.gender = "여자만"
            case .none:
                section2Footer.gender = "제한 없음"
            }

            if appointment.author.id == UserInfo.myInfo?.id {
                section2Footer.mode = .ownerOpened
            } else {

                switch appointment.sexRestriction {
                case .male, .female:
                    if UserInfo.myInfo?.sex != appointment.sexRestriction {
                        section2Footer.mode = .restricted
                    }
                case .none:
                    section2Footer.mode = .nonOwnerNonJoined
                    for members in appointment.members {
                        if members.id == UserInfo.myInfo?.id {
                            section2Footer.mode = .nonOwnerJoined
                        }
                    }
                }

            }

            self?.appointmentDetailTableView.reloadData()
        }

        // commentWritingView
        commentWritingView.delegate = self

        // layout + keyboard
        commentWritingViewBottomConstraint = commentWritingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        commentWritingViewKeyboardBottomConstraint = commentWritingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        commentWritingViewKeyboardBottomConstraint?.priority = .defaultHigh
        commentWritingViewBottomConstraint?.priority = .defaultLow
        enrollKeyboardNotification()
        enrollRemoveKeyboard()
        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }

    @objc
    func pullToRefresh() {
        viewDidLoad()
        refreshControl.endRefreshing()
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
        guard let commentWritingViewBottomConstraint = commentWritingViewBottomConstraint else { return }
        NSLayoutConstraint.activate([
            commentWritingView.topAnchor.constraint(equalTo: appointmentDetailTableView.bottomAnchor),
            commentWritingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            commentWritingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            commentWritingViewBottomConstraint
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
        appointmentDetailTableView.register(MemberJoinFooterView.self, forHeaderFooterViewReuseIdentifier: "MemberJoinFooter")

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
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "DividerFooter")
            footerViews.append(footer ?? nil)
            return footer
        case 2:
            let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MemberJoinFooter")
            footerViews.append(footer ?? nil)
            guard let footer = footer as? MemberJoinFooterView else { return footer }
            footer.delegate = self
            return footer
        default:
            let footer: UITableViewHeaderFooterView? = nil
            footerViews.append(footer ?? nil)
            return footer
        }
    }

}

extension AppointmentVC: MemberJoinFooterDelegate {
    func closeAppointment() {
        appointmentVM.closeAppointment(appointmentID: appointmentID)
    }

    func joinOrCancelAppointment() {
        appointmentVM.joinOrCancelAppointment(appointmentID: appointmentID)

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
    func didStartLoading() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        loadingView.startLoadingAnimation()
    }

    func didStopLoading() {
        loadingView.stopLoadingAnimation()
        loadingView.removeFromSuperview()
    }

    func didSetCommentsAndRepliesData() {
        appointmentDetailTableView.reloadData()
    }

    func didEnrollComment() {
        viewDidLoad()
        commentWritingView.setContentBlank()
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

    func didCloseAppointment() {
        viewDidLoad()
    }

    func didJoinOrCancelAppointment() {
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

// MARK: - keyboard Management
extension AppointmentVC {
    private func enrollKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardWillShow(_ sender: Notification) {
        guard let commentWritingViewKeyboardBottomConstraint = commentWritingViewKeyboardBottomConstraint else { return }
        if commentWritingViewKeyboardBottomConstraint.constant == 0 {
            guard let userInfo = sender.userInfo,
                  let keyboardFrame: NSValue = userInfo[ UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            commentWritingViewKeyboardBottomConstraint.isActive = true
            commentWritingViewKeyboardBottomConstraint.constant = -keyboardHeight
        }
    }

    @objc
    private func keyboardWillHide(_ sender: Notification) {
        guard let commentWritingViewKeyboardBottomConstraint = commentWritingViewKeyboardBottomConstraint else { return }
        if commentWritingViewKeyboardBottomConstraint.constant != 0 {
            commentWritingViewKeyboardBottomConstraint.isActive = false
            commentWritingViewKeyboardBottomConstraint.constant = 0
        }
    }

    private func removeKeyboard() {
        view.endEditing(true)
        if replyWritngInfo != nil {
            replyWritngInfo = nil
        }
    }

    private func enrollRemoveKeyboard() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOtherMethod))
            appointmentDetailTableView.addGestureRecognizer(singleTapGestureRecognizer)
    }

    @objc
    private func tapOtherMethod(sender: UITapGestureRecognizer) {
        removeKeyboard()
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

        private let mapView: NMFMapView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isTiltGestureEnabled = false
            $0.isRotateGestureEnabled = false
            $0.isZoomGestureEnabled = false
            $0.isScrollGestureEnabled = false
            return $0
        }(NMFMapView())

        var marker: NMFMarker? {
            didSet {
                if let marker = marker {
                    marker.mapView = mapView
                    let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position)
                    mapView.moveCamera(cameraUpdate)
                }
            }
        }

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

            let mapWrapperView: UIView = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.backgroundColor = .clear
                return $0
            }(UIView())
            placeAndTimeContentView.addSubview(mapWrapperView)

            NSLayoutConstraint.activate([
                mapWrapperView.topAnchor.constraint(equalTo: mapView.topAnchor),
                mapWrapperView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
                mapWrapperView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
                mapWrapperView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor)
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

    private class MemberJoinFooterView: UITableViewHeaderFooterView {

        weak var delegate: MemberJoinFooterDelegate?

        var age: String = " " { didSet { ageLabel.text = age } }
        var gender: String = " " { didSet { genderLabel.text = gender } }

        var mode: Mode? {
            didSet {
                button.backgroundColor = mode?.buttonColor
                button.setTitle(mode?.buttonTitle ?? "", for: .normal)
                button.setTitleColor(mode?.buttonTitleColor ?? .black, for: .normal)
            }
        }

        private let ageLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = " "
            $0.sizeToFit()
            return $0
        }(UILabel())

        private let genderLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = " "
            $0.sizeToFit()
            return $0
        }(UILabel())

        let button: UIButton = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.layer.cornerRadius = 5
            $0.backgroundColor = .white
            $0.addTarget(self, action: #selector(didButtonClicked), for: .touchUpInside)
            return $0
        }(UIButton())

        @objc
        func didButtonClicked() {
            switch mode {
            case .ownerOpened:
                delegate?.closeAppointment()
            case .ownerCloesed: return
            case .nonOwnerNonJoined, .nonOwnerJoined:
                delegate?.joinOrCancelAppointment()
            case .restricted: return
            case .none: return
            }
        }

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

            let ageFormLabel: UILabel = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = "나이제한"
                $0.textColor = UIColor(named: "MainColor1")
                $0.sizeToFit()
                $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                return $0
            }(UILabel())

            let genderFormLabel: UILabel = {
                $0.translatesAutoresizingMaskIntoConstraints = false
                $0.text = "성별제한"
                $0.textColor = UIColor(named: "MainColor1")
                $0.sizeToFit()
                $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
                return $0
            }(UILabel())

            let dividerView: DividerView = DividerView()

            contentView.addSubview(ageFormLabel)
            contentView.addSubview(ageLabel)
            contentView.addSubview(genderFormLabel)
            contentView.addSubview(genderLabel)

            NSLayoutConstraint.activate([
                ageFormLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
                ageFormLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

                ageLabel.centerYAnchor.constraint(equalTo: ageFormLabel.centerYAnchor),
                ageLabel.leadingAnchor.constraint(equalTo: ageFormLabel.trailingAnchor, constant: 10),
                ageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

                genderFormLabel.topAnchor.constraint(equalTo: ageFormLabel.bottomAnchor, constant: 5),
                genderFormLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),

                genderLabel.centerYAnchor.constraint(equalTo: genderFormLabel.centerYAnchor),
                genderLabel.leadingAnchor.constraint(equalTo: genderFormLabel.trailingAnchor, constant: 10),
                genderLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])

            contentView.addSubview(button)
            contentView.addSubview(dividerView)

            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: genderFormLabel.bottomAnchor, constant: 5),
                button.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
                button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
                button.heightAnchor.constraint(equalToConstant: 50),

                dividerView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 5),
                dividerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                dividerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                dividerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ])

        }

        enum Mode {
            case ownerOpened
            case ownerCloesed
            case nonOwnerNonJoined
            case nonOwnerJoined
            case restricted

            var buttonColor: UIColor {
                switch self {
                case .ownerOpened: return UIColor(named: "MainColor1") ?? .black
                case .ownerCloesed: return .gray
                case .nonOwnerNonJoined: return UIColor(named: "MainColor3") ?? .yellow
                case .nonOwnerJoined: return UIColor(named: "MainColor2") ?? .blue
                case .restricted: return .gray
                }
            }

            var buttonTitle: String {
                switch self {
                case .ownerOpened: return "마감하기"
                case .ownerCloesed: return "마감되었습니다"
                case .nonOwnerNonJoined: return "참가하기"
                case .nonOwnerJoined: return "취소하기"
                case .restricted: return "참가대상이 아닙니다"

                }
            }

            var buttonTitleColor: UIColor {
                switch self {
                case .ownerOpened: return .white
                case .ownerCloesed: return .black
                case .nonOwnerNonJoined: return .black
                case .nonOwnerJoined: return .white
                case .restricted: return .black
                }
            }
        }
    }

}

protocol MemberJoinFooterDelegate: AnyObject {
    func closeAppointment()
    func joinOrCancelAppointment()
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
