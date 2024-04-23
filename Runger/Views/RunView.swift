//
//  RunView.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import SwiftUI
import MapKit
import BottomSheet

struct RunView: View {
//    @Environment(\.managedObjectContext) private var context
    @ObservedObject var runViewModel: RunViewModel
    @ObservedObject var presetViewModel: PresetViewModel

    @State private var userPath = MKPolyline()
    @State private var showBottomSheet = false
    @State var runMode: RunMode = .preset

    var body: some View {
        ZStack {
//            Map(position: $runViewModel.position)
            MapView(route: $runViewModel.userPath)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if runViewModel.isRunning {
                    Text("Running")
                        .font(.headline)
                        
                } else {
                    Text("Paused")
                }
                Spacer()
                Button("Toggle Bottom Sheet") {
                    withAnimation {
                        showBottomSheet.toggle()
                    }
                }
            }
        }
        .onAppear() {
            /// start tracking
            runViewModel.startTracking()
//            runViewModel.startRun()/
        }
        .onDisappear() {
            /// stop tracking
//            runViewModel.endRun()
        }
        .onChange(of: runViewModel.locations) {
//            presetViewModel.nextInterval()
        }
//        .bottomSheet(isPresented: $showBottomSheet) {
//            /// bottom sheet content
//        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var route: MKPolyline
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        uiView.addOverlay(route)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let routePolyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: routePolyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer()
        }
    }
}



struct RunView_Previews: PreviewProvider {

    static var previews: some View {
        let vm = PresetViewModel()
        vm.addDistance(1.0)
        vm.addTime(99)
        vm.addDistance(2.2)
        
        return RunView(runViewModel: RunViewModel(context: PersistenceController.shared.container.viewContext), presetViewModel: vm)
    }
}
