//
//  Company.swift
//  SqliteDemo
//
//  Created by Ravi Bastola on 7/23/20.
//

import Foundation
import SQLite


struct Company:  Codable, Hashable {
    
    let name: String?
    let photoURL: String?
    let founded: String?
    
    enum CodingKeys: String, CodingKey {
        case name, founded
        case photoURL = "photoUrl"
    }
}


extension Company {
    
    static func field <T: Any> (name: String, typeOf: T.Type) -> Expression <T> {
        return Expression<T>(name)
    }
    
    static func all() -> [Company?] {
      
        do {
            let companies = try DatabaseManager.shared.connection.prepare(Migrations.getTableObject(name: "companies"))
            
            var companyModel: [Company] = [Company]()
            
            for company in companies {
                companyModel.append(self.init(name:company[field(name: "name", typeOf: String.self)],
                                              photoURL: company[field(name: "photo_url", typeOf: String.self)],
                                              founded: company[field(name: "founded", typeOf: String.self)]))
            }
            
            return companyModel
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
}
