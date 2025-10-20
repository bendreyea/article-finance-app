//
//  PersonalFinanceApp2App.swift
//  PersonalFinanceApp2
//
//  Created by Andrew Evstratov on 5. 10. 2025..
//

import SwiftUI

@main
struct PersonalFinanceApp2App: App {
    // Theme selection - can be changed to VibrantTheme() or user preference
    @State private var currentTheme: AppTheme = NeutralTheme()
    
    var body: some Scene {
        WindowGroup {
            AppShell()
                .theme(currentTheme)
                .frame(minWidth: 1000, minHeight: 700)
        }
        .defaultSize(width: 1400, height: 900)
        .commands {
            // Add menu commands for theme switching
            CommandGroup(after: .appSettings) {
                Menu("Theme") {
                    Button("Neutral Theme") {
                        currentTheme = NeutralTheme()
                    }
                    
                    Button("Vibrant Theme") {
                        currentTheme = VibrantTheme()
                    }
                }
            }
        }
    }
}
