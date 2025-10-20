//
//  ThemeProvider.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// A container view that provides a theme to its content hierarchy.
/// Use this at the root of your app to enable theme switching.
///
/// Example usage:
/// ```swift
/// @main
/// struct MyApp: App {
///     @State private var currentTheme: AppTheme = VibrantTheme()
///
///     var body: some Scene {
///         WindowGroup {
///             ThemeProvider(theme: currentTheme) {
///                 ContentView()
///             }
///         }
///     }
/// }
/// ```
public struct ThemeProvider<Content: View>: View {
    private let theme: AppTheme
    private let content: Content
    
    public init(theme: AppTheme, @ViewBuilder content: () -> Content) {
        self.theme = theme
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.theme, theme)
            .background(theme.colors.background)
    }
}

// MARK: - Preview Helpers

extension ThemeProvider {
    /// Create a theme provider with Vibrant theme for previews.
    public static func vibrant(@ViewBuilder content: () -> Content) -> some View {
        ThemeProvider(theme: VibrantTheme(), content: content)
    }
    
    /// Create a theme provider with Neutral theme for previews.
    public static func neutral(@ViewBuilder content: () -> Content) -> some View {
        ThemeProvider(theme: NeutralTheme(), content: content)
    }
}
