//
//  ViewController.swift
//  SqliteDemo
//
//  Created by Ravi Bastola on 7/23/20.
//

import UIKit
import SQLite

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        
//        NetworkService.shared.fetch(o≥bject: [Company].self) { (response) in
//            switch response {
//            case .success(let companies):
//
//                let db = DatabaseManager.shared.connection
//
//                do {
//                    let statement = try db.prepare("INSERT INTO companies (name, photo_url, founded) VALUES (?, ?, ?)")
//
//                    for company in companies {
//                        try statement.run(company.name, company.photoURL, company.founded)
//                    }
//
//
//                } catch let error  {
//                    print(error, "Cannot insert values")
//                }
//
//
//            case .failure(let error):
//                print(error)
//            }
//        }
        
    }
    
    
}

