import SwiftUI

// MARK: - Theme Environment Key

/// Environment key for theme injection
private struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppTheme = VibrantTheme()
}

extension EnvironmentValues {
    /// Access the current theme from the environment
    public var theme: AppTheme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Theme Provider View

/// View that injects a theme into the environment
public struct ThemeProvider<Content: View>: View {
    private let theme: AppTheme
    private let content: Content
    
    /// Creates a theme provider that injects the specified theme into the environment
    /// - Parameters:
    ///   - theme: The theme to inject
    ///   - content: The content view that will receive the theme
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
    /// Applies a theme to this view and all its descendants
    /// - Parameter theme: The theme to apply
    /// - Returns: A view with the theme injected into the environment
    public func themed(_ theme: AppTheme) -> some View {
        ThemeProvider(theme: theme) {
            self
        }
    }
}
