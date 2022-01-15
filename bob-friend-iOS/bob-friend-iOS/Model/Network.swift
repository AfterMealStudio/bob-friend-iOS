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

    static var accessToken: String = ""
    static var refreshToken: String = ""

    private enum API {
        case tokenRefresh
        case login
        case checkEmailDuplication(email: String)
        case checkNicknameDuplication(nickname: String)
        case signup
        case kakaoKeywordSearch
        case appointmentList
        case searchAppointmentList
        case appointment(id: Int)
        case enrollComment(appointmentID: Int)
        case enrollReply(appointmentID: Int, commentID: Int)
        case userInfo
        case reportAppointment(appointmentID: Int)
        case deleteAppointment(appointmentID: Int)
        case reportComment(appointmentID: Int, commentID: Int)
        case reportReply(appointmentID: Int, commentID: Int, replyID: Int)
        case deleteComment(appointmentID: Int, commentID: Int)
        case deleteReply(appointmentID: Int, commentID: Int, replyID: Int)
        case closeAppointment(appointmentID: Int)
        case joinOrCancelAppointment(appointmentID: Int)
        case enrollAppointment

        var path: String {
            let baseUrl: String = "http://117.17.102.143:8080/"
            let kakaoKeywordSearchUrl = "https://dapi.kakao.com/v2/local/search/keyword.json"

            switch self {
            case .tokenRefresh:
                return baseUrl + "api/issue"
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
            case .searchAppointmentList:
                return baseUrl + "recruitments/search"
            case .appointment(let id):
                return baseUrl + "recruitments/\(id)"
            case .enrollComment(appointmentID: let id):
                return baseUrl + "recruitments/\(id)/comments"
            case .enrollReply(appointmentID: let appointmentID, commentID: let commentID):
                return baseUrl + "recruitments/\(appointmentID)/comments/\(commentID)/replies"
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
            case .closeAppointment(appointmentID: let appointmentID):
                return baseUrl + "recruitments/\(appointmentID)/close"
            case .joinOrCancelAppointment(appointmentID: let appointmentID):
                return baseUrl + "recruitments/\(appointmentID)"
            case .enrollAppointment:
                return baseUrl + "recruitments"
            }
        }

        var method: HTTPMethod {
            switch self {
            case .tokenRefresh: return .post
            case .login: return .post
            case .checkEmailDuplication(email: _): return .get
            case .checkNicknameDuplication(nickname: _): return .get
            case .signup: return .post
            case .kakaoKeywordSearch: return .get
            case .appointmentList: return .get
            case .searchAppointmentList: return .get
            case .appointment(id: _): return .get
            case .enrollComment(appointmentID: _): return .post
            case .enrollReply(appointmentID: _): return .post
            case .userInfo: return .get
            case .reportAppointment(appointmentID: _): return .patch
            case .deleteAppointment(appointmentID: _): return .delete
            case .reportComment(appointmentID: _, commentID: _): return .patch
            case .reportReply(appointmentID: _, commentID: _, replyID: _): return .patch
            case .deleteComment(appointmentID: _, commentID: _): return .delete
            case .deleteReply(appointmentID: _, commentID: _, replyID: _): return .delete
            case .closeAppointment(appointmentID: _): return .patch
            case .joinOrCancelAppointment(appointmentID: _): return .patch
            case .enrollAppointment: return .post
            }
        }

    }

    func tokenRefreshRequest(completion: @escaping () -> Void) {
        let tokenInfo = TokenModel(accessToken: Network.accessToken, refreshToken: Network.refreshToken)
        request(api: .tokenRefresh, type: TokenModel.self, parameter: tokenInfo, completion: { response in

            switch response {
            case .success(let data):

                guard let token = data else { return }

                let tokenRepository = TokenRepositoryImpl()
                tokenRepository.saveToken(token: token)
                completion()

            case .failure:
                return

            }

        })
    }

    func loginRequest(loginInfo: LoginModel, completion: @escaping (Result<TokenModel?, Error>) -> Void) {
        request(api: API.login, type: TokenModel.self, parameter: loginInfo) { result in
            completion(result)
        }
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

        request(api: .kakaoKeywordSearch, type: KakaoKeywordSearchResultModel.self, parameter: parameters, headers: headers, completion: completion)
    }

    func getAppointmentListRequest(page: Int = 0, type: AppointmentGetRequestType, completion: @escaping(Result<AppointmentListModel?, Error>) -> Void) {
        let parameters: Parameters = ["page": page, "type": type]
        requestWithAuth(api: .appointmentList, type: AppointmentListModel.self, parameter: parameters, completion: completion)
    }

    func getSearchAppointmentListRequest(searchWord: String, selectedTime: (String, String)?, onlyEnterable: Bool, category: SearchCategory, page: Int = 0, completion: @escaping(Result<AppointmentListModel?, Error>) -> Void) {
        var parameters: Parameters = ["page": page, "category": category, "keyword": searchWord]
        if let selectedTime = selectedTime {
            parameters.updateValue(selectedTime.0, forKey: "start")
            parameters.updateValue(selectedTime.1, forKey: "end")
        }
        if onlyEnterable {
            parameters.updateValue("available", forKey: "type")
        }
        requestWithAuth(api: .searchAppointmentList, type: AppointmentListModel.self, parameter: parameters, completion: completion)
    }

    func getAppointment(_ appointmentID: Int, completion: @escaping(Result<AppointmentModel?, Error>) -> Void) {
        requestWithAuth(api: .appointment(id: appointmentID), type: AppointmentModel.self) { result in
            completion(result)
        }
    }

    func enrollCommentRequest(appointmentID: Int, comment: EnrollCommentModel, completion: @escaping(Result<EnrollCommentResponseModel?, Error>) -> Void) {
        requestWithAuth(api: API.enrollComment(appointmentID: appointmentID), type: EnrollCommentResponseModel.self, parameter: comment, completion: completion)
    }

    func enrollReplyRequest(appointmentID: Int, commentID: Int, comment: EnrollCommentModel, completion: @escaping(Result<EnrollCommentResponseModel?, Error>) -> Void) {
        requestWithAuth(api: API.enrollReply(appointmentID: appointmentID, commentID: commentID), type: EnrollCommentResponseModel.self, parameter: comment, completion: completion)
    }

    func getUserInfoRequest(completion: @escaping(Result<UserInfoModel?, Error>) -> Void) {
        requestWithAuth(api: .userInfo, type: UserInfoModel.self, completion: completion)
    }

    func reportAppointmentRequest(appointmentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: .reportAppointment(appointmentID: appointmentID), completion: completion)
    }

    func deleteAppointmentRequest(appointmentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: .deleteAppointment(appointmentID: appointmentID), completion: completion)
    }

    func reportCommentRequest(appointmentID: Int, commentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: .reportComment(appointmentID: appointmentID, commentID: commentID), completion: completion)
    }

    func reportReplyRequest(appointmentID: Int, commentID: Int, replyID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: .reportReply(appointmentID: appointmentID, commentID: commentID, replyID: replyID), completion: completion)
    }

    func deleteCommentRequest(appointmentID: Int, commentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: .deleteComment(appointmentID: appointmentID, commentID: commentID), completion: completion)
    }

    func deleteReplyRequest(appointmentID: Int, commentID: Int, replyID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: .deleteReply(appointmentID: appointmentID, commentID: commentID, replyID: replyID), completion: completion)
    }

    func closeAppointmentRequest(appointmentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: .closeAppointment(appointmentID: appointmentID), completion: completion)
    }

    func joinOrCancelAppointmentRequest(appointmentID: Int, completion: @escaping(Result<AppointmentModel?, Error>) -> Void) {
        requestWithAuth(api: .joinOrCancelAppointment(appointmentID: appointmentID), type: AppointmentModel.self, completion: completion)
    }

    func enrollAppointment(appointment: AppointmentEnrollModel, completion: @escaping(Result<AppointmentModel?, Error>) -> Void) {
        requestWithAuth(api: .enrollAppointment, type: AppointmentModel.self, parameter: appointment, completion: completion)
    }

}

extension Network {

    private func request<E: Encodable, D: Decodable>(api: API, type: D.Type, parameter: E, encoder: ParameterEncoder = JSONParameterEncoder(), headers: HTTPHeaders? = nil, completion: @escaping (Result<D?, Error>) -> Void) {

        session?.request(api.path, method: api.method, parameters: parameter, encoder: encoder, headers: headers).response { [weak self] response in
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

    private func request<D: Decodable>(api: API, type: D.Type, parameter: Parameters? = nil, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<D?, Error>) -> Void) {

        session?.request(api.path, method: api.method, parameters: parameter, headers: headers).response { [weak self] response in
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

    private func request(api: API, parameter: Parameters? = nil, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<Void?, Error>) -> Void) {

        session?.request(api.path, method: api.method, parameters: parameter, headers: headers).response { response in
            print(response.debugDescription)
            switch response.result {
            case .success:
                completion(.success(Void()))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    private func requestWithAuth<E: Encodable, D: Decodable>(api: API, type: D.Type, parameter: E, encoder: ParameterEncoder = JSONParameterEncoder(), headers: HTTPHeaders? = nil, completion: @escaping (Result<D?, Error>) -> Void) {

        var headers = headers
        if headers == nil { headers = HTTPHeaders() }
        let accessToken = HTTPHeader(name: "Authorization", value: Network.accessToken)
        headers?.add(accessToken)

        session?.request(api.path, method: api.method, parameters: parameter, encoder: encoder, headers: headers).response { [weak self] response in
            print(response.debugDescription)

            if response.response?.statusCode == 403 {
                self?.tokenRefreshRequest {
                    self?.requestWithAuth(api: api, type: type, parameter: parameter, encoder: encoder, headers: headers, completion: completion)
                }
                return
            }

            switch response.result {
            case .success(let data):
                let jsonData = self?.decodeJSONData(data: data, type: type)
                completion(.success(jsonData))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    private func requestWithAuth<D: Decodable>(api: API, type: D.Type, parameter: Parameters? = nil, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<D?, Error>) -> Void) {

        var headers = headers
        if headers == nil { headers = HTTPHeaders() }
        let accessToken = HTTPHeader(name: "Authorization", value: Network.accessToken)
        headers?.add(accessToken)

        session?.request(api.path, method: api.method, parameters: parameter, headers: headers).response { [weak self] response in
            print(response.debugDescription)

            if response.response?.statusCode == 403 {
                self?.tokenRefreshRequest {
                    self?.requestWithAuth(api: api, type: type, parameter: parameter, encoder: encoder, headers: headers, completion: completion)
                }
                return
            }

            switch response.result {
            case .success(let data):
                let jsonData = self?.decodeJSONData(data: data, type: type)
                completion(.success(jsonData))
            case .failure(let error):
                completion(.failure(error))
            }
        }

    }

    private func requestWithAuth(api: API, parameter: Parameters? = nil, encoder: ParameterEncoder = URLEncodedFormParameterEncoder.default, headers: HTTPHeaders? = nil, completion: @escaping (Result<Void?, Error>) -> Void) {

        var headers = headers
        if headers == nil { headers = HTTPHeaders() }
        let accessToken = HTTPHeader(name: "Authorization", value: Network.accessToken)
        headers?.add(accessToken)

        session?.request(api.path, method: api.method, parameters: parameter, headers: headers).response { [weak self] response in
            print(response.debugDescription)

            if response.response?.statusCode == 403 {
                self?.tokenRefreshRequest {
                    self?.requestWithAuth(api: api, parameter: parameter, encoder: encoder, headers: headers, completion: completion)
                }
                return
            }

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
