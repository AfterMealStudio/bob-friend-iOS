//
//  MyPageVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/14.
//

import UIKit

class MyPageVC: UIViewController {

    let myPageTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UITableView(frame: .zero, style: .grouped))

    let loadingView: LoadingView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(LoadingView())

    let myPageVM: MyPageVM = MyPageVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "MainColor1")

        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = UIColor(named: "MainColor1")
        navigationAppearance.titleTextAttributes =  [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationAppearance

        setMyPageTableView()
        layout()

        myPageVM.delegate = self
        myPageVM.getMyProfile()
    }

}

// MARK: - layout
extension MyPageVC {

    private func layout() {

        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(myPageTableView)
        NSLayoutConstraint.activate([
            myPageTableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            myPageTableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            myPageTableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            myPageTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

    }

}

// MARK: - myPageTableView
extension MyPageVC {

    private func setMyPageTableView() {
        myPageTableView.delegate = self
        myPageTableView.dataSource = self

        myPageTableView.separatorStyle = .none

        registTableView()
    }

    private func registTableView() {
        myPageTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeader")
        myPageTableView.register(MyPageTableViewCell.self, forCellReuseIdentifier: "MyPageTableViewCell")
    }

}

// MARK: - TableView Delegate
extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Section(rawValue: section)?.itemCount ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageTableViewCell") as? MyPageTableViewCell else { return UITableViewCell() }

        cell.title = Section(rawValue: indexPath.section)?.items[indexPath.row]

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedIndex = tableView.indexPathForSelectedRow
        if let selectedIndex = selectedIndex, let selectedRow = tableView.cellForRow(at: selectedIndex) {
            selectedRow.isSelected = false
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "ProfileHeader")
            return header
        default:
            return nil
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Section(rawValue: section)?.sectionTitle
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }

}

// MARK: - MyPageVM Delegate
extension MyPageVC: MyPageDelegate {
    func startLoading() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        loadingView.startLoadingAnimation()
    }

    func stopLoading() {
        loadingView.stopLoadingAnimation()
        loadingView.removeFromSuperview()
    }

    func didGetUserInfo(userInfo: UserInfoModel) {
        guard let profileHeader = myPageTableView.headerView(forSection: 0) as? ProfileHeaderView else { return }

        profileHeader.profileView.name = userInfo.nickname
        profileHeader.profileView.email = userInfo.email
        profileHeader.profileView.age = userInfo.age
        profileHeader.profileView.gender = userInfo.sex
        profileHeader.profileView.score = userInfo.rating

    }

}

// MARK: - Section INFO
extension MyPageVC {

    enum Section: Int {
        case noItems = 0
        case appointment = 1
        case account = 2
        case service = 3

        var sectionTitle: String? {
            switch self {
            case .noItems: return nil
            case .appointment: return "약속"
            case .account: return "계정"
            case .service: return "기타"
            }
        }

        var items: [String] {
            switch self {
            case .noItems:
                return []
            case .appointment:
                return ["내가 만든 약속",
                        "참가한 약속",
                        "댓글 단 약속"]
            case .account:
                return ["회원 정보 수정",
                        "정보 동의 설정",
                        "알림 설정",
                        "로그아웃",
                        "회원탈퇴"]
            case .service:
                return ["오픈소스 라이선스",
                        "서비스 이용약관",
                        "개인정보 처리방침",
                        "문의하기",
                        "개발자 정보"]
            }
        }

        var itemCount: Int { return self.items.count }
    }

}
