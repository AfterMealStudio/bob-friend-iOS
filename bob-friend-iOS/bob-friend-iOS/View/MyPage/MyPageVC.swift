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

        registTableView()
    }

    private func registTableView() {
        myPageTableView.register(ProfileHeaderView.self, forHeaderFooterViewReuseIdentifier: "ProfileHeader")
    }

}

// MARK: - TableView Delegate
extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        default:
            return 20
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
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
