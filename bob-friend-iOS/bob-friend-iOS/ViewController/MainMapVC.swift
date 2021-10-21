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
        $0.tintColor = .darkGray
        return $0
    }(UIButton())

    var locationManager: CLLocationManager!
    var updateCurrentLocation: MTMapPoint?
    let mainMapVM: MainMapVM = MainMapVM()

    var searchResults: KakaoKeywordSearchResultModel? {
        didSet {
            searchListView.reloadData()
            searchListView.isHidden = false
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // mainMapVM
        mainMapVM.delegate = self

        // searchBar
        searchBar.delegate = self

        // searchListView
        setSearchListView()
        searchListView.delegate = self
        searchListView.dataSource = self

        // mapView
        mapView.delegate = self
        setMap()

        // currentLocationButton
        setCurrentLocationButtonAction()

        // layout
        layout()
    }

}

// MARK: - MainMapVM Delegate
extension MainMapVC: MainMapDelegate {
    func mainMap(searchResults: KakaoKeywordSearchResultModel) {
        self.searchResults = searchResults
    }

    func occuredError() {
        let alertController = UIAlertController(title: "검색 실패하였습니다.", message: nil, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okBtn)
        DispatchQueue.main.async {
            [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }

}

// MARK: - SearchListView
extension MainMapVC {
    private func setSearchListView() {
        let listlayout = UICollectionViewFlowLayout()
        listlayout.itemSize = CGSize(width: view.frame.width - 10, height: 70)
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
        guard let searchResults = searchResults else { return 10 }
        return searchResults.documents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchListCell", for: indexPath) as? SearchListCell else { return SearchListCell() }
        guard let placeInfo = searchResults?.documents[indexPath.row] else { return cell }
        cell.placeName = placeInfo.place_name
        cell.roadAddress = placeInfo.road_address_name
        cell.address = placeInfo.address_name
        cell.longitude = Float(placeInfo.x) ?? 0
        cell.latitude = Float(placeInfo.y) ?? 0

        return cell

    }

    // TODO: 맵을 이동하지 않았을 때 검색 결과를 통해 검색장소로 이동하면 현위치로 다시 돌아오는 이슈 발생
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let placeInfo = searchResults?.documents[indexPath.row] else { return }
        let longitude = Double(placeInfo.x) ?? 0
        let latitude = Double(placeInfo.y) ?? 0
        let point = MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
        mapView.setMapCenter(point, animated: true)
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

// MARK: - ButtonSetting
extension MainMapVC {
    func setCurrentLocationButtonAction() {
        currentLocationButton.addTarget(self, action: #selector(currentButtonClicked), for: .touchUpInside)
    }

    @objc
    func currentButtonClicked() {
        mapView.setMapCenter(updateCurrentLocation, animated: true)
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

// MARK: - SearchBarViewDelegate
extension MainMapVC: SearchBarViewDelegate {

    func didSearchButtonClicked() {
        mainMapVM.requestPlaceSearch(keyword: searchBar.text) { _ in }
    }

}

// MARK: - MTMapViewDelegate
extension MainMapVC: MTMapViewDelegate {

    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        updateCurrentLocation = location
    }

    func mapView(_ mapView: MTMapView!, singleTapOn mapPoint: MTMapPoint!) {
        searchListView.isHidden = true
    }

}

// MARK: - Keyboard
extension MainMapVC {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         view.endEditing(true)
   }

    private func removeKeyboard() {
        view.endEditing(true)
    }

    private func enrollRemoveKeyboard() {
        let singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapOtherMethod))
        view.addGestureRecognizer(singleTapGestureRecognizer)

    }

    @objc
    private func tapOtherMethod(sender: UITapGestureRecognizer) {
        removeKeyboard()
    }

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
