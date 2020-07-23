//
//  ViewController.swift
//  SqliteDemo
//
//  Created by Ravi Bastola on 7/23/20.
//

import UIKit
import SQLite

class ViewController: UICollectionViewController {
    
    var companies: [Company] = [Company]()
    
    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Company>!
    
    init() {
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        
        let layout =  UICollectionViewCompositionalLayout.list(using: config)
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        guard let companies = Company.all() else { return }
        
        self.companies = companies
        
        configureData()
        
        collectionView.translatesAutoresizingMaskIntoConstraints  = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ])
        
    }
    
    
    func configureData() {
        
        if self.companies.count <= 0 {
            
            NetworkService.shared.fetch(object: [Company].self) { (response) in
                switch response {
                case .success(let companies):
                    
                    self.companies = companies
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.configureDataSource()
                        self?.configureSnapshot()
                    }
                    
                    let db = DatabaseManager.shared.connection
                    
                    do {
                        let statement = try db.prepare("INSERT INTO companies (name, photo_url, founded) VALUES (?, ?, ?)")
                        
                        for company in companies {
                            try statement.run(company.name, company.photoURL, company.founded)
                        }
                        
                        
                    } catch let error  {
                        print(error, "Cannot insert values")
                    }
                    
                    
                case .failure(let error):
                    print(error)
                }
            }
        } else {
            configureDataSource()
            configureSnapshot()
        }
    }
    
    
    func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Company>.init { (cell, indexPath, company) in
            var content = cell.defaultContentConfiguration()
            content.text = company.name
            
            cell.contentConfiguration = content
        }
        
        dataSource = .init(collectionView: collectionView, cellProvider: { (collectionView, indexPath, company) -> UICollectionViewCell? in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: company)
            
            return cell
        })
    }
    
    func configureSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Company>()
        
        snapshot.appendSections([.main])
        
        snapshot.appendItems(self.companies)
        
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
}

