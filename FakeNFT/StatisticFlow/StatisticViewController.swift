//
//  StatisticViewController.swift
//  FakeNFT
//
//  Created by Роман Пичугин on 22.07.2026.
//

import UIKit

final class StatisticViewController: UIViewController {
    
    //MARK: - Private Properties
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StatisticTableViewCell.self, forCellReuseIdentifier: ReuseIdentifiers.StatisticTableViewCell)
        
        return tableView
    }()
    
    //MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    @objc private func filterButtonTapped() {
        //TODO: Логика фильтрации
    }
}

//MARK: - UI Setup
extension StatisticViewController {
    
    private func setupNavigationBar() {
        let filterButton = UIBarButtonItem(image: UIImage(resource: .filterButtonIcon), style: .plain, target: self, action: #selector(filterButtonTapped))
        
        navigationItem.rightBarButtonItem = filterButton
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        ])
    }
    
    private func setupUI() {
        setupNavigationBar()
        setupTableView()
    }
}

//MARK: - UITableViewDataSource
extension StatisticViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.StatisticTableViewCell, for: indexPath) as? StatisticTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configure(number: indexPath.row + 1, avatar: nil, name: "UserTest", rating: 15)
        
        return cell
    }
}

//MARK: - UITableViewDelegate
extension StatisticViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        88
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true
        )
        let userViewController = UserProfileViewController()
        
        navigationController?.pushViewController(userViewController, animated: true)
    }
}
