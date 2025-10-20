//
//  PersonalFinanceApp3App.swift
//  PersonalFinanceApp3
//
//  Created by Andrew Evstratov on 17. 10. 2025..
//

import SwiftUI

@main
struct PersonalFinanceApp3App: App {
    @State private var currentTheme: AppTheme = VibrantTheme()
    
    var body: some Scene {
        WindowGroup {
            AppShell()
                .themed(currentTheme)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unified)
        .commands {
            CommandGroup(after: .appSettings) {
                Button("Switch to Vibrant Theme") {
                    currentTheme = VibrantTheme()
                }
                .keyboardShortcut("1", modifiers: [.command, .shift])
                
                Button("Switch to Neutral Theme") {
                    currentTheme = NeutralTheme()
                }
                .keyboardShortcut("2", modifiers: [.command, .shift])
            }
        }
    }
}
