//
//  HabitApp.swift
//  Habit
//
//  Created by Apps4World on 1/22/22.
//

import SwiftUI

@main
struct HabitApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var manager: DataManager = DataManager(preview: false)
    @StateObject var viewRouter = ViewRouter()
    @StateObject var fireStoreVM = FirestoreViewModel()
    @StateObject var realtimeVM = RealtimeViewModel()
    @StateObject var storageVM = StorageViewModel()
    
    // MARK: - Main rendering function
    var body: some Scene {
        WindowGroup {
//            ContentView()
//                .environmentObject(viewRouter)
//                .environmentObject(fireStoreVM)
//                .environmentObject(realtimeVM)
//                .environmentObject(manager)
//                .environmentObject(storageVM)
            DashboardContentView().environmentObject(manager)
                .environment(\.managedObjectContext, manager.container.viewContext)
                .environmentObject(viewRouter)
                .environmentObject(fireStoreVM)
                .environmentObject(realtimeVM)
                .environmentObject(manager)
                .environmentObject(storageVM)
        }
    }
}

/// Create a shape with specific rounded corners
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func hideKeyboard() {
        DispatchQueue.main.async {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }
}

// MARK: - Present an alert from anywhere in the app
func presentAlert(title: String, message: String, primaryAction: UIAlertAction = .ok, secondaryAction: UIAlertAction? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(primaryAction)
    if let secondary = secondaryAction { alert.addAction(secondary) }
    rootController?.present(alert, animated: true, completion: nil)
}

extension UIAlertAction {
    static var ok: UIAlertAction {
        UIAlertAction(title: "OK", style: .cancel, handler: nil)
    }
}

var rootController: UIViewController? {
    var root = UIApplication.shared.windows.first?.rootViewController
    if let presenter = root?.presentedViewController { root = presenter }
    return root
}

/// Helps us monitor changes on a binding object. For example when user selected a certain segment from segmented control or picker
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}

// MARK: - Useful date formatters
extension Date {
    var frequencyType: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "E"
        let dateString = formatter.string(from: self).lowercased()
        return FrequencyType(rawValue: dateString)!.rawValue
    }
    
    var longFormat: String {
        string(format: "MM/dd/yyyy")
    }
    
    var headerTitle: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM, y"
        return formatter.string(from: self)
    }
    
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "y"
        return formatter.string(from: self)
    }
    
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension String {
    func date(format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
    
    var weekday: Int {
        if self == FrequencyType.sun.rawValue { return 1 }
        return FrequencyType(rawValue: self)!.sortId + 2
    }
}
