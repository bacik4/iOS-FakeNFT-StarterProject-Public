//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 22.07.2026.
//
import UIKit

final class NFTCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Private Properties
    private lazy var nftImageView = UIImageView()
    private lazy var likeButton = UIButton()
    private lazy var ratingImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    private lazy var priceLabel = UILabel()
    private lazy var cartButton = UIButton()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    //MARK: - UI Settings
    private func setupNFTImageView() {
        nftImageView.backgroundColor = UIColor(resource: .nftLightGrey)
        nftImageView.contentMode = .scaleAspectFill
        nftImageView.clipsToBounds = true
        nftImageView.layer.cornerRadius = 12
        
        nftImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nftImageView)
        
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor)
        ])
    }
    
    private func setupLikeButton() {
        likeButton.setImage(UIImage(resource: .likeInactiveIcon), for: .normal)
        
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(likeButton)
        
        NSLayoutConstraint.activate([
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupRatingImageView() {
        ratingImageView.image = UIImage(resource: .ratingTwoStars)
        ratingImageView.contentMode = .left
        
        ratingImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(ratingImageView)
        
        NSLayoutConstraint.activate([
            ratingImageView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingImageView.widthAnchor.constraint(equalToConstant: 68),
            ratingImageView.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = UIColor(resource: .nftBlack)
        nameLabel.numberOfLines = 1
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: cartButton.leadingAnchor)
        ])
    }
    
    private func setupPriceLabel() {
        priceLabel.font = .systemFont(ofSize: 10, weight: .regular)
        priceLabel.textColor = UIColor(resource: .nftBlack)
        
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(priceLabel)
        
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
    private func setupCartButton() {
        cartButton.setImage(UIImage(resource: .cartIcon), for: .normal)
        
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cartButton)
        
        NSLayoutConstraint.activate([
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupUI() {
        setupNFTImageView()
        setupLikeButton()
        setupRatingImageView()
        setupCartButton()
        setupNameLabel()
        setupPriceLabel()
    }
}
