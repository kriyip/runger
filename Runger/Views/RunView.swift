//
//  RunView.swift
//  Runger
//
//  Created by Kristine Yip on 4/17/24.
//

import SwiftUI
import MapKit

struct RunView: View {
//    @Environment(\.managedObjectContext) private var context
    @ObservedObject var runViewModel: RunViewModel
//    @ObservedObject var presetViewModel: PresetViewModel

    @State private var userPath = MKPolyline()
    @State private var showBottomSheet = false
    @State var runMode: RunMode = .preset
    
    @State private var isTapped : Bool = false
    @State private var button : String = "Start"
    @State private var color : Color = .green
    @State private var start : Bool = true
    @State private var displayEnd: Bool = false
    
    var startlocation : CLLocation!
    var endLocation : CLLocation!

    var body: some View {
        ZStack {
            MapView(locationManager: runViewModel, started: $isTapped)
//                .ignoresSafeArea(.all)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
            VStack {
                if !start {
                    Text("Running")
                        .font(.headline)
                } else {
                    Text("Paused")
                }
                Spacer()
                Text("Speed: \((runViewModel.currSpeed < 0) ? "0.00" : String(runViewModel.currSpeed))")
                Text("Distance: \(runViewModel.totalDistance)")
//                Text(self.timer.timeString).font(.system(size : 20)).padding().offset(y:10)
                
                HStack{
                    if isTapped == false {
                        // if tapped once then disable tapping again
                    }
                    Button(action: {if start {
                        startrun()
                        displayEnd = true;
                    } else {
                        stop()
                    }
                    }){
                        ZStack{
                            Circle()
                                .fill(color)
                                .frame(width: 100, height: 100)
                            Text(button)
                                .foregroundColor(Color.white)
                        }.padding()
                    }
                    
                    if start && displayEnd {
                        Button(action: {
                            runViewModel.endRun(shouldSave: false)
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.red)
                                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: 100)
                                Text("End")
                                    .foregroundColor(Color.white)
                            }
                        }
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
            runViewModel.endRun(shouldSave: false)
        }
    }
    
    func startrun(){
        if start {
            button = "Stop"
            color = .red
        }
//        self.timer.start()
        self.isTapped.toggle()
        self.start.toggle()
    }
    
    func stop()  {
//        self.timer.stop()
        self.start.toggle()
        self.isTapped.toggle()
        
        //runList.addRun(run:Run(distance: 5.0, timer: timer.secs, locations: locManager.coords,region: locManager))
        button = "Start"
        color = .green
    }
    
}

//struct MapView: UIViewRepresentable {
//    @Binding var route: MKPolyline
//    
//    func makeUIView(context: Context) -> MKMapView {
//        let mapView = MKMapView()
//        mapView.delegate = context.coordinator
//        return mapView
//    }
//    
//    func updateUIView(_ uiView: MKMapView, context: Context) {
//        uiView.removeOverlays(uiView.overlays)
//        uiView.addOverlay(route)
//    }
//    
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//    
//    class Coordinator: NSObject, MKMapViewDelegate {
//        var parent: MapView
//        
//        init(_ parent: MapView) {
//            self.parent = parent
//        }
//        
//        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//            if let routePolyline = overlay as? MKPolyline {
//                let renderer = MKPolylineRenderer(polyline: routePolyline)
//                renderer.strokeColor = .blue
//                renderer.lineWidth = 5
//                return renderer
//            }
//            return MKOverlayRenderer()
//        }
//    }
//}



//struct RunView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        let vm = PresetViewModel()
//        vm.addDistance(1.0)
//        vm.addTime(99)
//        vm.addDistance(2.2)
//        
//        return RunView(runViewModel: RunViewModel(context: PersistenceController.shared.container.viewContext), presetViewModel: vm)
//    }
//}
