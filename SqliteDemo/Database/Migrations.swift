//
//  Migrations.swift
//  SqliteDemo
//
//  Created by Ravi Bastola on 7/23/20.
//

import Foundation
import SQLite

class Migrations {
    
    class func run() {
        createCompaniesTable()
        createEmployees()
    }
    
    private class func createUsersTable() {
        
        let table = Migrations.getTableObject(name: "users")
        
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let email = Expression<String>("email")
        let address = Expression<String?>("address")
        
        do {
            
            try DatabaseManager.shared.connection.run(table.create(ifNotExists: true, block: { (builder) in
                builder.column(id, primaryKey: true)
                builder.column(name)
                builder.column(email, unique: true)
                builder.column(address)
            }))
            
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
    

    private class func createCompaniesTable() {
        
        let table = Migrations.getTableObject(name: "companies")
        
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let photoURL = Expression<String?>("photo_url")
        let founded = Expression<String?>("founded")
        
        do {
            
            try DatabaseManager.shared.connection.run(table.create(ifNotExists: true, block: { (builder) in
                builder.column(id, primaryKey: true)
                builder.column(name)
                builder.column(photoURL, defaultValue: nil)
                builder.column(founded, defaultValue: nil)
            }))
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    private class func createEmployees() {
        
        let table = Migrations.getTableObject(name: "employees")
        
        let id = Expression<Int64>("id")
        let name = Expression<String?>("name")
        let companyId = Expression<Int64>("company_id")
        let birthday = Expression<String?>("birthday")
        let type = Expression<String?>("type")
        
        do {
            
            try DatabaseManager.shared.connection.run(table.create(ifNotExists: true, block: { (builder) in
                builder.column(id, primaryKey: true)
                builder.column(name)
                builder.column(companyId)
                builder.column(birthday, defaultValue: nil)
                builder.column(type, defaultValue: nil)
            }))
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    class func getTableObject(name: String) -> Table {
        let table = Table(name)
        
        return table
    }
}
