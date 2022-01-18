//
//  MyPageVM.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/16.
//

import Foundation

class MyPageVM {

    weak var delegate: MyPageDelegate?
    let network: Network = Network()

    var sections: [SectionRowData] = []

    init() {
        sections = [SectionRowData(self), AppointmentSection(self), AccountSection(self), ServiceSection(self)]
    }

    func getMyProfile() {
        delegate?.startLoading()
        network.getUserInfoRequest { [weak self] result in
            self?.delegate?.stopLoading()
            switch result {
            case .success(let userInfo):
                if let userInfo = userInfo {
                    self?.delegate?.didGetUserInfo(userInfo: userInfo)
                }
            case .failure:
                break
            }

        }
    }

    func logout() {
        Network.refreshToken = ""
        Network.accessToken = ""

        UserInfo.myInfo = nil
    }

}

// MARK: - Sections
extension MyPageVM {

    class SectionRowData {

        unowned let parent: MyPageVM

        var sectionTitle: String? { return nil }
        var rows: [(String, () -> Void)] { return [] }
        var rowAmount: Int { return self.rows.count }

        init(_ parent: MyPageVM) {
            self.parent = parent
        }

        func selectedEvent(row: Int) {
            rows[row].1()
        }
    }

    class AppointmentSection: SectionRowData {
        override var sectionTitle: String? { return "약속" }
        override var rows: [(String, () -> Void)] {
            return [("내가 만든 약속", toOwnedAppointments),
                    ("참가한 약속", toJoinedAppointments)]
        }

        func toOwnedAppointments() {
            parent.delegate?.toOwnedAppointments()
        }

        func toJoinedAppointments() {
            parent.delegate?.toJoinedAppointments()
        }

    }

    class AccountSection: SectionRowData {
        override var sectionTitle: String? { return "계정" }
        override var rows: [(String, () -> Void)] {
            return [("회원 정보 수정", toEditUserInfo),
                    ("정보 동의 설정", toSetAgreement),
                    ("알림 설정", toSetAlert),
                    ("로그아웃", toLogout),
                    ("회원탈퇴", toMembershipWithdrawal)]
        }

        func toEditUserInfo() {
            parent.delegate?.toEditUserInfo()
        }

        func toSetAgreement() {
            parent.delegate?.toSetAgreement()
        }

        func toSetAlert() {
            parent.delegate?.toSetAlert()
        }

        func toLogout() {
            parent.delegate?.toLogout()
        }

        func toMembershipWithdrawal() {
            parent.delegate?.toMembershipWithdrawal()
        }

    }

    class ServiceSection: SectionRowData {
        override var sectionTitle: String? { return "기타" }
        override var rows: [(String, () -> Void)] {
            return [("오픈소스 라이선스", toOpenSourceLicense),
                    ("서비스 이용약관", toTermsAndConditions),
                    ("개인정보 처리방침", toPrivacyPolicy),
                    ("문의하기", toContactUs)]
        }

        func toOpenSourceLicense() {
            parent.delegate?.toOpenSourceLicense()
        }

        func toTermsAndConditions() {
            parent.delegate?.toTermsAndConditions()
        }

        func toPrivacyPolicy() {
            parent.delegate?.toPrivacyPolicy()
        }

        func toContactUs() {
            parent.delegate?.toContactUs()
        }

    }

}

// MARK: - MyPageDelegate Protocol
protocol MyPageDelegate: AnyObject {
    func startLoading()
    func stopLoading()

    func didGetUserInfo(userInfo: UserInfoModel)

    func toOwnedAppointments()
    func toJoinedAppointments()

    func toEditUserInfo()
    func toSetAgreement()
    func toSetAlert()
    func toLogout()
    func toMembershipWithdrawal()

    func toOpenSourceLicense()
    func toTermsAndConditions()
    func toPrivacyPolicy()
    func toContactUs()

}
