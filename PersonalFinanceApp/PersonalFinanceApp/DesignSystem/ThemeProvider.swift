import SwiftUI

// MARK: - Theme Environment Key
private struct ThemeEnvironmentKey: EnvironmentKey {
    static let defaultValue: AppTheme = VibrantTheme()
}

// MARK: - Environment Values Extension
extension EnvironmentValues {
    public var theme: AppTheme {
        get { self[ThemeEnvironmentKey.self] }
        set { self[ThemeEnvironmentKey.self] = newValue }
    }
}

// MARK: - Theme Provider View
/// A view that provides theme context to its child views through the SwiftUI environment
public struct ThemeProvider<Content: View>: View {
    private let theme: AppTheme
    private let content: Content
    
    /// Creates a ThemeProvider with the specified theme
    /// - Parameters:
    ///   - theme: The theme to provide to child views
    ///   - content: The child views that will have access to the theme
    public init(
        theme: AppTheme,
        @ViewBuilder content: () -> Content
    ) {
        self.theme = theme
        self.content = content()
    }
    
    public var body: some View {
        content
            .environment(\.theme, theme)
    }
}

// MARK: - Convenience View Modifier
extension View {
    /// Applies a theme to this view and its descendants
    /// - Parameter theme: The theme to apply
    /// - Returns: A view with the specified theme in its environment
    public func theme(_ theme: AppTheme) -> some View {
        ThemeProvider(theme: theme) {
            self
        }
    }
}

// MARK: - Theme Manager (Optional Utility)
/// A simple theme manager for switching between themes
@Observable
public class ThemeManager {
    public var currentTheme: AppTheme
    
    public init(theme: AppTheme = VibrantTheme()) {
        self.currentTheme = theme
    }
    
    public func setTheme(_ theme: AppTheme) {
        currentTheme = theme
    }
}