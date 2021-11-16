//
//  Network.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/08/28.
//

import Foundation
import Alamofire

final class Network {

    private let session: Session?

    init(_ session: Session = AF) {
        self.session = session
    }

    static var token: String = ""

    private enum API {
        case login
        case checkEmailDuplication(email: String)
        case checkNicknameDuplication(nickname: String)
        case signup
        case kakaoKeywordSearch
        case appointmentList
        case appointment(id: Int)
        case enrollComment(appointmentID: Int)
        case userInfo
        case reportAppointment(appointmentID: Int)
        case deleteAppointment(appointmentID: Int)
        case reportComment(appointmentID: Int, commentID: Int)
        case reportReply(appointmentID: Int, commentID: Int, replyID: Int)
        case deleteComment(appointmentID: Int, commentID: Int)
        case deleteReply(appointmentID: Int, commentID: Int, replyID: Int)

        var path: String {
            let baseUrl: String = "http://117.17.102.143:8080/"
            let kakaoKeywordSearchUrl = "https://dapi.kakao.com/v2/local/search/keyword.json"

            switch self {
            case .login:
                return baseUrl + "api/signin"
            case .checkEmailDuplication(let email):
                return baseUrl + "api/email/\(email)"
            case .checkNicknameDuplication(let nickname):
                return baseUrl + "api/nickname/\(nickname)"
            case .signup:
                return baseUrl + "api/signup"
            case .kakaoKeywordSearch:
                return kakaoKeywordSearchUrl
            case .appointmentList:
                return baseUrl + "recruitments"
            case .appointment(let id):
                return baseUrl + "recruitments/\(id)"
            case .enrollComment(appointmentID: let id):
                return baseUrl + "recruitments/\(id)/comments"
            case .userInfo:
                return baseUrl + "api/user"
            case .reportAppointment(appointmentID: let appointmentID):
                return baseUrl + "recruitments/\(appointmentID)/report"
            case .deleteAppointment(appointmentID: let appointmentID):
                return baseUrl + "recruitments/\(appointmentID)"
            case .reportComment(appointmentID: let appointmentID, commentID: let commentID):
                return baseUrl + "recruitments/\(appointmentID)/comments/\(commentID)/report"
            case .reportReply(appointmentID: let appointmentID, commentID: let commentID, replyID: let replyID):
                return baseUrl + "recruitments/\(appointmentID)/comments/\(commentID)/replies/\(replyID)/report"
            case .deleteComment(appointmentID: let appointmentID, commentID: let commentID):
                return baseUrl + "recruitments/\(appointmentID)/comments/\(commentID)"
            case .deleteReply(appointmentID: let appointmentID, commentID: let commentID, replyID: let replyID):
                return baseUrl + "recruitments/\(appointmentID)/comments/\(commentID)/replies/\(replyID)"
            }
        }

        var method: HTTPMethod {
            switch self {
            case .login: return .post
            case .checkEmailDuplication(email: _): return .get
            case .checkNicknameDuplication(nickname: _): return .get
            case .signup: return .post
            case .kakaoKeywordSearch: return .get
            case .appointmentList: return .get
            case .appointment(id: _): return .get
            case .enrollComment(appointmentID: _): return .post
            case .userInfo: return .get
            case .reportAppointment(appointmentID: _): return .patch
            case .deleteAppointment(appointmentID: _): return .delete
            case .reportComment(appointmentID: _, commentID: _): return .patch
            case .reportReply(appointmentID: _, commentID: _, replyID: _): return .patch
            case .deleteComment(appointmentID: _, commentID: _): return .delete
            case .deleteReply(appointmentID: _, commentID: _, replyID: _): return .delete

            }
        }

    }

    func loginRequest(loginInfo: LoginModel, completion: @escaping (Result<TokenModel?, Error>) -> Void) {
        request(api: API.login, type: TokenModel.self, parameter: loginInfo, completion: completion)
    }

    func checkEmailDuplicationRequest(email: String, completion: @escaping (Result<DuplicationCheckResultModel?, Error>) -> Void) {
        request(api: .checkEmailDuplication(email: email), type: DuplicationCheckResultModel.self, completion: completion)
    }

    func checkNicknameDuplicationRequest(nickname: String, completion: @escaping (Result<DuplicationCheckResultModel?, Error>) -> Void) {
        request(api: .checkNicknameDuplication(nickname: nickname), type: DuplicationCheckResultModel.self, completion: completion)
    }

    func signUpRequest(signUpInfo: SignUpModel, completion: @escaping (Result<SignUpResponseModel?, Error>) -> Void) {
        request(api: .signup, type: SignUpResponseModel.self, parameter: signUpInfo, completion: completion)
    }

    // TODO: 카카오 앱키 관리
    func kakaoKeywordSearchRequest(keyword: String, page: Int, completion: @escaping (Result<KakaoKeywordSearchResultModel?, Error>) -> Void) {
        let kakaoRestAPIKey = "3136b32531da9ba1c20a78ea3457e50d"
        let parameters: Parameters = ["query": keyword, "page": page, "size": 15]
        let headers = HTTPHeaders(["Authorization": "KakaoAK \(kakaoRestAPIKey)"])

        request(api: .kakaoKeywordSearch, type: KakaoKeywordSearchResultModel.self, parameters: parameters, headers: headers, completion: completion)
    }

    func getAppointmentListRequest(page: Int = 0, completion: @escaping(Result<AppointmentListModel?, Error>) -> Void) {
        let parameters: Parameters = ["page": page]
        let headers = HTTPHeaders(["Authorization": Network.token])
        request(api: .appointmentList, type: AppointmentListModel.self, parameters: parameters, headers: headers, completion: completion)
    }

    func getAppointment(_ appointmentID: Int, completion: @escaping(Result<AppointmentModel?, Error>) -> Void) {
        let headers = HTTPHeaders(["Authorization": Network.token])
        request(api: .appointment(id: appointmentID), type: AppointmentModel.self, headers: headers) { result in
            completion(result)
        }
    }

    func enrollCommentRequest(appointmentID: Int, comment: EnrollCommentModel, completion: @escaping(Result<EnrollCommentResponseModel?, Error>) -> Void) {
        let headers = HTTPHeaders(["Authorization": Network.token])
        request(api: API.enrollComment(appointmentID: appointmentID), type: EnrollCommentResponseModel.self, parameter: comment, headers: headers, completion: completion)
    }

    func getUserInfoRequest(completion: @escaping(Result<UserInfoModel?, Error>) -> Void) {
        let headers = HTTPHeaders(["Authorization": Network.token])
        request(api: .userInfo, type: UserInfoModel.self, headers: headers, completion: completion)
    }

    func reportAppointmentRequest(appointmentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        let headers = HTTPHeaders(["Authorization": Network.token])
        request(api: .reportAppointment(appointmentID: appointmentID), headers: headers, completion: completion)
    }

    func deleteAppointmentRequest(appointmentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        let headers = HTTPHeaders(["Authorization": Network.token])
        request(api: .deleteAppointment(appointmentID: appointmentID), headers: headers, completion: completion)
    }

    func reportCommentRequest(appointmentID: Int, commentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        let headers = HTTPHeaders(["Authorization": Network.token])
        request(api: .reportComment(appointmentID: appointmentID, commentID: commentID), headers: headers, completion: completion)
    }

    func reportReplyRequest(appointmentID: Int, commentID: Int, replyID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        let headers = HTTPHeaders(["Authorization": Network.token])
        request(api: .reportReply(appointmentID: appointmentID, commentID: commentID, replyID: replyID), headers: headers, completion: completion)
    }

    func deleteCommentRequest(appointmentID: Int, commentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        let headers = HTTPHeaders(["Authorization": Network.token])
        request(api: .deleteComment(appointmentID: appointmentID, commentID: commentID), headers: headers, completion: completion)
    }

    func deleteReplyRequest(appointmentID: Int, commentID: Int, replyID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        let headers = HTTPHeaders(["Authorization": Network.token])
        request(api: .deleteReply(appointmentID: appointmentID, commentID: commentID, replyID: replyID), headers: headers, completion: completion)
    }

}

extension Network {

    private func request<E: Encodable, D: Decodable>(api: API, type: D.Type, parameter: E, encoder: ParameterEncoder = JSONParameterEncoder(), headers: HTTPHeaders? = nil, completion: @escaping (Result<D?, Error>) -> Void) {

        session?.request(api.path, method: api.method, parameters: parameter, encoder: encoder, headers: headers).response { [weak self] response in
            switch response.result {
            case .success(let data):
                let jsonData = self?.decodeJSONData(data: data, type: type)
                completion(.success(jsonData))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    private func request<D: Decodable>(api: API, type: D.Type, parameters: Parameters? = nil, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<D?, Error>) -> Void) {

        session?.request(api.path, method: api.method, parameters: parameters, headers: headers).response { [weak self] response in
            print(response.debugDescription)
            switch response.result {
            case .success(let data):
                let jsonData = self?.decodeJSONData(data: data, type: type)
                completion(.success(jsonData))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    private func request(api: API, parameters: Parameters? = nil, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<Void?, Error>) -> Void) {

        session?.request(api.path, method: api.method, parameters: parameters, headers: headers).response { response in
            print(response.debugDescription)
            switch response.result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    private func decodeJSONData<D: Decodable>(data: Data?, type: D.Type) -> D? {
        let decoder = JSONDecoder()
        guard let data = data, let jsonData = try? decoder.decode(type, from: data) else { return nil }
        return jsonData
    }

    private func request(api: API, completion: @escaping (Result<Bool, Error>) -> Void) {
        session?.request(api.path).response { response in
            switch response.result {
            case .success(let data):
                if let data = data, let isValid = String(decoding: data, as: UTF8.self).bool {
                    completion(.success(isValid))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

}

extension String {
    fileprivate var bool: Bool? {
        switch self.lowercased() {
        case "true":
            return true
        case "false" :
            return false
        default:
            return nil
        }
    }
}
