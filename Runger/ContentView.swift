//
//  ContentView.swift
//  Runger
//
//  Created by Kristine Yip on 4/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var goTest: Bool?
    @EnvironmentObject var runviewmodel: RunViewModel
    @StateObject var timer = StopWatch()

    var body: some View {
        Text("isRunning: \(runviewmodel.isRunning)")
        if runviewmodel.isRunning {
            RunView(runViewModel: runviewmodel)
        } else {
            TabView {
                // home tab
                VStack {
                    EmptyView()
                }
                .tabItem { Label("Home", systemImage: "house") }
                .navigationBarHidden(true)
                .padding()
                
                // running tab
                VStack {
                    StartRunView(runViewModel: runviewmodel)
                }
                .tabItem{Label("Run", systemImage: "figure.run")}
                .navigationBarHidden(true).environmentObject(timer)
                
                VStack {
                    EmptyView()
                }
                .tabItem{Label("Account", systemImage: "person")}
                .navigationBarHidden(true).environmentObject(timer)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RunViewModel())
}
