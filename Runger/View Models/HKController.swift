//
//  HKController.swift
//  Runger
//
//  Created by Kristine Yip on 4/21/24.
//

import Foundation
import HealthKit
import CoreLocation
import MapKit

// health kit controller
struct HKController {
    static let healthStore = HKHealthStore()
    static let available = HKHealthStore.isHealthDataAvailable()
    static let shared = HKController()
    var routeBuilder: HKWorkoutRouteBuilder?
    
    static func requestAuth() async -> HKAuthorizationStatus {
        let types: Set = [
            HKObjectType.workoutType(),
            HKSeriesType.workoutRoute()
        ]
        
        try? await healthStore.requestAuthorization(toShare: types, read: types)
        return status
    }
    
    static var status: HKAuthorizationStatus {
        let workoutStatus = healthStore.authorizationStatus(for: HKObjectType.workoutType())
        let routeStatus = healthStore.authorizationStatus(for: HKSeriesType.workoutRoute())
        if workoutStatus == .sharingAuthorized && routeStatus == .sharingAuthorized {
            return .sharingAuthorized
        } else if workoutStatus == .notDetermined && routeStatus == .notDetermined {
            return .notDetermined
        } else {
            return .sharingDenied
        }
    }
    
    static func loadWorkouts(completion: @escaping ([HKWorkout]) -> Void) {
        let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        let query = HKSampleQuery(sampleType: .workoutType(), predicate: nil, limit: HKObjectQueryNoLimit, sortDescriptors: [sort]) { query, samples, error in
            guard let workouts = samples as? [HKWorkout] else {
                completion([])
                return
            }
            completion(workouts)
        }
        healthStore.execute(query)
    }
    
    static func loadWorkoutRoute(hkWorkout: HKWorkout, completion: @escaping ([CLLocation]) -> Void) {
        let type = HKSeriesType.workoutRoute()
        let predicate = HKQuery.predicateForObjects(from: hkWorkout)
        
        let routeQuery = HKSampleQuery(sampleType: type, predicate: predicate, limit: HKObjectQueryNoLimit, sortDescriptors: nil) { query, samples, error in
            guard let route = samples?.first as? HKWorkoutRoute else {
                completion([])
                return
            }
            
            var locations = [CLLocation]()
            let locationsQuery = HKWorkoutRouteQuery(route: route) { query, newLocations, finished, error in
                locations.append(contentsOf: newLocations ?? [])
                if finished {
                    completion(locations)
                }
            }
            self.healthStore.execute(locationsQuery)
        }
        healthStore.execute(routeQuery)
    }
    
    mutating func startWorkout() {
        routeBuilder = HKWorkoutRouteBuilder(healthStore: HKController.healthStore, device: nil)
        
//        let workoutConfiguration = HKWorkoutConfiguration()
//        workoutConfiguration.activityType = .running
//        workoutConfiguration.locationType = .outdoor
//
//        do {
//            let workoutSession = try HKWorkoutSession(healthStore: healthStore, configuration: workoutConfiguration)
//            workoutSession.startActivity(with: Date())
//            // Retain workoutSession, e.g., in a property
//        } catch {
//            print("Failed to start workout session: \(error.localizedDescription)")
//        }
    }

    // routeBuilder.finishRoute automatically saves to healthkit store??
    func finishWorkout(_ workout: HKWorkout, metadata: [String: Any]) {
        guard let routeBuilder = routeBuilder else {
            return
        }
        routeBuilder.finishRoute(with: workout, metadata: metadata) { (newRoute, err) in
            guard newRoute != nil else {
                return
            }
            // do something??
        }
    }
}
