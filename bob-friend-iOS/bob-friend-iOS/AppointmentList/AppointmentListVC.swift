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

    var appointments: [AppointmentSimpleModel] = [] {
        didSet {
            appointmentListTableView.reloadData()
        }
    }
    let appointmentListVM: AppointmentListVM = AppointmentListVM()

    override func viewDidLoad() {
        super.viewDidLoad()

        // vm
        appointmentListVM.delegate = self
        appointmentListVM.getAppointmentList()

        // appointmentListTableView
        appointmentListTableView.delegate = self
        appointmentListTableView.dataSource = self
        registAppointmentListTableView()

        layout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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

// MARK: - AppointmentListVM Delegate
extension AppointmentListVC: AppointmentListDelegate {
    func didGetAppointments(_ appointments: [AppointmentSimpleModel]) {
        self.appointments += appointments
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
        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AppointListCell", for: indexPath) as?  AppointmentListTableViewCell else { return AppointmentListTableViewCell() }

        let appointment = appointments[indexPath.row]
        cell.titleLabel.text = appointment.title
        cell.userLabel.text = appointment.author.nickname
        cell.peopleCntLabel.text = "\(appointment.currentNumberOfPeople)/\( appointment.totalNumberOfPeople)"
        cell.commentCntLabel.text = "\(0)"
        cell.dateLabel.text = "\(appointment.createdAt)"
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AppointmentVC()
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == appointments.count - 1 {
            appointmentListVM.getAppointmentList()
        }
    }

}
