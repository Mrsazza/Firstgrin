//
//  StatsChartView.swift
//  Habit
//
//  Created by Apps4World on 1/22/22.
//

import SwiftUI

/// Stats chart view
extension StatsContentView {
    
    /// Chart view with stats data
    var ChartView: some View {
        let percentage = Array([0, 25, 50, 75, 100].reversed())
        let weekDays = Array(manager.calendarDays.dropLast().reversed().prefix(7).reversed())
        return ZStack {
            /// Chart percentage horizontal lines
            VStack(alignment: .leading, spacing: 20) {
                ForEach(0..<percentage.count, id: \.self) { index in
                    HStack(spacing: 10) {
                        Text("\(percentage[index])").frame(width: 30, alignment: .leading)
                        Line().stroke(style: StrokeStyle(lineWidth: 1, dash: [6])).frame(height: 1).opacity(0.5)
                    }
                }
            }.padding(.bottom, 30)
            
            /// Chart days
            VStack {
                Spacer()
                HStack {
                    ForEach(0..<weekDays.count, id: \.self) { index in
                        Text(weekDays[index].string(format: "MMM\nd"))
                            .font(.system(size: 15, weight: .semibold))
                            .multilineTextAlignment(.center)
                    }.frame(maxWidth: .infinity)
                }
            }.padding(.leading, 30)
            
            /// Chart progress bars
            HStack {
                ForEach(0..<weekDays.count, id: \.self) { index in
                    ChartProgressBar(forDate: weekDays[index].longFormat)
                }
            }.padding(.leading, 30).padding(.bottom, 40)
        }
    }
    
    /// Chart progress for day
    private func ChartProgressBar(forDate date: String) -> some View {
        GeometryReader { reader in
            VStack {
                Spacer()
                Rectangle().frame(height: completionHeight(reader: reader, date: date))
                    .foregroundColor(.clear).overlay(
                        RoundedCorner(radius: 5, corners: [.topLeft, .topRight]).frame(width: 20)
                    )
                    .onTapGesture {
                        if selectedChartItem == date { selectedChartItem = nil } else {
                            selectedChartItem = date
                        }
                    }
                    .opacity(selectedChartItem != nil ? (selectedChartItem == date ? 1 : 0.2) : 1)
                    .foregroundColor(Color("TextColor"))
            }
        }
    }
    
    /// Completion progress height for chart bar
    private func completionHeight(reader: GeometryProxy, date: String) -> CGFloat {
        guard let progress = manager.performance[date] else { return 0 }
        let max = Double(100.0)
        let completed = reader.size.height
        let current = (CGFloat(progress) * completed) / CGFloat(max)
        return progress == max ? completed - 5 : current
    }
}
