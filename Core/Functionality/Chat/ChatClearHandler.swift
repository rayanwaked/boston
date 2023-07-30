//
//  ChatClearHandler.swift
//  Boston
//
//  Created by Rayan Waked on 7/29/23.
//

import SwiftUI
import CoreData

class CoreDataClearer {
    func clearCoreData(moc: NSManagedObjectContext, shouldReload: Binding<Bool>) {
        let entityNames = ["ConversationUser", "ConversationBoston"]
        
        do {
            for entityName in entityNames {
                guard NSEntityDescription.entity(forEntityName: entityName, in: moc) != nil else {
                    print("Error: Entity description not found for \(entityName)")
                    continue
                }
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
                
                if let result = try moc.execute(batchDeleteRequest) as? NSBatchDeleteResult,
                   let objectIDs = result.result as? [NSManagedObjectID] {
                    NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: objectIDs], into: [moc])
                }
            }
            
            try moc.save()
            
            DispatchQueue.main.async {
                shouldReload.wrappedValue.toggle()
            }
        } catch {
            print("Error deleting Core Data entities: \(error)")
        }
    }
}
