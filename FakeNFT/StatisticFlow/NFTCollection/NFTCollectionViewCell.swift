//
//  NFTCollectionViewCell.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 22.07.2026.
//
import UIKit
import Kingfisher

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
    
    // MARK: - Overrides Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        
        nftImageView.kf.cancelDownloadTask()
        nftImageView.image = nil
        ratingImageView.image = nil
        nameLabel.text = nil
        priceLabel.text = nil
        likeButton.setImage(nil, for: .normal)
    }
    
    // MARK: - Public Methods
    func configure(viewModel: NFTCollectionCellViewModel) {
        nameLabel.text = viewModel.name
        priceLabel.text = "\(viewModel.price) ETH"
        ratingImageView.image = makeRatingImage(rating: viewModel.rating)
        
        let likeImage = viewModel.isLiked
        ? UIImage(resource: .likeActiveIcon)
        : UIImage(resource: .likeInactiveIcon)
        
        likeButton.setImage(likeImage, for: .normal)
        nftImageView.kf.setImage(with: viewModel.imageURL)
    }
    
    private func makeRatingImage(rating: Int) -> UIImage? {
        switch rating {
        case 1:
            return UIImage(resource: .ratingOne)
        case 2:
            return UIImage(resource: .ratingTwo)
        case 3:
            return UIImage(resource: .ratingThree)
        case 4:
            return UIImage(resource: .ratingFour)
        case 5:
            return UIImage(resource: .ratingFive)
        default:
            return nil
        }
    }
    
    // MARK: - UI Settings
    private func configureAppearance() {
        nftImageView.backgroundColor = UIColor(resource: .nftLightGrey)
        nftImageView.contentMode = .scaleAspectFill
        nftImageView.clipsToBounds = true
        nftImageView.layer.cornerRadius = 12
        
        ratingImageView.contentMode = .scaleAspectFit
        
        nameLabel.font = .systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = UIColor(resource: .nftBlack)
        nameLabel.numberOfLines = 1
        nameLabel.lineBreakMode = .byTruncatingTail
        
        priceLabel.font = .systemFont(ofSize: 10, weight: .medium)
        priceLabel.textColor = UIColor(resource: .nftBlack)
        priceLabel.numberOfLines = 1
        
        cartButton.setImage(UIImage(resource: .cartIcon), for: .normal)
    }
    
    private func addSubviews() {
        let views: [UIView] = [
            nftImageView,
            likeButton,
            ratingImageView,
            nameLabel,
            priceLabel,
            cartButton
        ]
        
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nftImageView.heightAnchor.constraint(equalTo: nftImageView.widthAnchor),
            
            likeButton.topAnchor.constraint(equalTo: nftImageView.topAnchor),
            likeButton.trailingAnchor.constraint(equalTo: nftImageView.trailingAnchor),
            likeButton.widthAnchor.constraint(equalToConstant: 40),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            
            ratingImageView.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 8),
            ratingImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            ratingImageView.widthAnchor.constraint(equalToConstant: 68),
            ratingImageView.heightAnchor.constraint(equalToConstant: 12),
            
            nameLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: cartButton.leadingAnchor, constant: -4),
            
            priceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            priceLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            priceLabel.trailingAnchor.constraint(lessThanOrEqualTo: cartButton.leadingAnchor, constant: -4),
            priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            
            cartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cartButton.bottomAnchor.constraint(equalTo: priceLabel.bottomAnchor),
            cartButton.widthAnchor.constraint(equalToConstant: 40),
            cartButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupUI() {
        configureAppearance()
        addSubviews()
        setupConstraints()
    }
}
