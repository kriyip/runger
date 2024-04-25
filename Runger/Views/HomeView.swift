//
//  HomeView.swift
//  Runger
//
//  Created by Teena Bhatia on 22/4/24.
//
import Foundation
import SwiftUI
import CoreData
import MapKit

struct ActivityView: View {
    let activity: String // You would replace this with your actual activity data model
    
    var body: some View {
        VStack {
            // Content of your activity
            Text(activity)
                .font(.headline)
                .padding()
        }
        .frame(width: 300, height: 200)
        .background(Color.blue)
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

struct HomeView: View {
    // You might need to replace these with actual data from your ViewModel
    @State private var totalMiles = "0.0"
    @State private var totalTime = "0:00"
    @State private var numberOfRuns = 0
    @State private var currentWeather = "Loading..."
    private var pastActivities = ["Run 1", "Run 2", "Run 3", "Run 4", "Run 5"]
    @StateObject private var runViewModel = RunViewModel()  // Consider using @EnvironmentObject if shared across views
    @State private var isRunStarted: Bool = false
    @State private var mockRun: Run?

    
    var formattedTotalDistance: String {
           String(format: "%.2f", runViewModel.totalDistance)
       }

    
    var body: some View {
        
        
        NavigationView {
            
            VStack(spacing: 20) {
                Text("Your Home")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 25, leading: 22, bottom: 0, trailing: 0))
                
                VStack(alignment: .leading, spacing: 16) {
                                    Text("Weekly Snapshot")
                                        .font(.headline)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                        .padding(EdgeInsets(top: 10, leading: 5, bottom: 0, trailing: 0))
                                    
                                    HStack {
                                        snapshotBox(title: "Total Metres", value: formattedTotalDistance)
                                        Divider().background(Color.secondary)
                                        snapshotBox(title: "Total Time", value: runViewModel.totalTime)
                                        Divider().background(Color.secondary)
                                        snapshotBox(title: "No. of Runs", value: "\(runViewModel.numberOfRuns)")
                                    }
                                    .padding(.horizontal)
                                    .frame(height: 100)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(10)
                                }
                                .padding(.horizontal)
                                .onAppear {
                                    runViewModel.fetchWeeklySnapshot()
                                }
                    

                // Location Weather Section
                VStack(alignment: .center, spacing: 16) {
                    Text("Location Weather")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    WeatherWidgetView()

                   // WeatherView(viewModel: weatherViewModel)
                }
                
               
                    
                // Displaying the last run
                Text("Last Run")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading)

                // Using RunMapView to display the last run's map
                // Conditional rendering based on availability of lastRun
                                if let lastRun = runViewModel.lastRun {
                                    RunMapView(run: lastRun)
                                        .frame(height: 200)
                                        .cornerRadius(15)
                                        .padding(.horizontal)
                                } else {
                                    Text("No recent runs available.")
                                        .padding()
                                }
                    
                    // Past Activities Carousel
//                    ScrollView(.horizontal, showsIndicators: false) {
//                        LazyHStack(spacing: 20) {
//                            ForEach(pastActivities, id: \.self) { activity in
//                                ActivityView(activity: activity)
//                            }
//                        }
//                        .padding(.horizontal)
//                    }
//                    .frame(height: 220) // Adjust height if necessary
                    
                    Spacer()
                }
//                .navigationBarTitle("Home", displayMode: .inline)
                .onAppear {
                    runViewModel.fetchLastRun()
                    runViewModel.fetchWeeklySnapshot()
                }
                
                
            }
        }
    
    @ViewBuilder
        private func snapshotBox(title: String, value: String) -> some View {
            VStack {
                Text(title)
                Text(value)
                    .bold()
            }
            .frame(maxWidth: .infinity)
        }
    }


// For previewing in Xcode
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


