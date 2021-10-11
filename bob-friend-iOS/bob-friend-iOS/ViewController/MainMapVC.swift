//
//  MainMapVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/03.
//

import UIKit
import CoreLocation

class MainMapVC: UIViewController {

    let searchBar: SearchBarView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(SearchBarView())

    var searchListView: SearchListView = SearchListView(frame: .zero, collectionViewLayout: UICollectionViewLayout())

    let searchResultList: [PlaceSearchResultModel] = []

    let mapView: MTMapView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(MTMapView())

    let currentLocationButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        $0.setImage(UIImage(systemName: "scope"), for: .normal)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 0.5
        $0.layer.cornerRadius = 10
        return $0
    }(UIButton())

    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        setSearchListView()
        searchListView.delegate = self
        searchListView.dataSource = self

        mapView.delegate = self
        setMap()
        layout()
    }

}

// MARK: - SearchListView
extension MainMapVC {
    private func setSearchListView() {
        let listlayout = UICollectionViewFlowLayout()
        listlayout.itemSize = CGSize(width: view.frame.width - 10, height: 80)
        listlayout.minimumLineSpacing = 5
        listlayout.scrollDirection = .vertical
        listlayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        searchListView = SearchListView(frame: .zero, collectionViewLayout: listlayout)
        searchListView.register(SearchListCell.self, forCellWithReuseIdentifier: "SearchListCell")

        searchListView.isHidden = true
    }
}

extension MainMapVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResultList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchListCell", for: indexPath) as? SearchListCell else { return SearchListCell() }
        return cell
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

        // searchListView
        view.addSubview(searchListView)
        NSLayoutConstraint.activate([
            searchListView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            searchListView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            searchListView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            searchListView.heightAnchor.constraint(equalToConstant: 200)
        ])

        // currentLocationButton
        view.addSubview(currentLocationButton)
        NSLayoutConstraint.activate([
            currentLocationButton.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -10),
            currentLocationButton.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -10),
            currentLocationButton.widthAnchor.constraint(equalToConstant: 40),
            currentLocationButton.heightAnchor.constraint(equalToConstant: 40)
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
