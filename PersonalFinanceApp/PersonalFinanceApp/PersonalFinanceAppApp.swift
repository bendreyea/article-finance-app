//
//  PersonalFinanceAppApp.swift
//  PersonalFinanceApp
//
//  Created by Andrew Evstratov on 30. 9. 2025..
//

import SwiftUI

@main
struct PersonalFinanceAppApp: App {
    var body: some Scene {
        WindowGroup {
            AppShell()
        }
        .windowResizability(.contentSize)
        .windowToolbarStyle(.unified)
    }
}
