//
//  AppDelegate.swift
//  Habit
//
//  Created by Apps4World on 1/24/22.
//

import UIKit
import Foundation
import PurchaseKit
import GoogleMobileAds
import UserNotifications

/// App Delegate file in SwiftUI
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        PKManager.loadProducts(identifiers: [AppConfig.premiumVersion])
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        return true
    }
}

// MARK: - Handle notification received by application
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.sound, .list, .banner])
    }
}

// MARK: - Google AdMob Interstitial - Support class
class Interstitial: NSObject, GADFullScreenContentDelegate {
    var isPremiumUser: Bool = UserDefaults.standard.bool(forKey: AppConfig.premiumVersion)
    private var interstitial: GADInterstitialAd?
    private var presentedCount: Int = 0
    static var shared: Interstitial = Interstitial()
    
    /// Default initializer of interstitial class
    override init() {
        super.init()
        loadInterstitial()
    }
    
    /// Request AdMob Interstitial ads
    func loadInterstitial() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: AppConfig.adMobAdId, request: request, completionHandler: { [self] ad, error in
            if ad != nil { interstitial = ad }
            interstitial?.fullScreenContentDelegate = self
        })
    }
    
    func showInterstitialAds() {
        presentedCount += 1
        if self.interstitial != nil, presentedCount % AppConfig.adMobFrequency == 0, !isPremiumUser {
            var root = UIApplication.shared.windows.first?.rootViewController
            if let presenter = root?.presentedViewController { root = presenter }
            self.interstitial?.present(fromRootViewController: root!)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        loadInterstitial()
    }
}
