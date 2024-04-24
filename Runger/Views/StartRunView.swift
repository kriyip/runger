//
//  StartRunView.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import SwiftUI
import MapKit

enum RunMode: String {
    case onTheFly
    case preset
}

enum RunType: String {
    case time
    case distance
}

struct PresetInterval {
    let type: RunType
    let value: Double
}

struct StartRunView: View {
    @Environment(\.managedObjectContext) private var context
    @StateObject var runViewModel: RunViewModel
    
    @State var isStarted: Bool = false
    @State var selectedMode: RunMode = .onTheFly
    @State private var distance: Double = 0
    @State private var time: Double = 0
    var presetViewModel = PresetViewModel()
    
    var body: some View {
        if (isStarted) {
            // getting just preset running mode to work first
            RunView(runViewModel: runViewModel)
        } else {
            GeometryReader { geometry in
                ZStack {
                    Map(position: $runViewModel.position)
                        .edgesIgnoringSafeArea(.all)
                    
                    Color.black.opacity(0.25)
                        .edgesIgnoringSafeArea(.all)
                        .transition(.opacity)
                    
                    VStack {
                        Spacer()
                        
                        VStack {
                            Text("Start Run")
                                .font(.headline)
                                .padding(.top)
                            
                            Picker("Mode", selection: $selectedMode) {
                                Text("On-the-Fly").tag(RunMode.onTheFly)
                                Text("Preset").tag(RunMode.preset)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding()
                            
                            if selectedMode == .onTheFly {
                                onTheFlyView()
                            } else {
                                presetView(presetViewModel: presetViewModel)
                            }
                                                                
                        }.padding()
                        .padding(.horizontal)
                        .background(Color.white.opacity(0.8).cornerRadius(15))
                        .frame(width: geometry.size.width * 0.9)
                        
                        Spacer()
                        Button("Start Run") {
                            runViewModel.isRunning = true
                            isStarted = true
                        }
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: 150)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(15)
                        .padding()
                    }
                }
            }
        }
        
    }
    private func getDynamicVStackHeight() -> CGFloat {
            // calculate the height of the VStack content dynamically
            // based on the number of intervals or other content you have.
            let baseHeight: CGFloat = 200 // Base height for picker and buttons
            let intervalHeight: CGFloat = 50 // Approximate height per interval row
            let intervalCount = CGFloat(presetViewModel.presets.count) // Number of intervals
            return baseHeight + (intervalCount * intervalHeight)
        }
}

struct onTheFlyView: View {
    var body: some View {
        Text("Feeling spontaneous? Create intervals as you run using On-the-Fly mode.")
            .font(.callout)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 30)
            .padding(.bottom)
    }
}

struct presetView: View {
    @ObservedObject var presetViewModel: PresetViewModel
    @State var showTimeInput: Bool = false
    @State var showDistanceInput: Bool = false
    @State var timeInput: String = ""
    @State var distanceInput: String = ""
    
    var body: some View {
        VStack {
            // debug statement (timeInput is always nil??
            Text("Want structure? Use Preset mode to follow your interval running plan.")
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)
            
            let columns: [GridItem] = [
                GridItem(.flexible(minimum: 50)), // For index numbers
                GridItem(.flexible()), // For time
                GridItem(.flexible()), // For distance
            ]
            
            HStack {
                LazyVGrid(columns: columns, alignment: .center, spacing: 10) {
                    Text("#")
                        .font(.headline)
                    Text("Time")
                        .font(.headline)
                    Text("Distance")
                        .font(.headline)
                    
                    ForEach(presetViewModel.presets.indices, id: \.self) { index in
                        Text("\(index + 1)")
                        if presetViewModel.presets[index].type == .time {
                            Text("\(presetViewModel.presets[index].value, specifier: "%.2f")")
                            Text("")
                        } else {
                            Text("")
                            Text("\(presetViewModel.presets[index].value, specifier: "%.2f")")
                        }
                    }
                    
                    // row for adding new intervals
                    Text("\(presetViewModel.presets.count + 1)")
                    
                    if showTimeInput {
                        TextField("sec", text: $timeInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .onSubmit {
                                if let time = Double(timeInput) {
                                    presetViewModel.addTime(time)
                                }
                                showTimeInput = false
                                timeInput = ""
                            }
                            .onDisappear {
                                timeInput = ""
                            }
                    } else {
                        Button(action: {
                            showTimeInput = true
                            showDistanceInput = false
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                    
                    if showDistanceInput {
                        TextField("mi", text: $distanceInput)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .multilineTextAlignment(.center)
                            .keyboardType(.numberPad)
                            .onSubmit {
                                if let distance = Double(distanceInput) {
                                    presetViewModel.addDistance(distance)
                                }
                                showDistanceInput = false
                                distanceInput = ""
                            }
                            .onDisappear {
                                distanceInput = ""
                            }
                    } else {
                        Button(action: {
                            showDistanceInput = true
                            showTimeInput = false
                        }) {
                            Image(systemName: "plus.circle")
                        }
                    }
                    
                }.padding()
                Spacer()
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    StartRunView(runViewModel: RunViewModel())
}
