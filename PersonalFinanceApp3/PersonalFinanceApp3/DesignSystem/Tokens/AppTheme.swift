import Foundation

/// Protocol defining a complete application theme
public protocol AppTheme {
    var name: String { get }
    var colors: ColorTokens { get }
    var spacing: SpacingTokens { get }
    var radius: RadiusTokens { get }
    var typography: TypographyTokens { get }
    var shadow: ShadowTokens { get }
}
