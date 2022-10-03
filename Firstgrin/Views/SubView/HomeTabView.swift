//
//  HomeTabView.swift
//  Firstgrin
//
//  Created by Sazza on 6/9/22.
//

import Foundation
import SwiftUI

struct HomeTabView: View {
    var body: some View {
        TabView{
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "list.dash")
                }
            ArticleView()
                .tabItem {
                    Label("Education", systemImage: "doc.circle")
                }
            FindADentistView()
                .tabItem {
                    Label("Find A Detinst", systemImage: "magnifyingglass.circle")
                }
            StatsView()
                .tabItem {
                    Label("Stat", systemImage: "chart.bar.xaxis")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear.circle")
                }
        }
    }
}

struct HomeTabView_Previews: PreviewProvider {
    static var previews: some View {
        HomeTabView()
    }
}
