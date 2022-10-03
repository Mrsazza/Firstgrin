//
//  TrendingHabitsContentView.swift
//  Habit
//
//  Created by Apps4World on 1/23/22.
//

import SwiftUI

/// Shows a custom list of trending habits
struct TrendingHabitsContentView: View {
    
    @EnvironmentObject var manager: DataManager
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                HeaderTitle
                TrendingListView
            }
            CreateHabitButtonView
        }
    }
    
    /// Header title
    private var HeaderTitle: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Trending").font(.largeTitle).bold()
                Text("Choose a habit or create one")
            }
            Spacer()
            Button {
                manager.fullScreenMode = nil
            } label: {
                Image(systemName: "xmark").font(.system(size: 18, weight: .medium))
            }
        }.padding(.horizontal).foregroundColor(Color("LightColor"))
    }
    
    /// A list of trending habits
    private var TrendingListView: some View {
        ZStack {
            RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                .foregroundColor(Color("ListColor")).ignoresSafeArea()
                .shadow(color: Color.black.opacity(0.03), radius: 5, y: -5)
            VStack(alignment: .center, spacing: 0) {
                Capsule().frame(width: 35, height: 5).padding(10).opacity(0.2)
                ScrollView(.vertical, showsIndicators: false) {
                    Spacer(minLength: 10)
                    LazyVGrid(columns: Array(repeating: GridItem(spacing: 0), count: 2), spacing: 20) {
                        ForEach(0..<TrendingHabits.count, id: \.self) { index in
                            Button {
                                if manager.isPremiumUser {
                                    manager.trendingHabit = TrendingHabits[index]
                                } else {
                                    manager.fullScreenMode = .subscriptions
                                }
                            } label: {
                                TrendingHabit(atIndex: index)
                            }
                        }
                    }
                    Spacer(minLength: 100)
                }.padding(.horizontal, 10)
            }
        }.padding(.top, 5)
    }
    
    /// Create the habit item
    private func TrendingHabit(atIndex index: Int) -> some View {
        ZStack {
            AppConfig.colors[TrendingHabits[index].colorIndex].cornerRadius(18)
                .padding(.horizontal, 10)
            VStack(alignment: .center, spacing: 5) {
                Image(uiImage: UIImage(named: TrendingHabits[index].iconString)!)
                    .resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                    .padding(.vertical)
                Text(TrendingHabits[index].name)
                Text(TrendingHabits[index].motto).opacity(0.7)
                    .font(.system(size: 14, weight: .light)).lineLimit(3)
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(height: 125)
            .frame(width: UIScreen.main.bounds.width/2 - 60)
            .foregroundColor(Color("LightColor"))
            .padding().overlay(
                Color("BackgroundColor").cornerRadius(18)
                    .opacity(manager.isPremiumUser ? 0 : 0.4)
            )
            
            if manager.isPremiumUser == false {
                VStack {
                    HStack {
                        Spacer()
                        Image(systemName: "lock.fill").font(.system(size: 20))
                    }.foregroundColor(.white)
                    Spacer()
                }.padding(.horizontal, 20).padding(.top, 15)
            }
        }
    }
    
    /// Create a custom habit
    private var CreateHabitButtonView: some View {
        ZStack {
            VStack {
                Spacer()
                LinearGradient(gradient: Gradient(colors: [Color("ListColor").opacity(0), Color("ListColor").opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea().frame(height: 150).allowsHitTesting(false)
            }
            
            VStack {
                Spacer()
                Button {
                    manager.trendingHabit = nil
                } label: {
                    ZStack {
                        Color("TabBarColor").cornerRadius(40)
                        HStack {
                            Image(systemName: "plus").font(.system(size: 22, weight: .bold))
                            Text("Create Your Own").font(.title3).bold()
                        }
                    }.foregroundColor(Color("ListColor"))
                }.frame(width: 250, height: 60, alignment: .center)
            }
        }
    }
}

// MARK: - Preview UI
struct TrendingHabitsContentView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingHabitsContentView()
            .environmentObject(DataManager(preview: false))
    }
}
