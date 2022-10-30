//
//  FindADentistView.swift
//  Firstgrin
//
//  Created by Sazza on 6/9/22.
//

import SwiftUI
import MapKit

struct FindADentistView: View {
    @EnvironmentObject var realtimeVM: RealtimeViewModel
    @State var showingSheet: Bool = false
    
   
    
    var body: some View {
        NavigationView{
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
            .navigationTitle("Find A dentist")
        }
    }
}

//struct FindADentistView_Previews: PreviewProvider {
//    static var previews: some View {
//        FindADentistView()
//    }
//}
