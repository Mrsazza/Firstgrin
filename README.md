# Habit

## Setup
You must run the 'pod install' command first before opening the '.xcworkspace' file with Xcode.
1) Right-click on the project folder
2) Select ‘New Terminal at Folder’ (if you don’t see this option, it may be under Services -> New Terminal at Folder)
3) After the Terminal window has opened, type 'pod install' then hit Enter (wait until everything is complete)
4) Now you can open the '.xcworkspace' file in Xcode

## Code Structure
* Flows - all app screens/flows
* Views - all app views
* Lifecycle - basic app launch files
* DataManager - main data managers

**DashboardContentView** is the main view of the app. This view contains the main home tab details, the list of habits and tab bar at the bottom of the screen to switch between flows.

**StatsContentView** shows the user's habit statistics including weekly performance graph, streaks, completion rate and the best month.

**TrendingHabitsContentView** this view contains the list predefined habits that you can setup in the AppConfig file. This is a premium feature so the user must make an in-app purchase in order to access these habits.

**AddHabitContentView** is where a user can add new habits by providing the name, some inspiration/ motto text, color, icon, reminder notification time, etc.

**AppConfig** is where you'll find useful configurations that you can change if needed.

## Add more trending habits
1) Simply open the AppConfig file and locate the 'TrendingHabits' variable. Edit this by adding a new habit.
2) Whenever you add a new habit, make sure you either add a new icon or use an existing icon. To add a new icon, just drag & drop your .PNG image into the Assets.xcassets, then set the Render As mode to Template, so the icon will support color changes.

Make sure to add the icon name into the AppConfig icons array as well.

## Replace AdMob IDs

1. Open the ‘Info.plist’ file in Xcode. Look for ‘GADApplicationIdentifier’ and replace the existing value with your Google AdMob App ID.
2. Open the ‘AppConfig.swift’ file in Xcode. Look for ‘adMobAdID’ and replace the existing value with your Google AdMob Interstitial Ad ID.

Thank you for your business and feel free to [contact me](https://www.bradbooysen.com/contact) for all your app needs.
Email: hey@bradbooysen.com
