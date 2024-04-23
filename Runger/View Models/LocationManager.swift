//import Foundation
//import _MapKit_SwiftUI
//import CoreLocation
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    static let shared = LocationManager()
//    private let locationManager = CLLocationManager()
//    var locations = [CLLocation]()
//    var isTracking = false
//    
//    @Published var position: MapCameraPosition = MapCameraPosition.region(
//        MKCoordinateRegion(
//            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
//            span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
//        )
//    )
//    @Published var userPath = MKPolyline()
//
//    override init() {
//        super.init()
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        locationManager.activityType = .fitness
//    }
//
//    func startTracking() {
//        locationManager.requestAlwaysAuthorization()
//        locationManager.startUpdatingLocation()
//        isTracking = true
//        locations.removeAll()
//    }
//
//    func stopTracking() {
//        locationManager.stopUpdatingLocation()
//        isTracking = false
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
//        locations.append(contentsOf: newLocations)
//    }
//    
//    
//}
//
