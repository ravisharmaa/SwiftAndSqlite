//
//  Company.swift
//  SqliteDemo
//
//  Created by Ravi Bastola on 7/23/20.
//

import Foundation
import SQLite

protocol Retrievable {
    
    static func field <T: Any> (fieldName: String, typeOf: T.Type) -> Expression<T>
}

struct Company:  Codable, Hashable {
    
    let name: String?
    let photoURL: String?
    let founded: String?
    
    enum CodingKeys: String, CodingKey {
        case name, founded
        case photoURL = "photoUrl"
    }
}


extension Company: Retrievable {
        
    static func field<T>(fieldName: String, typeOf: T.Type) -> Expression<T> {
        return Expression<T>(fieldName)
    }
    
    
    static func all() -> [Company]? {
      
        do {
            let companies = try DatabaseManager.shared.connection.prepare(Migrations.getTableObject(name: "companies"))
            
            var companyModel: [Company] = [Company]()
            
            for company in companies {
                companyModel.append(self.init(name:company[field(fieldName: "name", typeOf: String.self)],
                                              photoURL: company[field(fieldName: "photo_url", typeOf: String.self)],
                                              founded: company[field(fieldName: "founded", typeOf: String.self)]))
            }
            
            return companyModel
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []
    }
}
