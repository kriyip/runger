//
//  TestView.swift
//  Runger
//
//  Created by Kristine Yip on 4/22/24.
//

import SwiftUI
import HealthKit
import MapKit


struct TestView: View {
//    @StateObject var locationManager: LocationManager
    @State private var authorizationStatus: HKAuthorizationStatus = .notDetermined
    @State private var workouts: [HKWorkout] = []
    @State private var routeLocations = [CLLocation]()
    
    @ObservedObject var runViewModel: RunViewModel

    var body: some View {
        VStack {
            if authorizationStatus == .sharingAuthorized {
                Text("Authorized")
                
                Map(position: $runViewModel.position)
                    
                
//                List(workouts, id: \.uuid) { workout in
//                    Text("Workout: \(workout.startDate)")
//                }
                
            } else {
                Text("Authorization status: \(authorizationStatus)")
                Button("Authorize HealthKit") {
                    Task {
                        self.authorizationStatus = await HKController.requestAuth()
                    }
                }
            }
        }.onAppear() {
            /// start location tracking
            runViewModel.startTracking()
        }

    }
    // used to load a previous workout, i think
//    private func loadWorkouts() {
//        HKController.loadWorkouts { loadedWorkouts in
//            self.workouts = loadedWorkouts
//            // Optionally, load routes for each workout
//            for workout in workouts {
//                HKController.loadWorkoutRoute(hkWorkout: workout) { locations in
//                    self.routeCoordinates += locations.map { $0.coordinate }
//                }
//            }
//        }
//    }
    
}

#Preview {
    TestView(runViewModel: RunViewModel(context: PersistenceController.shared.container.viewContext))
}
