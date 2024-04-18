//
//  StartRunView.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import SwiftUI

enum RunMode: String {
    case onTheFly
    case preset
}

struct StartRunView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject var runViewModel: RunViewModel
    
    @State var isStarted: Bool = false
    @State var selectedMode: RunMode = .onTheFly
    @State private var distance: Double = 0
    @State private var time: Double = 0
            
    var body: some View {
        if (isStarted) {
            RunView(runViewModel: runViewModel)
        } else {
            Text("Hello World")
            VStack {
                Button("Start Run") {
                    runViewModel.isRunning = true
                    isStarted = true
                }
                
                Picker("Mode", selection: $selectedMode) {
                    Text("On the Fly").tag(RunMode.onTheFly)
                    Text("Preset").tag(RunMode.preset)
                }
            }
        }
    }
    
}

#Preview {
    StartRunView(runViewModel: RunViewModel(context: PersistenceController.shared.container.viewContext))
}
