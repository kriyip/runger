//
//  PersistenceController.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import Foundation
import CoreData

class PersistenceController: ObservableObject {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "DataModel")
        if inMemory {
            let description = NSPersistentStoreDescription()
            description.url = URL(fileURLWithPath: "/dev/null")
            container.persistentStoreDescriptions = [description]
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func saveContext() {
        saveContext(context: container.viewContext)
    }
    
    private func saveContext(context: NSManagedObjectContext) {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    // Function to fetch all RunModel objects from the persistent store
    func getResults() -> [RunModel] {
        let request: NSFetchRequest<RunModel> = RunModel.fetchRequest()
        
        request.sortDescriptors = [NSSortDescriptor(keyPath: \RunModel.startTime, ascending: false)]
        
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Failed to fetch results: \(error)")
            return []
        }
    }
}

