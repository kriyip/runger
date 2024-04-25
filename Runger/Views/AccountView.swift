//
//  AccountView.swift
//  Runger
//
//  Created by Teena Bhatia on 22/4/24.
//

import SwiftUI
import CoreData

struct AccountView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var runViewModel: RunViewModel
    @ObservedObject var stopwatch: StopWatch
    @FetchRequest(
        entity: RunModel.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \RunModel.startTime, ascending: true)],
        animation: .default)
    private var runs: FetchedResults<RunModel>
    
    var body: some View {
        NavigationView {
            ScrollView {
                Text("Your Account")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 25, leading: 22, bottom: 0, trailing: 0))
                VStack(spacing: 12) {
                    // Header could be a view showing the current user's name or statistics
                    // AccountHeaderView()
                    
                    // GraphView showing progress, for example, distance over time
                    // if let distances = runs.map({ $0.totalDistance }),
                    let dataPoints = runs.map { GraphDataPoint(date: $0.startTime!, value: $0.totalDistance) }
                    GraphView(dataPoints: dataPoints)
                        .frame(height: 200)
                    
                    Text("Past Runs")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 25, bottom: 0, trailing: 0))
                    // List of saved runs
                    LazyVStack(spacing: 15) {
                        ForEach(runs, id: \.self) { run in
                                RunSummaryView(run: run)
                                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0)) // Add padding to space out the content
                                    .frame(maxWidth: 350, alignment: .leading)
                                    .background(RoundedRectangle(cornerRadius: 10) // Rounded corners
                                    .fill(Color.white) // White background
                                    .shadow(radius: 2)) // Slight shadow for depth
                            

                        }
                    }
                    
                  
                }
            }
//                .navigationBarTitle("Account", displayMode: .inline)
            }
        }
    
}

// A simple view component to display each run summary in the list
struct RunSummaryView: View {
    let run: RunModel
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading) {
            if let startTime = run.startTime {
                Text("Run on \(startTime, formatter: Self.dateFormatter)")
            } else {
                Text("Run on N/A")
            }
            Text("Distance: \(run.totalDistance, specifier: "%.2f") meters")
            // Include additional details as required
        }
    }
}


// Detail view when tapping on a saved run
struct SavedRunDetailView: View {
    let run: Run
    
    var body: some View {
        RunMapView(run: run)
            .edgesIgnoringSafeArea(.all)
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .long
    formatter.timeStyle = .medium
    return formatter
}()

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        let mockContainer = PersistenceController.previewContainer()
        return AccountView(runViewModel: RunViewModel(), stopwatch: StopWatch())
            .environment(\.managedObjectContext, mockContainer.viewContext)
    }
}

