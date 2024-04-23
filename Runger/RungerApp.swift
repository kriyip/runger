//
//  RungerApp.swift
//  Runger
//
//  Created by Kristine Yip on 4/11/24.
//

import SwiftUI

@main
struct RungerApp: App {    
    @State var goTest: Bool?
    @StateObject var runviewmodel = RunViewModel(context: PersistenceController.shared.container.viewContext)
    @StateObject var vm = PresetViewModel()
    
    var body: some Scene {
        
        WindowGroup {
            if let goTest = goTest {
                if goTest {
                    TestView(runViewModel: runviewmodel)
                } else {
                    RunView(runViewModel: runviewmodel, presetViewModel: vm)
                }
            } else {
                Button("TestView") {
                    goTest = true
                }
                Button("RunView") {
                    goTest = false
                }
            }
        }
        
    }
}
