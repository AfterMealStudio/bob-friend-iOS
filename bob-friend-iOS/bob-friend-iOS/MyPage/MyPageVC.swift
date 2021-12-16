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

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "MainColor1")

        setMyPageTableView()
        layout()
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
