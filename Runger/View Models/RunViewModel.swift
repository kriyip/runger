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
    @Published var shouldSaveRun: Bool = false
    
    @Published var position: MapCameraPosition = MapCameraPosition.region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 39.95145254, longitude: -75.19634140),
            span: MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
        )
    )
    
    @Published var lineCoordinates: [CLLocationCoordinate2D] = []
    @Published var userPath = MKPolyline()
    
    @Published var lastLocation: CLLocation?
    @Published var runLocations: [CLLocation?] = []
    @Published var runDistances : [CLLocationDistance?] = []
    @Published var totalDistance: CLLocationDistance = 0.0
    @Published var currSpeed : CLLocationSpeed = 0.0
    
    @Published var totalMeters: Double = 0.0
    @Published var totalTime: String = "00:00:00" // Time as a string
    @Published var numberOfRuns: Int = 0
    @Published var lastRun: Run?
    
    var routeBuilder: HKWorkoutRouteBuilder?
    var locations: [CLLocation] = []
        
    let locationManager = CLLocationManager()
    private var isRequestingLocation = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        /// https://stackoverflow.com/questions/67271580/hkworkoutroutebuilder-and-cllocationmanager-only-adding-route-updates-in-increme
        // Update every 13.5 meters in order to achieve updates no faster than once every 3sec (6 min/mile max update)
        locationManager.distanceFilter = 13.5
        locationManager.activityType = .fitness
        
        startTracking()
        locationManager.startUpdatingLocation()
    }
    
    /// LOCATION-RELATED FUNCTIONS
    func startTracking() {
        //        authorize location
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
            requestLocation()
            locationManager.allowsBackgroundLocationUpdates = true
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
        @unknown default:
            break
        }
    }
    
    func setCameraPosition(latitude: Double, longitude: Double) {
        position = MapCameraPosition.region(
            MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
        )
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
        lastLocation = location
        runLocations.append(lastLocation)
        
        let locationsCount = runLocations.count
        if (locationsCount > 1) {
            self.currSpeed = location.speed
            let newDist = lastLocation?.distance(from:( runLocations[locationsCount - 2] ?? lastLocation)!)
            runDistances.append(newDist)
            totalDistance += newDist ?? 0.0
        }
        
        /// check which dining halls are near this location
        print("didUpdateLocations Location: \(location)")
        self.locations.append(location)
        updatePath(with: self.locations)
        setCameraPosition(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        lineCoordinates.append(location.coordinate)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        isRequestingLocation = false
        print("Failed to get location: \(error)")
    }
    
    private func updatePath(with locations: [CLLocation]) {
        let coordinates = locations.map { $0.coordinate }
        self.userPath = MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    /// RUN LOGIC RELATED FUNCTIONS
    func startRun() {
        let locationsCount = runLocations.count
        if locationsCount > 1 {
            let locToKeep = runLocations[locationsCount - 1]
            runLocations.removeAll()
            runLocations.append(locToKeep)
        }
        runDistances.removeAll()
        totalDistance = 0.0
        
        // Initialize a new run using PersistenceController
        isRunning = true
    }

    
    func resetRunViewModel() {
        isRunning = false
        runLocations = []
        runDistances = []
        totalDistance = 0.0
        currSpeed = 0.0
        currentRun = nil
        
        updateLastRun()
    }
    
    func updateLastRun() {
        let runs = PersistenceController.shared.getResults()
        if let mostRecentRun = runs.first {
            let distance = mostRecentRun.totalDistance
            let duration = calculateDuration(run: mostRecentRun)
            let locations = self.runLocations  // This needs to correctly reflect locations from the most recent run

            self.lastRun = Run(distance: distance, timer: duration, locations: locations)
        }
    }
    
    private func calculateDuration(run: RunModel) -> Double {
        guard let start = run.startTime, let end = run.endTime else { return 0 }
        return end.timeIntervalSince(start)
    }
    
    func fetchWeeklySnapshot() {
           let runs = PersistenceController.shared.getResults()
        _ = runs.reduce(0.0) { $0 + $1.totalDistance }
        let totalTime = runs.reduce(0.0) { $0 + calculateDuration(run: $1) }
           let numberOfRuns = runs.count

           DispatchQueue.main.async {
               self.totalMeters = self.totalMeters
               self.totalTime = self.formatDuration(totalTime)
               self.numberOfRuns = numberOfRuns
           }
       }
       
       private func formatDuration(_ totalSeconds: Double) -> String {
           let hours = Int(totalSeconds / 3600)
           let minutes = Int(totalSeconds.truncatingRemainder(dividingBy: 3600) / 60)
           let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
           return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
       }
    
    func fetchLastRun() {
        let runs = PersistenceController.shared.getResults()
        if let firstRun = runs.first {
            let distance = firstRun.totalDistance  // Assuming RunModel has totalDistance
            let duration = calculateDuration(run: firstRun)  // Ensure this method calculates correctly
            let locations = self.runLocations 

            // Now create the Run object
            self.lastRun = Run(distance: distance, timer: duration, locations: locations)
        }
    }
    
    func createMockRun() -> Run {
        let locations = createMockLocations()
        return Run(distance: 5000.0, timer: 1800.0, locations: locations)
    }

    // Helper function to create a list of CLLocation objects
    private func createMockLocations() -> [CLLocation?] {
        let coordinates = [
            CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),  // Example coordinates
            CLLocationCoordinate2D(latitude: 37.7750, longitude: -122.4184),
            CLLocationCoordinate2D(latitude: 37.7751, longitude: -122.4174)
        ]
        return coordinates.map { CLLocation(latitude: $0.latitude, longitude: $0.longitude) }
    }
    
    // In RunViewModel
    func loadMockRun() {
        self.lastRun = createMockRun()
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
