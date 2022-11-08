//
//  NewMapView.swift
//  Firstgrin
//
//  Created by Sazza on 5/11/22.
//

import SwiftUI

struct NewMapView: View {
    @StateObject var parkingFinder = ParkingFinder()
    var body: some View {
        ZStack(alignment: .top) {
            // background
            Color.white.ignoresSafeArea()
            // map view
            Map(
                coordinateRegion: $parkingFinder.region,
                annotationItems: parkingFinder.spots) { spot in
                MapAnnotation(
                    coordinate: spot.location,
                    anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                    Button(action: {
                        parkingFinder.selectedPlace = spot
                    }, label: {
                        SpotAnnotatonView(
                            selected: spot.id == parkingFinder.selectedPlace?.id)
                    })
                }
            }
            .cornerRadius(75)
            //.frame(height: UIScreen.screenHeight*0.58)
//            .edgesIgnoringSafeArea(.top)
//            .offset(y: -70)
            
            VStack {
                SearchView()
                // top navigation
//                TopNavigationView()
                Spacer()
                // parking card view
                ParkingCardView(parkingPlace: parkingFinder.selectedPlace ?? parkingFinder.spots[0])
                    .offset(y: -30)
                    .onTapGesture {
                        parkingFinder.showDetail = true
                    }
                // search view
                    //.offset(y: -30)
            }
            .frame(height: UIScreen.screenHeight*0.7)
            .padding(.horizontal)
            
//            if parkingFinder.showDetail {
//                // parking detail view when click on card
//                ParkingDetailView(
//                    parkingFinder: parkingFinder,
//                    region: MKCoordinateRegion(
//                        center: parkingFinder.selectedPlace?.location ?? parkingFinder.spots[0].location,
//                        span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)))
//            }
        }
    }
}

struct NewMapView_Previews: PreviewProvider {
    static var previews: some View {
        NewMapView()
    }
}


import MapKit

struct MapData {
    static let spots = [
        ParkingItem(name: "Ashley Lerman", address: "2351 Mission St, San Francisco", photoName: "1", place: "B1", carLimit: 45, location: CLLocationCoordinate2D(latitude: 37.7985599, longitude: -122.4100056), fee: 5.0, hour: "0.0"),
        ParkingItem(name: "John Doe", address: "654 Green St, San Francisco", photoName: "2", place: "A6", carLimit: 15, location: CLLocationCoordinate2D(latitude: 37.7993822, longitude: -122.4077079), fee: 3.0, hour: "0.0"),
        ParkingItem(name: "Rose Dawson", address: "440 Pine St, San Francisco", photoName: "3", place: "B4", carLimit: 20, location: CLLocationCoordinate2D(latitude: 37.799386, longitude: -122.4092267), fee: 4.0, hour: "0.0"),
        ParkingItem(name: "Mark Juckerbarg", address: "701 Stevenson St, San Francisco", photoName: "4", place: "C2", carLimit: 25, location: CLLocationCoordinate2D(latitude: 37.7983406, longitude: -122.4064634), fee: 3.0, hour: "0.0"),
        ParkingItem(name: "Elon Mask", address: "1647 Powell St, San Francisco", photoName: "5", place: "A12", carLimit: 12, location: CLLocationCoordinate2D(latitude: 37.7998639, longitude: -122.4110218), fee: 2.0, hour: "0.0"),
        ParkingItem(name: "King Kong", address: "455 Castro St, San Francisco", photoName: "6", place: "B9", carLimit: 90, location: CLLocationCoordinate2D(latitude: 37.7978987, longitude: -122.4098621), fee: 1.0, hour: "0.0")
    ]
}


class ParkingFinder: ObservableObject {
    @Published var spots = MapData.spots
    @Published var selectedPlace: ParkingItem?
    @Published var showDetail = false
    
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: MapData.spots[0].location.latitude,
            longitude: MapData.spots[0].location.longitude),
        span: MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007))
}


import MapKit

struct ParkingItem: Identifiable {
    let id = UUID()
    let name: String
    let address: String
    let photoName: String
    let place: String
    let carLimit: Int
    let location: CLLocationCoordinate2D
    let fee: CGFloat
    var hour: String
}

struct ParkingCardView: View {
    let parkingPlace: ParkingItem
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(parkingPlace.name)
                    .font(.system(size: 18, weight: .bold))
                Text(parkingPlace.address)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .padding(.bottom, 20)
//                
//                HStack {
//                    Image(systemName: "car.fill")
//                        .foregroundColor(.gray)
//                    Text("\(parkingPlace.carLimit)")
//                    
//                    Image(systemName: "dollarsign.circle.fill")
//                        .foregroundColor(.gray)
//                    Text("$\(String.init(format: "%0.2f", parkingPlace.fee))/h")
//                }
            }
            
            Spacer()
            
            Image(parkingPlace.photoName)
                .resizable()
                .frame(width: 80, height: 80)
                .scaledToFit()
                .cornerRadius(15)
        }
        .padding()
        .frame(height: 150)
        .background(Color.white)
        .cornerRadius(40)
    }
}

struct SearchView: View {
    @State var text: String = ""
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 22))
                .padding()
            TextField("Search for a doctor", text: $text)
//            Text("Search a doctor...")
                .foregroundColor(.gray)
            Spacer()
            Image(systemName: "chevron.left")
                .padding()
        }
        //.padding(10)
        .background(Color.white.shadow(radius: 3))
        .cornerRadius(20, corners: .allCorners)

    }
}
