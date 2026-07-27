import UIKit

final class CatalogCollectionCell: UITableViewCell {

    static let reuseIdentifier = String(
        describing: CatalogCollectionCell.self
    )

    private var imageLoadingTask: URLSessionDataTask?

    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()

    private let nftCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureAppearance()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        imageLoadingTask?.cancel()
        imageLoadingTask = nil

        coverImageView.image = UIImage(systemName: "photo")
        nameLabel.text = nil
        nftCountLabel.text = nil
    }

    func configure(with model: CatalogCellModel) {
        nameLabel.text = model.name
        nftCountLabel.text = model.nftCountText
        coverImageView.image = UIImage(systemName: "photo")

        imageLoadingTask = ImageLoader.shared.loadImage(
            from: model.coverURL
        ) { [weak self] image in
            self?.coverImageView.image =
                image ?? UIImage(systemName: "photo")
        }
    }
}

private extension CatalogCollectionCell {

    func configureAppearance() {
        backgroundColor = .clear
        selectionStyle = .none
    }

    func configureLayout() {
        [
            coverImageView,
            nameLabel,
            nftCountLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(
                equalTo: contentView.topAnchor,
                constant: 8
            ),
            coverImageView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor,
                constant: 16
            ),
            coverImageView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor,
                constant: -16
            ),
            coverImageView.heightAnchor.constraint(
                equalTo: coverImageView.widthAnchor,
                multiplier: 0.55
            ),

            nameLabel.topAnchor.constraint(
                equalTo: coverImageView.bottomAnchor,
                constant: 8
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: coverImageView.leadingAnchor
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: coverImageView.trailingAnchor
            ),

            nftCountLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 4
            ),
            nftCountLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),
            nftCountLabel.trailingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor
            ),
            nftCountLabel.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor,
                constant: -12
            )
        ])
    }
}
