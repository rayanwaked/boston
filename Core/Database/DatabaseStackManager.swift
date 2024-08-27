//
//  DatabaseStackManager.swift
//  Boston
//
//  Created by Rayan Waked on 3/11/23.
//

// MARK: - IMPORT
import CoreData

// MARK: - DATA CONTROLLER
class DataController: ObservableObject {
    static let shared = DataController()
    let container = NSPersistentContainer(name: "Conversations")
    
    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error)")
            }
        }
    }
}
