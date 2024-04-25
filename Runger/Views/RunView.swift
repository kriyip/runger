//
//  RunView.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import SwiftUI
import MapKit

struct RunView: View {
//    @Environment(\.managedObjectContext) private var context
    @ObservedObject var runViewModel: RunViewModel
//    @ObservedObject var presetViewModel: PresetViewModel

    @State private var userPath = MKPolyline()
    @State private var showBottomSheet = false
    @State var runMode: RunMode = .preset
    
    @State private var isTapped : Bool = false
    @State private var button : String = "Start"
    @State private var color : Color = .green
    @State private var start : Bool = true
    @State private var displayEnd: Bool = false
    
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
                Text("Speed: \((runViewModel.currSpeed < 0) ? "0.00" : String(runViewModel.currSpeed))")
                Text("Distance: \(runViewModel.totalDistance)")
//                Text(self.timer.timeString).font(.system(size : 20)).padding().offset(y:10)
                
                HStack{
                    if isTapped == false {
                        // disable tapping if already tapped once
                    }
                    Button(action: {if start {
                        startrun()
                        displayEnd = true;
                    } else {
                        stop()
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
                            SavedRunView()
//                            runViewModel.endRun()
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
        .onAppear() {
            /// start tracking
            runViewModel.startTracking()
            runViewModel.startRun()
        }
        .onDisappear() {
            /// stop tracking
            runViewModel.endRun()
        }
    }
    
    func startrun(){
        if start {
            button = "Stop"
            color = .red
        }
//        self.timer.start()
        self.isTapped.toggle()
        self.start.toggle()
    }
    
    func stop()  {
//        self.timer.stop()
        self.start.toggle()
        self.isTapped.toggle()
        
        //runList.addRun(run:Run(distance: 5.0, timer: timer.secs, locations: locManager.coords,region: locManager))
        button = "Resume"
        color = .green
    }
    
}
