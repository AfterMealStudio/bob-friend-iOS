//
//  WriteAppointmentVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/22.
//

import UIKit
import NMapsMap

class WriteAppointmentVC: UIViewController {

    let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        return $0
    }(UIScrollView())

    private var scrollViewBottomConstraint: NSLayoutConstraint?
    private var scrollViewBottomKeyboardConstraint: NSLayoutConstraint?

    let mapView: NMFMapView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isTiltGestureEnabled = false
        $0.isRotateGestureEnabled = false
        $0.isZoomGestureEnabled = false
        $0.isScrollGestureEnabled = false
        return $0
    }(NMFMapView())

    var marker: NMFMarker? {
        willSet {
            if let marker = marker {
                marker.mapView = nil
            }
        }
        didSet {
            if let marker = marker {
                marker.mapView = mapView
                let cameraUpdate = NMFCameraUpdate(scrollTo: marker.position)
                mapView.moveCamera(cameraUpdate)
            }
        }
    }

    let titleTextField: UITextField = {
        $0.placeholder = "제목을 입력하세요."
        $0.addBorder(.bottom, color: .lightGray, width: 1)
        return $0
    }(UITextField())

    let contentTextView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 2)
        $0.heightAnchor.constraint(equalToConstant: 250).isActive = true
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.cornerRadius = 5
        return $0
    }(UITextView())

    let timePicker: UIDatePicker = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.preferredDatePickerStyle = .compact
        $0.minimumDate = Date()
        return $0
    }(UIDatePicker())

    let placeSearchButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = UIColor(named: "MainColor3")
        $0.layer.cornerRadius = 5
        $0.setTitle("장소 검색하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.addTarget(self, action: #selector(didPlaceSearchButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    let memberAmountTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addBorder(.bottom, color: .lightGray, width: 1)
        $0.placeholder = "ex) 4"
        $0.keyboardType = .numberPad
        return $0
    }(UITextField())

    let considerAgeButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(" 상관있음", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        $0.tintColor = UIColor(named: "MainColor3")
        $0.isEnabled = true
        $0.isSelected = false

        $0.addTarget(self, action: #selector(didConsiderAgeButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    let notConsiderAgeButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(" 상관없음", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        $0.tintColor = UIColor(named: "MainColor3")
        $0.isEnabled = true
        $0.isSelected = true

        $0.addTarget(self, action: #selector(didDontConsiderAgeButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    let ageSelectView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
        $0.isHidden = true
        return $0
    }(UIView())

    let minAgeTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "1~100"
        $0.text = "1"
        $0.keyboardType = .numberPad
        $0.addBorder()
        return $0
    }(UITextField())

    let maxAgeTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "1~100"
        $0.text = "100"
        $0.keyboardType = .numberPad
        $0.addBorder()
        return $0
    }(UITextField())

    let onlyMaleButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(" 남성만", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        $0.tintColor = UIColor(named: "MainColor3")
        $0.isEnabled = true

        $0.addTarget(self, action: #selector(didOnlyMaleButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    let onlyFemaleButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(" 여성만", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        $0.tintColor = UIColor(named: "MainColor3")
        $0.isEnabled = true

        $0.addTarget(self, action: #selector(didOnlyFemaleButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    let dontMentionGenderButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle(" 상관없음", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "circle"), for: .normal)
        $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
        $0.tintColor = UIColor(named: "MainColor3")
        $0.isEnabled = true
        $0.isSelected = true

        $0.addTarget(self, action: #selector(didDontMentionGenderButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    let restaurantNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "없음"
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UILabel())

    let restaurantAddressLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "없음"
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UILabel())

    let loadingView: LoadingView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(LoadingView())

    let writeAppointmentVM: WriteAppointmentVM = WriteAppointmentVM()

    var willConsiderAge: Bool = false {
        didSet {
            switch willConsiderAge {
            case true:
                considerAgeButton.isSelected = true
                notConsiderAgeButton.isSelected = false
                ageSelectView.isHidden = false
            case false:
                considerAgeButton.isSelected = false
                notConsiderAgeButton.isSelected = true
                ageSelectView.isHidden = true
            }
        }
    }

    var minAge: Int?
    var maxAge: Int?
    var ageRestrict: (Int?, Int?) = (nil, nil)

    var gender: Gender = .none {
        didSet {
            onlyMaleButton.isSelected = false
            onlyFemaleButton.isSelected = false
            dontMentionGenderButton.isSelected = false

            switch gender {
            case .male: onlyMaleButton.isSelected = true
            case .female: onlyFemaleButton.isSelected = true
            case .none: dontMentionGenderButton.isSelected = true
            }
        }
    }

    var restaurantName: String = "" {
        didSet {
            if restaurantName == "" {
                restaurantNameLabel.text = "없음"
            } else {
                restaurantNameLabel.text = restaurantName
            }
        }
    }
    var restaurantAddress: String = "" {
        didSet {
            if restaurantAddress == "" {
                restaurantAddressLabel.text = "없음"
            } else {
                restaurantAddressLabel.text = restaurantAddress
            }
        }
    }
    var longitude: Double?
    var latitude: Double?

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "MainColor1")

        // VM Delegate
        writeAppointmentVM.delegate = self

        // set navigation
        navigationItem.title = "약속 작성하기"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        let enrollButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "checkmark.circle"), style: .plain, target: self, action: #selector(didEnrollButtonClicked))
        navigationItem.rightBarButtonItem = enrollButton

        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.backgroundColor = UIColor(named: "MainColor1")
        navigationAppearance.titleTextAttributes =  [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = navigationAppearance

        // keyboard
        enrollKeyboardNotification()
        scrollView.delegate = self

        // textField

        // layout
        layout()

        // timePickerSet
        setTimePicker()

    }

    func resetVC() {
        titleTextField.text = ""
        contentTextView.text = ""
        timePicker.setDate(Date(), animated: false)
        restaurantName = ""
        restaurantAddress = ""
        longitude = nil
        latitude = nil
        didDontMentionGenderButtonClicked()
        didDontConsiderAgeButtonClicked()
        scrollView.scrollsToTop = true
    }

    func setTimePicker() {
        let timePickerEventAction = UIAction { [weak self] _ in
            self?.timePicker.minimumDate = Date()
        }
        timePicker.addAction(timePickerEventAction, for: .allEditingEvents)
    }

    // MARK: - layout
    func layout() {

        let safeArea = view.safeAreaLayoutGuide

        scrollViewBottomConstraint = scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
        scrollViewBottomKeyboardConstraint = scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

        scrollViewBottomConstraint?.priority = .defaultHigh
        scrollViewBottomKeyboardConstraint?.priority = .defaultLow

        guard let scrollViewBottomConstraint = scrollViewBottomConstraint, let scrollViewBottomKeyboardConstraint = scrollViewBottomKeyboardConstraint else { return }

        // MARK: scrollView
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollViewBottomConstraint,
            scrollViewBottomKeyboardConstraint,
            scrollView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

        // MARK: scrollStackView
        let scrollStackView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .vertical
            return $0
        }(UIStackView())

        scrollView.addSubview(scrollStackView)
        NSLayoutConstraint.activate([
            scrollStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 10),
            scrollStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -10),
            scrollStackView.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 10),
            scrollStackView.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -10)
        ])

        // MARK: - title
        let titleView: AppointmentVC.AppointmentDetailView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "제목", contentView: titleTextField))

        scrollStackView.addArrangedSubview(titleView)

        // MARK: - content
        let contentView: AppointmentVC.AppointmentDetailView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "내용", contentView: contentTextView))

        scrollStackView.addArrangedSubview(contentView)

        // MARK: - time
        let timeView: AppointmentVC.AppointmentDetailView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "약속 시간", contentView: timePicker))

        scrollStackView.addArrangedSubview(timeView)

        // MARK: - place
        let placeInnerContentView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIView())

        let restaurantNameFormLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "선택 식당"
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(named: "MainColor1")
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return $0
        }(UILabel())

        let restaurantAddressFormLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "식당 정보"
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(named: "MainColor1")
            $0.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            return $0
        }(UILabel())

        placeInnerContentView.addSubview(restaurantNameFormLabel)
        placeInnerContentView.addSubview(restaurantNameLabel)
        placeInnerContentView.addSubview(restaurantAddressFormLabel)
        placeInnerContentView.addSubview(restaurantAddressLabel)

        NSLayoutConstraint.activate([
            restaurantNameFormLabel.topAnchor.constraint(equalTo: placeInnerContentView.topAnchor),
            restaurantNameFormLabel.leadingAnchor.constraint(equalTo: placeInnerContentView.leadingAnchor, constant: 5),

            restaurantNameLabel.centerYAnchor.constraint(equalTo: restaurantNameFormLabel.centerYAnchor),
            restaurantNameLabel.leadingAnchor.constraint(equalTo: restaurantNameFormLabel.trailingAnchor, constant: 5),
            restaurantNameLabel.trailingAnchor.constraint(equalTo: placeInnerContentView.trailingAnchor),

            restaurantAddressFormLabel.topAnchor.constraint(equalTo: restaurantNameFormLabel.bottomAnchor, constant: 5),
            restaurantAddressFormLabel.leadingAnchor.constraint(equalTo: placeInnerContentView.leadingAnchor, constant: 5),

            restaurantAddressLabel.centerYAnchor.constraint(equalTo: restaurantAddressFormLabel.centerYAnchor),
            restaurantAddressLabel.leadingAnchor.constraint(equalTo: restaurantAddressFormLabel.trailingAnchor, constant: 5),
            restaurantAddressLabel.trailingAnchor.constraint(equalTo: placeInnerContentView.trailingAnchor)
        ])

        placeInnerContentView.addSubview(placeSearchButton)
        placeInnerContentView.addSubview(mapView)

        NSLayoutConstraint.activate([
            placeSearchButton.topAnchor.constraint(equalTo: restaurantAddressFormLabel.bottomAnchor, constant: 5),
            placeSearchButton.leadingAnchor.constraint(equalTo: placeInnerContentView.leadingAnchor),
            placeSearchButton.trailingAnchor.constraint(equalTo: placeInnerContentView.trailingAnchor),

            placeSearchButton.heightAnchor.constraint(equalToConstant: 40),

            mapView.topAnchor.constraint(equalTo: placeSearchButton.bottomAnchor, constant: 5),
            mapView.leadingAnchor.constraint(equalTo: placeInnerContentView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: placeInnerContentView.trailingAnchor),
            mapView.widthAnchor.constraint(equalTo: mapView.heightAnchor),
            mapView.bottomAnchor.constraint(equalTo: placeInnerContentView.bottomAnchor)
        ])

        let mapWrapperView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
            return $0
        }(UIView())
        placeInnerContentView.addSubview(mapWrapperView)

        NSLayoutConstraint.activate([
            mapWrapperView.topAnchor.constraint(equalTo: mapView.topAnchor),
            mapWrapperView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor),
            mapWrapperView.leadingAnchor.constraint(equalTo: mapView.leadingAnchor),
            mapWrapperView.trailingAnchor.constraint(equalTo: mapView.trailingAnchor)
        ])

        let placeView: AppointmentVC.AppointmentDetailView = {
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "약속 장소", contentView: placeInnerContentView))

        scrollStackView.addArrangedSubview(placeView)

        // MARK: - member amount & age limit
        let memberAmountView: AppointmentVC.AppointmentDetailView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.widthAnchor.constraint(equalToConstant: 80).isActive = true
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "약속 인원", contentView: memberAmountTextField))

        let ageOptionView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            return $0
        }(UIStackView())

        ageOptionView.addArrangedSubview(considerAgeButton)
        ageOptionView.addArrangedSubview(notConsiderAgeButton)

        let ageView: AppointmentVC.AppointmentDetailView = {
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "연령", contentView: ageOptionView))

        let memberAndAgeView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.spacing = 10
            return $0
        }(UIStackView())

        memberAndAgeView.addArrangedSubview(memberAmountView)
        memberAndAgeView.addArrangedSubview(ageView)

        scrollStackView.addArrangedSubview(memberAndAgeView)
        scrollStackView.addArrangedSubview(ageSelectView)

        let ageMinLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "최소 나이"
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(named: "MainColor1")
            return $0
        }(UILabel())

        let ageMaxLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "최대 나이"
            $0.font = UIFont.systemFont(ofSize: 15)
            $0.textColor = UIColor(named: "MainColor1")
            return $0
        }(UILabel())

        ageSelectView.addSubview(ageMinLabel)
        ageSelectView.addSubview(minAgeTextField)
        ageSelectView.addSubview(ageMaxLabel)
        ageSelectView.addSubview(maxAgeTextField)

        NSLayoutConstraint.activate([
            ageMinLabel.centerYAnchor.constraint(equalTo: ageSelectView.centerYAnchor),
            ageMinLabel.leadingAnchor.constraint(equalTo: ageSelectView.leadingAnchor, constant: 10),
//            ageMinLabel.widthAnchor.constraint(equalToConstant: 50),

            minAgeTextField.centerYAnchor.constraint(equalTo: ageSelectView.centerYAnchor),
            minAgeTextField.leadingAnchor.constraint(equalTo: ageMinLabel.trailingAnchor, constant: 10),
            minAgeTextField.widthAnchor.constraint(equalToConstant: 50),

            ageMaxLabel.centerYAnchor.constraint(equalTo: ageSelectView.centerYAnchor),
            ageMaxLabel.leadingAnchor.constraint(equalTo: minAgeTextField.trailingAnchor, constant: 20),

            maxAgeTextField.centerYAnchor.constraint(equalTo: ageSelectView.centerYAnchor),
            maxAgeTextField.leadingAnchor.constraint(equalTo: ageMaxLabel.trailingAnchor, constant: 10),
            maxAgeTextField.widthAnchor.constraint(equalToConstant: 50)
        ])

        // MARK: - gender
        let genderStackview: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            return $0
        }(UIStackView())

        genderStackview.addArrangedSubview(onlyMaleButton)
        genderStackview.addArrangedSubview(onlyFemaleButton)
        genderStackview.addArrangedSubview(dontMentionGenderButton)

        let genderView: AppointmentVC.AppointmentDetailView = {
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "성별", contentView: genderStackview))

        scrollStackView.addArrangedSubview(genderView)
    }

}

// MARK: - Buttons Events
extension WriteAppointmentVC {
    // MARK: - Enroll Button Event
    @objc
    func didEnrollButtonClicked() {
        print("didEnrollButtonClicked")

        guard let title = titleTextField.text, let content = contentTextView.text, let strMemberAmount = memberAmountTextField.text, let totalNumberOfPeople = Int(strMemberAmount), let longitude = longitude, let latitude = latitude else { return }

        if willConsiderAge {
            guard let strMinAge = minAgeTextField.text, let minAge = Int(strMinAge), let strMaxAge = maxAgeTextField.text, let maxAge = Int(strMaxAge) else { return }
            if maxAge < minAge || minAge < 1 || minAge > 100 || maxAge < 1 || maxAge > 100 { return }
            self.minAge = minAge
            self.maxAge = maxAge
        } else { (minAge, maxAge) = (nil, nil) }

        if title == "" || content == "" || restaurantName == "" || restaurantAddress == "" { return }

        let dateAndTime = timePicker.date

        if dateAndTime < Date() {
            noticeMessage(title: "약속 시간은 현재보다 이를 수 없습니다.", msg: nil)
            return
        }

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"

        let dateString = dateFormatter.string(from: dateAndTime)
        let timeString = timeFormatter.string(from: dateAndTime)

        let appointmentTime = dateString + "T" + timeString + ":00"

        let appointment = AppointmentEnrollModel(title: title, content: content, totalNumberOfPeople: totalNumberOfPeople, restaurantName: restaurantName, restaurantAddress: restaurantAddress, latitude: latitude, longitude: longitude, sexRestriction: gender, appointmentTime: appointmentTime, ageRestrictionStart: minAge, ageRestrictionEnd: maxAge)

        writeAppointmentVM.enrollAppointment(appointment: appointment)
    }
    // MARK: - Place Search Button Event
    @objc
    func didPlaceSearchButtonClicked() {
        let vc = PlaceSearchVC()
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Age Buttons Event
    @objc
    func didConsiderAgeButtonClicked() {
        willConsiderAge = true
    }

    @objc
    func didDontConsiderAgeButtonClicked() {
        willConsiderAge = false
    }

    // MARK: - Gender Buttons Event
    @objc
    func didOnlyMaleButtonClicked() {
        gender = .male
    }

    @objc
    func didOnlyFemaleButtonClicked() {
        gender = .female
    }

    @objc
    func didDontMentionGenderButtonClicked() {
        gender = .none
    }

}

// MARK: - WriteAppointment Delegate
extension WriteAppointmentVC: WriteAppointmentDelegate {
    func startLoading() {
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        loadingView.startLoadingAnimation()
    }

    func stopLoading() {
        loadingView.stopLoadingAnimation()
        loadingView.removeFromSuperview()
    }

    func didEnrollAppointment() {

        let alertController = UIAlertController(title: "게시글이 등록되었습니다.", message: nil, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.resetVC()
        }

        alertController.addAction(okBtn)

        DispatchQueue.main.async {
            [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }

        guard let naviVC = tabBarController?.viewControllers?[1] as? UINavigationController else { return }
        naviVC.viewControllers = [AppointmentListVC()]
    }

}

// MARK: - PlaceSerachDelegate
extension WriteAppointmentVC: PlaceSearchDelegate {
    func didSelectPlace(restaurantName: String, restaurantAddress: String, longitude: Double, latitude: Double) {
        self.restaurantName = restaurantName
        self.restaurantAddress = restaurantAddress
        self.longitude = longitude
        self.latitude = latitude

        marker = NMFMarker(position: NMGLatLng(lat: latitude, lng: longitude))
    }
}

// MARK: - Keyboard
extension WriteAppointmentVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeKeyboard()
    }

    private func enrollKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc
    private func keyboardWillShow(_ sender: Notification) {

        if let scrollViewBottomKeyboardConstraint = scrollViewBottomKeyboardConstraint, scrollViewBottomKeyboardConstraint.constant == 0 {
            guard let userInfo = sender.userInfo,
                  let keyboardFrame: NSValue = userInfo[ UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height

            scrollViewBottomKeyboardConstraint.constant = -keyboardHeight
        }

        scrollViewBottomConstraint?.priority = .defaultLow
        scrollViewBottomKeyboardConstraint?.priority = .defaultHigh

    }

    @objc
    private func keyboardWillHide(_ sender: Notification) {

        if let scrollViewBottomKeyboardConstraint = scrollViewBottomKeyboardConstraint, scrollViewBottomKeyboardConstraint.constant != 0 {
            scrollViewBottomKeyboardConstraint.constant = 0
        }

        scrollViewBottomConstraint?.priority = .defaultHigh
        scrollViewBottomKeyboardConstraint?.priority = .defaultLow

    }

    private func removeKeyboard() {
        view.endEditing(true)
    }

}

// MARK: - Alert
extension WriteAppointmentVC {

    func noticeMessage(title: String, msg: String?) {
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.dismiss(animated: true) { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
        }

        alertController.addAction(okBtn)

        DispatchQueue.main.async {
            [weak self] in
            self?.present(alertController, animated: true, completion: nil)
        }
    }

}
