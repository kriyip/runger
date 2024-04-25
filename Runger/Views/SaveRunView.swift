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
                Text("Distance: \(String(format: "%.2f", runViewModel.totalDistance)) meters")
                Text("Duration: \(timer.timeString)")
                Text("Average Pace: \(String(format: "%.2f", runViewModel.totalDistance / timer.secondsPassed)) min/mi")
            
                .padding()
                
                Button("Save Run") {
                    persistenceController.saveContext() // Saves the current state to CoreData
                    runViewModel.resetRunViewModel() // Reset the ViewModel for new data
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Capsule())

                Button("Discard Run") {
                    runViewModel.resetRunViewModel() // Clears the current run data without saving
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())
                
                NavigationLink(destination: SavedRunView()) {
                    Text("See All Saved Runs")
                        .foregroundColor(.blue)
                        .padding()
                }
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
