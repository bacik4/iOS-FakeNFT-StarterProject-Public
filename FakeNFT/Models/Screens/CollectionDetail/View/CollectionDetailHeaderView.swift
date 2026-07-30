import UIKit

final class CollectionDetailHeaderView: UICollectionReusableView {
    
    var onAuthorTapped: (() -> Void)?
    
    static let reuseIdentifier = String(
        describing: CollectionDetailHeaderView.self
    )
    
    private var imageLoadingTask: URLSessionDataTask?
    private var currentCoverURL: URL?
    
    private let coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .label
        label.numberOfLines = 0
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .systemBlue
        label.numberOfLines = 1
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureLayout()
        configureActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageLoadingTask?.cancel()
        imageLoadingTask = nil
        currentCoverURL = nil
        
        coverImageView.image = nil
        nameLabel.text = nil
        descriptionLabel.text = nil
        authorLabel.text = nil
        
        onAuthorTapped = nil
    }
    
    func configure(with model: CollectionHeaderModel) {
        imageLoadingTask?.cancel()
        
        currentCoverURL = model.coverURL
        nameLabel.text = model.name
        descriptionLabel.text = model.description
        authorLabel.text = model.author
        coverImageView.image = UIImage(systemName: "photo")
        
        let coverURL = model.coverURL
        
        imageLoadingTask = ImageLoader.shared.loadImage(
            from: coverURL
        ) { [weak self] image in
            guard let self else { return }
            guard self.currentCoverURL == coverURL else { return }
            
            self.imageLoadingTask = nil
            self.coverImageView.image =
            image ?? UIImage(systemName: "photo")
        }
    }
}

private extension CollectionDetailHeaderView {
    
    func configureLayout() {
        [
            coverImageView,
            nameLabel,
            descriptionLabel,
            authorLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            coverImageView.topAnchor.constraint(equalTo: topAnchor),
            coverImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            coverImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            coverImageView.heightAnchor.constraint(equalToConstant: 310),
            
            nameLabel.topAnchor.constraint(
                equalTo: coverImageView.bottomAnchor,
                constant: 16
            ),
            nameLabel.leadingAnchor.constraint(
                equalTo: leadingAnchor,
                constant: 16
            ),
            nameLabel.trailingAnchor.constraint(
                equalTo: trailingAnchor,
                constant: -16
            ),
            
            descriptionLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor,
                constant: 8
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor
            ),
            
            authorLabel.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: 8
            ),
            authorLabel.leadingAnchor.constraint(
                equalTo: nameLabel.leadingAnchor
            ),
            authorLabel.trailingAnchor.constraint(
                equalTo: nameLabel.trailingAnchor
            ),
            authorLabel.bottomAnchor.constraint(
                equalTo: bottomAnchor,
                constant: -16
            )
        ])
    }
    
    private func configureActions() {
        authorLabel.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(authorLabelDidTap)
        )
        
        authorLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func authorLabelDidTap() {
        onAuthorTapped?()
    }
}
