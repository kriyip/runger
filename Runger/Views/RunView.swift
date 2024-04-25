//
//  RunView.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import SwiftUI
import MapKit

struct RunView: View {
    @EnvironmentObject private var timer : StopWatch
    @EnvironmentObject var persistenceController: PersistenceController
    @ObservedObject var runViewModel: RunViewModel

    @State private var userPath = MKPolyline()
    @State private var showBottomSheet = false
    @State var runMode: RunMode = .preset
    
    @State private var isTapped : Bool = false
    @State private var button : String = "Start"
    @State private var color : Color = .green
    @State private var start : Bool = true
    @State private var displayEnd: Bool = false
    @State private var goToSaveRunView = false
    
    var startlocation : CLLocation!
    var endLocation : CLLocation!

    var body: some View {
        ZStack {
            MapView(locationManager: runViewModel, started: $isTapped)
                .ignoresSafeArea(.all)
            VStack {
                if !start {
                    Text("Running")
                        .font(.headline)
                } else {
                    Text("Paused")
                }
                Spacer()
                Text("Speed: \((runViewModel.currSpeed < 0) ? "0.00 m/s" : String(runViewModel.currSpeed))")
                    .font(.headline)
                Text("Distance: \(String(format: "%.2f", runViewModel.totalDistance)) m")
                    .font(.headline)
                Text("\(self.timer.timeString)")
                    .font(.system(size : 40)).padding().offset(y:10)
                    .bold()
                    .foregroundStyle(self.timer.mode == .start ? .green : .blue)
                
                HStack{
                    if isTapped == false {
                        // disable tapping if already tapped once
                    }
                    // resume/pause button
                    Button(action: {
                        if self.timer.mode == .stop || self.timer.mode == .pause {
                            self.startRun()
                            displayEnd = true
                        } else {
                            self.pauseRun()
                        }
                    }){
                        ZStack{
                            Circle()
                                .fill(color)
                                .frame(width: 100, height: 100)
                            Text(button)
                                .foregroundColor(Color.white)
                        }.padding()
                    }
                    
                    if start && displayEnd {
                        Button(action: {
                            goToSaveRunView = true
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                                Text("End")
                                    .foregroundColor(Color.white)
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $goToSaveRunView) {
            SaveRunView()
        }
        .onAppear() {
            /// start tracking, initialize run model for new run
            timer.reset()
            runViewModel.startTracking()
            persistenceController.initializeRun()
            runViewModel.startRun()
        }
    }
    
    func startRun() {
        if start {
            button = "Stop"
            color = .red
        }
        self.timer.start()
        self.isTapped.toggle()
        self.start.toggle()
    }
    
    func pauseRun() {
        self.timer.pause()
        self.start.toggle()
        self.isTapped.toggle()
        self.button = "Resume"
        self.color = .green
    }
}
