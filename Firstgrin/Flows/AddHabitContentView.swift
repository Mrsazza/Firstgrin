//
//  AddHabitContentView.swift
//  Habit
//
//  Created by Apps4World on 1/22/22.
//

import SwiftUI

/// Frequency for a habit during a week period
enum FrequencyType: String, CaseIterable, Identifiable {
    case mon, tue, wed, thu, fri, sat, sun
    var id: Int { hashValue }
    var sortId: Int {
        var ids = [FrequencyType: Int]()
        FrequencyType.allCases.enumerated().forEach { index, type in
            ids[type] = index
        }
        return ids[self]!
    }
}

/// Add a habit content view
struct AddHabitContentView: View {
    
    @EnvironmentObject var manager: DataManager
    @Environment(\.colorScheme) var colorScheme
    @FetchRequest(entity: HabitModel.entity(), sortDescriptors: []) var habitsData: FetchedResults<HabitModel>
    @State var habitName: String = ""
    @State var inspirationText: String = "You can do this"
    @State var selectedFrequency: [FrequencyType] = FrequencyType.allCases
    @State var habitColorIndex: Int = 0
    @State var habitIconText: String = AppConfig.icons[0]
    @State var dailyCount: String = "1"
    @State var reminder: Bool = false
    @State var reminderTime: Date = Date()
    @State var showColorsPicker: Bool = false
    @State var showIconsPicker: Bool = false
    @State var didConfigureTrendingHabit: Bool = false
    @State var didShowKeyboard: Bool = false
    
    /// Fetch habits to verify if habits with the same name exists
    init() {
        _habitsData = FetchRequest(entity: HabitModel.entity(), sortDescriptors: [])
    }
    
    // MARK: - Main rendering function
    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color("ListColor").ignoresSafeArea()
                
                VStack {
                    HeaderTitle
                    ScrollView(.vertical, showsIndicators: true) {
                        Spacer(minLength: 15)
                        VStack(spacing: 20) {
                            CreateSection(items: [AnyView(HabitNameField), AnyView(HabitInspirationView), AnyView(HabitStyleView)])
                            CreateSection(items: [AnyView(FrequencyView), AnyView(DaysSelectorView)])
                            CreateSection(items: [AnyView(GoalFrequencyView)])
                            CreateSection(items: [AnyView(ReminderView)])
                        }.padding(.horizontal)
                    }
                }
                
                /// Colors & Icons picker overlays
                ColorsGridView(selectedColorIndex: $habitColorIndex, showColorsGrid: $showColorsPicker)
                IconsGridView(selectedIconName: $habitIconText, showIconsGrid: $showIconsPicker, tintColor: AppConfig.colors[habitColorIndex])
            }
        }
        
        /// Auto-fill trending habit details
        .onAppear {
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: nil) { _ in
                DispatchQueue.main.async { withAnimation { didShowKeyboard = true } }
            }
            NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: nil) { _ in
                DispatchQueue.main.async { withAnimation { didShowKeyboard = false } }
            }
            if let trending = manager.trendingHabit, !didConfigureTrendingHabit {
                habitName = trending.name
                inspirationText = trending.motto
                habitColorIndex = trending.colorIndex
                habitIconText = trending.iconString
                didConfigureTrendingHabit = true
            }
        }
    }
    
    /// Header title
    private var HeaderTitle: some View {
        ZStack {
            Text("Create a Habit").font(.system(size: 22, weight: .light))
            HStack(alignment: .center) {
                Button {
                    if didShowKeyboard {
                        hideKeyboard()
                    } else {
                        saveHabit()
                    }
                } label: {
                    if didShowKeyboard {
                        Image(systemName: "keyboard.chevron.compact.down").font(.system(size: 18, weight: .medium))
                    } else {
                        Text("Save").font(.system(size: 18, weight: .medium))
                    }
                }
                Spacer()
                Button {
                    manager.fullScreenMode = nil
                } label: {
                    Image(systemName: "xmark").font(.system(size: 18, weight: .medium))
                }
            }.padding(.horizontal)
        }.foregroundColor(Color("TextColor"))
    }
    
    /// Create a section with certain items
    private func CreateSection(items: [AnyView]) -> some View {
        VStack(spacing: 15) {
            ForEach(0..<items.count, id: \.self) { index in
                items[index].padding(.horizontal, 20)
                if index != items.count - 1 {
                    Color("TextColor").frame(height: 1).opacity(0.2)
                }
            }
        }.padding(.vertical, 20).background(
            Color("Secondary").cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        )
    }
    
    /// Name for the habit text input
    private var HabitNameField: some View {
        TextField("Name", text: $habitName)
            .font(.system(size: 20))
            .foregroundColor(Color("TextColor"))
    }
    
    /// Habit color and icon
    private var HabitStyleView: some View {
        HStack(spacing: 20) {
            Button {
                hideKeyboard()
                withAnimation { showIconsPicker = true }
            } label: {
                Image(uiImage: UIImage(named: habitIconText)!).resizable()
                    .aspectRatio(contentMode: .fit).frame(width: 28, height: 28)
            }.frame(width: 30, height: 30).frame(maxWidth: .infinity)
            Color("DarkColor").frame(width: 1, height: 30)
            Circle().frame(width: 30, height: 30).frame(maxWidth: .infinity).onTapGesture {
                withAnimation { showColorsPicker = true }
            }
        }.foregroundColor(AppConfig.colors[habitColorIndex])
    }
    
    /// Habit inspiration/motto text input
    private var HabitInspirationView: some View {
        HStack {
            TextField("Inspiration text", text: $inspirationText)
            Spacer()
            Button {
                hideKeyboard()
                inspirationText = AppConfig.mottoStrings.randomElement() ?? AppConfig.mottoStrings[0]
            } label: {
                Image(systemName: "dice.fill").font(.system(size: 25))
            }.foregroundColor(AppConfig.colors[habitColorIndex])
        }
    }
    
    /// Frequency for a week for this habit
    private var FrequencyView: some View {
        let formattedText = selectedFrequency
            .sorted(by: { $0.sortId < $1.sortId })
            .compactMap { $0.rawValue.capitalized }
            .joined(separator: ", ")
        return Text(selectedFrequency.count == 7 ? "Every day" : formattedText)
    }
    
    /// Horizontal day selector
    private var DaysSelectorView: some View {
        HStack {
            ForEach(FrequencyType.allCases) { type in
                ZStack {
                    Circle().foregroundColor(selectedFrequency.contains(type) ? AppConfig.colors[habitColorIndex] : .clear)
                    Text(String(type.rawValue.prefix(1)).capitalized)
                        .foregroundColor(selectedFrequency.contains(type) ? (colorScheme == .light ? Color("LightColor") : Color("LightColor")) : (colorScheme == .light ? Color("TextColor") : Color("LightColor")))
                }
                .frame(width: 30, height: 30)
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    if selectedFrequency.contains(type) {
                        if selectedFrequency.count > 1 {
                            selectedFrequency.removeAll(where: { $0 == type })
                        }
                    } else {
                        selectedFrequency.append(type)
                    }
                }
            }
        }
    }
    
    /// Goal/Times a day/week for the habit to complete
    private var GoalFrequencyView: some View {
        HStack {
            TextField("1", text: $dailyCount)
                .keyboardType(.numberPad)
                .frame(width: 45, height: 30)
                .multilineTextAlignment(.center)
                .background(AppConfig.colors[habitColorIndex].cornerRadius(10))
                .foregroundColor(.white)
            Text("per day")
            Spacer()
            Text("ex: time, min, mile").italic().opacity(0.3)
        }
    }
    
    /// Reminder view and time selector for a reminder
    private var ReminderView: some View {
        HStack {
            if manager.isPremiumUser == false {
                Image(systemName: "lock.fill")
            }
            Text("Remind me at")
            Spacer()
            DatePicker("", selection: $reminderTime, displayedComponents: [.hourAndMinute]).labelsHidden().opacity(reminder ? 1 : 0)
            Spacer()
            Toggle("", isOn: $reminder.onChange { _ in
                if manager.isPremiumUser == false {
                    reminder = false
                    presentAlert(title: "Premium Feature", message: "This is a premium feature that requires in-app purchases", primaryAction: UIAlertAction(title: "Buy Now", style: .default, handler: { _ in
                        manager.fullScreenMode = .subscriptions
                    }), secondaryAction: UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                }
            })
            .labelsHidden()
            .toggleStyle(SwitchToggleStyle(tint: AppConfig.colors[habitColorIndex]))
        }
    }
}

// MARK: - Save Habit to CoreData
extension AddHabitContentView {
    /// Save habit to CoreData
    func saveHabit() {
        hideKeyboard()
        if habitName.trimmingCharacters(in: .whitespaces).isEmpty {
            presentAlert(title: "Oops!", message: "Missing Habit name")
        } else {
            /// Check if a habit with the same name exists
            if habitsData.contains(where: { $0.name?.lowercased() == habitName.lowercased() }) {
                presentAlert(title: "Duplicate?", message: "Looks like there is a habit with the same name")
            } else {
                /// Create the habit entity
                let habit = HabitModel(context: manager.container.viewContext)
                habit.name = habitName
                habit.motto = inspirationText
                habit.color = Int16(habitColorIndex)
                habit.frequency = selectedFrequency.compactMap { $0.rawValue }.joined(separator: ",")
                habit.goal = Int16(dailyCount) ?? 1
                habit.icon = habitIconText
                habit.reminder = reminder ? reminderTime : nil
                
                do {
                    try manager.container.viewContext.save()
                    manager.fullScreenMode = nil
                    manager.verifyHabitDate(selectedDate: manager.selectedDate)
                    manager.scheduleNotification(forHabit: habit)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        Interstitial.shared.showInterstitialAds()
                    }
                } catch let error {
                    presentAlert(title: "Oops!", message: error.localizedDescription)
                }
            }
        }
    }
}

// MARK: - Preview UI
struct AddHabitContentView_Previews: PreviewProvider {
    static var previews: some View {
        AddHabitContentView().environmentObject(DataManager(preview: true))
    }
}
