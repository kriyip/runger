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
    @Published var currentRun: RunModel?
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
    }
    
    func endRun() {
        guard let run = currentRun else { return }
        run.endTime = Date()
        isRunning = false
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
