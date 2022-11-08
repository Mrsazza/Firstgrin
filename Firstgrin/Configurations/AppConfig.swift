//
//  AppConfig.swift
//  Habit
//
//  Created by Apps4World on 1/22/22.
//

import SwiftUI
import Foundation

/// Generic configurations for the app
class AppConfig {
    
    /// This is the AdMob Interstitial ad id
    /// Test App ID: ca-app-pub-3940256099942544~1458002511
    static let adMobAdId: String = "ca-app-pub-3940256099942544/4411468910"
    static let adMobFrequency: Int = 2 /// whenever we tap on a habit or create a habit
    
    // MARK: - Settings flow items
    static let emailSupport = "support@apps4world.com"
    static let privacyURL: URL = URL(string: "https://www.google.com/")!
    static let termsAndConditionsURL: URL = URL(string: "https://www.google.com/")!
    static let yourAppURL: URL = URL(string: "https://apps.apple.com/app/idXXXXXXXXX")!

    // MARK: - Habit Style
    static let colors: [Color] = [Color(#colorLiteral(red: 0.1884031892, green: 0.6164012551, blue: 0.7388934493, alpha: 1)), Color(#colorLiteral(red: 0.1884031892, green: 0.7812900772, blue: 0.7388934493, alpha: 1)), Color(#colorLiteral(red: 0.8304590583, green: 0.2868802845, blue: 0.5694329143, alpha: 1)), Color(#colorLiteral(red: 0.9708533654, green: 0.2868802845, blue: 0.5694329143, alpha: 1)), Color(#colorLiteral(red: 0.5536777973, green: 0.4510317445, blue: 0.9476286769, alpha: 1)), Color(#colorLiteral(red: 0.5536777973, green: 0.6288913198, blue: 1, alpha: 1)), Color(#colorLiteral(red: 0.973535955, green: 0.2599409819, blue: 0.299492985, alpha: 1)), Color(#colorLiteral(red: 1, green: 0.493189179, blue: 0.299492985, alpha: 1))]
    static let icons: [String] = ["alarm", "brush", "language", "read", "walk", "water", "workout", "fruit", "meditate", "yoga", "budget", "sleep"]
    
    // MARK: - Generic configurations
    static let headerTitleDaysCount: Int = 10
    static let mottoStrings: [String] = [
        "Keep your teeth & gums clean", "Reading makes you smarter", "Learn a new language", "Walking is good for your pet",
        "Be the first one to wake up", "Bend your mind, inspire yourself", "If you can dream it, you can do it",
        "Do not go over budget", "It's kind of fun to do the impossible", "You need at least 8+ hrs of sleep",
        "We do not remember days, we remember moments", "You can do this"
    ]
    
    // MARK: - In App Purchases
    static let premiumVersion: String = "Habit.Premium"
}

// MARK: - Trending Habits
struct TrendingHabitModel {
    let name: String
    let motto: String
    let colorIndex: Int
    let iconString: String
}

let TrendingHabits: [TrendingHabitModel] = [
    .init(name: "Brushing", motto: "Brush teeth for 2 minutes", colorIndex: 0, iconString: "brush"),
    .init(name: "Flossing", motto: "Floss teeth", colorIndex: 1, iconString: "read"),
    .init(name: "Mouth Wash", motto: "Mouth Wash your teeth for 2 days", colorIndex: 2, iconString: "language"),
//    .init(name: "Walk your Dog", motto: "Walking is good for your pet", colorIndex: 3, iconString: "walk"),
//    .init(name: "Wake up Early", motto: "Be the first one to wake up", colorIndex: 4, iconString: "alarm"),
//    .init(name: "Yoga", motto: "Bend your mind, inspire yourself", colorIndex: 5, iconString: "yoga"),
//    .init(name: "Budgeting", motto: "Do not go over budget", colorIndex: 6, iconString: "budget"),
//    .init(name: "Sleep Early", motto: "You need at least 8+ hrs of sleep", colorIndex: 7, iconString: "sleep")
]
