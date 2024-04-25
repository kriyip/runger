//
//  RunMapView.swift
//  Runger
//
//  Created by Teena Bhatia on 25/4/24.
//

import SwiftUI
import MapKit
import CoreData

struct RunMapView: UIViewRepresentable {
    let run: Run
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {

        let locations = run.toLocations()
        guard !locations.isEmpty else { return }

        let coordinates = locations.map { $0.coordinate }
        let polyline = MKPolyline(coordinates: coordinates, count: coordinates.count)
        uiView.addOverlay(polyline)
        
        let region = MKCoordinateRegion(polyline.boundingMapRect)
        uiView.setRegion(uiView.regionThatFits(region), animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: RunMapView
        
        init(_ parent: RunMapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}



extension RunViewModel {
    func polyline(for run: Run) -> MKPolyline? {
        let locations = run.toLocations()
        guard !locations.isEmpty else { return nil }
        
        let coordinates = locations.map { $0.coordinate }
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
}

