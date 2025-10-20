import SwiftUI

/// Vibrant theme with bold colors and high contrast
public struct VibrantTheme: AppTheme {
    public let name = "Vibrant"
    
    public let colors = ColorTokens(
        // Backgrounds
        background: Color(red: 0.95, green: 0.96, blue: 0.98),
        backgroundSecondary: Color(red: 0.98, green: 0.98, blue: 0.99),
        backgroundTertiary: Color(red: 0.92, green: 0.94, blue: 0.96),
        
        // Surfaces
        surface: Color.white,
        surfaceElevated: Color.white,
        
        // Text
        textPrimary: Color(red: 0.12, green: 0.14, blue: 0.18),
        textSecondary: Color(red: 0.45, green: 0.48, blue: 0.52),
        textTertiary: Color(red: 0.65, green: 0.68, blue: 0.72),
        textInverse: Color.white,
        
        // Borders
        border: Color(red: 0.85, green: 0.87, blue: 0.90),
        borderSubtle: Color(red: 0.92, green: 0.93, blue: 0.95),
        
        // Accents
        accentPrimary: Color(red: 0.20, green: 0.51, blue: 0.98),  // Bright blue
        accentSecondary: Color(red: 0.56, green: 0.27, blue: 0.98), // Purple
        
        // Semantic
        success: Color(red: 0.13, green: 0.77, blue: 0.45),
        warning: Color(red: 0.98, green: 0.65, blue: 0.10),
        error: Color(red: 0.96, green: 0.26, blue: 0.26),
        info: Color(red: 0.20, green: 0.67, blue: 0.98),
        
        // Charts
        chartPrimary: [
            Color(red: 0.20, green: 0.51, blue: 0.98),
            Color(red: 0.56, green: 0.27, blue: 0.98),
            Color(red: 0.98, green: 0.26, blue: 0.57),
            Color(red: 0.98, green: 0.65, blue: 0.10),
            Color(red: 0.13, green: 0.77, blue: 0.45)
        ],
        chartSecondary: [
            Color(red: 0.40, green: 0.63, blue: 0.99),
            Color(red: 0.70, green: 0.50, blue: 0.99),
            Color(red: 0.99, green: 0.50, blue: 0.71),
            Color(red: 0.99, green: 0.78, blue: 0.40),
            Color(red: 0.40, green: 0.85, blue: 0.64)
        ]
    )
    
    public let spacing = SpacingTokens()
    public let radius = RadiusTokens(sm: 6, md: 10, lg: 14, xl: 18)
    public let typography = TypographyTokens()
    public let shadow = ShadowTokens(
        sm: ShadowStyle(color: Color.black.opacity(0.08), radius: 3, x: 0, y: 2),
        md: ShadowStyle(color: Color.black.opacity(0.12), radius: 6, x: 0, y: 3),
        lg: ShadowStyle(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5),
        xl: ShadowStyle(color: Color.black.opacity(0.18), radius: 20, x: 0, y: 10)
    )
    
    public init() {}
}
