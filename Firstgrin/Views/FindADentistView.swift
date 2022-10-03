//
//  FindADentistView.swift
//  Firstgrin
//
//  Created by Sazza on 6/9/22.
//

import SwiftUI

struct FindADentistView: View {
    @EnvironmentObject var realtimeVM: RealtimeViewModel
    var body: some View {
        NavigationView{
            VStack{
                ForEach(realtimeVM.doctorsList?.doctor ?? [], id: \.id){ doctor in
                    HStack{
                        Text("name: \(doctor.firstName ?? "") \(doctor.lastName ?? "")")
                        Spacer()
                        VStack{
                            Text(doctor.degrees?[0] ?? "")
                            Text((doctor.specialties?[0])!.display)
                        }
                    }
                    .padding()
                }
            }
            .navigationTitle("Find A dentist")
        }
    }
}

struct FindADentistView_Previews: PreviewProvider {
    static var previews: some View {
        FindADentistView()
    }
}
