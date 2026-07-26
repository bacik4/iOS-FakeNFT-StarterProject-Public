//
//  StatisticTableViewCell.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 22.07.2026.
//

import UIKit

final class StatisticTableViewCell: UITableViewCell {
    
    // MARK: - Private Properties
    private lazy var numberLabel = UILabel()
    private lazy var cardBGView = UIView()
    private lazy var avatarImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    private lazy var ratingLabel = UILabel()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        avatarImageView.image = UIImage(resource: .avatarPlaceholderIcon)
    }
    
    // MARK: - Public Methods
    func configure(number: Int, avatar: UIImage?, name: String, rating: Int) {
        numberLabel.text = "\(number)"
        nameLabel.text = name
        ratingLabel.text = "\(rating)"
        avatarImageView.image = avatar ?? UIImage(resource: .avatarPlaceholderIcon)
    }
    
    //MARK: - UI Setup
    private func setupNumberLabel() {
        numberLabel.font = .systemFont(ofSize: 15, weight: .regular)
        numberLabel.textColor = UIColor(resource: .nftBlack)
        numberLabel.textAlignment = .center
        
        numberLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            numberLabel.widthAnchor.constraint(equalToConstant: 27),
            numberLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    private func setupBGView() {
        cardBGView.backgroundColor = UIColor(resource: .nftLightGrey)
        cardBGView.layer.cornerRadius = 12
        
        cardBGView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardBGView)
        
        NSLayoutConstraint.activate([
            cardBGView.leadingAnchor.constraint(equalTo: numberLabel.trailingAnchor, constant: 8),
            cardBGView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardBGView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cardBGView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4)
        ])
    }
    
    private func setupAvatarImageView() {
        avatarImageView.image = UIImage(resource: .avatarPlaceholderIcon)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 14
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        cardBGView.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: cardBGView.leadingAnchor, constant: 16),
            avatarImageView.centerYAnchor.constraint(equalTo: cardBGView.centerYAnchor),
            avatarImageView.widthAnchor.constraint(equalToConstant: 28),
            avatarImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textColor = UIColor(resource: .nftBlack)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardBGView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: ratingLabel.leadingAnchor, constant: -8),
            nameLabel.centerYAnchor.constraint(equalTo: cardBGView.centerYAnchor)
        ])
    }
    
    private func setupRatingLabel() {
        ratingLabel.font = .systemFont(ofSize: 22, weight: .bold)
        ratingLabel.textColor = UIColor(resource: .nftBlack)
        ratingLabel.textAlignment = .right
        
        ratingLabel.translatesAutoresizingMaskIntoConstraints = false
        cardBGView.addSubview(ratingLabel)
        
        NSLayoutConstraint.activate([
            ratingLabel.trailingAnchor.constraint(equalTo: cardBGView.trailingAnchor, constant: -16),
            ratingLabel.centerYAnchor.constraint(equalTo: cardBGView.centerYAnchor)
        ])
    }
    
    private func setupUI() {
        setupNumberLabel()
        setupBGView()
        setupAvatarImageView()
        setupRatingLabel()
        setupNameLabel()
    }
}
