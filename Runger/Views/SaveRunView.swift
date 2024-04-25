//
//  SaveRunView.swift
//  Runger
//
//  Created by Deepika Kannan on 4/21/24.
//
import SwiftUI

struct SaveRunView: View {
    @EnvironmentObject var runViewModel: RunViewModel
    @EnvironmentObject var persistenceController: PersistenceController
    
    var body: some View {
        NavigationView {
            VStack {
                // Check if there's an ongoing run or a completed run to display
                // Display the stats for a completed run
                Text("Run Ended")
                Group {
                    // Use the properties from RunModel directly
//                    Text("Duration: \(run.totalDuration.formatAsDuration())")
//                    Text("Distance: \(run.totalDistance, specifier: "%.2f") meters")
//                    Text("Average Pace: \(run.averagePace, specifier: "%.2f") min/km")
//                    Text("Duration: \(runViewModel.totalDuration.formatAsDuration())")
                    Text("Distance: \(runViewModel.totalDistance, specifier: "%.2f") meters")
//                    Text("Average Pace: \(runViewModel.totalDistance / runViewModel.totalDuration, specifier: "%.2f") min/km")
                }
                .padding()
                
                // Button to save the run
                Button("Save Run") {
                    persistenceController.saveContext()
                    runViewModel.resetRunViewModel()
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Capsule())

                // Button to discard the run
                Button("Discard Run") {
                    // TODO: see if there's a way to clear current context to prevent memory leaks
                    runViewModel.resetRunViewModel()
                }
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .clipShape(Capsule())

                // Link to see all saved runs
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

// Helper extension to format total duration as a duration string
private extension Double {
    func formatAsDuration() -> String {
        let duration = Int(self)
        let hours = duration / 3600
        let minutes = (duration % 3600) / 60
        let seconds = duration % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

struct SaveRunView_Previews: PreviewProvider {
    static var previews: some View {
        SaveRunView()
            .environmentObject(PersistenceController.shared)
            .environmentObject(RunViewModel())
    }
}
