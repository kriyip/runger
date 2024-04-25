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


struct Run{ // maybe add Hashable protocol
    
    var date : Date = Date()
    private var dateFormat : DateFormatter = DateFormatter()
    var distance : Double
   // var start_time : Int
    var timer : Double
    var locations : [CLLocation?]
    var latitudes : [CLLocationDegrees] = []
    var longitudes : [CLLocationDegrees] = []
    
    
    var dateStr : String {
        print("run date")
        print(self.date)
        dateFormat.dateFormat = "MMM d, yyyy"
        dateFormat.timeZone = TimeZone(abbreviation: "EST+0:00")
        print(dateFormat.string(from:date))
        return dateFormat.string(from: date)
    }


    init(distance : Double, timer: Double, locations: [CLLocation?]){
        self.distance = distance
        self.timer = timer
        self.locations = locations
    }
}

extension Run{
    
    
    func runLocations(locations: [CLLocation?]) -> [[Double]] {
        
        var locs : [[Double]] = []
        
        for location in locations{
            
            if let loc = location {
                
                let cord = latlong(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude).toArray()
                locs.append(cord)
                
            }
            
        }
        
        return locs
        
    }
    
    
    
    mutating func get_lat_lon() {
        
        var latitudes: [CLLocationDegrees] = []
        var longitudes: [CLLocationDegrees] = []
        for location in self.locations {
            // Only include coordinates where neither latitude nor longitude is nil
            if let currentLatitude = location?.coordinate.latitude {
                if let currentLongitude = location?.coordinate.longitude {
                    latitudes.append(currentLatitude)
                    longitudes.append(currentLongitude)
                }
            }
        }
        self.longitudes = longitudes
        self.latitudes = latitudes
    }
    
    
    func setupCoordinates(latitudes: [CLLocationDegrees], longitudes: [CLLocationDegrees]) -> [CLLocationCoordinate2D] {
        var coordinates: [CLLocationCoordinate2D] = []
        
        var locationsCount = latitudes.count
        if (latitudes.count > longitudes.count) {
            locationsCount = longitudes.count
        }
        
        for index in 0..<locationsCount {
            coordinates.append(CLLocationCoordinate2DMake(latitudes[index], longitudes[index]))
        }
        
        return coordinates
    }
    
    func calculateCenter(latitudes: [CLLocationDegrees], longitudes: [CLLocationDegrees]) -> CLLocationCoordinate2D {
        // Find the min and max latitude and longitude to find ideal span that fits entire route
        if (latitudes.count > 0 && longitudes.count > 0) {
            var maxLatitude: CLLocationDegrees = latitudes[0]
            var minLatitude: CLLocationDegrees = latitudes[0]
            var maxLongitude: CLLocationDegrees = longitudes[0]
            var minLongitude: CLLocationDegrees = longitudes[0]
            
            for latitude in latitudes {
                if (latitude < minLatitude) {
                    minLatitude = latitude
                }
                if (latitude > maxLatitude) {
                    maxLatitude = latitude
                }
            }
            
            for longitude in longitudes {
                if (longitude < minLongitude) {
                    minLongitude = longitude
                }
                if (longitude > maxLongitude) {
                    maxLongitude = longitude
                }
            }
            
            let latitudeMidpoint = (maxLatitude + minLatitude)/2
            let longitudeMidpoint = (maxLongitude + minLongitude)/2
            return CLLocationCoordinate2D(latitude: latitudeMidpoint, longitude: longitudeMidpoint)
        }
        else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
    
    
    func calculateSpan(latitudes: [CLLocationDegrees], longitudes: [CLLocationDegrees]) -> CLLocationDegrees {
        // Find the min and max latitude and longitude to find ideal span that fits entire route
        if (latitudes.count > 0 && longitudes.count > 0) {
            var maxLatitude: CLLocationDegrees = latitudes[0]
            var minLatitude: CLLocationDegrees = latitudes[0]
            var maxLongitude: CLLocationDegrees = longitudes[0]
            var minLongitude: CLLocationDegrees = longitudes[0]
            
            for latitude in latitudes {
                if (latitude < minLatitude) {
                    minLatitude = latitude
                }
                if (latitude > maxLatitude) {
                    maxLatitude = latitude
                }
            }
            
            for longitude in longitudes {
                if (longitude < minLongitude) {
                    minLongitude = longitude
                }
                if (longitude > maxLongitude) {
                    maxLongitude = longitude
                }
            }
            
            // Add 10% extra so that there is some space around the map
            let latitudeSpan = (maxLatitude - minLatitude) * 1.1
            let longitudeSpan = (maxLongitude - minLongitude) * 1.1
            return latitudeSpan > longitudeSpan ? latitudeSpan : longitudeSpan
        }
        else {
            return 0.1
        }
    }
}

struct latlong : Codable {
    private var latitude: Double
    private var longitude: Double
    
    init ( latitude: Double, longitude: Double){
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func toArray() -> [Double]{
        
        var subarr : [Double] = []
        
        subarr.append( self.latitude)
        subarr.append( self.longitude)
        
        return subarr
    }
    
    
}




enum watchMode {
    case start, stop, pause
}

class StopWatch : ObservableObject {
    @Published var timeString = "00:00"
    @Published var mode : watchMode = .stop
    @Published var secs = 0.0
    var secondsPassed = 0.0
    var lastPausedTime = 0.0
    var timer = Timer()
    
//    func start() {
//        self.mode = .start
//        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
//            timer in self.secondsPassed += 1
//            self.formatTimer()
//        }
//    }

    func start() {
        if mode == .pause {
            // reuming paue
            secondsPassed = lastPausedTime
        } else {
            // new start
            secondsPassed = 0.0
        }
        self.mode = .start
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.secondsPassed += 1
                self.formatTimer()
            }
        }
    }
    
    func pause() {
        timer.invalidate()
        lastPausedTime = self.secondsPassed
        self.mode = .pause
    }
    
    func reset() {
        timer.invalidate()
        self.secondsPassed = 0.0
        lastPausedTime = 0.0
        timeString = "00:00"
        self.mode = .stop
    }
    
    func formatTimer() {
        let minutes : Int = Int(self.secondsPassed/60)
        let minStr = (minutes < 10) ? "0\(minutes)" : "\(minutes)"
        
        let seconds : Int = Int(self.secondsPassed) - (minutes * 60)
        let secStr = (seconds < 10) ? "0\(seconds)" : "\(seconds)"
        
        self.timeString = minStr + ":" + secStr
    }
}
