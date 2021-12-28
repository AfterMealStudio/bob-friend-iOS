//
//  ProfileView.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/16.
//

import UIKit

class ProfileView: UIView {

    var profileImage: UIImage? {
        didSet {
            if let profileImage = profileImage {
                profileImageView.image = profileImage
            } else {
                profileImageView.image = UIImage(systemName: "person.crop.circle")
            }
        }
    }

    var name: String? {
        didSet {
            if let name = name {
                nameLabel.text = name
            } else { nameLabel.text = "" }
        }
    }

    var email: String? {
        didSet {
            if let email = email {
                emailLabel.text = email
            } else { emailLabel.text = "" }
        }
    }

    var age: Int? {
        didSet {
            if let age = age {
                ageLabel.text = String(age) + " 세"
            } else { ageLabel.text = "" }
        }
    }

    var gender: Gender? {
        didSet {
            if let gender = gender {
                genderLabel.text = gender.kr
            } else { genderLabel.text = "" }
        }
    }

    var score: Float? {
        didSet {
            if let score = score {
                scoreLabel.text = String(score)
            } else { scoreLabel.text = "" }
        }
    }

    private var profileImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = UIImage(systemName: "person.crop.circle")
        return $0
    }(UIImageView())

    private var nameLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "이름"
        $0.font = UIFont.boldSystemFont(ofSize: 17)
        return $0
    }(UILabel())

    private var emailLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 12)
        $0.textColor = .gray
        $0.text = "이메일"
        return $0
    }(UILabel())

    private var ageLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "나이"
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())

    private var genderLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "성별"
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())

    private var scoreLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "점수"
        $0.font = UIFont.systemFont(ofSize: 14)
        return $0
    }(UILabel())

    init() {
        super.init(frame: .zero)

        backgroundColor = .white
        layout()

    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func layout() {

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 90)
        ])

        let profileImageSection: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIView())

        profileImageSection.addSubview(profileImageView)
        addSubview(profileImageSection)

        let profileImageViewWidth = CGFloat(60)
        profileImageView.layer.cornerRadius = profileImageViewWidth / 2

        NSLayoutConstraint.activate([
            profileImageSection.topAnchor.constraint(equalTo: topAnchor),
            profileImageSection.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileImageSection.bottomAnchor.constraint(equalTo: bottomAnchor),

            profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewWidth),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor),

            profileImageView.leadingAnchor.constraint(equalTo: profileImageSection.leadingAnchor, constant: 15),

            profileImageView.centerXAnchor.constraint(equalTo: profileImageSection.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: profileImageSection.centerYAnchor)
        ])

        let infoSection: UIView = {
            $0.translatesAutoresizingMaskIntoConstraints = false
            return $0
        }(UIView())
        infoSection.addSubview(nameLabel)
        infoSection.addSubview(emailLabel)
        infoSection.addSubview(ageLabel)
        infoSection.addSubview(genderLabel)
        infoSection.addSubview(scoreLabel)

        let verticalSpace: CGFloat = 3

        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: infoSection.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: infoSection.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: infoSection.trailingAnchor),

            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: verticalSpace),
            emailLabel.leadingAnchor.constraint(equalTo: infoSection.leadingAnchor),
            emailLabel.trailingAnchor.constraint(equalTo: infoSection.trailingAnchor),

            ageLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: verticalSpace),
            ageLabel.leadingAnchor.constraint(equalTo: infoSection.leadingAnchor),
            ageLabel.widthAnchor.constraint(equalToConstant: 50),

            genderLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: verticalSpace),
            genderLabel.leadingAnchor.constraint(equalTo: ageLabel.trailingAnchor, constant: 10),
            genderLabel.widthAnchor.constraint(equalToConstant: 50),

            scoreLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: verticalSpace),
            scoreLabel.leadingAnchor.constraint(equalTo: genderLabel.trailingAnchor, constant: 10),
            scoreLabel.widthAnchor.constraint(equalToConstant: 50),

            scoreLabel.bottomAnchor.constraint(equalTo: infoSection.bottomAnchor)
        ])

        addSubview(infoSection)
        NSLayoutConstraint.activate([
            infoSection.leadingAnchor.constraint(equalTo: profileImageSection.trailingAnchor),
            infoSection.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),

            infoSection.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }

}

class ProfileHeaderView: UITableViewHeaderFooterView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    let profileView: ProfileView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(ProfileView())

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit() {
        backgroundColor = .white
        layout()
    }

    func layout() {
        addSubview(profileView)
        NSLayoutConstraint.activate([
            profileView.topAnchor.constraint(equalTo: topAnchor),
            profileView.bottomAnchor.constraint(equalTo: bottomAnchor),
            profileView.leadingAnchor.constraint(equalTo: leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }

}
