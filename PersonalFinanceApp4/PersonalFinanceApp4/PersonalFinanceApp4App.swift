//
//  PersonalFinanceApp4App.swift
//  PersonalFinanceApp4
//
//  Created by Andrew Evstratov on 17. 10. 2025..
//

import SwiftUI

@main
struct PersonalFinanceApp4App: App {
    // Choose theme: VibrantTheme() or NeutralTheme()
    @State private var currentTheme: AppTheme = VibrantTheme()
    
    var body: some Scene {
        WindowGroup {
            ThemeProvider(theme: currentTheme) {
                AppShell()
            }
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 1400, height: 900)
    }
}
