//
//  RunView.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import SwiftUI

struct RunView: View {
//    @Environment(\.managedObjectContext) private var context
    @ObservedObject var runViewModel: RunViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        VStack {
            if runViewModel.isRunning {
                Text("run in progress")
            } else {
                Text("not running")
            }
        }

    }
}

#Preview {
    RunView(runViewModel: RunViewModel(context: PersistenceController.shared.container.viewContext))
}
