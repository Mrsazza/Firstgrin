//
//  DataManager.swift
//  Habit
//
//  Created by Apps4World on 1/22/22.
//

import SwiftUI
import CoreData
import Foundation

/// Full Screen flow
enum FullScreenMode: Int, Identifiable {
    case createHabit, subscriptions, settings, trendingHabits, emergency
    var id: Int { hashValue }
}

/// Main data manager for the app
class DataManager: NSObject, ObservableObject {
    
    /// Dynamic properties that the UI will react to
    @Published var showLoading: Bool = false
    @Published var fullScreenMode: FullScreenMode?
    @Published var performance: [String: Double] = [String: Double]()
    @Published var swipeActionsIndex: Int?
    @Published var didCompleteDailyHabits: Bool = false
    
    @Published var trendingHabit: TrendingHabitModel? {
        didSet { fullScreenMode = .createHabit }
    }
    
    @Published var selectedDate: Date = Date() {
        didSet { verifyHabitDate(selectedDate: selectedDate) }
    }
    
    /// Dynamic properties that the UI will react to AND store values in UserDefaults
    @AppStorage("showConfetti") var showCompletionConfetti: Bool = true
    @AppStorage("allowPastDaysCompletion") var allowPastDaysCompletion: Bool = false
    @AppStorage("allowFutureDaysCompletion") var allowFutureDaysCompletion: Bool = false
    @AppStorage(AppConfig.premiumVersion) var isPremiumUser: Bool = false {
        didSet { Interstitial.shared.isPremiumUser = isPremiumUser }
    }
    
    /// Core Data container with the database model
    let container: NSPersistentContainer = NSPersistentContainer(name: "Database")
    
    /// Default init method. Load the Core Data container
    init(preview: Bool = false) {
        super.init()
        if preview {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { _, _ in
            self.container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        }
    }
    
    /// Calendar days
    var calendarDays: [Date] {
        var days = [Date]()
        for index in 0..<AppConfig.headerTitleDaysCount {
            let date = Calendar(identifier: .gregorian).date(byAdding: .day, value: -index, to: Date())!
            days.append(date)
        }
        days.removeLast()
        days.insert(Calendar(identifier: .gregorian).date(byAdding: .day, value: 1, to: Date())!, at: 0)
        return days.reversed()
    }
}

// MARK: - Update habit model
extension DataManager {
    /// Update the habit completion
    func updateCompletion(forHabit habit: HabitModel, habitsList: FetchedResults<HabitModel>) {
        if habit.completion < habit.goal { habit.completion += 1 }
        habit.completed = habit.completion == habit.goal
        if showCompletionConfetti && habitsList.count == habitsList.filter({ $0.completed }).count {
            ConfettiController.showConfettiOverlay()
        } else {
            Interstitial.shared.showInterstitialAds()
        }
        try? container.viewContext.save()
    }
    
    /// Delete a habit from all days of the week
    func deleteHabit(_ habit: HabitModel) {
        guard let habitName = habit.name else { return }
        let frequencyPredicate = NSPredicate(format: "name = %@", habitName)
        let fetchRequest: NSFetchRequest<HabitModel> = HabitModel.fetchRequest()
        fetchRequest.predicate = frequencyPredicate
        if let results = try? container.viewContext.fetch(fetchRequest) {
            DispatchQueue.main.async {
                results.forEach { self.container.viewContext.delete($0) }
                try? self.container.viewContext.save()
            }
        }
    }
    
    /// Verify if the habits from CoreData has selected date as the date object
    func verifyHabitDate(selectedDate date: Date) {
        swipeActionsIndex = nil
        let frequencyPredicate = NSPredicate(format: "frequency CONTAINS[c] %@", date.frequencyType)
        let fetchRequest: NSFetchRequest<HabitModel> = HabitModel.fetchRequest()
        fetchRequest.predicate = frequencyPredicate
        if let habits = try? container.viewContext.fetch(fetchRequest) {
            habits.filter { $0.date == nil }.forEach { habit in
                if habits.first(where: { $0.name == habit.name && $0.date == date.longFormat }) == nil {
                    updateDate(forHabit: habit, date: date)
                }
            }
        }
    }
    
    /// Create a copy of the habit and save it with the selected date
    private func updateDate(forHabit habit: HabitModel, date: Date) {
        let updatedHabit = HabitModel(context: container.viewContext)
        updatedHabit.name = habit.name
        updatedHabit.motto = habit.motto
        updatedHabit.color = habit.color
        updatedHabit.frequency = habit.frequency
        updatedHabit.goal = habit.goal
        updatedHabit.icon = habit.icon
        updatedHabit.reminder = habit.reminder
        updatedHabit.date = date.longFormat
        DispatchQueue.main.async { try? self.container.viewContext.save() }
    }
}

// MARK: - Stats data
extension DataManager {
    /// Get stats data based on highlights type
    func fetchStats(type: HighlightType) -> String {
        let tomorrow = Calendar(identifier: .gregorian).date(byAdding: .day, value: 1, to: Date())
        let datePredicate = NSPredicate(format: "date CONTAINS[c] %@", "/\(Date().year)")
        let excludeTomorrow = NSPredicate(format: "NOT (date CONTAINS[c] %@)", tomorrow!.longFormat)
        let fetchRequest: NSFetchRequest<HabitModel> = HabitModel.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [datePredicate, excludeTomorrow])
        
        /// Get all core data results for current year
        if let results = try? container.viewContext.fetch(fetchRequest) {
            var completion = [String: Bool]()
            var streaks = [[String]]()
            
            _ = Dictionary(grouping: results, by: { $0.date })
                .map { completion[$0.key!] = ($0.value.count == $0.value.filter({ $0.completed }).count) }
            
            /// Get the day streaks
            var streak = [String]()
            completion.sorted(by: { $0.key.date(format: "MM/dd/yyyy") ?? Date() > $1.key.date(format: "MM/dd/yyyy") ?? Date()})
                .forEach { date, completed in
                    if completed { streak.append(date) } else {
                        if streak.count > 0 {
                            streaks.append(streak)
                            streak.removeAll()
                        }
                    }
                }
            
            if streak.count > 0 {
                streaks.append(streak)
            }
            
            /// Get the best month by completed habits
            var months = [String: Int]()
            completion.filter({ $0.value == true }).forEach { date, _ in
                if let month = date.date(format: "MM/dd/yyyy")?.string(format: "MMMM") {
                    months[month] = months[month] ?? 0 + 1
                }
            }
            
            /// Performance/Completion data
            let totalPerformance = performance.compactMap({ $0.value }).reduce(0, +)

            switch type {
            case .currentStreak:
                return "\(streaks.first?.count ?? 0) Days"
            case .longestStreak:
                return "\(streaks.sorted(by: { $0.count > $1.count }).first?.count ?? 0) Days"
            case .bestMonth:
                return months.sorted(by: { $0.value > $1.value }).first?.key ?? "- -"
            case .completionRate:
                return performance.count > 0 ? String(format: "%.f%%", totalPerformance/Double(performance.count)) : "- -%"
            }
        }
        
        return "- -"
    }
    
    /// Fetch performance data for current week only
    func fetchWeeklyPerformanceData() {
        let currentWeek = Array(calendarDays.dropLast().sorted().suffix(7)).compactMap({ $0.longFormat })
        let datePredicate = NSPredicate(format: "date IN %@", currentWeek)
        let fetchRequest: NSFetchRequest<HabitModel> = HabitModel.fetchRequest()
        fetchRequest.predicate = datePredicate
        
        /// Get all core data results for current week
        if let results = try? container.viewContext.fetch(fetchRequest) {
            var performanceData = [String: Double]()
            currentWeek.forEach { date in
                let habits = results.filter({ $0.date == date })
                let completedHabits = habits.filter({ $0.completed })
                if habits.count > 0 {
                    performanceData[date] = Double(Double(completedHabits.count)/Double(habits.count)) * 100.0
                }
            }
            DispatchQueue.main.async {
                self.performance = performanceData
            }
        }
    }
}

// MARK: - Notifications schedule
extension DataManager {
    /// Schedule a local notification for a habit
    /// - Parameter habit: habit to be reminded about
    func scheduleNotification(forHabit habit: HabitModel) {
        guard let time = habit.reminder, let name = habit.name, let days = habit.frequency else { return }
        
        let notification = UNMutableNotificationContent()
        notification.title = name
        notification.body = habit.motto ?? AppConfig.mottoStrings.last!
        notification.sound = .default
        
        func schedule(weekday: Int) {
            let hour = Calendar(identifier: .gregorian).dateComponents([.hour], from: time).hour!
            let minute = Calendar(identifier: .gregorian).dateComponents([.minute], from: time).minute!
            let dateComponents = DateComponents(hour: hour, minute: minute, weekday: weekday)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(identifier: "\(name)_\(weekday)", content: notification, trigger: trigger)
            UNUserNotificationCenter.current().add(request) { _ in }
        }
        
        days.components(separatedBy: ",").forEach { day in
            schedule(weekday: day.weekday)
        }
    }
}
