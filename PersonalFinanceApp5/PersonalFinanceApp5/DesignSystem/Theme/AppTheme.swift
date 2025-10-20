import Foundation

/// Core protocol that defines a complete design system theme
public protocol AppTheme {
    var name: String { get }
    var colors: ColorTokens { get }
    var spacing: SpacingTokens { get }
    var radius: RadiusTokens { get }
    var typography: TypographyTokens { get }
    var shadows: ShadowTokens { get }
}
