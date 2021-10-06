//
//  MainTabBarController.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/03.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.addBorder(.top, color: .lightGray, width: 0.5)
        tabBar.backgroundColor = .white

        let mainMapVC = MainMapVC()
        let appointmentListVC = UIViewController()
        let makeAppointmentVC = UIViewController()
        let myPageVC = UIViewController()

        mainMapVC.tabBarItem = UITabBarItem(title: "123", image: UIImage(systemName: "map"), selectedImage: UIImage(systemName: "map.fill"))
        appointmentListVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "list.bullet.circle"), selectedImage: UIImage(systemName: "list.bullet.circle.fill"))
        makeAppointmentVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "plus.app"), selectedImage: UIImage(systemName: "plus.app.fill"))
        myPageVC.tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), selectedImage: UIImage(systemName: "person.fill"))

        viewControllers = [mainMapVC, appointmentListVC, makeAppointmentVC, myPageVC]

    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */

}

// MARK: - use Canvas
#if DEBUG
import SwiftUI

struct MainTabbarControllerRepresntable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MainTabBarController
    func makeUIViewController(context: Context) -> MainTabBarController {
        return MainTabBarController()
    }

    func updateUIViewController(_ uiViewController: MainTabBarController, context: Context) {

    }
}

@available(iOS 13.0.0, *)
struct MainTabBarController_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            MainTabbarControllerRepresntable()
                .previewDevice("iPhone 11 Pro")
        }
    }
}
#endif