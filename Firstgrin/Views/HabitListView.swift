//
//  HabitListView.swift
//  Habit
//
//  Created by Apps4World on 1/22/22.
//

import SwiftUI

/// Shows the list of habits
struct HabitListView: View {
    
    @EnvironmentObject var manager: DataManager
    @FetchRequest(entity: HabitModel.entity(), sortDescriptors: []) var habitsData: FetchedResults<HabitModel>
    @State private var didValidateDailyHabits: Bool = false
    @State var showCompletionAnimation: Bool = false
    @State var swipeActionsOffset: Double = 0.0
    
    /// Initialize the list with a given calendar date
    init(date: Date) {
        let dateFrequency = date.frequencyType
        let dateLong = date.longFormat
        let frequencyPredicate = NSPredicate(format: "frequency CONTAINS[c] %@", dateFrequency)
        let datePredicate = NSPredicate(format: "date = %@", dateLong)
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [frequencyPredicate, datePredicate])
        let completedSort = NSSortDescriptor(keyPath: \HabitModel.completed, ascending: true)
        let nameSort = NSSortDescriptor(keyPath: \HabitModel.name, ascending: true)
        _habitsData = FetchRequest(entity: HabitModel.entity(), sortDescriptors: [completedSort, nameSort], predicate: predicate)
    }
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            RoundedCorner(radius: 20, corners: [.topLeft, .topRight])
                .foregroundColor(Color("ListColor")).ignoresSafeArea()
                .shadow(color: Color.black.opacity(0.03), radius: 5, y: -5).onTapGesture {
                    manager.swipeActionsIndex = nil
                }
            VStack(alignment: .center, spacing: 0) {
                //Capsule().frame(width: 35, height: 5).padding(10).opacity(0.2)
                if habitsData.count == 0 {
                    EmptyListView
                } else {
                    ListView
                }
            }.padding(10)
        }.padding(.top, 5).onAppear {
            if !didValidateDailyHabits {
                didValidateDailyHabits = true
                manager.verifyHabitDate(selectedDate: manager.selectedDate)
            }
        }
    }
    
    /// List of habits
    private var ListView: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Log List").padding(.horizontal, 20).font(.headline)
                Spacer()
            }
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 15) {
                    ForEach(0..<habitsData.count, id: \.self) { index in
                        HabitListItem(model: habitsData[index], index: index)
                    }
                }
                Spacer(minLength: 80)
            }.onTapGesture {
                manager.swipeActionsIndex = nil
            }
        }
    }
    
    /// No habits view
    private var EmptyListView: some View {
        VStack {
            Spacer()
            Image(systemName: "list.star").font(.largeTitle).padding(2)
            Text("No Log Yet").font(.title3).bold()
            Text("You don't have any log for today\nTap the '+' button below to create a new log")
                .font(.subheadline).opacity(0.6)
            Spacer()
            Spacer()
        }.multilineTextAlignment(.center).foregroundColor(Color("TextColor"))
    }
}

// MARK: - Preview UI
struct HabitsListView_Previews: PreviewProvider {
    static var previews: some View {
        HabitListView(date: Date())
            .environmentObject(DataManager(preview: true))
    }
}
