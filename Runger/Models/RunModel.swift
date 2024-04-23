//
//  RunModel.swift
//  Runger
//
//  Created by Kristine Yip on 4/21/24.
//

import Foundation
import HealthKit
import MapKit
import CoreLocation

/// this is just because I'm not sure how to store PolyLine yet in CoreData
/// for the actual final submission, we can maybe just not store PolyLines in core data
class Workout: NSObject {
    let polyline: MKPolyline
    let locations: [CLLocation]
    let date: Date
    let duration: Double
    let distance: Double
    let elevation: Double
    
    init(polyline: MKPolyline, locations: [CLLocation], date: Date, duration: Double) {
        self.polyline = polyline
        self.locations = locations
        self.date = date
        self.duration = duration
        self.distance = locations.distance
        self.elevation = locations.elevation
    }
    
    convenience init(hkWorkout: HKWorkout, locations: [CLLocation]) {
        let coords = locations.map(\.coordinate)
        let polyline = MKPolyline(coordinates: coords, count: coords.count)
        let date = hkWorkout.startDate
        let duration = hkWorkout.duration
        self.init(polyline: polyline, locations: locations, date: date, duration: duration)
    }
    
    static let example = Workout(polyline: MKPolyline(), locations: [], date: .now, duration: 3456)
}

extension Workout: MKOverlay {
    var coordinate: CLLocationCoordinate2D {
        polyline.coordinate
    }
    
    var boundingMapRect: MKMapRect {
        polyline.boundingMapRect
    }
}
