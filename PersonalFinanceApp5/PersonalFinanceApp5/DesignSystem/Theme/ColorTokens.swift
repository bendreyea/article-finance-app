import SwiftUI

/// Color tokens for the design system
public struct ColorTokens {
    // MARK: - Primary Colors
    public let primary: Color
    public let primaryAlt: Color        // Alternate primary for gradients
    public let primaryHover: Color
    public let primaryActive: Color
    
    // MARK: - Background Colors
    public let background: Color
    public let backgroundSecondary: Color
    public let backgroundTertiary: Color
    
    // MARK: - Surface Colors
    public let surface: Color
    public let surfaceElevated: Color
    public let surfaceHover: Color
    
    // MARK: - Text Colors
    public let textPrimary: Color
    public let textSecondary: Color
    public let textTertiary: Color
    public let textInverse: Color
    
    // MARK: - Border Colors
    public let border: Color
    public let borderFocus: Color
    public let borderSubtle: Color
    
    // MARK: - Semantic Colors
    public let success: Color
    public let successBackground: Color
    public let warning: Color
    public let warningBackground: Color
    public let error: Color
    public let errorBackground: Color
    public let info: Color
    public let infoBackground: Color
    
    // MARK: - Chart Colors
    public let chartPrimary: Color
    public let chartSecondary: Color
    public let chartTertiary: Color
    public let chartQuaternary: Color
    public let chartQuinary: Color
    public let chartPalette: [Color]
    
    public init(
        primary: Color,
        primaryAlt: Color,
        primaryHover: Color,
        primaryActive: Color,
        background: Color,
        backgroundSecondary: Color,
        backgroundTertiary: Color,
        surface: Color,
        surfaceElevated: Color,
        surfaceHover: Color,
        textPrimary: Color,
        textSecondary: Color,
        textTertiary: Color,
        textInverse: Color,
        border: Color,
        borderFocus: Color,
        borderSubtle: Color,
        success: Color,
        successBackground: Color,
        warning: Color,
        warningBackground: Color,
        error: Color,
        errorBackground: Color,
        info: Color,
        infoBackground: Color,
        chartPrimary: Color,
        chartSecondary: Color,
        chartTertiary: Color,
        chartQuaternary: Color,
        chartQuinary: Color,
        chartPalette: [Color]
    ) {
        self.primary = primary
        self.primaryAlt = primaryAlt
        self.primaryHover = primaryHover
        self.primaryActive = primaryActive
        self.background = background
        self.backgroundSecondary = backgroundSecondary
        self.backgroundTertiary = backgroundTertiary
        self.surface = surface
        self.surfaceElevated = surfaceElevated
        self.surfaceHover = surfaceHover
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.textInverse = textInverse
        self.border = border
        self.borderFocus = borderFocus
        self.borderSubtle = borderSubtle
        self.success = success
        self.successBackground = successBackground
        self.warning = warning
        self.warningBackground = warningBackground
        self.error = error
        self.errorBackground = errorBackground
        self.info = info
        self.infoBackground = infoBackground
        self.chartPrimary = chartPrimary
        self.chartSecondary = chartSecondary
        self.chartTertiary = chartTertiary
        self.chartQuaternary = chartQuaternary
        self.chartQuinary = chartQuinary
        self.chartPalette = chartPalette
    }
}
