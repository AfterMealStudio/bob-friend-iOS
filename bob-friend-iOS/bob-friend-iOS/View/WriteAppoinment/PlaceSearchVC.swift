//
//  PlaceSearchVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/23.
//

import UIKit

class PlaceSearchVC: UIViewController {

    weak var delegate: PlaceSearchDelegate?
    let placeSearchVM: MainMapVM = MainMapVM()

    let searchBar: SearchBarView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(SearchBarView())

    var searchListView: PlaceSearchListView = {
        $0.translatesAutoresizingMaskIntoConstraints = true
        return $0
    }(PlaceSearchListView(frame: .zero, collectionViewLayout: UICollectionViewLayout()))

    private var searchListViewBottomConstraint: NSLayoutConstraint?
    private var searchListViewBottomKeyboardConstraint: NSLayoutConstraint?

    var searchResults: KakaoKeywordSearchResultModel? {
        didSet {
            searchListView.reloadData()
            searchListView.setContentOffset(.zero, animated: false)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // searchBar
        searchBar.delegate = self

        // VM
        placeSearchVM.delegate = self

        // searchListView
        setSearchListView()
        searchListView.delegate = self
        searchListView.dataSource = self

        // keyboard
        enrollKeyboardNotification()

        // layout
        layout()

    }

    func layout() {
        view.backgroundColor = UIColor(named: "MainColor1")
        let safeArea = view.safeAreaLayoutGuide

        searchListViewBottomConstraint = searchListView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        searchListViewBottomKeyboardConstraint = searchListView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        searchListViewBottomConstraint?.priority = .defaultHigh
        searchListViewBottomKeyboardConstraint?.priority = .defaultLow

        guard let searchListViewBottomConstraint = searchListViewBottomConstraint, let searchListViewBottomKeyboardConstraint = searchListViewBottomKeyboardConstraint else { return }

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
            searchListViewBottomConstraint,
            searchListViewBottomKeyboardConstraint,
            searchListView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            searchListView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }

}

// MARK: - SearchBarViewDelegate
extension PlaceSearchVC: SearchBarViewDelegate {

    func didReturnKeyInput() {
        placeSearchVM.searchPlace(keyword: searchBar.text)
    }

}

// MARK: - SearchListView
extension PlaceSearchVC: UICollectionViewDelegate, UICollectionViewDataSource {
    private func setSearchListView() {

        let listlayout = UICollectionViewFlowLayout()
        listlayout.itemSize = CGSize(width: view.frame.width - 10, height: 70)
        listlayout.minimumLineSpacing = 5
        listlayout.scrollDirection = .vertical
        listlayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)

        searchListView = PlaceSearchListView(frame: .zero, collectionViewLayout: listlayout)
        searchListView.register(PlaceSearchListCell.self, forCellWithReuseIdentifier: "SearchListCell")

        // TODO: 배경색을 여기보다 빨리 지정해주면(ex, 이 함수의 첫 문장 위치) 배경색이 지정되지 않는 것 같음. 이유 분석 필요.
        searchListView.backgroundColor = .white
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let searchResults = searchResults else { return 0 }
        return searchResults.documents.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchListCell", for: indexPath) as? PlaceSearchListCell else { return PlaceSearchListCell() }
        guard let placeInfo = searchResults?.documents[indexPath.row] else { return cell }
        cell.placeName = placeInfo.place_name
        cell.roadAddress = placeInfo.road_address_name
        cell.address = placeInfo.address_name
        cell.longitude = Float(placeInfo.x) ?? 0
        cell.latitude = Float(placeInfo.y) ?? 0

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let placeInfo = searchResults?.documents[indexPath.row] else { return }
        let longitude = Double(placeInfo.x) ?? 0
        let latitude = Double(placeInfo.y) ?? 0

        delegate?.didSelectPlace(restaurantName: placeInfo.place_name, restaurantAddress: placeInfo.road_address_name, longitude: longitude, latitude: latitude)

        navigationController?.popViewController(animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeKeyboard()
    }
}

// MARK: - VM Delegate
// TODO: - MainMap과 Delegate 분리하기
extension PlaceSearchVC: MainMapDelegate {
    func didGetAppointmentLocations(locations: AppointmentLocationListModel) {

    }

    func didSearchPlace(searchResults: KakaoKeywordSearchResultModel) {
        self.searchResults = searchResults
        removeKeyboard()
    }

    func occuredSearchError(errMessage: String) {
        let alertController = UIAlertController(title: errMessage, message: nil, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "확인", style: .default)
        alertController.addAction(okBtn)
        DispatchQueue.main.async {
            [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }

}

// MARK: - Delegate Protocol
protocol PlaceSearchDelegate: AnyObject {
    func didSelectPlace(restaurantName: String, restaurantAddress: String, longitude: Double, latitude: Double)
}

// MARK: - Keyboard
extension PlaceSearchVC {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        removeKeyboard()
    }

    private func enrollKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardWillShow(_ sender: Notification) {

        if let searchListViewBottomKeyboardConstraint = searchListViewBottomKeyboardConstraint, searchListViewBottomKeyboardConstraint.constant == 0 {
            guard let userInfo = sender.userInfo,
                  let keyboardFrame: NSValue = userInfo[ UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            searchListViewBottomKeyboardConstraint.constant = -keyboardHeight
        }

        searchListViewBottomConstraint?.priority = .defaultLow
        searchListViewBottomKeyboardConstraint?.priority = .defaultHigh

    }

    @objc
    private func keyboardWillHide(_ sender: Notification) {

        if let searchListViewBottomKeyboardConstraint = searchListViewBottomKeyboardConstraint, searchListViewBottomKeyboardConstraint.constant != 0 {
            searchListViewBottomKeyboardConstraint.constant = 0
        }

        searchListViewBottomConstraint?.priority = .defaultHigh
        searchListViewBottomKeyboardConstraint?.priority = .defaultLow

    }

    private func removeKeyboard() {
        view.endEditing(true)
    }

}
