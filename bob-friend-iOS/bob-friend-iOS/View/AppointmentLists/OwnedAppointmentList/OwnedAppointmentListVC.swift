//
//  OwnedAppointmentListVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2022/01/10.
//

import UIKit

class OwnedAppointmentListVC: AppointmentListVC {

    override init() {
        super.init()
        searchBar = nil
        appointmentListVM = OwnedAppointmentListVM()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.navigationBar.isHidden = false

        navigationItem.title = "내가 만든 약속"

        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = UIColor(named: "MainColor1")
        navigationAppearance.titleTextAttributes =  [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationAppearance
    }

}
