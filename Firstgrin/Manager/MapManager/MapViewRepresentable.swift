//
//  MapViewRepresentable.swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 2/11/22.
//

import MapKit
import SwiftUI

struct MapViewRepresentable: UIViewRepresentable {
    
    @Binding var manager: CLLocationManager
    
    let map = MKMapView()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<MapViewRepresentable>) {}
    
    func makeUIView(context: UIViewRepresentableContext<MapViewRepresentable>) -> MKMapView {
        let center = CLLocationCoordinate2D(latitude: 13.1, longitude: 80.3)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        map.region = region
        manager.delegate = context.coordinator
        return map
    }
}

