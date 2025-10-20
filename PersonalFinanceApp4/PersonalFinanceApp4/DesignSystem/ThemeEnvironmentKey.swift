//
//  ThemeEnvironmentKey.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// Environment key for accessing the current theme.
private struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppTheme = VibrantTheme()
}

extension EnvironmentValues {
    /// The current theme from the environment.
    /// Access this in any view with: @Environment(\.theme)
    public var theme: AppTheme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

extension View {
    /// Sets the theme for this view and all its descendants.
    ///
    /// Example usage:
    /// ```swift
    /// ContentView()
    ///     .withTheme(VibrantTheme())
    /// ```
    public func withTheme(_ theme: AppTheme) -> some View {
        self.environment(\.theme, theme)
    }
}
