//
//  JobCollectionViewCell.swift
//  104Test
//
//  Created by Nic Wu on 2023/5/13.
//

import UIKit

class JobCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let companyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let salaryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let experienceLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let locationLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var favoriteButton: UIButton = {
        let button = UIButton()
        let size = UIImage.SymbolConfiguration(pointSize: 25)
        button.setImage(UIImage(systemName: "star.fill", withConfiguration: size), for: .normal)
        button.tintColor = .systemGray5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 25
        contentView.addSubview(titleLabel)
        contentView.addSubview(companyLabel)
        contentView.addSubview(salaryLabel)
        contentView.addSubview(experienceLabel)
        contentView.addSubview(locationLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(favoriteButton)
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: dateLabel.leadingAnchor, constant: -10),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            companyLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            companyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            salaryLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            salaryLabel.topAnchor.constraint(equalTo: companyLabel.bottomAnchor, constant: 10),
            salaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            experienceLabel.leadingAnchor.constraint(equalTo: salaryLabel.trailingAnchor, constant: 5),
            experienceLabel.centerYAnchor.constraint(equalTo: salaryLabel.centerYAnchor),
            locationLabel.leadingAnchor.constraint(equalTo: experienceLabel.trailingAnchor, constant: 5),
            locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: favoriteButton.leadingAnchor),
            locationLabel.centerYAnchor.constraint(equalTo: salaryLabel.centerYAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            dateLabel.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: dateLabel.trailingAnchor),
            favoriteButton.centerYAnchor.constraint(equalTo: salaryLabel.centerYAnchor)
        ])
        dateLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
    }
}
