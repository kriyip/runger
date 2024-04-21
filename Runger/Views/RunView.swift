//
//  RunView.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import SwiftUI
import MapKit
import BottomSheet

struct RunView: View {
//    @Environment(\.managedObjectContext) private var context
    @ObservedObject var runViewModel: RunViewModel
    @State private var userPath = MKPolyline()
    @State private var showBottomSheet = false

    var body: some View {
        VStack {
//            if runViewModel.isRunning {
//                Text("run in progress")
//            } else {
//                Text("not running")
//            }
            ZStack {
                Map()
                Button("Toggle Bottom Sheet") {
                    withAnimation {
                        showBottomSheet.toggle()
                    }
                }
            }
            
//            Map(position: $runViewModel.position, overlays: [userPath])
//            .onAppear() {
//                runViewModel.setupLocationTracking()
//            }
//            .onDisappear() {
////                    runViewModel.stopTracking()
//            }
//            .onChange(of: runViewModel.locations) {
//                
//            }
            
        }
    }
}

#Preview {
    RunView(runViewModel: RunViewModel(context: PersistenceController.shared.container.viewContext))
}
