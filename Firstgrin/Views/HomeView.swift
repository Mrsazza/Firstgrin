//
//  HomeView.swift
//  Firstgrin
//
//  Created by Sazza on 3/9/22.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var fireStoreVM: FirestoreViewModel
    @StateObject var babyProfileVM = BabyProfileViewModel()
    var body: some View {
        NavigationView{
            VStack{
                if let user = fireStoreVM.user {
                    Text("Mail: \(user.email)")
                    HStack{
                        TextField("Enter Baby Name", text: $babyProfileVM.profile.name)
                    }
                    HStack{
                        TextField("Enter Baby's age", text: $babyProfileVM.profile.age)
                    }
                    Button(action: {
                        babyProfileVM.saveBabyProfile()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                    ForEach(babyProfileVM.babyProfile, id: \.id){ profile in
                        HStack{
                            Text(profile.name)
                            Spacer()
                            Text(profile.age)
                            Button(action: {
                                babyProfileVM.deleteBabyProfile(profile: profile)
                            }, label: {
                                Image(systemName: "trash")
                            })
                        }
                        .padding()
                    }
                }
            }
            .onAppear{
                fireStoreVM.fetchCurrentUser()
                babyProfileVM.fetchBabyProfile()
            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
