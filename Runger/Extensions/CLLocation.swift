//
//  CLLocation.swift
//  Runger
//
//  Created by Kristine Yip on 4/21/24.
//

import Foundation
import CoreLocation

extension Array where Element == CLLocation {
    var distance: Double {
        guard count > 1 else { return 0 }
        var distance = Double.zero
        
        for i in 0..<count-1 {
            let location = self[i]
            let nextLocation = self[i+1]
            distance += nextLocation.distance(from: location)
        }
        return distance
    }
    
    var elevation: Double {
        guard count > 1 else { return 0 }
        var elevation = Double.zero
        
        for i in 0..<count-1 {
            let location = self[i]
            let nextLocation = self[i+1]
            let delta = nextLocation.altitude - location.altitude
            if delta > 0 {
                elevation += delta
            }
        }
        return elevation
    }
}

extension CLLocationCoordinate2D: Identifiable {
    public var id: String {
        "\(location),\(longitude)-\(UUID())"
    }
    
    var location: CLLocation {
        CLLocation(latitude: latitude, longitude: longitude)
    }
}
