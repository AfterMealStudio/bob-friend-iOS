//
//  MyPageTableViewCell.swift
//  bob-friend-iOS
//
//  Created by 김수진 on 2021/12/29.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {

    var title: String? {
        get { return label.text }
        set(value) { label.text = value }
    }

    let label: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.systemFont(ofSize: 15)
        return $0
    }(UILabel())

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

// MARK: - layout

extension MyPageTableViewCell {
    func layout() {

        heightAnchor.constraint(equalToConstant: 50).isActive = true

        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])

    }
}
