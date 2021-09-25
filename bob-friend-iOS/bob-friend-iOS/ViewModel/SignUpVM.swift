//
//  SignUpVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/09/16.
//

import Foundation

class SignUpVM {

    let network: Network = Network()
    weak var delegate: SignUpDelegate?

    var checkedEmail: String?
    var checkedNickname: String?

    func checkEmail(email: String) {
        if !isEmailForm(email) {
            delegate?.emailRequireValidForm()
            return
        }

        network.checkEmailDuplicationRequest(email: email) { [weak self] result in
            switch result {
            case .success(let data):
                if let data = data {
                    let resultStr = String(decoding: data, as: UTF8.self)
                    switch resultStr {
                    case "true":
                        self?.checkedEmail = nil
                        self?.delegate?.emailDidDuplicate(true)
                    case "false":
                        self?.checkedEmail = email
                        self?.delegate?.emailDidDuplicate(false)
                    default:
                        break
                    }
                }
            case .failure:
                self?.checkedEmail = nil
                self?.delegate?.errorOccured()
            }
        }

    }

    func checkNickname(nickname: String) {

        network.checkNicknameDuplicationRequest(nickname: nickname) { [weak self] result in
            switch result {
            case .success(let data):
                if let data = data {
                    let resultStr = String(decoding: data, as: UTF8.self)
                    switch resultStr {
                    case "true":
                        self?.checkedNickname = nil
                        self?.delegate?.nicknameDidDuplicate(true)
                    case "false":
                        self?.checkedNickname = nickname
                        self?.delegate?.nicknameDidDuplicate(false)
                    default:
                        break
                    }
                }
            case .failure:
                self?.checkedNickname = nil
                self?.delegate?.errorOccured()
            }
        }

    }

    func signUp(email: String, nickname: String, password: String, passwordCheck: String, birth: String, gender: Gender, agree: Bool) {

        let isValidParams: Bool = checkValidationForSignUp(email: email, nickname: nickname, password: password, passwordCheck: passwordCheck, birth: birth, gender: gender, agree: agree)

        if !isValidParams { return }

        let birth = generateBirth(birth)

        let signUpModel: SignUpModel = SignUpModel(email: email, nickname: nickname, password: password, sex: gender, birth: birth, agree: agree)

        network.signUpRequest(signUpInfo: signUpModel) { result in
            switch result {
            case .success:
                self.delegate?.didSuccessSignUp(true)
            case .failure:
                self.delegate?.didSuccessSignUp(false)
            }
        }

    }

    private func isEmailForm(_ email: String) -> Bool {
        let emailPattern = "^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*.[a-zA-Z]$"
        let regex = try? NSRegularExpression(pattern: emailPattern)
        if let _ = regex?.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) { return true }
        return false
    }

    private func generateBirth(_ birthStr: String) -> String {
        let birth = String(birthStr.prefix(4)) + "-" + String(birthStr.prefix(6).suffix(2)) + "-" + String(birthStr.suffix(2))
        return birth
    }

    private func checkValidationForSignUp(email: String, nickname: String, password: String, passwordCheck: String, birth: String, gender: Gender, agree: Bool) -> Bool {
        var isValid: Bool = true

        if !isSameParmaAndCheckedParam(param: email, checkedParam: checkedEmail) { // 실패 -> 중복검사 받은 이메일이 아니다
            isValid = false
            delegate?.emailDidCheckForSignUp(false)
        } else { delegate?.emailDidCheckForSignUp(true) }

        if !isSameParmaAndCheckedParam(param: nickname, checkedParam: checkedNickname) { // 실패 -> 중복검사 받은 유저네임이 아니다
            isValid = false
            delegate?.nicknameDidCheckForSignUp(false)
        } else { delegate?.nicknameDidCheckForSignUp(true) }

        if !isValidPassword(password) { // 실패 -> 비밀번호가 부적합하다.
            isValid = false
            delegate?.passwordValidataionDidCheckForSignUp(false)
        } else { delegate?.passwordValidataionDidCheckForSignUp(true) }

        if !isSamePasswordAndPasswordCheck(password, passwordCheck) { // 실패 -> 비밀번호 확인이 비밀번호와 다르다
            isValid = false
            delegate?.passwordDidCheckSameForSignUp(false)
        } else { delegate?.passwordDidCheckSameForSignUp(true) }

        if !isValidDate(birth) { // 실패 -> 생년월일이 정해진 포맷의 날짜로 주어지지 않았다.
            isValid = false
            delegate?.birthValidationDidCheckForSignUp(false)
        } else { delegate?.birthValidationDidCheckForSignUp(true) }

        if !agree { // 실패 -> 동의를 안 했다.
            isValid = false
            delegate?.agreementDidCheck(false)
        } else { delegate?.agreementDidCheck(true) }

        return isValid
    }

    private func isSameParmaAndCheckedParam(param: String, checkedParam: String?) -> Bool {
        guard let checkedParam = checkedParam else { return false }
        if checkedParam != param { return false }
        return true
    }

    private func isValidPassword(_ password: String) -> Bool {

        if password.count < 8 { return false }

        let passwordPattern = "^[0-9a-zA-Z!@#$%]*$"
        let regex = try? NSRegularExpression(pattern: passwordPattern)
        guard let _ = regex?.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) else { return false }

        let regexNumber = try? NSRegularExpression(pattern: "[0-9]")
        guard let _ = regexNumber?.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) else { return false }

        let regexAlphabet = try? NSRegularExpression(pattern: "[a-zA-Z]")
        guard let _ = regexAlphabet?.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) else { return false }

        let regexSpecialChar = try? NSRegularExpression(pattern: "[!@#$%]")
        guard let _ = regexSpecialChar?.firstMatch(in: password, options: [], range: NSRange(location: 0, length: password.count)) else { return false }

        return true
    }

    private func isSamePasswordAndPasswordCheck(_ password: String, _ passwordCheck: String) -> Bool {
        if password == passwordCheck { return true }
        return false
    }

    private func isValidDate(_ inputDateString: String) -> Bool {
        if inputDateString == "" { return false }
        // yyyyMMdd
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        if let _ = dateFormatter.date(from: inputDateString) {
            return true
        } else { return false }
    }

}

protocol SignUpDelegate: AnyObject {

    func emailRequireValidForm()
    func emailDidDuplicate(_ didDuplicate: Bool)

    func nicknameDidDuplicate(_ didDuplicate: Bool)

    func emailDidCheckForSignUp(_ didChecked: Bool)
    func nicknameDidCheckForSignUp(_ didChecked: Bool)
    func passwordValidataionDidCheckForSignUp(_ isValid: Bool)
    func passwordDidCheckSameForSignUp(_ isSamePasswordAndPasswordCheck: Bool)
    func birthValidationDidCheckForSignUp(_ isValid: Bool)
    func agreementDidCheck(_ didAgree: Bool)

    func didSuccessSignUp(_ didSuccess: Bool)

    func errorOccured()

}
