//
//  SaveRunView.swift
//  Runger
//
//  Created by Deepika Kannan on 4/21/24.
//
import SwiftUI

struct SaveRunView: View {
    @EnvironmentObject var runViewModel: RunViewModel
    @EnvironmentObject var timer: StopWatch
    @EnvironmentObject var persistenceController: PersistenceController
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Run Ended")
                    .font(.headline)
                
                VStack {
                    Text("Distance: \(String(format: "%.2f", runViewModel.totalDistance)) m")
                    Text("Duration: \(timer.timeString)")
                    if (timer.secondsPassed > 0) {
                        Text("Average Pace: \(String(format: "%.2f", runViewModel.totalDistance / timer.secondsPassed)) m/s")
                            .padding()
                    }
                }.padding()
                
                if (timer.secondsPassed <= 0) {
                    Text("this run is too short to be saved.")
                        .font(.caption)
                        .bold()
                        .foregroundStyle(.red)
                }
                Button("Save Run") {
                    persistenceController.saveRun(distance: runViewModel.totalDistance, duration: timer.secondsPassed) // Saves the current state to CoreData
                    runViewModel.resetRunViewModel() // Reset the ViewModel for new data
                }
                .padding()
                .background(timer.secondsPassed > 0 ? Color.green : Color.secondary)
                .foregroundColor(.white)
                .clipShape(Capsule())
                .disabled(timer.secondsPassed <= 0)

                Button("Discard Run") {
                    runViewModel.resetRunViewModel() // Clears the current run data without saving
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
            .navigationBarTitle("Run Details", displayMode: .inline)
        }
    }
}

struct SaveRunView_Previews: PreviewProvider {
    static var previews: some View {
        SaveRunView()
            .environmentObject(PersistenceController.shared)
            .environmentObject(RunViewModel())
            .environmentObject(StopWatch())
    }
}
