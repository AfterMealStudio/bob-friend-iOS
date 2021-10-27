//
//  AppointmentListVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/24.
//

import UIKit

class AppointmentListVC: UIViewController {

    let searchBar: SearchBarView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(SearchBarView())

    let appointmentListTableView: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return $0
    }(UITableView())

    override func viewDidLoad() {
        super.viewDidLoad()

        // appointmentListTableView
        appointmentListTableView.delegate = self
        appointmentListTableView.dataSource = self
        registAppointmentListTableView()

        layout()
    }

}

// MARK: - layout
extension AppointmentListVC {

    private func layout() {

        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = UIColor(named: "MainColor1")
        let safeArea = view.safeAreaLayoutGuide

        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

        view.addSubview(appointmentListTableView)
        NSLayoutConstraint.activate([
            appointmentListTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            appointmentListTableView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            appointmentListTableView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
            appointmentListTableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        ])

    }

}

// MARK: - appointmentListTableView
extension AppointmentListVC {
    private func registAppointmentListTableView() {
        appointmentListTableView.register(AppointmentListTableViewCell.self, forCellReuseIdentifier: "AppointListCell")
    }
}

extension AppointmentListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppointListCell", for: indexPath) as?  AppointmentListTableViewCell else { return AppointmentListTableViewCell() }

        return cell
    }

}
