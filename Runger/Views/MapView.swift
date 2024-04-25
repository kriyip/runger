//
//  MapView.swift
//  Runger
//
//  Created by Kristine Yip on 4/23/24.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    @EnvironmentObject var timer : StopWatch
    @ObservedObject var locationManager: RunViewModel
    typealias UIViewType = MKMapView
    @Binding var started : Bool
    
    var userLatitude: String {
        locationManager.lastLocation?.coordinate.latitude.description ?? "0"
    }

    var userLongitude: String {
        locationManager.lastLocation?.coordinate.longitude.description ?? "0"
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.showsUserLocation = true
        
        let location: CLLocationCoordinate2D = CLLocationCoordinate2DMake(CLLocationDegrees(userLatitude)!, CLLocationDegrees(userLongitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)
        let region = MKCoordinateRegion(center:location,span:span)
        
        uiView.setRegion(region, animated: true)
        
        // Place state updates or publishing changes here
        DispatchQueue.main.async {
            if started && !startedRunning {
                startedRunning = true
                locationManager.startRun()
            }
        }
        
        if started {
            let locationsCount = $locationManager.runLocations.count
            
            if locationsCount >= 2 {
                var locationsToRoute: [CLLocationCoordinate2D] = []
                for location in locationManager.runLocations {
                    if location != nil {
                        locationsToRoute.append(location!.coordinate)
                    }
                }
                
                // Check and add new route if not already added
                if locationsToRoute.count > 1 && locationsToRoute.count <= $locationManager.runLocations.count {
                    let newRoute = MKPolyline(coordinates: locationsToRoute, count: locationsToRoute.count)
                    uiView.addOverlay(newRoute)
                }
            }
            uiView.delegate = context.coordinator
        } else {
            if (startedRunning) {
                startedRunning = false
                // don't remove overlays when paused
//                let overlays = uiView.overlays
//                uiView.removeOverlays(overlays)                
            }
        }
    }
    
    func resetRun(_ uiView: MKMapView) {
        uiView.removeOverlays(uiView.overlays)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 10
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
    
    func makeCoordinator() -> MapView.Coordinator {
        Coordinator(self)
    }
}


var startedRunning = false

