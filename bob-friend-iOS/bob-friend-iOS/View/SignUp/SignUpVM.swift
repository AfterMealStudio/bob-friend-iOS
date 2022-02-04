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
        guard email.isEmailForm else {
            delegate?.showNotice(.notEmailForm)
            return
        }

        network.checkEmailDuplicationRequest(email: email) { [weak self] result in
            switch result {
            case .success(let duplicationData):
                if duplicationData?.exist == false {
                    self?.checkedEmail = email
                    self?.delegate?.showNotice(.validEmail)
                } else {
                    self?.checkedEmail = nil
                    self?.delegate?.showNotice(.duplicateEmail)
                }
            case .failure:
                self?.checkedEmail = nil
                self?.delegate?.occuredNetworkError()
            }
        }

    }

    func resetEmail() {
        checkedEmail = nil
    }

    func checkNickname(nickname: String) {

        network.checkNicknameDuplicationRequest(nickname: nickname) { [weak self] result in
            switch result {
            case .success(let duplicationData):
                if duplicationData?.exist == false {
                    self?.checkedNickname = nickname
                    self?.delegate?.showNotice(.validNickname)
                } else {
                    self?.checkedNickname = nil
                    self?.delegate?.showNotice(.duplicateNickname)
                }
            case .failure:
                self?.checkedEmail = nil
                self?.delegate?.occuredNetworkError()
            }
        }

    }

    func signUp(email: String, nickname: String, password: String, passwordCheck: String, birth: String, gender: Gender, agree: Bool) {

        let isValidParams: Bool = checkValidationForSignUp(email: email, nickname: nickname, password: password, passwordCheck: passwordCheck, birth: birth, gender: gender, agree: agree)

        if !isValidParams { return }

        let birth = generateBirth(birth)

        let signUpModel: SignUpModel = SignUpModel(email: email, nickname: nickname, password: password, sex: gender, birth: birth, agree: agree)

        delegate?.didStartLoading()
        network.signUpRequest(signUpInfo: signUpModel) { [weak self] result in
            self?.delegate?.didStopLoading()

            switch result {
            case .success:
                self?.delegate?.didSuccessSignUp(true)
            case .failure:
                self?.delegate?.didSuccessSignUp(false)
            }
        }

    }

    private func generateBirth(_ birthStr: String) -> String {
        let birth = String(birthStr.prefix(4)) + "-" + String(birthStr.prefix(6).suffix(2)) + "-" + String(birthStr.suffix(2))
        return birth
    }

    private func checkValidationForSignUp(email: String, nickname: String, password: String, passwordCheck: String, birth: String, gender: Gender, agree: Bool) -> Bool {
        var isValid: Bool = true

        if email != checkedEmail { // 실패 -> 중복검사 받은 이메일이 아니다
            isValid = false
            delegate?.showNotice(.notCheckedEmail)
        } else { delegate?.showNotice(.checkedEmail) }

        if nickname != checkedNickname { // 실패 -> 중복검사 받은 유저네임이 아니다
            isValid = false
            delegate?.showNotice(.notCheckedNickname)
        } else { delegate?.showNotice(.checkedNickname) }

        if !password.isPasswordForm { // 실패 -> 비밀번호가 부적합하다.
            isValid = false
            delegate?.showNotice(.invalidPassword)
        } else { delegate?.showNotice(.validPassword) }

        if password != passwordCheck { // 실패 -> 비밀번호 확인이 비밀번호와 다르다
            isValid = false
            delegate?.showNotice(.notSamePasswordAndPasswordCheck)
        } else { delegate?.showNotice(.samePasswordAndPasswordCheck) }

        if !birth.isDateForm { // 실패 -> 생년월일이 정해진 포맷의 날짜로 주어지지 않았다.
            isValid = false
            delegate?.showNotice(.notBirthdayForm)
        } else { delegate?.showNotice(.validBrith) }

        if !agree { // 실패 -> 동의를 안 했다.
            isValid = false
        } else {
            // TODO: 동의 했을 때 이벤트
        }

        return isValid
    }

}

protocol SignUpDelegate: AnyObject {
    func showNotice(_ notice: SignUpNotice)
    func didSuccessSignUp(_ didSuccess: Bool)
    func occuredNetworkError()

    func didStartLoading()
    func didStopLoading()
}

enum SignUpNotice {
    case blankEmail
    case notEmailForm
    case validEmail
    case duplicateEmail
    case blankNickname
    case validNickname
    case duplicateNickname
    case notCheckedEmail
    case checkedEmail
    case notCheckedNickname
    case checkedNickname
    case invalidPassword
    case validPassword
    case notSamePasswordAndPasswordCheck
    case samePasswordAndPasswordCheck
    case notBirthdayForm
    case validBrith

    var message: String {
        switch self {
        case .blankEmail: return "이메일 주소를 입력해주세요."
        case .notEmailForm: return "이메일 형식에 맞게 써 주세요."
        case .validEmail: return "사용 가능한 이메일입니다."
        case .duplicateEmail: return "중복된 이메일입니다."
        case .blankNickname: return "사용할 닉네임을 입력해주세요."
        case .validNickname: return "사용 가능한 닉네임입니다."
        case .duplicateNickname: return "중복된 닉네임입니다."
        case .notCheckedEmail: return "이메일 중복검사를 받으세요."
        case .checkedEmail: return ""
        case .notCheckedNickname: return "닉네임 중복검사를 받으세요."
        case .checkedNickname: return ""
        case .invalidPassword: return "영어, 숫자, 특수문자(!@#$%)를 포함하여 8자 이상이어야 합니다."
        case .validPassword: return ""
        case .notSamePasswordAndPasswordCheck: return "비밀번호와 다릅니다."
        case .samePasswordAndPasswordCheck: return ""
        case .notBirthdayForm: return "yyyyMMdd의 형식으로 올바른 날짜를 입력해주세요. ex) 19900101"
        case .validBrith: return ""
        }
    }

    var isValidate: Bool {
        switch  self {
        case .blankEmail: return false
        case .notEmailForm: return false
        case .validEmail: return true
        case .duplicateEmail: return false
        case .blankNickname: return false
        case .validNickname: return true
        case .duplicateNickname: return false
        case .notCheckedEmail: return false
        case .checkedEmail: return true
        case .notCheckedNickname: return false
        case .checkedNickname: return true
        case .invalidPassword: return false
        case .validPassword: return true
        case .notSamePasswordAndPasswordCheck: return false
        case .samePasswordAndPasswordCheck: return true
        case .notBirthdayForm: return false
        case .validBrith: return true
        }
    }
}
