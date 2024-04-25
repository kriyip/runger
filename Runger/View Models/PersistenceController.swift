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
    
    var currentRun: RunModel?
    
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
        //print("Saveing context")
        if context.hasChanges {
            print("saving context")
            do {
                print("saving context")
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
    
    func initializeRun() {
        currentRun = RunModel(context: container.viewContext)
        currentRun?.id = UUID()
        currentRun?.startTime = Date()
        print("current run: \(String(describing: currentRun))")
    }
    
    func saveRun(distance: Double, duration: Double) {
        print("in save run")
        guard let currentRun else {
            print("current run?? \(String(describing: currentRun))")
            return
        }
        currentRun.endTime = Date()
        currentRun.totalDistance = distance // meters
        currentRun.totalDuration = duration // seconds
        currentRun.averagePace = distance / duration // m/s
        print("distance: \(distance), duration: \(duration)")
        saveContext()
    }
}


