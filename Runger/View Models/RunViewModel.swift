//
//  RunViewModel.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import Foundation
import CoreData

class RunViewModel: ObservableObject {
    @Published var isRunning: Bool = false
    private var currentRun: RunModel?
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func startRun() {
        let newRun = RunModel(context: context)
        newRun.id = UUID()
        newRun.startTime = Date()
        currentRun = newRun
        isRunning = true
//        saveContext()
    }
    
    func endRun() {
        guard let run = currentRun else { return }
        run.endTime = Date()
        isRunning = false
//        saveContext()
        currentRun = nil
    }
}
