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

    var commentsAndReplies: [CommentsAndRepliesModel] = [] {
        didSet { delegate?.didSetCommentsAndRepliesData() }
    }

    struct CommentsAndRepliesModel {
        let id: Int
        let author: String
        let content: String
        let parentId: Int?
        let createdAt: String
    }

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

}

protocol AppointmentDelegate: AnyObject {
    func didSetCommentsAndRepliesData()
    func didEnrollComment()
}
