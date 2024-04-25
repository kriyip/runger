//
//  RungerApp.swift
//  Runger
//
//  Created by Kristine Yip on 4/11/24.


import SwiftUI

@main
struct RungerApp: App {
    let persistenceController = PersistenceController.shared
    /// if we have time, add hkcontroller as an environment object, have a way to save a run to apple health settings

    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(PersistenceController())
                .environmentObject(RunViewModel())
                .environmentObject(StopWatch())
        }
    }
}
