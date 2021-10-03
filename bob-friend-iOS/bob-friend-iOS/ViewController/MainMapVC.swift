//
//  MainMapVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/03.
//

import UIKit

class MainMapVC: UIViewController {

    let mapView = MTMapView()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        layout()

    }

}

extension MainMapVC {
    func layout() {
        view.backgroundColor = .white
        let safeArea = view.safeAreaLayoutGuide

        // map
        mapView.frame = safeArea.layoutFrame
        view.addSubview(mapView)
//        NSLayoutConstraint.activate([
//            mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
//            mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
//            mapView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
//            mapView.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
//        ])

    }
}

// MARK: - MTMapViewDelegate
extension MainMapVC: MTMapViewDelegate {

}

// MARK: - use Canvas
#if DEBUG
import SwiftUI

struct MainMapVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = MainMapVC

    func makeUIViewController(context: Context) -> MainMapVC {
        return MainMapVC()
    }

    func updateUIViewController(_ uiViewController: MainMapVC, context: Context) {

    }

}

@available(iOS 13.0.0, *)
struct MainMapVC_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            MainMapVCRepresentable()
                .previewDevice("iPhone 11 Pro")
        }
    }
}
#endif
