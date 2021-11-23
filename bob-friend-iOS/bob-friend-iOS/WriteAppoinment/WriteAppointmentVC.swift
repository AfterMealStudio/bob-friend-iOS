//
//  WriteAppointmentVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/22.
//

import UIKit

class WriteAppointmentVC: UIViewController {

    let scrollView: UIScrollView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        return $0
    }(UIScrollView())

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(named: "MainColor1")

        // set navigation
        navigationItem.title = "약속 작성하기"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]

        // layout
        layout()

    }

    // MARK: - layout
    func layout() {

        let safeArea = view.safeAreaLayoutGuide

        // MARK: scrollView
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
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
        let titleTextField: UITextField = {
            $0.placeholder = "제목을 입력하세요."
            $0.addBorder(.bottom, color: .lightGray, width: 1)
            return $0
        }(UITextField())

        let titleView: AppointmentVC.AppointmentDetailView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "제목", contentView: titleTextField))

        scrollStackView.addArrangedSubview(titleView)

        // MARK: - content
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

        let contentView: AppointmentVC.AppointmentDetailView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "내용", contentView: contentTextView))

        scrollStackView.addArrangedSubview(contentView)

        // MARK: - time
        let timePicker: UIDatePicker = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.preferredDatePickerStyle = .inline
            return $0
        }(UIDatePicker())

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

        let placeSearchButton: UIButton = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = UIColor(named: "MainColor3")
            $0.layer.cornerRadius = 5
            $0.setTitle("장소 검색하기", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            return $0
        }(UIButton())

        let mapView: MTMapView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(MTMapView())

        placeInnerContentView.addSubview(placeSearchButton)
        placeInnerContentView.addSubview(mapView)

        NSLayoutConstraint.activate([
            placeSearchButton.topAnchor.constraint(equalTo: placeInnerContentView.topAnchor),
            placeSearchButton.leadingAnchor.constraint(equalTo: placeInnerContentView.leadingAnchor),
            placeSearchButton.trailingAnchor.constraint(equalTo: placeInnerContentView.trailingAnchor),

            placeSearchButton.heightAnchor.constraint(equalToConstant: 40),

            mapView.topAnchor.constraint(equalTo: placeSearchButton.bottomAnchor, constant: 5),
            mapView.leadingAnchor.constraint(equalTo: placeInnerContentView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: placeInnerContentView.trailingAnchor),
            mapView.widthAnchor.constraint(equalTo: mapView.heightAnchor),
            mapView.bottomAnchor.constraint(equalTo: placeInnerContentView.bottomAnchor)
        ])

        let placeView: AppointmentVC.AppointmentDetailView = {
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "약속 장소", contentView: placeInnerContentView))

        scrollStackView.addArrangedSubview(placeView)

        // MARK: member amount & age limit
        let memberAmountTextField: UITextField = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.addBorder(.bottom, color: .lightGray, width: 1)
            $0.placeholder = "ex) 4"
            return $0
        }(UITextField())

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

        let considerAgeButton: UIButton = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle(" 상관있음", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setImage(UIImage(systemName: "circle"), for: .normal)
            $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
            $0.tintColor = UIColor(named: "MainColor3")
            $0.isEnabled = true
            $0.isSelected = true
            return $0
        }(UIButton())

        let notConsiderAgeButton: UIButton = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle(" 상관있음", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setImage(UIImage(systemName: "circle"), for: .normal)
            $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
            $0.tintColor = UIColor(named: "MainColor3")
            $0.isEnabled = true
            $0.isSelected = false
            return $0
        }(UIButton())

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

        let ageSelectView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return $0
        }(UIView())

        scrollStackView.addArrangedSubview(ageSelectView)

        // MARK: - gender
        let genderStackview: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            return $0
        }(UIStackView())

        let onlyMaleButton: UIButton = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.setTitle(" 남성만", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setImage(UIImage(systemName: "circle"), for: .normal)
            $0.setImage(UIImage(systemName: "circle.circle"), for: .selected)
            $0.tintColor = UIColor(named: "MainColor3")
            $0.isEnabled = true
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
            return $0
        }(UIButton())

        genderStackview.addArrangedSubview(onlyMaleButton)
        genderStackview.addArrangedSubview(onlyFemaleButton)
        genderStackview.addArrangedSubview(dontMentionGenderButton)

        let genderView: AppointmentVC.AppointmentDetailView = {
            return $0
        }(AppointmentVC.AppointmentDetailView(title: "성별", contentView: genderStackview))

        scrollStackView.addArrangedSubview(genderView)
    }

}
