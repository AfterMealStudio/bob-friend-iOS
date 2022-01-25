//
//  SearchListView.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/10/04.
//

import UIKit

class PlaceSearchListView: UICollectionView {

    public override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, a: 64)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: - Cell

class PlaceSearchListCell: UICollectionViewCell {

    var placeName: String = "" { didSet { placeNameLabel.text = placeName } }
    var roadAddress: String = "" { didSet { roadAddressLabel.text = roadAddress } }
    var address: String = "" { didSet { addressLabel.text = address } }
    var longitude: Float = 0
    var latitude: Float = 0

    private let placeNameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.boldSystemFont(ofSize: 16)
        return $0
    }(UILabel())

    private let roadAddressLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .darkGray
        return $0
    }(UILabel())

    private let addressLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .lightGray
        return $0
    }(UILabel())

    public override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }

    init() {
        super.init(frame: .zero)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        placeName = ""
        roadAddress = ""
        address = ""
        longitude = 0
        latitude = 0
    }

    func layout() {
        backgroundColor = .white
        layer.cornerRadius = 5

        addSubview(placeNameLabel)
        NSLayoutConstraint.activate([
            placeNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            placeNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            placeNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

        addSubview(roadAddressLabel)
        NSLayoutConstraint.activate([
            roadAddressLabel.topAnchor.constraint(equalTo: placeNameLabel.bottomAnchor),
            roadAddressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            roadAddressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

        addSubview(addressLabel)
        NSLayoutConstraint.activate([
            addressLabel.topAnchor.constraint(equalTo: roadAddressLabel.bottomAnchor),
            addressLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            addressLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
        ])

    }

}
