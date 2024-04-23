//
//  RunViewModel.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import Foundation
import CoreData
import CoreLocation
import _MapKit_SwiftUI
import HealthKit

class RunViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isRunning: Bool = false
    @Published var position: MapCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        )
    )
    
    @Published var userPath = MKPolyline()
    
    
    var routeBuilder: HKWorkoutRouteBuilder?
    var locations: [CLLocation] = []
    
    private var currentRun: RunModel?
    let locationManager = CLLocationManager()
    private var isRequestingLocation = false
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        /// https://stackoverflow.com/questions/67271580/hkworkoutroutebuilder-and-cllocationmanager-only-adding-route-updates-in-increme
        // Update every 13.5 meters in order to achieve updates no faster than once every 3sec.
        // This assumes runner is running at no faster than 6min/mile
        locationManager.distanceFilter = 13.5
        locationManager.activityType = .fitness
        
        startTracking()
    }
    
    /// LOCATION-RELATED FUNCTIONS
    func startTracking() {
        //        authorize location
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
            requestLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            guard let lastLocation = locations.last else {
                print("error, no location gotten")
                return
            }
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                )
            )
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
            position = MapCameraPosition.region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
                    span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
                )
            )
        @unknown default:
            break
        }
    }
    
    func requestLocation() {
        if !isRequestingLocation {
            isRequestingLocation = true
            locationManager.requestLocation()
        }
    }
    
    // handle authorization changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
        default:
            print("Location not authorized")
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        isRequestingLocation = false
        
        /// check which dining halls are near this location
        print("didUpdateLocations Location: \(location)")
        self.locations.append(location)
        updatePath(with: self.locations)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        isRequestingLocation = false
        print("Failed to get location: \(error)")
    }
    
    private func updatePath(with locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate }
        self.userPath = MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    /// RUN-RELATED FUNCTIONS
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
    
    func startRun() {
        let newRun = RunModel(context: context)
        newRun.id = UUID()
        newRun.startTime = Date()
        currentRun = newRun
        isRunning = true
//        saveContext()
    }
    
    func endRun() {
        guard let run = currentRun else { return }
        run.endTime = Date()
        isRunning = false
//        saveContext()
        currentRun = nil
    }
}

class PresetViewModel: ObservableObject {
    @Published var presets: [PresetInterval] = []
    
    func addTime(_ time: Double) {
        presets.append(PresetInterval(type: .time, value: time))
    }
    
    func addDistance(_ distance: Double) {
        presets.append(PresetInterval(type: .distance, value: distance))
    }
}
