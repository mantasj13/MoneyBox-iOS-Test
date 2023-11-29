//
//  AccountCell.swift
//  MoneyBox
//
//  Created by Mantas Jakstas on 28/11/23.
//

import Foundation
import UIKit

final class AccountCell: UITableViewCell {

    private let leftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(named: "AccentColor")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let productTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .semibold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let planValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = UIColor.gray
        return label
    }()

    private let moneyboxValueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15.0, weight: .regular)
        label.textColor = UIColor.gray
        return label
    }()

    private let rightImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = UIColor(named: "AccentColor")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override var accessibilityElements: [Any]? {
        set {}
        get {
             [
                self.productTitleLabel as Any,
                self.leftImageView as Any,
                self.planValueLabel as Any,
                self.moneyboxValueLabel as Any,
                self.rightImageView as Any
             ]
        }
    }

    func configureAccessibility() {
        self.productTitleLabel.accessibilityHint = "This is the title of the account."
        self.leftImageView.accessibilityHint = "Image of the account."
        self.planValueLabel.accessibilityHint = "This is the amount of your plan value."
        self.moneyboxValueLabel.accessibilityHint = "This is the amount of money box."
    }

    func setData(leftImageURL: String?, planValue: Double?, moneyboxValue: Double?, productTitle: String?) {
        if let leftImageURL {
            leftImageView.downloaded(from: leftImageURL)
        } else {
            leftImageView.image = UIImage(named: "photo")
        }
        productTitleLabel.text = productTitle
        planValueLabel.text = "Plan value: \(planValue?.formatAsPounds() ?? "")"
        moneyboxValueLabel.text = "Moneybox: \(moneyboxValue?.formatAsPounds() ?? "")"
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(leftImageView)
        contentView.addSubview(productTitleLabel)
        contentView.addSubview(planValueLabel)
        contentView.addSubview(moneyboxValueLabel)
        contentView.addSubview(rightImageView)

        NSLayoutConstraint.activate([
            leftImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            leftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftImageView.widthAnchor.constraint(equalToConstant: 60),
            leftImageView.heightAnchor.constraint(equalToConstant: 60),

            productTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            productTitleLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
            productTitleLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -8),

            planValueLabel.topAnchor.constraint(equalTo: productTitleLabel.bottomAnchor, constant: 4),
            planValueLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
            planValueLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -8),

            moneyboxValueLabel.topAnchor.constraint(equalTo: planValueLabel.bottomAnchor, constant: 4),
            moneyboxValueLabel.leadingAnchor.constraint(equalTo: leftImageView.trailingAnchor, constant: 8),
            moneyboxValueLabel.trailingAnchor.constraint(equalTo: rightImageView.leadingAnchor, constant: -8),
            moneyboxValueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),

            rightImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            rightImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightImageView.widthAnchor.constraint(equalToConstant: 30),
            rightImageView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
