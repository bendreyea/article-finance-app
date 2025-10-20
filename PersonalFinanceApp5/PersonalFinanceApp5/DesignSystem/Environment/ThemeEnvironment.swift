import SwiftUI

// MARK: - Environment Key
private struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppTheme = VibrantTheme()
}

// MARK: - Environment Values Extension
extension EnvironmentValues {
    /// The current theme from the environment
    public var theme: AppTheme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Theme Provider View
/// A view that injects a theme into the SwiftUI environment
///
/// Usage:
/// ```swift
/// ThemeProvider(theme: VibrantTheme()) {
///     ContentView()
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
    }
}

// MARK: - View Extension for Theme Access
extension View {
    /// Applies a theme to this view and its descendants
    public func theme(_ theme: AppTheme) -> some View {
        environment(\.theme, theme)
    }
}
