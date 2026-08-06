//
//  UserCollectionViewController.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 22.07.2026.
//

import UIKit
import ProgressHUD

final class UserCollectionViewController: UIViewController {
    
    // MARK: - Private Properties
    private let viewModel: UserCollectionViewModel
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = Constants.CollectionView.minimumLineSpacingForSection
        layout.minimumInteritemSpacing = Constants.CollectionView.minimumInteritemSpacingForSection
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(resource: .nftWhite)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifiers.NFTCollectionViewCell)
        
        return collectionView
    }()
    
    // MARK: - Initializers
    init(viewModel: UserCollectionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupUI()
        bindViewModel()
        
        viewModel.loadNFTs()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        ProgressHUD.dismiss()
    }
    
    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.onLoadingChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                guard let self else { return }
                
                if isLoading {
                    ProgressHUD.show()
                    self.collectionView.isUserInteractionEnabled = false
                } else {
                    ProgressHUD.dismiss()
                    self.collectionView.isUserInteractionEnabled = true
                }
            }
        }
        
        viewModel.onNFTsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
        
        viewModel.onNFTChanged = { [weak self] index in
            DispatchQueue.main.async {
                self?.collectionView.reloadItems(at: [IndexPath(item: index, section: 0)])
            }
        }
        
        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.showError(message: message)
            }
        }
    }
    
    private func showError(message: String) {
        guard presentedViewController == nil else {
            return
        }
        
        let alert = UIAlertController(
            title: NSLocalizedString("ShowError.message", comment: ""),
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(
                title: NSLocalizedString("Alert.close", comment: ""),
                style: .default
            )
        )
        
        present(alert, animated: true)
    }
}

//MARK: - UI Setup
extension UserCollectionViewController {
    func setupUI() {
        view.backgroundColor = UIColor(resource: .nftWhite)
        title = NSLocalizedString("UserCollection.header", comment: "")
        
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

//MARK: - CollectionViewDataSource
extension UserCollectionViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfNFTs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.NFTCollectionViewCell, for: indexPath) as? NFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let nft = viewModel.getNft(at: indexPath.row)
        cell.configure(viewModel: nft)
        
        cell.onLikeButtonTapped = { [weak self] in
            self?.viewModel.toggleLike(at: indexPath.row)
        }
        
        cell.onCartButtonTapped = { [weak self] in
            self?.viewModel.toggleCart(at: indexPath.row)
        }
        
        return cell
    }
}

//MARK: - CollectionViewDelegateFlowLayout
extension UserCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let horizontalInsets = Constants.CollectionViewFlowLayout.horizontalInsets
        let spacing: CGFloat = Constants.CollectionView.minimumInteritemSpacingForSection
        let availableWidth = collectionView.bounds.width - horizontalInsets * 2 - spacing * 2
        let width = floor(availableWidth / 3)
        
        return CGSize(width: width, height: Constants.CollectionViewFlowLayout.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.CollectionView.minimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.CollectionView.minimumInteritemSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 16, right: 16)
    }
}
