//
//  CardViewDetails.swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 12/10/22.
//

import Foundation
import SwiftUI
import MapKit

struct CardViewDetails: View {
    @Environment(\.presentationMode) var presentationMode
    @State var doctor: Doctor
   
    @State var showHourSelectionView = false
    @State var selectedHour: CGFloat = 0.0
    @State var animate = false
    
    @State var translation: CGFloat = 0.0
    @State var region: MKCoordinateRegion
    
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()
            VStack {
                VStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
                
                VStack {
                    Map(
                        coordinateRegion: $region,
                        annotationItems: doctor.locations!) { spot in
                            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: spot.latitude, longitude: spot.longitude), anchorPoint: CGPoint(x: 0.5, y: 0.5)) {
                                SpotAnnotatonView(selected: true)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .cornerRadius(20)                }
                //Doctor InfoView
                VStack(spacing: 10) {
                    Text("\(doctor.firstName ?? "") \(doctor.lastName ?? "")")
                        .font(.system(size: 28, weight: .bold, design: .rounded))
                        .foregroundColor(Color("orange").opacity(0.8))
                    
                    Text("\(doctor.specialties?[0].display ?? "")")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundColor(Color.black.opacity(0.7))
                    
                    HStack {
                        ForEach(doctor.degrees ?? [], id: \.self) { degree in
                            Text("\(degree)\(degree == doctor.degrees?.last ? "" : ",")")
                                .font(.system(size: 14, weight: .semibold, design: .rounded))
                                .foregroundColor(Color.black.opacity(0.7))
                        }
                    }
                    ForEach(doctor.educations ?? [], id: \.self) { education in
                        Text("\(education.education.name)\(education == doctor.educations?.last ? "" : ",")")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.black.opacity(0.7))
                    }
                }
                HStack {
                    ForEach(doctor.treatmentsPerformed ?? [], id: \.self) { treatments in
                        Text("\(treatments.display)\(treatments == doctor.treatmentsPerformed?.last ? "" : ",")")
                            .font(.system(size: 18, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.black.opacity(0.7))
                    }
                }
                .padding(.top, 5)
                VStack {
                    Text("\(doctor.locations?[0].address ?? "")")
                        .multilineTextAlignment(.leading)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .foregroundColor(Color.black.opacity(0.7))
                        .padding(.horizontal, 20)
                }
                .padding(.top, 10)
                Spacer()
                
            }
        }
    }
}


struct SpotAnnotatonView: View {
//    let fee: String
    var selected: Bool = false
    var body: some View {
        ZStack {
            Image(selected ? "tooth-2" : "tooth")
                .resizable()
                .frame(width: 50, height: 50)
        }
    }
}
