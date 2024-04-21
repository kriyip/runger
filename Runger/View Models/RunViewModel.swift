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

class RunViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var isRunning: Bool = false
    @Published var position: MapCameraPosition = .camera(
        .init(centerCoordinate: CLLocationCoordinate2D(latitude: 39.9522, longitude: -75.1932), distance: 5000)
    )
    @Published var locations: [CLLocation] = []
    
    private var currentRun: RunModel?
    let locationManager = CLLocationManager()
    private var isRequestingLocation = false
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    /// LOCATION-RELATED FUNCTIONS
//    call this func when the app first loads
    func setupLocationTracking() {
        //        authorize location
        switch locationManager.authorizationStatus {
        case .notDetermined, .restricted, .denied:
            locationManager.requestWhenInUseAuthorization()
            requestLocation()
        case .authorizedAlways, .authorizedWhenInUse:
            requestLocation()
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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        isRequestingLocation = false
        print("Failed to get location: \(error)")
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
