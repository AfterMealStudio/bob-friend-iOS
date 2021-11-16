//
//  AppointmentVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/09.
//

import Foundation

class AppointmentVM {

    private let network: Network = Network()
    weak var delegate: AppointmentDelegate?

    public var appointmentInfo: AppointmentModel? {
        didSet {
            if let appointmentInfo = appointmentInfo {
                comments = appointmentInfo.comments
            }
        }
    }

    private var comments: [CommentModel] = [] {
        didSet {
            var commentsAndReplies: [CommentsAndRepliesModel] = []
            for comment in comments {

                let refinedComment: CommentsAndRepliesModel
                if let author = comment.author, let content = comment.content {
                    refinedComment = CommentsAndRepliesModel(id: comment.id, author: CommentsAndRepliesModel.User(id: author.id, nickname: author.nickname), content: content, parentId: nil, createdAt: comment.createdAt)
                } else {
                    refinedComment = CommentsAndRepliesModel(id: comment.id, author: CommentsAndRepliesModel.User(id: -1, nickname: "(알 수 없음)"), content: "삭제 된 댓글입니다.", parentId: nil, createdAt: comment.createdAt)
                }

                commentsAndReplies.append(refinedComment)
                for reply in comment.replies {
                    let refinedReply = CommentsAndRepliesModel(id: reply.id, author: CommentsAndRepliesModel.User(id: reply.author.id, nickname: reply.author.nickname), content: reply.content, parentId: comment.id, createdAt: reply.createdAt)
                    commentsAndReplies.append(refinedReply)
                }
            }
            self.commentsAndReplies = commentsAndReplies
        }
    }

    var commentsAndReplies: [CommentsAndRepliesModel] = [] {
        didSet { delegate?.didSetCommentsAndRepliesData() }
    }

    // MARK: - Appointment Methods

    func getAppointment(_ id: Int, completion: @escaping (AppointmentModel) -> Void) {
        network.getAppointment(id) { [weak self] result in
            switch result {
            case .success(let appointment):
                if let appointment = appointment {
                    self?.appointmentInfo = appointment
                    completion(appointment)
                }
            case .failure:
                break
            }

        }
    }

    // MARK: - Comment Methods

    func enrollComment(appointmentID: Int, content: String) {
        let enrollCommentModel: EnrollCommentModel = EnrollCommentModel(content: content)
        network.enrollCommentRequest(appointmentID: appointmentID, comment: enrollCommentModel) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didEnrollComment()
            case .failure:
                break
            }
        }
    }

    func reportComment(appointmentID: Int, commentID: Int) {
        network.reportCommentRequest(appointmentID: appointmentID, commentID: commentID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didReportCommentOrReply()
            case .failure:
                break
            }

        }

    }

    func reportReply(appointmentID: Int, commentID: Int, replyID: Int) {
        network.reportReplyRequest(appointmentID: appointmentID, commentID: commentID, replyID: replyID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didReportCommentOrReply()
            case .failure:
                break
            }
        }
    }

    func deleteComment(appointmentID: Int, commentID: Int) {
        network.deleteCommentRequest(appointmentID: appointmentID, commentID: commentID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didDeleteCommentOrReply()
            case .failure:
                break
            }

        }

    }

    func deleteReply(appointmentID: Int, commentID: Int, replyID: Int) {
        network.deleteReplyRequest(appointmentID: appointmentID, commentID: commentID, replyID: replyID) { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.didDeleteCommentOrReply()
            case .failure:
                break
            }
        }
    }

}

extension AppointmentVM {

    struct CommentsAndRepliesModel {
        let id: Int
        let author: User
        let content: String
        let parentId: Int?
        let createdAt: String

        struct User {
            let id: Int
            let nickname: String
        }
    }

}

protocol AppointmentDelegate: AnyObject {
    func didSetCommentsAndRepliesData()
    func didEnrollComment()
    func didReportCommentOrReply()
    func didDeleteCommentOrReply()
}
