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
    case home = "house", log = "chart.pie", article = "doc.circle", find = "magnifyingglass.circle", settings = "gearshape.circle", shop = "cart.circle"
}

/// Main view for the app
struct DashboardContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @State private var selectedTab: CustomTabBarItem = .home
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("blue").ignoresSafeArea()
            if selectedTab == .home {
                HomeTabView
            } else if selectedTab == .article{
                ArticleView()
            } else if selectedTab == .find{
                FindADentistView()
            } else if selectedTab == .settings{
                SettingsContentView()
            } else if selectedTab == .shop {
                ShopContentView()
            }
            else {
                StatsContentView().environmentObject(manager)
            }
            CustomTabBarView
                .edgesIgnoringSafeArea(.bottom)
        }
        .onAppear {
            print("width:\(UIScreen.screenWidth) , Height: \(UIScreen.screenHeight)")
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
            case .emergency:
                EmergencyContentView()
                    .environmentObject(manager)
            }
        }
    }
    
    /// Dashboard/Home tab view
    private var HomeTabView: some View {
        ZStack{
            ScrollView {
                HeaderTitle
                HeaderLottieView
                VStack{
                    // HeaderCalendarView
                    HabitListView(date: manager.selectedDate)
                        .shadow(radius: 0.5)
                }
                .frame(height: UIScreen.screenHeight*0.5)
                .background(Color("offwhite"))
                .cornerRadius(20, corners: [.topLeft,.topRight])
            }
            VStack{
                Spacer()
                CreateHabitButtonView
                    .padding(.bottom, 40)
            }
        }
    }
        
    
    /// Header title
    private var HeaderTitle: some View {
        ZStack{
            HStack {
                Text("Firstgrin").font(.system(.largeTitle, design: .rounded)).fontWeight(.black)
                    .foregroundColor(Color("offwhite"))
//                Text(manager.selectedDate.headerTitle)
            }
            HStack(alignment: .top) {
                Button {
                    manager.fullScreenMode = .settings
                } label: {
                    ZStack{
                        Circle()
                            .fill(Color.red)
                            .frame(width: 40)
                        Text("S")
                            .font(.title3).bold()
                    }
                }
                Spacer()
                Button {
                    manager.fullScreenMode = .emergency
                } label: {
                    LottieView(name: "heal", playAnimation: .constant(true))
                        .frame(width: 40,height: 40)
//                    HStack{
//                        Image(systemName: "exclamationmark.triangle.fill").font(.system(size: 18, weight: .medium))
//                            .foregroundColor(.red)
//                    }
                }
            }.padding(.horizontal).foregroundColor(Color("LightColor"))
        }
    }
    
    private var HeaderLottieView: some View{
        ZStack{
            LottieView(name: "moving-bubbles", playAnimation: .constant(true))
                .frame(width: UIScreen.screenWidth,height: UIScreen.screenHeight*0.35)
            LottieView(name: "hover-blob-orange", playAnimation: .constant(true))
                .frame(height: UIScreen.screenHeight*0.26)
            VStack {
                Text("Samantha")
                    .font(.system(size: 32, weight: .black,design: .rounded))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: UIScreen.screenWidth * 0.4)
                    .overlay(
                        HStack {
                            Spacer()
                            Image(systemName: "repeat")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        }
                            .offset(y: -UIScreen.screenHeight / 26.375)
                    )
                
                    .overlay(
                        VStack {
                            Text("2yrs, 3mnth")
                                .font(.system(size: 10, weight: .black,design: .rounded))
                                .foregroundColor(.white)
                            Text(manager.selectedDate.headerTitle)
                                .font(.system(size: 14, weight: .black,design: .rounded))
                                .foregroundColor(.white)
                        }
                            .offset(y: UIScreen.screenHeight / 26.375)
                    )
            }
        }
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
                            TabBarItem(type: .shop)
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
