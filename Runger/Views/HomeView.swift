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
    

    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Titles are now outside of the boxes
                // Weekly Snapshot Section
                VStack(alignment: .leading, spacing: 16) {
                    Text("Weekly Snapshot")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0))
                    
                    HStack {
                        VStack {
                            Text("Total mi")
                            Text(totalMiles)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Vertical Divider
                        Rectangle()
                            .fill(Color.secondary)
                            .frame(width: 1)
                            .padding(.vertical, 19)
                        
                        VStack {
                            Text("Total Time")
                            Text(totalTime)
                        }
                        .frame(maxWidth: .infinity)
                        
                        // Vertical Divider
                        Rectangle()
                            .fill(Color.secondary)
                            .frame(width: 1)
                            .padding(.vertical, 19)
                        
                        VStack {
                            Text("# Activity")
                            Text("\(numberOfRuns)")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal)
                    .frame(height: 100) // This ensures the height is consistent.
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                    

                // Location Weather Section
                VStack(alignment: .center, spacing: 16) {
                    Text("Location Weather")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0))
                    WeatherWidgetView()

                   // WeatherView(viewModel: weatherViewModel)
                }
                
               
                    
                    Text("Last Run ")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading)
                VStack(alignment: .center, spacing: 16) {
                    MapView(locationManager: runViewModel, started: $isRunStarted)
                        .frame(height: 200) // Specify a height for the map view
                        .cornerRadius(15)
                        .padding(.horizontal)
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
                .navigationBarTitle("Home", displayMode: .inline)
                
            }
        }
    }


// For previewing in Xcode
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}


