//
//  UserProfileViewController.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 23.07.2026.
//

import UIKit
import Kingfisher

final class UserProfileViewController: UIViewController {
    
    // MARK: - Private Properties
    private let viewModel: UserProfileViewModel
    private let nftService: NftService
    
    private lazy var avatarImageView = UIImageView()
    private lazy var nameLabel = UILabel()
    private lazy var descriptionLabel = UILabel()
    private lazy var goToWebButton = UIButton()
    private lazy var userCollectionButton = UIButton()
    
    private lazy var collectionTitleLabel = UILabel()
    private lazy var collectionArrowImageView = UIImageView()
    
    // MARK: - Initializers
    init(viewModel: UserProfileViewModel, nftService: NftService) {
        self.viewModel = viewModel
        self.nftService = nftService
        
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(resource: .nftWhite)
        title = NSLocalizedString("UserProfileViewController.header", comment: "")
        
        setupUI()
        bindViewModel()
    }
    
    @objc private func goToWebButtonTapped() {
        guard let url = URL(string: viewModel.website) else { return }
        
        let webViewController = WebViewViewController(url: url)
        navigationController?.pushViewController(webViewController, animated: true)
    }
    
    @objc private func userCollectionButtonTapped() {
        let collectionViewModel = UserCollectionViewModel(nftIDs: viewModel.nftIDs, nftService: nftService)
        let controller = UserCollectionViewController(viewModel: collectionViewModel)
        
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - UI Setup
extension UserProfileViewController {
    private func setupAvatar() {
        avatarImageView.image = UIImage(resource: .avatarPlaceholderIcon)
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.cornerRadius = 35
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(avatarImageView)
        
        NSLayoutConstraint.activate([
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            avatarImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func setupNameLabel() {
        nameLabel.font = .systemFont(ofSize: 22, weight: .bold)
        nameLabel.textColor = UIColor(resource: .nftBlack)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 16),
            nameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupDescriptionLabel() {
        descriptionLabel.font = .systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.textColor = UIColor(resource: .nftBlack)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20)
        ])
    }
    
    private func setupGoToWebButton() {
        goToWebButton.setTitle(NSLocalizedString("UserProfile.goToWebButton", comment: ""), for: .normal)
        goToWebButton.setTitleColor(UIColor(resource: .nftBlack), for: .normal)
        goToWebButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .regular)
        goToWebButton.backgroundColor = .clear
        goToWebButton.layer.borderWidth = 1
        goToWebButton.layer.borderColor = UIColor(resource: .nftBlack).cgColor
        goToWebButton.layer.cornerRadius = 16
        
        goToWebButton.addTarget(self, action: #selector(goToWebButtonTapped), for: .touchUpInside)
        
        goToWebButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(goToWebButton)
        
        NSLayoutConstraint.activate([
            goToWebButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            goToWebButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            goToWebButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 28),
            goToWebButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func setupUserCollectionButton() {
        collectionTitleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        collectionTitleLabel.textColor = UIColor(resource: .nftBlack)
        collectionArrowImageView.image = UIImage(systemName: "chevron.right")
        collectionArrowImageView.tintColor = UIColor(resource: .nftBlack)
        
        let stackView = UIStackView(arrangedSubviews: [
            collectionTitleLabel,
            collectionArrowImageView
        ])
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.isUserInteractionEnabled = false
        
        userCollectionButton.addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: userCollectionButton.leadingAnchor,constant: 16),
            stackView.trailingAnchor.constraint(equalTo: userCollectionButton.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: userCollectionButton.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: userCollectionButton.bottomAnchor)
        ])
        
        userCollectionButton.addTarget(self,action: #selector(userCollectionButtonTapped), for: .touchUpInside)
        
        userCollectionButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(userCollectionButton)
        
        NSLayoutConstraint.activate([
            userCollectionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userCollectionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userCollectionButton.topAnchor.constraint(equalTo: goToWebButton.bottomAnchor,constant: 40),
            userCollectionButton.heightAnchor.constraint(equalToConstant: 54)
        ])
    }
    
    private func setupUI() {
        setupAvatar()
        setupNameLabel()
        setupDescriptionLabel()
        setupGoToWebButton()
        setupUserCollectionButton()
        
    }
    
    private func bindViewModel() {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        
        collectionTitleLabel.text =
        "\(NSLocalizedString("UserProfile.collectionButton", comment: "")) (\(viewModel.nftCount))"
        
        if let url = viewModel.avatarURL {
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(resource: .avatarPlaceholderIcon)
            )
        } else {
            avatarImageView.image = UIImage(resource: .avatarPlaceholderIcon)
        }
    }
}
