//
//  UserCollectionViewController.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 22.07.2026.
//

import UIKit

final class UserCollectionViewController: UIViewController {
    
    // MARK: - Private Properties
    private let viewModel: UserCollectionViewModel
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.minimumLineSpacing = Constants.collectionViewMinimumLineSpacingForSection
        layout.minimumInteritemSpacing = Constants.collectionViewMinimumInteritemSpacingForSection
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(resource: .nftWhite)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifiers.NFTCollectionViewCell)
        
        return collectionView
    }()
    
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
    
    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.onNFTsChanged = { [weak self] in
            DispatchQueue.main.async {
                self?.collectionView.reloadData()
            }
        }
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
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
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
        
        let nft = viewModel.nft(at: indexPath.row)
        cell.configure(viewModel: nft)
        
        return cell
    }
}

//MARK: - CollectionViewDelegateFlowLayout
extension UserCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = Constants.collectionViewMinimumInteritemSpacingForSection
        let width = (collectionView.bounds.width - spacing * 2) / 3
        let height = Constants.tableViewCellHeight
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.collectionViewMinimumLineSpacingForSection
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        Constants.collectionViewMinimumInteritemSpacingForSection
    }
}

