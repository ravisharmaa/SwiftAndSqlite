//
//  DatabaseManager.swift
//  SqliteDemo
//
//  Created by Ravi Bastola on 7/23/20.
//

import Foundation
import SQLite


struct DatabaseManager {
    
    static let shared = DatabaseManager()
    
    let connection: Connection = {
        
        var dbConnection: Connection!
        
        do {
            
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            
            let url = NSURL(fileURLWithPath: path)
            
            if let pathComponent = url.appendingPathComponent("database")?.appendingPathExtension("sqlite3") {
                
                let filePath = pathComponent.path
                
                print(filePath)
                
                if FileManager.default.fileExists(atPath: filePath) {
                    
                    let database = try Connection(filePath)
                    
                    dbConnection = database
                    
                } else {
                    
                    var documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    
                    let fileURL = documentDirectory.appendingPathComponent("database").appendingPathExtension("sqlite3")
                    
                    print(fileURL.path)
                    
                    let database = try Connection(fileURL.path)
                    
                    dbConnection = database
                    
                }
            }
        } catch let error {
            print("Cannot Initilize Databse", error.localizedDescription)
        }
        
        return dbConnection
        
    }()
    
    
    private init () {}
    
    
}
