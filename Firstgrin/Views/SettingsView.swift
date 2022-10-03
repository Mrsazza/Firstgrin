//
//  SettingsView.swift
//  Firstgrin
//
//  Created by Sazza on 6/9/22.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView{
            VStack{
                Text("Settings")
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
