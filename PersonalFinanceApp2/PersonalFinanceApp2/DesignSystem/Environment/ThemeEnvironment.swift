import SwiftUI

// MARK: - Environment Key
private struct ThemeKey: EnvironmentKey {
    static let defaultValue: AppTheme = NeutralTheme()
}

// MARK: - Environment Values Extension
public extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
