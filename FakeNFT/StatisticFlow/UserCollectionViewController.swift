//
//  UserCollectionViewController.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 22.07.2026.
//

import UIKit

final class UserCollectionViewController: UIViewController {
    
    // MARK: - Private Properties
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColor(resource: .nftWhite)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(NFTCollectionViewCell.self, forCellWithReuseIdentifier: ReuseIdentifiers.NFTCollectionViewCell)
        
        return collectionView
    }()
    
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        setupUI()
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
        8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifiers.NFTCollectionViewCell, for: indexPath) as? NFTCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

//MARK: - CollectionViewDelegateFlowLayout
extension UserCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 9
        let width = (collectionView.bounds.width - spacing * 2) / 3
        
        return CGSize(width: width, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        9
    }
}

