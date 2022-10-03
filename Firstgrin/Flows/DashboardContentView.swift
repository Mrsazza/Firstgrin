//
//  DashboardContentView.swift
//  Habit
//
//  Created by Apps4World on 1/22/22.
//

import SwiftUI
import CoreData

// MARK: - Custom tab bar items
enum CustomTabBarItem: String {
    case home = "house", log = "chart.pie", article = "doc.circle", find = "magnifyingglass.circle", settings = "gearshape.circle"
}

/// Main view for the app
struct DashboardContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var selectedTab: CustomTabBarItem = .home
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("brown").ignoresSafeArea()
            if selectedTab == .home {
                HomeTabView
            } else if selectedTab == .article{
                ArticleView()
            } else if selectedTab == .find{
                FindADentistView()
            } else if selectedTab == .settings{
                SettingsContentView()
            }
            else {
                StatsContentView().environmentObject(manager)
            }
            CustomTabBarView
                .edgesIgnoringSafeArea(.bottom)
        }
        
        /// Full modal screen flow
        .fullScreenCover(item: $manager.fullScreenMode) { type in
            switch type {
            case .createHabit:
                AddHabitContentView().environmentObject(manager)
            case .trendingHabits:
                TrendingHabitsContentView().environmentObject(manager)
            case .settings:
                SettingsContentView().environmentObject(manager)
            case .subscriptions:
                PremiumContentView(title: "Premium Version", subtitle: "Upgrade Today", features: ["Remove ads", "Unlock trending habits", "Unlock reminder feature"], productIds: [AppConfig.premiumVersion]) { _, status, _ in
                    DispatchQueue.main.async {
                        if status == .success || status == .restored {
                            manager.isPremiumUser = true
                        }
                        manager.fullScreenMode = nil
                    }
                }
            }
        }
    }
    
    /// Dashboard/Home tab view
    private var HomeTabView: some View {
        ZStack{
            VStack {
                HeaderTitle
                HeaderBabyProfile
                HeaderCalendarView
                HabitListView(date: manager.selectedDate)
            }
            VStack{
                Spacer()
                CreateHabitButtonView
                    .padding(.bottom, 40)
            }
        }
    }
    
    private var HeaderBabyProfile: some View{
        ZStack{
            Color.white
            HStack{
                Circle()
                    .fill(Color.blue)
                VStack(alignment: .leading){
                    Text("Name: SAMANTHA")
                    Text("Age: 2 month")
                }
                Spacer()
            }
            .padding()
            HStack{
                Spacer()
                VStack{
                    HStack{
                        Button(action: {
                            
                        }, label: {
                            HStack(spacing: 2){
                                Image(systemName: "plus.circle")
                                    .font(.caption)
                                Text("Add")
                                    .font(.caption2)
                            }
                        })
                        
                        Button(action: {
                            
                        }, label: {
                            HStack(spacing: 2){
                                Image(systemName: "pencil.circle")
                                    .font(.caption)
                                Text("Edit")
                                    .font(.caption2)
                            }
                        })
                        Button(action: {
                            
                        }, label: {
                            HStack(spacing: 2){
                                Image(systemName: "trash.circle")
                                    .font(.caption)
                                Text("Delete")
                                    .font(.caption2)
                            }.foregroundColor(.red)
                        })
                    }
                    .padding(5)
                    Spacer()
                }
            }
        }
        .cornerRadius(10)
        .padding()
        .frame(height: 90)
    }
    
    /// Header title
    private var HeaderTitle: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Firstgrin").font(.largeTitle).bold()
                Text(manager.selectedDate.headerTitle)
            }
            Spacer()
            Button {
                manager.fullScreenMode = .settings
            } label: {
                Image(systemName: "gearshape.fill").font(.system(size: 18, weight: .medium))
            }
        }.padding(.horizontal).foregroundColor(Color("LightColor"))
    }
    
    /// Header calendar view
    private var HeaderCalendarView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            ScrollViewReader { proxy in
                HStack {
                    Spacer()
                    ForEach(0..<manager.calendarDays.count, id: \.self) { index in
                        CalendarItem(atIndex: index).id(index).onTapGesture {
                            manager.selectedDate = manager.calendarDays[index]
                        }
                    }
                    Spacer()
                }.onAppear {
                    proxy.scrollTo(manager.calendarDays.count-1)
                }
            }
        }
    }
    
    /// Header calendar item view
    private func CalendarItem(atIndex index: Int) -> some View {
        let date = manager.calendarDays[index]
        let isTodayItem = date.longFormat == Date().longFormat
        let isSelectedItem = manager.selectedDate.longFormat == date.longFormat
        return VStack(spacing: 5) {
            Text(date.string(format: "E").uppercased().dropLast())
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(Color("LightColor"))
                .padding(.top, 2)
            ZStack {
                Circle().frame(width: 30, height: 30)
                    .foregroundColor(manager.didCompleteDailyHabits ? .green : .white)
                Text(date.string(format: "d")).font(.system(size: 16))
                    .foregroundColor(.black)
            }
        }.padding(.horizontal, 5).padding(.vertical, 6).background(
            ZStack {
                if isTodayItem {
                    RoundedRectangle(cornerRadius: 30).foregroundColor(Color("DateColor"))
                } else if isSelectedItem && !isTodayItem {
                    RoundedRectangle(cornerRadius: 30).strokeBorder(Color("DateColor"), lineWidth: 2)
                }
            }
        )
    }
    
    /// Bottom Custom tab bar view
    private var CustomTabBarView: some View {
        ZStack {
            VStack {
                Spacer()
                LinearGradient(gradient: Gradient(colors: [Color("ListColor").opacity(0), Color("ListColor").opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea().frame(height: 150).allowsHitTesting(false)
            }
            VStack {
                Spacer()
                ZStack {
//                    CreateHabitButtonView
                    HStack{
                       // Spacer()
                        Group{
                            TabBarItem(type: .home)
                           // Spacer()
                            TabBarItem(type: .log)
                            //Spacer()
                            TabBarItem(type: .article)
                            //Spacer()
                            TabBarItem(type: .find)
                          //  Spacer()
                            TabBarItem(type: .settings)
                        }
                       // Spacer()
                    }.padding(.horizontal)
                }.padding(.horizontal, 15).background(
                    Color("offwhite")
                        .shadow(color: Color.black.opacity(0.2), radius: 10)
                )
            }
        }
    }
    
    private var CreateHabitButtonView: some View {
        Button {
            manager.fullScreenMode = .trendingHabits
        } label: {
            ZStack {
                Circle().foregroundColor(Color("blue")).padding(5)
                Image(systemName: "plus").font(.system(size: 22, weight: .bold))
                    .foregroundColor(Color("orange"))
            }
        }.frame(width: 60, height: 60, alignment: .center)
    }
    
    private func TabBarItem(type: CustomTabBarItem) -> some View {
        Button {
//            withAnimation{
                selectedTab = type
//            }
        } label: {
            VStack{
                Image(systemName: "\(type.rawValue)\(type == selectedTab ? ".fill" : "")")
                    .font(.system(size: 25, weight: .light))
                    .foregroundColor(type == selectedTab ? Color("orange") : Color("brown"))
            }
            .padding(.bottom, 10)
        }
        .padding()
    }
}

// MARK: - Preview UI
struct DashboardContentViewPreviews: PreviewProvider {
    static var previews: some View {
        DashboardContentView()
            .environmentObject(DataManager(preview: true))
    }
}
