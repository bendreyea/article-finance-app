import SwiftUI

/// Neutral theme with subtle colors and refined aesthetics
public struct NeutralTheme: AppTheme {
    public let name = "Neutral"
    
    public let colors = ColorTokens(
        // Backgrounds
        background: Color(red: 0.97, green: 0.97, blue: 0.98),
        backgroundSecondary: Color(red: 0.99, green: 0.99, blue: 0.99),
        backgroundTertiary: Color(red: 0.94, green: 0.95, blue: 0.96),
        
        // Surfaces
        surface: Color(red: 0.99, green: 0.99, blue: 1.00),
        surfaceElevated: Color.white,
        
        // Text
        textPrimary: Color(red: 0.18, green: 0.20, blue: 0.24),
        textSecondary: Color(red: 0.52, green: 0.55, blue: 0.60),
        textTertiary: Color(red: 0.70, green: 0.73, blue: 0.78),
        textInverse: Color.white,
        
        // Borders
        border: Color(red: 0.88, green: 0.90, blue: 0.92),
        borderSubtle: Color(red: 0.94, green: 0.95, blue: 0.96),
        
        // Accents
        accentPrimary: Color(red: 0.28, green: 0.38, blue: 0.52),  // Slate blue
        accentSecondary: Color(red: 0.45, green: 0.52, blue: 0.62), // Muted blue-gray
        
        // Semantic
        success: Color(red: 0.22, green: 0.66, blue: 0.48),
        warning: Color(red: 0.85, green: 0.58, blue: 0.18),
        error: Color(red: 0.82, green: 0.32, blue: 0.32),
        info: Color(red: 0.35, green: 0.58, blue: 0.78),
        
        // Charts
        chartPrimary: [
            Color(red: 0.28, green: 0.38, blue: 0.52),
            Color(red: 0.52, green: 0.60, blue: 0.70),
            Color(red: 0.70, green: 0.75, blue: 0.82),
            Color(red: 0.45, green: 0.52, blue: 0.62),
            Color(red: 0.35, green: 0.45, blue: 0.58)
        ],
        chartSecondary: [
            Color(red: 0.48, green: 0.56, blue: 0.68),
            Color(red: 0.68, green: 0.74, blue: 0.82),
            Color(red: 0.82, green: 0.86, blue: 0.90),
            Color(red: 0.62, green: 0.68, blue: 0.76),
            Color(red: 0.55, green: 0.62, blue: 0.72)
        ]
    )
    
    public let spacing = SpacingTokens()
    public let radius = RadiusTokens(sm: 4, md: 8, lg: 12, xl: 16)
    public let typography = TypographyTokens(
        displayLarge: .system(size: 48, weight: .semibold),
        displayMedium: .system(size: 36, weight: .semibold),
        displaySmall: .system(size: 28, weight: .medium)
    )
    public let shadow = ShadowTokens(
        sm: ShadowStyle(color: Color.black.opacity(0.04), radius: 2, x: 0, y: 1),
        md: ShadowStyle(color: Color.black.opacity(0.06), radius: 4, x: 0, y: 2),
        lg: ShadowStyle(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 4),
        xl: ShadowStyle(color: Color.black.opacity(0.10), radius: 16, x: 0, y: 8)
    )
    
    public init() {}
}
