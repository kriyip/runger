//
//  RungerApp.swift
//  Runger
//
//  Created by Kristine Yip on 4/11/24.


import SwiftUI

@main
struct RungerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            StartRunView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
