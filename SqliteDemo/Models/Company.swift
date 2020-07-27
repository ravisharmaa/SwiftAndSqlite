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
    let employees: [Employee]?
    
    enum CodingKeys: String, CodingKey {
        case name, founded
        case photoURL = "photoUrl"
        case employees
    }
}

struct Employee: Codable, Hashable {
    let name: String?
    let birthday: String?
    let type: String?
}


extension Company {
    
    func convertToCompanyModel() -> CompanyModel {
        return .init(name: self.name, photoURL: self.photoURL, founded: self.founded)
    }
}


protocol Database {
    
    static func field <T: Any> (_ fieldName: String, typeOf: T.Type) -> Expression<T>
}


struct CompanyModel: Database, Hashable {
    
    let name: String?
    let photoURL: String?
    let founded: String?
    let uuid: UUID = UUID()
    
    
    static func field<T>(_ fieldName: String, typeOf: T.Type) -> Expression<T> {
        return Expression<T>(fieldName)
    }
    
    static func all() -> [CompanyModel]? {
        
        let db = DatabaseManager.shared.connection
        
        do {
            
            let companyQuery = try db.prepare(Migrations.getTableObject(name: "companies"))
            
            var companyModel: [CompanyModel] = [CompanyModel]()
            
            for result in companyQuery {
               
                companyModel.append(self.init(name: result[field("name", typeOf: String.self)],
                                              photoURL: result[field("photo_url", typeOf: String.self)],
                                              founded: result[field("founded", typeOf: String.self)]))
            }
            
            return companyModel
            
        } catch let error {
            print(error.localizedDescription)
        }
        
        return []

        
    }
}
