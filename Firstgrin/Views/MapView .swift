//
//  MapView .swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 2/11/22.
//
import SwiftUI
import CoreLocationUI
import CoreLocation

struct MapView: View {
    @Binding var manager: CLLocationManager
    
    var body: some View {
        ZStack(alignment: .bottom) {
            
            MapViewRepresentable(manager: $manager)
//                .edgesIgnoringSafeArea(.all)
            
            LocationButton(LocationButton.Title.currentLocation) {
                // Start updating location when user taps the button.
                // Location button doesn't require the additional step of calling `requestWhenInUseAuthorization()`.
                manager.startUpdatingLocation()
            }
            .foregroundColor(Color.white)
            .cornerRadius(27)
//            .frame(width: 210, height: 54)
            .padding(.bottom, 30)
        }
    }
}

//struct MapView__Previews: PreviewProvider {
//    static var previews: some View {
//        MapView()
//    }
//}
