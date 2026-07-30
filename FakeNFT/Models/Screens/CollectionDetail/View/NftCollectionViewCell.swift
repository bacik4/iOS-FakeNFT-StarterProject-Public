import UIKit

final class NftCollectionViewCell: UICollectionViewCell {

    // MARK: - Static Properties

    static let reuseIdentifier = String(
        describing: NftCollectionViewCell.self
    )

    // MARK: - Public Properties

    var onFavoriteButtonTapped: (() -> Void)?
    var onCartButtonTapped: (() -> Void)?

    // MARK: - Private Properties

    private var imageLoadingTask: URLSessionDataTask?
    private var currentImageURL: URL?

    private let nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.layer.cornerRadius = 12
        return imageView
    }()

    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)

        let configuration = UIImage.SymbolConfiguration(
            pointSize: 20,
            weight: .medium
        )

        button.setImage(
            UIImage(
                systemName: "heart",
                withConfiguration: configuration
            ),
            for: .normal
        )

        button.tintColor = .systemRed
        return button
    }()

    private let ratingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()

    private var ratingImageViews: [UIImageView] = []

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 17,
            weight: .bold
        )
        label.textColor = .label
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private let priceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Цена"
        label.font = .systemFont(ofSize: 10)
        label.textColor = .label
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(
            ofSize: 17,
            weight: .medium
        )
        label.textColor = .label
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.7
        return label
    }()

    private let cartButton: UIButton = {
        let button = UIButton(type: .system)

        let configuration = UIImage.SymbolConfiguration(
            pointSize: 18,
            weight: .medium
        )

        button.setImage(
            UIImage(
                systemName: "cart",
                withConfiguration: configuration
            ),
            for: .normal
        )

        button.tintColor = .label
        return button
    }()

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        configureAppearance()
        configureRatingView()
        configureLayout()
        configureActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func prepareForReuse() {
        super.prepareForReuse()

        imageLoadingTask?.cancel()
        imageLoadingTask = nil
        currentImageURL = nil

        nftImageView.image = UIImage(systemName: "photo")

        nameLabel.text = nil
        priceLabel.text = nil

        updateRating(0)
        updateFavoriteButton(isFavorite: false)
        updateCartButton(isInCart: false)

        onFavoriteButtonTapped = nil
        onCartButtonTapped = nil
    }

    // MARK: - Public Methods

    func configure(with model: NftCellModel) {
        imageLoadingTask?.cancel()
        imageLoadingTask = nil

        nameLabel.text = model.name
        priceLabel.text = model.priceText

        updateRating(model.rating)
        updateFavoriteButton(isFavorite: model.isFavorite)
        updateCartButton(isInCart: model.isInCart)

        nftImageView.image = UIImage(systemName: "photo")

        guard let imageURL = model.imageURL else {
            currentImageURL = nil
            return
        }

        currentImageURL = imageURL

        imageLoadingTask = ImageLoader.shared.loadImage(
            from: imageURL
        ) { [weak self] image in
            guard let self else { return }
            guard self.currentImageURL == imageURL else { return }

            self.imageLoadingTask = nil
            self.nftImageView.image =
                image ?? UIImage(systemName: "photo")
        }
    }
}

// MARK: - Configuration

private extension NftCollectionViewCell {

    func configureAppearance() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
    }

    func configureRatingView() {
        let configuration = UIImage.SymbolConfiguration(
            pointSize: 10,
            weight: .medium
        )

        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.image = UIImage(
                systemName: "star",
                withConfiguration: configuration
            )
            imageView.tintColor = .systemYellow
            imageView.contentMode = .scaleAspectFit

            ratingImageViews.append(imageView)
            ratingStackView.addArrangedSubview(imageView)
        }
    }

    func configureActions() {
        favoriteButton.addTarget(
            self,
            action: #selector(favoriteButtonDidTap),
            for: .touchUpInside
        )

        cartButton.addTarget(
            self,
            action: #selector(cartButtonDidTap),
            for: .touchUpInside
        )
    }
}

// MARK: - Layout

private extension NftCollectionViewCell {

    func configureLayout() {
        [
            nftImageView,
            favoriteButton,
            ratingStackView,
            nameLabel,
            priceTitleLabel,
            priceLabel,
            cartButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            nftImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor
            ),
            nftImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            nftImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            nftImageView.heightAnchor.constraint(
                equalTo: nftImageView.widthAnchor
            ),

            favoriteButton.topAnchor.constraint(
                equalTo: nftImageView.topAnchor,
                constant: 4
            ),
            favoriteButton.trailingAnchor.constraint(
                equalTo: nftImageView.trailingAnchor,
                constant: -4
            ),
            favoriteButton.widthAnchor.constraint(
                equalToConstant: 32
            ),
            favoriteButton.heightAnchor.constraint(
                equalToConstant: 32
            ),

            ratingStackView.topAnchor.constraint(
                equalTo: nftImageView.bottomAnchor,
                constant: 8
            ),
            ratingStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            ratingStackView.heightAnchor.constraint(
                equalToConstant: 12
            ),

            nameLabel.topAnchor.constraint(
                equalTo: ratingStackView.bottomAnchor,
                constant: 4
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),

            priceTitleLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 4
            ),
            priceTitleLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),

            priceLabel.topAnchor.constraint(
                equalTo: priceTitleLabel.bottomAnchor,
                constant: 2
            ),
            priceLabel.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor
            ),
            priceLabel.trailingAnchor.constraint(
                lessThanOrEqualTo: cartButton.leadingAnchor,
                constant: -4
            ),
            priceLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor
            ),

            cartButton.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor
            ),
            cartButton.centerYAnchor.constraint(
                equalTo: priceLabel.centerYAnchor
            ),
            cartButton.widthAnchor.constraint(
                equalToConstant: 32
            ),
            cartButton.heightAnchor.constraint(
                equalToConstant: 32
            )
        ])
    }
}

// MARK: - Updating UI

private extension NftCollectionViewCell {

    func updateRating(_ rating: Int) {
        let safeRating = min(max(rating, 0), 5)

        for (index, imageView) in ratingImageViews.enumerated() {
            let imageName = index < safeRating
                ? "star.fill"
                : "star"

            imageView.image = UIImage(systemName: imageName)
        }
    }

    func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite
            ? "heart.fill"
            : "heart"

        favoriteButton.setImage(
            UIImage(systemName: imageName),
            for: .normal
        )
    }

    func updateCartButton(isInCart: Bool) {
        let imageName = isInCart
            ? "cart.fill"
            : "cart"

        cartButton.setImage(
            UIImage(systemName: imageName),
            for: .normal
        )
    }
}

// MARK: - Actions

private extension NftCollectionViewCell {

    @objc
    func favoriteButtonDidTap() {
        onFavoriteButtonTapped?()
    }

    @objc
    func cartButtonDidTap() {
        onCartButtonTapped?()
    }
}
