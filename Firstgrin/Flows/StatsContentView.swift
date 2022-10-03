//
//  StatsContentView.swift
//  Habit
//
//  Created by Apps4World on 1/22/22.
//

import SwiftUI

// MARK: - Stats Highlights type
enum HighlightType: String, CaseIterable, Identifiable {
    case currentStreak = "Current streak"
    case longestStreak = "Longest streak"
    case bestMonth = "Best month"
    case completionRate = "Completion rate"
    var id: Int { hashValue }
    
    var color: Color {
        switch self {
        case .currentStreak:
            return Color(#colorLiteral(red: 0.1884031892, green: 0.6164012551, blue: 0.7388934493, alpha: 1))
        case .longestStreak:
            return Color(#colorLiteral(red: 0.8304590583, green: 0.2868802845, blue: 0.5694329143, alpha: 1))
        case .bestMonth:
            return Color(#colorLiteral(red: 0.5536777973, green: 0.4510317445, blue: 0.9476286769, alpha: 1))
        case .completionRate:
            return Color(#colorLiteral(red: 0.973535955, green: 0.2599409819, blue: 0.299492985, alpha: 1))
        }
    }
    
    var info: String {
        switch self {
        case .currentStreak:
            return "Simply indicate how continuously and regularly you have completed all your habits for a day"
        case .longestStreak:
            return "The longest duration of consecutive daily streaks"
        case .bestMonth:
            return "Your best month when you had the most completed habits"
        case .completionRate:
            return "The average completion rate for the past seven days"
        }
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

/// Stats flow for the habits
struct StatsContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @State var selectedChartItem: String?
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("BackgroundColor").ignoresSafeArea()
            VStack {
                HeaderTitle
                ZStack {
                    RoundedCorner(radius: 30, corners: [.topLeft, .topRight])
                        .foregroundColor(Color("ListColor")).ignoresSafeArea()
                        .shadow(color: Color.black.opacity(0.03), radius: 5, y: -5)
                    VStack(alignment: .center, spacing: 0) {
                        Capsule().frame(width: 35, height: 5).padding(10).opacity(0.2)
                        ScrollView(.vertical, showsIndicators: false) {
                            VStack(spacing: 30) {
                                HighlightsView
                                WeeklyChartView
                            }.padding(.horizontal)
                            Spacer(minLength: 100)
                        }
                    }
                }
            }
        }.onAppear {
            manager.fetchWeeklyPerformanceData()
        }
    }
    
    /// Header title
    private var HeaderTitle: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading) {
                Text("Stats").font(.largeTitle).bold()
                Text("See your habit stats")
            }
            Spacer()
            Button {
                manager.fullScreenMode = .settings
            } label: {
                Image(systemName: "gearshape.fill").font(.system(size: 18, weight: .medium))
            }
        }.padding(.horizontal).foregroundColor(Color("LightColor"))
    }
    
    /// Section title with right side data as optional text
    private func SectionHeader(title: String, showData: Bool = false) -> some View {
        HStack {
            Text(title).font(.system(size: 18, weight: .semibold))
            Spacer()
            if showData, let item = selectedChartItem {
                Text(String(format: "%.f%%", manager.performance[item] ?? 0.0))
            }
        }
    }
    
    /// Highlights view
    private var HighlightsView: some View {
        VStack(spacing: 10) {
            SectionHeader(title: "Highlights")
            LazyVGrid(columns: Array(repeating: GridItem(spacing: 15), count: 2), spacing: 15) {
                ForEach(HighlightType.allCases) { type in
                    HighlightView(forType: type)
                }
            }
        }
    }
    
    /// Highlight item
    private func HighlightView(forType type: HighlightType) -> some View {
        ZStack {
            type.color
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Image(uiImage: UIImage(named: "\(type)")!).resizable()
                        .aspectRatio(contentMode: .fit).frame(width: 25, height: 25)
                    VStack(alignment: .leading) {
                        Text(manager.fetchStats(type: type))
                            .font(.system(size: 20, weight: .semibold))
                        Text(type.rawValue).font(.system(size: 15))
                    }
                }
                Spacer()
            }.padding()
            VStack {
                HStack {
                    Spacer()
                    Button {
                        presentAlert(title: "", message: type.info)
                    } label: {
                        Image(systemName: "info.circle.fill")
                    }
                    .font(.system(size: 12))
                    .frame(width: 20, height: 20, alignment: .center)
                }
                Spacer()
            }.padding(10)
        }.cornerRadius(20).foregroundColor(Color("LightColor"))
    }
    
    /// Weekly chart performance
    private var WeeklyChartView: some View {
        VStack(spacing: 10) {
            SectionHeader(title: "Weekly Performance", showData: true)
            ChartView
        }
    }
}

// MARK: - Preview UI
struct StatsContentView_Previews: PreviewProvider {
    static var previews: some View {
        StatsContentView().environmentObject(DataManager(preview: true))
    }
}
