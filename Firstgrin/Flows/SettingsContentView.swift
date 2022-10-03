//
//  SettingsContentView.swift
//  Habit
//
//  Created by Apps4World on 1/22/22.
//

import SwiftUI
import StoreKit
import MessageUI
import PurchaseKit

/// Main settings view
struct SettingsContentView: View {
    
    @EnvironmentObject private var manager: DataManager
    @State private var showLoadingView: Bool = false
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            Color("ListColor").ignoresSafeArea()
            
            VStack(spacing: 10) {
                HeaderTitle
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack {
                        CustomHeader(title: "IN-APP PURCHASES")
                        InAppPurchasesPromoBannerView
                        InAppPurchasesView
                        CustomHeader(title: "HABIT CONFIG")
                        HabitConfigView
                        CustomHeader(title: "SPREAD THE WORD")
                        RatingShareView
                        CustomHeader(title: "SUPPORT & PRIVACY")
                        PrivacySupportView
                    }.padding([.leading, .trailing], 18)
                    Spacer(minLength: 20)
                }).padding(.top, 5)
            }
            
            /// Show loading view
            LoadingView(isLoading: $showLoadingView)
        }
    }
    
    /// Header title
    private var HeaderTitle: some View {
        HStack(alignment: .top) {
            Text("Settings").font(.largeTitle).bold()
            Spacer()
            Button {
                manager.fullScreenMode = nil
            } label: {
                Image(systemName: "xmark").font(.system(size: 18, weight: .medium))
            }
        }.padding(.horizontal).foregroundColor(Color("TextColor"))
    }
    
    /// Create custom header view
    private func CustomHeader(title: String, subtitle: String? = nil) -> some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title).font(.system(size: 18, weight: .medium))
                if let subtitleText = subtitle {
                    Text(subtitleText)
                }
            }
            Spacer()
        }.foregroundColor(Color("TextColor"))
    }
    
    /// Custom settings item
    private func SettingsItem(title: String, icon: String, action: @escaping() -> Void) -> some View {
        Button(action: {
            UIImpactFeedbackGenerator().impactOccurred()
            action()
        }, label: {
            HStack {
                Image(systemName: icon).resizable().aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22, alignment: .center)
                Text(title).font(.system(size: 18))
                Spacer()
                Image(systemName: "chevron.right")
            }.foregroundColor(Color("TextColor")).padding()
        })
    }
    
    // MARK: - In App Purchases
    private var InAppPurchasesView: some View {
        VStack {
            SettingsItem(title: "Upgrade Premium", icon: "crown") {
                manager.fullScreenMode = .subscriptions
            }
            Color("TextColor").frame(height: 1).opacity(0.2)
            SettingsItem(title: "Restore Purchases", icon: "arrow.clockwise") {
                showLoadingView = true
                PKManager.restorePurchases { _, status, _ in
                    DispatchQueue.main.async {
                        showLoadingView = false
                        if status == .restored { manager.isPremiumUser = true }
                    }
                }
            }
        }.padding([.top, .bottom], 5).background(
            Color("Secondary").cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        ).padding(.bottom, 40)
    }
    
    private var InAppPurchasesPromoBannerView: some View {
        ZStack {
            if manager.isPremiumUser == false {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color("DateColor").opacity(0.7), Color("DateColor")]), startPoint: .topTrailing, endPoint: .bottom)
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Premium Version").bold().font(.system(size: 20))
                            Text("- Unlock trending habits").font(.system(size: 15)).opacity(0.7)
                            Text("- Unlock reminder feature").font(.system(size: 15)).opacity(0.7)
                            Text("- Remove ads").font(.system(size: 15)).opacity(0.7)
                        }
                        Spacer()
                        Image(systemName: "crown.fill").font(.system(size: 45))
                    }.foregroundColor(.white).padding([.leading, .trailing], 20)
                }.frame(height: 110).cornerRadius(15).padding(.bottom, 5)
            }
        }
    }
    
    // MARK: - Habit configurations
    private var HabitConfigView: some View {
        VStack(spacing: 15) {
            ToggleItem(name: "Complete future days", binding: $manager.allowFutureDaysCompletion)
                .padding([.horizontal, .top])
            Color("TextColor").frame(height: 1).opacity(0.2)
            ToggleItem(name: "Complete past days", binding: $manager.allowPastDaysCompletion)
                .padding(.horizontal)
            Color("TextColor").frame(height: 1).opacity(0.2)
            ToggleItem(name: "Completion confetti", binding: $manager.showCompletionConfetti)
                .padding([.horizontal, .bottom])
        }.toggleStyle(SwitchToggleStyle(tint: Color("DateColor"))).background(
            Color("Secondary").cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        ).padding(.bottom, 40)
    }
    
    private func ToggleItem(name: String, binding: Binding<Bool>) -> some View {
        HStack {
            Text(name).font(.system(size: 18))
            Spacer()
            Toggle("", isOn: binding).labelsHidden()
        }.foregroundColor(Color("TextColor"))
    }
    
    // MARK: - Rating and Share
    private var RatingShareView: some View {
        VStack {
            SettingsItem(title: "Rate App", icon: "star") {
                if let scene = UIApplication.shared.windows.first?.windowScene {
                    SKStoreReviewController.requestReview(in: scene)
                }
            }
            Color("TextColor").frame(height: 1).opacity(0.2)
            SettingsItem(title: "Share App", icon: "square.and.arrow.up") {
                let shareController = UIActivityViewController(activityItems: [AppConfig.yourAppURL], applicationActivities: nil)
                rootController?.present(shareController, animated: true, completion: nil)
            }
        }.padding([.top, .bottom], 5).background(
            Color("Secondary").cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        ).padding(.bottom, 40)
    }
    
    // MARK: - Support & Privacy
    private var PrivacySupportView: some View {
        VStack {
            SettingsItem(title: "E-Mail us", icon: "envelope.badge") {
                EmailPresenter.shared.present()
            }
            Color("TextColor").frame(height: 1).opacity(0.2)
            SettingsItem(title: "Privacy Policy", icon: "hand.raised") {
                UIApplication.shared.open(AppConfig.privacyURL, options: [:], completionHandler: nil)
            }
            Color("TextColor").frame(height: 1).opacity(0.2)
            SettingsItem(title: "Terms of Use", icon: "doc.text") {
                UIApplication.shared.open(AppConfig.termsAndConditionsURL, options: [:], completionHandler: nil)
            }
        }.padding([.top, .bottom], 5).background(
            Color("Secondary").cornerRadius(15)
                .shadow(color: Color.black.opacity(0.07), radius: 10)
        )
    }
}

// MARK: - Preview UI
struct SettingsContentView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsContentView().environmentObject(DataManager())
    }
}

// MARK: - Mail presenter for SwiftUI
class EmailPresenter: NSObject, MFMailComposeViewControllerDelegate {
    public static let shared = EmailPresenter()
    private override init() { }
    
    func present() {
        if !MFMailComposeViewController.canSendMail() {
            let alert = UIAlertController(title: "Email Simulator", message: "Email is not supported on the simulator. This will work on a physical device only.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            rootController?.present(alert, animated: true, completion: nil)
            return
        }
        let picker = MFMailComposeViewController()
        picker.setToRecipients([AppConfig.emailSupport])
        picker.mailComposeDelegate = self
        rootController?.present(picker, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        rootController?.dismiss(animated: true, completion: nil)
    }
}

/// Show a loading indicator view
struct LoadingView: View {
    
    @Binding var isLoading: Bool
    
    // MARK: - Main rendering function
    var body: some View {
        ZStack {
            if isLoading {
                Color.black.edgesIgnoringSafeArea(.all).opacity(0.4)
                ProgressView("please wait...")
                    .scaleEffect(1.1, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .foregroundColor(.white).padding()
                    .background(RoundedRectangle(cornerRadius: 10).opacity(0.7))
            }
        }.colorScheme(.light)
    }
}
