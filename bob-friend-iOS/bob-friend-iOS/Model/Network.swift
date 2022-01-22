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

    func tokenRefreshRequest(completion: @escaping () -> Void) {
        let tokenInfo = TokenModel(accessToken: Network.accessToken, refreshToken: Network.refreshToken)
        request(api: AuthAPI.reissueToken, type: TokenModel.self, parameter: tokenInfo, completion: { response in

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
        request(api: AuthAPI.signIn, type: TokenModel.self, parameter: loginInfo) { result in
            completion(result)
        }
    }

    func checkEmailDuplicationRequest(email: String, completion: @escaping (Result<DuplicationCheckResultModel?, Error>) -> Void) {
        request(api: UserAPI.checkEmailIsUsing(email: email), type: DuplicationCheckResultModel.self, completion: completion)
    }

    func checkNicknameDuplicationRequest(nickname: String, completion: @escaping (Result<DuplicationCheckResultModel?, Error>) -> Void) {
        request(api: UserAPI.checkNicknameIsUsing(nickname: nickname), type: DuplicationCheckResultModel.self, completion: completion)
    }

    func signUpRequest(signUpInfo: SignUpModel, completion: @escaping (Result<SignUpResponseModel?, Error>) -> Void) {
        request(api: AuthAPI.signUp, type: SignUpResponseModel.self, parameter: signUpInfo, completion: completion)
    }

    // TODO: 카카오 앱키 관리
    func kakaoKeywordSearchRequest(keyword: String, page: Int, completion: @escaping (Result<KakaoKeywordSearchResultModel?, Error>) -> Void) {
        let kakaoRestAPIKey = "3136b32531da9ba1c20a78ea3457e50d"
        let parameters: Parameters = ["query": keyword, "page": page, "size": 15]
        let headers = HTTPHeaders(["Authorization": "KakaoAK \(kakaoRestAPIKey)"])

        request(api: KakaoKeywordSearchAPI.search, type: KakaoKeywordSearchResultModel.self, parameter: parameters, headers: headers, completion: completion)
    }

    func getAppointmentListRequest(page: Int = 0, type: AppointmentGetRequestType, completion: @escaping(Result<AppointmentListModel?, Error>) -> Void) {
        let parameters: Parameters = ["page": page, "type": type]
        requestWithAuth(api: AppointmentAPI.getAppointments, type: AppointmentListModel.self, parameter: parameters, completion: completion)
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
        requestWithAuth(api: AppointmentAPI.searchAppointments, type: AppointmentListModel.self, parameter: parameters, completion: completion)
    }

    func getAppointment(_ appointmentID: Int, completion: @escaping(Result<AppointmentModel?, Error>) -> Void) {
        requestWithAuth(api: AppointmentAPI.getAppointment(id: appointmentID), type: AppointmentModel.self) { result in
            completion(result)
        }
    }

    func enrollCommentRequest(appointmentID: Int, comment: EnrollCommentModel, completion: @escaping(Result<EnrollCommentResponseModel?, Error>) -> Void) {
        requestWithAuth(api: CommentAPI.createComment(appointmentID: appointmentID), type: EnrollCommentResponseModel.self, parameter: comment, completion: completion)
    }

    func enrollReplyRequest(appointmentID: Int, commentID: Int, comment: EnrollCommentModel, completion: @escaping(Result<EnrollCommentResponseModel?, Error>) -> Void) {
        requestWithAuth(api: CommentAPI.createRecomment(appointmentID: appointmentID, commentID: commentID), type: EnrollCommentResponseModel.self, parameter: comment, completion: completion)
    }

    func getMyUserInfoRequest(completion: @escaping(Result<UserInfoModel?, Error>) -> Void) {
        requestWithAuth(api: UserAPI.getMyUserInfo, type: UserInfoModel.self, completion: completion)
    }

    func reportAppointmentRequest(appointmentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: AppointmentAPI.reportAppointment(id: appointmentID), completion: completion)
    }

    func deleteAppointmentRequest(appointmentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: AppointmentAPI.deleteAppointment(id: appointmentID), completion: completion)
    }

    func reportCommentRequest(appointmentID: Int, commentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: CommentAPI.reportComments(appointmentID: appointmentID, commentID: commentID), completion: completion)
    }

    func reportReplyRequest(appointmentID: Int, commentID: Int, replyID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: CommentAPI.reportRecomment(appointmentID: appointmentID, commentID: commentID, recommentID: replyID), completion: completion)
    }

    func deleteCommentRequest(appointmentID: Int, commentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: CommentAPI.deleteComment(appointmentID: appointmentID, commentID: commentID), completion: completion)
    }

    func deleteReplyRequest(appointmentID: Int, commentID: Int, replyID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: CommentAPI.deleteRecomment(appointmentID: appointmentID, commentID: commentID, recommentID: replyID), completion: completion)
    }

    func closeAppointmentRequest(appointmentID: Int, completion: @escaping(Result<Void?, Error>) -> Void) {
        requestWithAuth(api: AppointmentAPI.closeAppointment(id: appointmentID), completion: completion)
    }

    func joinOrCancelAppointmentRequest(appointmentID: Int, completion: @escaping(Result<AppointmentModel?, Error>) -> Void) {
        requestWithAuth(api: AppointmentAPI.joinAppointment(id: appointmentID), type: AppointmentModel.self, completion: completion)
    }

    func enrollAppointment(appointment: AppointmentEnrollModel, completion: @escaping(Result<AppointmentModel?, Error>) -> Void) {
        requestWithAuth(api: AppointmentAPI.createAppointment, type: AppointmentModel.self, parameter: appointment, completion: completion)
    }

    func withdrawalMembership(password: String, completion: @escaping(Result<Void?, Error>) -> Void) {
        let data = WithdrawalMembershipModel(password: password)
        requestWithAuth(api: UserAPI.deleteUser, parameter: data) { _ in

        }
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

    private func requestWithAuth<E: Encodable>(api: API, parameter: E, encoder: ParameterEncoder = JSONParameterEncoder(), headers: HTTPHeaders? = nil, completion: @escaping (Result<Void?, Error>) -> Void) {

        var headers = headers
        if headers == nil { headers = HTTPHeaders() }
        let accessToken = HTTPHeader(name: "Authorization", value: Network.accessToken)
        headers?.add(accessToken)

        session?.request(api.path, method: api.method, parameters: parameter, encoder: encoder, headers: headers).response { [weak self] response in
            print(response.debugDescription)

            if response.response?.statusCode == 401 {
                self?.tokenRefreshRequest {
                    self?.requestWithAuth(api: api, parameter: parameter, encoder: encoder, headers: headers, completion: completion)
                }
                return
            }

            switch response.result {
            case .success:
                if let statusCode = response.response?.statusCode, statusCode >= 200 && statusCode < 300 {
                    completion(.success(Void()))
                }
                completion(.failure(ResponedError.error))
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

            if response.response?.statusCode == 401 {
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

            if response.response?.statusCode == 401 {
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

            if response.response?.statusCode == 401 {
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
