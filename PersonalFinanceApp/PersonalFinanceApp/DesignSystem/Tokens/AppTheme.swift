import SwiftUI

/// Protocol defining the complete theme interface for the application
public protocol AppTheme {
    // MARK: - Token Collections
    var colors: ColorTokens { get }
    var spacing: SpacingTokens { get }
    var radius: RadiusTokens { get }
    var typography: TypographyTokens { get }
    var shadows: ShadowCollection { get }
    
    // MARK: - Theme Metadata
    var name: String { get }
    var isDark: Bool { get }
}