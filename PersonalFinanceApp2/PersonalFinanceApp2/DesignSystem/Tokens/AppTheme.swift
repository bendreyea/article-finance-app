import SwiftUI

/// The main theme protocol that defines the design system interface
public protocol AppTheme {
    var colors: ColorTokens { get }
    var spacing: SpacingTokens { get }
    var radius: RadiusTokens { get }
    var typography: TypographyTokens { get }
    var shadows: ShadowTokens { get }
    
    /// A human-readable name for the theme
    var name: String { get }
}
