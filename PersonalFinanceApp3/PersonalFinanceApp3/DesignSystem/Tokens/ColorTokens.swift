import SwiftUI

/// Design system color tokens
public struct ColorTokens {
    // MARK: - Background Colors
    public let background: Color
    public let backgroundSecondary: Color
    public let backgroundTertiary: Color
    
    // MARK: - Surface Colors
    public let surface: Color
    public let surfaceElevated: Color
    
    // MARK: - Text Colors
    public let textPrimary: Color
    public let textSecondary: Color
    public let textTertiary: Color
    public let textInverse: Color
    
    // MARK: - Border Colors
    public let border: Color
    public let borderSubtle: Color
    
    // MARK: - Accent Colors
    public let accentPrimary: Color
    public let accentSecondary: Color
    
    // MARK: - Semantic Colors
    public let success: Color
    public let warning: Color
    public let error: Color
    public let info: Color
    
    // MARK: - Chart Colors
    public let chartPrimary: [Color]
    public let chartSecondary: [Color]
    
    public init(
        background: Color,
        backgroundSecondary: Color,
        backgroundTertiary: Color,
        surface: Color,
        surfaceElevated: Color,
        textPrimary: Color,
        textSecondary: Color,
        textTertiary: Color,
        textInverse: Color,
        border: Color,
        borderSubtle: Color,
        accentPrimary: Color,
        accentSecondary: Color,
        success: Color,
        warning: Color,
        error: Color,
        info: Color,
        chartPrimary: [Color],
        chartSecondary: [Color]
    ) {
        self.background = background
        self.backgroundSecondary = backgroundSecondary
        self.backgroundTertiary = backgroundTertiary
        self.surface = surface
        self.surfaceElevated = surfaceElevated
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.textInverse = textInverse
        self.border = border
        self.borderSubtle = borderSubtle
        self.accentPrimary = accentPrimary
        self.accentSecondary = accentSecondary
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
        self.chartPrimary = chartPrimary
        self.chartSecondary = chartSecondary
    }
}
