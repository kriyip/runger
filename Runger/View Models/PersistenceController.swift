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
    
    //Function to fetch the top 10 fastest runs by average pace
        func getTopFastestRuns(limit: Int = 10) -> [RunModel] {
            let fetchRequest: NSFetchRequest<RunModel> = RunModel.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "averagePace", ascending: true) // Assumes lower pace is faster
            fetchRequest.sortDescriptors = [sortDescriptor]
            fetchRequest.fetchLimit = limit // Limit the number of results

            do {
                return try container.viewContext.fetch(fetchRequest)
            } catch {
                print("Failed to fetch fastest runs: \(error)")
                return []
            }
        }
    
    func initializeRun() -> RunModel {
        let newRun = RunModel(context: container.viewContext)
        newRun.startTime = Date()
        newRun.totalDistance = 0.0
        newRun.averagePace = 0.0
        return newRun
    }

}

extension PersistenceController {
    static func previewContainer() -> NSPersistentContainer {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        
        // Create mock RunModel data
        for _ in 0..<10 {
            let runModel = RunModel(context: viewContext)
            runModel.id = UUID()
            runModel.startTime = Date()
            runModel.totalDistance = Double.random(in: 1000...5000)
        }
        
        // Save mock data
        do {
            try viewContext.save()
        } catch {
            // Handle any errors appropriately in your app
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        
        return controller.container
    }
}



