//
//  TestView.swift
//  Runger
//
//  Created by Kristine Yip on 4/22/24.
//

import SwiftUI
import HealthKit
import MapKit


struct TestView: View {
//    @StateObject var locationManager: LocationManager
    @State private var authorizationStatus: HKAuthorizationStatus = .notDetermined
    @State private var workouts: [HKWorkout] = []
    @State private var routeLocations = [CLLocation]()
    
    @ObservedObject var runViewModel: RunViewModel
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334803, longitude: -122.008965),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

    var body: some View {
        VStack {
            if authorizationStatus == .sharingAuthorized {
                Text("Authorized")
                
//                Map(position: $runViewModel.position)
                
                MapViewNew(region: region, lineCoordinates: runViewModel.lineCoordinates)
                    .edgesIgnoringSafeArea(.all)
            } else {
                Text("Authorization status: \(authorizationStatus)")
                Button("Authorize HealthKit") {
                    Task {
                        self.authorizationStatus = await HKController.requestAuth()
                    }
                }
            }
        }.onAppear() {
            /// start location tracking
            runViewModel.startTracking()
        }

    }
}

struct MapViewNew: UIViewRepresentable {
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    
    // Create the MKMapView using UIKit.
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region

        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)

        return mapView
    }

      func updateUIView(_ view: MKMapView, context: Context) {}

      func makeCoordinator() -> Coordinator {
        Coordinator(self)
      }
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapViewNew

    init(_ parent: MapViewNew) {
        self.parent = parent
    }

    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.systemBlue
            renderer.lineWidth = 10
            return renderer
        }
        return MKOverlayRenderer()
    }
}

#Preview {
    TestView(runViewModel: RunViewModel())
}
