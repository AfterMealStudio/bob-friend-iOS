//
//  MainMapVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/03.
//

import UIKit
import CoreLocation

class MainMapVC: UIViewController {

    var locationManager: CLLocationManager!

    let mapView: MTMapView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(MTMapView())

    let searchBar: SearchBarView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(SearchBarView())

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        setMap()
        layout()

    }

}

// MARK: - Map Setting
extension MainMapVC: CLLocationManagerDelegate {
    func setMap() {
        locationManager = CLLocationManager()
        locationManager.delegate = self

        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        mapView.showCurrentLocationMarker = true
        mapView.currentLocationTrackingMode = .onWithoutHeading

        locationManager.startUpdatingLocation()
    }
}

// MARK: - layout
extension MainMapVC {
    func layout() {
        view.backgroundColor = UIColor(named: "MainColor1")
        let safeArea = view.safeAreaLayoutGuide

        // map
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            mapView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: safeArea.rightAnchor)
        ])

        // searchBar
        view.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

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
