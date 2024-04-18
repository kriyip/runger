//
//  PersistenceController.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import Foundation
import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "CoreDataModel")
        container.loadPersistentStores(completionHandler: { (description, error) in
            if let error = error as NSError? {
                // Real apps should handle this error appropriately.
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
