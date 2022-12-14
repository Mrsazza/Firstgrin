//
//  FindADentistView.swift
//  Firstgrin
//
//  Created by Sazza on 6/9/22.
//

import SwiftUI
import MapKit

enum MapTab : String {
    case map = "Map View"
    case list = "Dentist List"
}

struct FindADentistView: View {
    @EnvironmentObject var realtimeVM: RealtimeViewModel
    @State var showingSheet: Bool = false
    
    @State var selectedTab : MapTab = .map
    
    @State var manager = CLLocationManager()

    var body: some View {
        ZStack {
            if selectedTab == .map {
                NewMapView(selectedTab: $selectedTab)
            } else {
                NewCardView()
            }
            
            
            
//            ZStack{
//                RoundedRectangle(cornerRadius: 10)
//                HStack(spacing: 0){
//                    PickerTopTab(tab: .map, selectedTab: $selectedTab)
//                    PickerTopTab(tab: .list, selectedTab: $selectedTab)
//                }
//            }
//            .frame(minWidth: 260, maxWidth: 300, maxHeight: 36)
//            .foregroundColor(Color("blue"))
//            .padding()
        
//            if selectedTab == .map {
//
//            } else {
//                ScrollView(.vertical, showsIndicators: false){
//                    ForEach(realtimeVM.doctorsList?.doctor ?? [], id: \.id){ doctor in
//                        Button {
//                            showingSheet.toggle()
//                        } label: {
//                            CardView(doctor: doctor)
//                                .sheet(isPresented: $showingSheet, content: {
//                                    CardViewDetails(doctor: doctor, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (doctor.locations?[0].latitude)!, longitude: (doctor.locations?[0].longitude)!), span:  MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)))
//                                })
//                        }
//                    }
//                }
//            }
        }
    }
}

//struct FindADentistView_Previews: PreviewProvider {
//    static var previews: some View {
//        FindADentistView()
//    }
//}
//struct PickerTopTab: View{
//    @State var tab: MapTab
//    @Binding var selectedTab: MapTab
//    var body: some View{
//        Button(action: {
//            selectedTab = tab
//        }, label: {
//            ZStack{
//                RoundedRectangle(cornerRadius: 10)
//                    .foregroundColor(tab == selectedTab ? Color("orange") : Color("blue"))
//                Text(tab.rawValue)
//                    .foregroundColor(tab == selectedTab ? .white : .black)
//            }
//        })
//    }
//}

struct NewCardView: View {
    @EnvironmentObject var realtimeVM: RealtimeViewModel
    @State var showingSheet: Bool = false
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            ForEach(realtimeVM.doctorsList?.doctor ?? [], id: \.id){ doctor in
                Button {
                    showingSheet.toggle()
                } label: {
                    CardView(doctor: doctor)
                        .sheet(isPresented: $showingSheet, content: {
                            CardViewDetails(doctor: doctor, region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (doctor.locations?[0].latitude)!, longitude: (doctor.locations?[0].longitude)!), span:  MKCoordinateSpan(latitudeDelta: 0.007, longitudeDelta: 0.007)))
                        })
                }
            }
        }
    }
}
