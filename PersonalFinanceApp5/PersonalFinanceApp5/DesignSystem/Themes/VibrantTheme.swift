import SwiftUI

/// A vibrant, energetic theme with bold colors ideal for modern financial dashboards
public struct VibrantTheme: AppTheme {
    public let name = "Vibrant"
    
    public let colors: ColorTokens
    public let spacing: SpacingTokens
    public let radius: RadiusTokens
    public let typography: TypographyTokens
    public let shadows: ShadowTokens
    
    public init() {
        // MARK: - Vibrant Color Palette
        self.colors = ColorTokens(
            // Primary - Electric Blue
            primary: Color(red: 0.25, green: 0.47, blue: 1.0),           // #4078FF
            primaryAlt: Color(red: 0.4, green: 0.6, blue: 1.0),          // #6699FF (Lighter for gradient)
            primaryHover: Color(red: 0.2, green: 0.42, blue: 0.95),      // #336BF2
            primaryActive: Color(red: 0.15, green: 0.37, blue: 0.85),    // #265ED9
            
            // Backgrounds
            background: Color(red: 0.97, green: 0.97, blue: 0.98),       // #F7F7FA
            backgroundSecondary: Color(red: 0.95, green: 0.95, blue: 0.97), // #F2F2F7
            backgroundTertiary: Color(red: 0.92, green: 0.92, blue: 0.95),  // #EBEBF2
            
            // Surfaces
            surface: Color.white,
            surfaceElevated: Color.white,
            surfaceHover: Color(red: 0.98, green: 0.98, blue: 0.99),     // #FAFAFC
            
            // Text
            textPrimary: Color(red: 0.12, green: 0.12, blue: 0.14),      // #1F1F23
            textSecondary: Color(red: 0.38, green: 0.38, blue: 0.42),    // #61616B
            textTertiary: Color(red: 0.58, green: 0.58, blue: 0.62),     // #94949E
            textInverse: Color.white,
            
            // Borders
            border: Color(red: 0.88, green: 0.88, blue: 0.91),           // #E0E0E8
            borderFocus: Color(red: 0.25, green: 0.47, blue: 1.0),       // #4078FF
            borderSubtle: Color(red: 0.93, green: 0.93, blue: 0.95),     // #EDEDF2
            
            // Semantic Colors
            success: Color(red: 0.2, green: 0.78, blue: 0.35),           // #34C759
            successBackground: Color(red: 0.9, green: 0.98, blue: 0.92), // #E6F9EC
            warning: Color(red: 1.0, green: 0.62, blue: 0.04),           // #FF9E0A
            warningBackground: Color(red: 1.0, green: 0.95, blue: 0.88), // #FFF3E0
            error: Color(red: 1.0, green: 0.27, blue: 0.23),             // #FF453A
            errorBackground: Color(red: 1.0, green: 0.92, blue: 0.92),   // #FFEBEB
            info: Color(red: 0.0, green: 0.48, blue: 1.0),               // #007AFF
            infoBackground: Color(red: 0.9, green: 0.95, blue: 1.0),     // #E5F2FF
            
            // Chart Colors - Vibrant and Distinct
            chartPrimary: Color(red: 0.25, green: 0.47, blue: 1.0),      // Electric Blue
            chartSecondary: Color(red: 0.69, green: 0.32, blue: 0.87),   // Purple
            chartTertiary: Color(red: 0.2, green: 0.78, blue: 0.35),     // Green
            chartQuaternary: Color(red: 1.0, green: 0.62, blue: 0.04),   // Orange
            chartQuinary: Color(red: 1.0, green: 0.27, blue: 0.58),      // Pink
            chartPalette: [
                Color(red: 0.25, green: 0.47, blue: 1.0),                // Electric Blue
                Color(red: 0.2, green: 0.78, blue: 0.35),                // Green
                Color(red: 1.0, green: 0.62, blue: 0.04),                // Orange
                Color(red: 0.69, green: 0.32, blue: 0.87),               // Purple
                Color(red: 1.0, green: 0.27, blue: 0.58),                // Pink
                Color(red: 0.0, green: 0.48, blue: 1.0),                 // Info Blue
                Color(red: 1.0, green: 0.27, blue: 0.23)                 // Red
            ]
        )
        
        // MARK: - Spacing (Standard)
        self.spacing = SpacingTokens()
        
        // MARK: - Radius (Moderate Roundness)
        self.radius = RadiusTokens(
            none: 0,
            sm: 6,
            md: 10,
            lg: 14,
            xl: 18,
            full: 9999
        )
        
        // MARK: - Typography (Default Scale)
        self.typography = .defaultScale
        
        // MARK: - Shadows (Prominent)
        self.shadows = ShadowTokens(
            none: ShadowToken(
                color: .clear,
                radius: 0
            ),
            sm: ShadowToken(
                color: Color.black.opacity(0.08),
                radius: 4,
                x: 0,
                y: 2
            ),
            md: ShadowToken(
                color: Color.black.opacity(0.1),
                radius: 8,
                x: 0,
                y: 4
            ),
            lg: ShadowToken(
                color: Color.black.opacity(0.12),
                radius: 16,
                x: 0,
                y: 8
            ),
            xl: ShadowToken(
                color: Color.black.opacity(0.15),
                radius: 24,
                x: 0,
                y: 12
            )
        )
    }
}
