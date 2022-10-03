//
//  HabitListItem.swift
//  Habit
//
//  Created by Apps4World on 1/22/22.
//

import SwiftUI

/// Habit list item view
extension HabitListView {
    
    /// Build the habit list item
    /// - Parameter model: habit model
    /// - Returns: returns the list item view
    func HabitListItem(model habitModel: HabitModel, index: Int) -> some View {
        ZStack {
            SwipeActionsView(model: habitModel)
            ListItemDetailsView(model: habitModel)
                .padding(.horizontal, 10).padding(.vertical).background(
                    GeometryReader { reader in
                        Color("ListColor")
                        AppConfig.colors[Int(habitModel.color)].opacity(0.6)
                        AppConfig.colors[Int(habitModel.color)]
                            .frame(width: completionWidth(reader: reader, model: habitModel))
                            .animation(showCompletionAnimation ? Animation.easeInOut.delay(0.2) : nil)
                        Color("BackgroundColor").opacity(habitModel.completed ? 1 : 0)
                    }.cornerRadius(15)
                )
                .padding(.horizontal)
                .padding(.trailing, manager.swipeActionsIndex == index ? swipeActionsOffset : 0).gesture(
                    DragGesture().onChanged { value in
                        showCompletionAnimation = false
                        manager.swipeActionsIndex = index
                        if value.startLocation.x < value.location.x - 10 {
                            swipeActionsOffset = 0
                        } else if value.startLocation.x > value.location.x + 10 {
                            swipeActionsOffset = min(abs(value.translation.width), 45)
                        }
                    }.onEnded { value in
                        if swipeActionsOffset > 0 {
                            swipeActionsOffset = 60
                            withAnimation(Animation.spring(response: 1, dampingFraction: 0.5).speed(2)) {
                                manager.swipeActionsIndex = index
                                swipeActionsOffset = 45
                            }
                        }
                    }
                ).onTapGesture { handleCompletionTap(forHabitModel: habitModel) }
        }.frame(height: 70)
    }
    
    /// List item details
    private func ListItemDetailsView(model: HabitModel) -> some View {
        HStack(spacing: 15) {
            Image(uiImage: UIImage(named: model.icon ?? "")!)
                .resizable().aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30).padding(.leading, 10)
                .opacity(model.completed ? 0.3 : 1)
            VStack(alignment: .leading) {
                if model.completed { Text(model.name ?? "").strikethrough() } else {
                    Text(model.name ?? "")
                }
                Text(model.motto ?? "You can do this").opacity(0.7)
                    .font(.system(size: 14, weight: .light)).lineLimit(1)
            }.opacity(model.completed ? 0.3 : 1)
            Spacer()
            if model.completed == false {
                Text("\(model.completion)/\(model.goal)").padding(.trailing, 5)
            } else {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 25)).padding(.trailing, 5)
            }
        }.foregroundColor(Color("LightColor"))
    }
    
    /// Custom swipe actions
    private func SwipeActionsView(model: HabitModel) -> some View {
        ZStack {
            Color.red.cornerRadius(20)
            HStack(spacing: 22) {
                Spacer()
                Image(systemName: "trash.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 18, weight: .semibold))
                    .padding(.trailing, 15).onTapGesture {
                        manager.swipeActionsIndex = nil
                        presentAlert(title: "Delete Item", message: "Are you sure you want to delete this habit? It will be deleted for all days of the week.", primaryAction: UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
                            manager.deleteHabit(model)
                        }), secondaryAction: UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    }
            }
        }.padding(.vertical, 1).padding(.horizontal)
    }
    
    /// Get the completion width for a list item
    private func completionWidth(reader: GeometryProxy, model habitModel: HabitModel) -> CGFloat {
        let progress = habitModel.completion
        let max = habitModel.goal
        let completed = reader.size.width
        let current = (CGFloat(progress) * completed) / CGFloat(max)
        return progress == max ? completed : current
    }
    
    /// Handle tap gesture for completion
    private func handleCompletionTap(forHabitModel model: HabitModel) {
        guard let habitDate = model.date?.date(format: "MM/dd/yyyy") else { return }
        
        let allowFutureDates = manager.allowFutureDaysCompletion && habitDate >= Date()
        let allowPastDates = manager.allowPastDaysCompletion && habitDate <= Date()
        let todayHabit = habitDate.longFormat == Date().longFormat
        
        if model.completed == false && (allowPastDates || allowFutureDates || todayHabit) {
            if manager.swipeActionsIndex == nil {
                showCompletionAnimation = true
                manager.updateCompletion(forHabit: model, habitsList: habitsData)
            } else {
                showCompletionAnimation = false
                manager.swipeActionsIndex = nil
            }
        }

        if !manager.allowFutureDaysCompletion && habitDate >= Date() && !todayHabit {
            presentAlert(title: "Oops!", message: "You can't mark progress for future dates", primaryAction: .ok)
        } else if !manager.allowPastDaysCompletion && habitDate <= Date() && !todayHabit {
            presentAlert(title: "Oops!", message: "You can't mark progress for past dates", primaryAction: .ok)
        } else if !manager.allowPastDaysCompletion && !manager.allowFutureDaysCompletion && !todayHabit {
            presentAlert(title: "Oops!", message: "You can't mark progress for past & future dates", primaryAction: .ok)
        }
    }
}
