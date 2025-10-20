import SwiftUI

/// A provider view that injects a theme into the environment for all child views
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

// MARK: - Convenience View Extension
public extension View {
    /// Apply a theme to this view and all its children
    func theme(_ theme: AppTheme) -> some View {
        ThemeProvider(theme: theme) {
            self
        }
    }
}
