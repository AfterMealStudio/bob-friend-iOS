//
//  SearchAppointmentVC.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/11/28.
//

import UIKit

class SearchAppointmentVC: UIViewController {

    var isTimeSettingMode: Bool = false {
        didSet {
            switch isTimeSettingMode {
            case true:
                termSettingButton.isSelected = true
                timePickersView.isHidden = false
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyyMMddHHmm"
                let startTime = dateFormatter.string(from: startTermPicker.date)
                let endTime = dateFormatter.string(from: endTermPicker.date)
                selectedTime = (startTime, endTime)
            case false:
                termSettingButton.isSelected = false
                timePickersView.isHidden = true
                selectedTime = nil
            }
        }
    }

    var searchType: SearchCategory = .all

    private let safeAreaView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .white
        return $0
    }(UIView())

    private let searchBar: SearchBarView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.activeMode = .searchOptionMode
        return $0
    }(SearchBarView())

    private let optionStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 15
        return $0
    }(UIStackView())

    private let searchTypePickerView: UISegmentedControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.selectedSegmentIndex = .zero
        return $0
    }(UISegmentedControl())

    private let sortingTypeSelectButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(systemName: "arrowtriangle.down.fill"), for: .normal)
        $0.setTitle("임박한 순", for: .normal)
        $0.setTitleColor(UIColor(named: "MainColor2"), for: .normal)
        $0.tintColor = .black
        return $0
    }(UIButton())

    private let termSettingButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("기간 설정", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        $0.addTarget(self, action: #selector(termSettingButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let timePickersView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 5
        $0.isHidden = true
        return $0
    }(UIStackView())

    private let startTermPicker: UIDatePicker = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .dateAndTime
        return $0
    }(UIDatePicker())

    private let endTermPicker: UIDatePicker = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.preferredDatePickerStyle = .compact
        $0.datePickerMode = .dateAndTime
        return $0
    }(UIDatePicker())

    private let checkOnlyEnterableButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("참가 가능한 약속들만 보기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(systemName: "square"), for: .normal)
        $0.setImage(UIImage(systemName: "checkmark.square"), for: .selected)
        $0.addTarget(self, action: #selector(checkOnlyEnterableButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let initializingButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("검색 설정 초기화", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "MainColor1")
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(initializingButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let searchButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("검색하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "MainColor1")
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(searchButtonClicked), for: .touchUpInside)
        return $0
    }(UIButton())

    private let searchTypeString: [String] = ["제목+내용", "제목", "내용", "장소"]
    private var tagIndex: Int = .zero

    private var selectedTime: (String, String)?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "MainColor1")

        setSearchTypePickerView()
        setSortingTypeSelectButton()
        layout()
    }

}

// MARK: - layout
extension SearchAppointmentVC {

    private func layout() {
        let safeArea = view.safeAreaLayoutGuide

        // safeAreaView
        view.addSubview(safeAreaView)
        NSLayoutConstraint.activate([
            safeAreaView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            safeAreaView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            safeAreaView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            safeAreaView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

        // searchBar
        safeAreaView.addSubview(searchBar)
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])

        // optionStack
        configureOptionStackLayout()

        // searchTypePicker
        optionStackView.addArrangedSubview(searchTypePickerView)

        // select sort
        configureSortingTypeSelectButtonLayout()

        // termOption
        configureTermOptionViewLayout()

        // only enterable
        configureCheckOnlyEnterableButtonLayout()

        // Init or Search Buttons
        configureInitializingAndSearchButtonLayout()

    }

    private func configureOptionStackLayout() {
        let safeArea = view.safeAreaLayoutGuide

        safeAreaView.addSubview(optionStackView)
        NSLayoutConstraint.activate([
            optionStackView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 15),
            optionStackView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 15),
            optionStackView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -15)
        ])
    }

    private func configureSortingTypeSelectButtonLayout() {
        let view: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIView())

        view.addSubview(sortingTypeSelectButton)
        NSLayoutConstraint.activate([
            sortingTypeSelectButton.topAnchor.constraint(equalTo: view.topAnchor),
            sortingTypeSelectButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sortingTypeSelectButton.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        optionStackView.addArrangedSubview(view)
    }

    private func configureTermOptionViewLayout() {
        let termOptionView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIView())

        let startTermLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "기간 시작"
            return $0
        }(UILabel())

        let endTermLabel: UILabel = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.text = "기간 끝"
            return $0
        }(UILabel())

        let startView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIView())

        let endView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIView())

        termOptionView.addSubview(termSettingButton)
        NSLayoutConstraint.activate([
            termSettingButton.topAnchor.constraint(equalTo: termOptionView.topAnchor),
            termSettingButton.leadingAnchor.constraint(equalTo: termOptionView.leadingAnchor),
            termSettingButton.bottomAnchor.constraint(equalTo: termOptionView.bottomAnchor)
        ])

        startView.addSubview(startTermLabel)
        startView.addSubview(startTermPicker)
        endView.addSubview(endTermLabel)
        endView.addSubview(endTermPicker)

        NSLayoutConstraint.activate([
            startTermLabel.leadingAnchor.constraint(equalTo: startView.leadingAnchor, constant: 15),
            startTermLabel.centerYAnchor.constraint(equalTo: startTermPicker.centerYAnchor),

            startTermPicker.topAnchor.constraint(equalTo: startView.topAnchor),
            startTermPicker.trailingAnchor.constraint(equalTo: startView.trailingAnchor),
            startTermPicker.bottomAnchor.constraint(equalTo: startView.bottomAnchor),

            endTermLabel.leadingAnchor.constraint(equalTo: endView.leadingAnchor, constant: 15),
            endTermLabel.centerYAnchor.constraint(equalTo: endTermPicker.centerYAnchor),

            endTermPicker.topAnchor.constraint(equalTo: endView.topAnchor),
            endTermPicker.trailingAnchor.constraint(equalTo: endView.trailingAnchor),
            endTermPicker.bottomAnchor.constraint(equalTo: endView.bottomAnchor)
        ])

        timePickersView.addArrangedSubview(startView)
        timePickersView.addArrangedSubview(endView)
        optionStackView.addArrangedSubview(termOptionView)
        optionStackView.addArrangedSubview(timePickersView)
    }

    private func configureCheckOnlyEnterableButtonLayout() {
        let settingEnterableView: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIView())

        settingEnterableView.addSubview(checkOnlyEnterableButton)
        NSLayoutConstraint.activate([
            checkOnlyEnterableButton.topAnchor.constraint(equalTo: settingEnterableView.topAnchor),
            checkOnlyEnterableButton.bottomAnchor.constraint(equalTo: settingEnterableView.bottomAnchor),
            checkOnlyEnterableButton.leadingAnchor.constraint(equalTo: settingEnterableView.leadingAnchor)
        ])

        optionStackView.addArrangedSubview(settingEnterableView)
    }

    private func configureInitializingAndSearchButtonLayout() {
        let buttonsView: UIStackView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.axis = .horizontal
            $0.spacing = 10
            $0.distribution = .fillEqually
            $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
            return $0
        }(UIStackView())

        buttonsView.addArrangedSubview(initializingButton)
        buttonsView.addArrangedSubview(searchButton)

        optionStackView.addArrangedSubview(buttonsView)
    }

}

// MARK: - searchTypePicker
extension SearchAppointmentVC {

    private func setSearchTypePickerView() {

        searchTypeString.enumerated().forEach { index, tag in
            searchTypePickerView.insertSegment(withTitle: tag, at: index, animated: false)
        }

        searchTypePickerView.selectedSegmentIndex = tagIndex
        searchTypePickerView.addTarget(self, action: #selector(pickSegmented(_:)), for: .valueChanged)

    }

    @objc
    private func pickSegmented(_ segmented: UISegmentedControl) {
        tagIndex = segmented.selectedSegmentIndex
        switch tagIndex {
        case 0: searchType = .all
        case 1: searchType = .title
        case 2: searchType = .content
        case 3: searchType = .place
        default: break
        }
    }

}

// MARK: - Button Events
extension SearchAppointmentVC {

    private func setSortingTypeSelectButton() {
        let approached = UIAction(title: "임박한 순", image: UIImage(systemName: "star")) { [weak self] _ in
            self?.sortingTypeSelectButton.setTitle("임박한 순", for: .normal)
        }
        let recentEnrolled = UIAction(title: "최신 등록 순", image: UIImage(systemName: "star")) { [weak self] _ in
            self?.sortingTypeSelectButton.setTitle("최신 등록 순", for: .normal)
        }

        sortingTypeSelectButton.menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [approached, recentEnrolled])
        sortingTypeSelectButton.showsMenuAsPrimaryAction = true
    }

    @objc
    private func termSettingButtonClicked() {
        isTimeSettingMode = !isTimeSettingMode
    }

    @objc
    private func checkOnlyEnterableButtonClicked() {
        checkOnlyEnterableButton.isSelected = !(checkOnlyEnterableButton.isSelected)
    }

    @objc
    private func initializingButtonClicked() {
        searchTypePickerView.selectedSegmentIndex = 0
        tagIndex = .zero

        sortingTypeSelectButton.setTitle("임박한 순", for: .normal)

        if termSettingButton.isSelected { termSettingButtonClicked() }
        startTermPicker.setDate(Date(), animated: true)
        endTermPicker.setDate(Date(), animated: true)

        if checkOnlyEnterableButton.isSelected { checkOnlyEnterableButtonClicked() }
    }

    @objc
    private func searchButtonClicked() {
        let searchWord = searchBar.text
        if searchWord.count == 0 { return }

        let vc = SearchResultAppointmentVC()
        vc.searchWord = searchWord
        vc.selectedTime = selectedTime
        vc.searchType = searchType
        navigationController?.pushViewController(vc, animated: true)
    }

}

// MARK: - use Canvas
#if DEBUG
import SwiftUI

struct SearchAppointmentVCRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = SearchAppointmentVC

    func makeUIViewController(context: Context) -> SearchAppointmentVC {
        return SearchAppointmentVC()
    }

    func updateUIViewController(_ uiViewController: SearchAppointmentVC, context: Context) {

    }

}

@available(iOS 13.0.0, *)
struct SearchAppointmentVC_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            SearchAppointmentVCRepresentable()
                .previewDevice("iPhone 11 Pro")
//            SearchAppointmentVCRepresentable()
//                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}
#endif
