//
//  CardView.swift
//  Firstgrin
//
//  Created by Sopnil Sohan on 4/10/22.
//

import SwiftUI
import MapKit

struct CardView: View {
    @State var doctor: Doctor
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                HStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)
                        .foregroundColor(Color.black.opacity(0.7))
                    
                    VStack(alignment: .leading ,spacing: 0) {
                        Text("\(doctor.firstName ?? "") \(doctor.lastName ?? "")")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundColor(Color("orange").opacity(0.8))
                        
                        Text("\(doctor.specialties?[0].display ?? "")")
                            .font(.system(size: 14, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.black.opacity(0.7))
                    }
                }
                Rectangle()
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .foregroundColor(.black.opacity(0.1))
                
                VStack(alignment: .leading ,spacing: 8) {
//                    HStack(spacing: 8) {
//                        Image(systemName: "person.circle.fill")
//                            .font(.headline)
//                            .foregroundColor(Color.black.opacity(0.7))
//                        
//                    }
//                    
                    HStack(spacing: 8) {
                        Image(systemName: "location.circle")
                            .font(.headline)
                            .foregroundColor(Color.black.opacity(0.7))
                        Text("\(doctor.locations?[0].address ?? "")")
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black.opacity(0.7))
                    }
                    HStack(spacing: 8) {
                        Image(systemName: "phone.circle")
                            .font(.headline)
                            .foregroundColor(Color.black.opacity(0.7))
                        Text("\(doctor.locations?[0].phoneNumbers[0].phone ?? "")")
                            .font(.system(size: 16, weight: .semibold, design: .rounded))
                            .foregroundColor(Color.black.opacity(0.7))
                    }
                }
            }
            .padding()
            .background(LinearGradient(colors: [Color("offwhite"),Color("blue").opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 6)
        .shadow(color: .gray, radius: 3, x: 3, y: 3)
    }
}

//struct CardView_Previews: PreviewProvider {
//    static var previews: some View {
//        CardView(doctor: Doctor())
//    }
//}




