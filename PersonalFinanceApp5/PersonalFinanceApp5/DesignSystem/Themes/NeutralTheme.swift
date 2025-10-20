import SwiftUI

/// A neutral, professional theme with subtle colors ideal for conservative financial interfaces
public struct NeutralTheme: AppTheme {
    public let name = "Neutral"
    
    public let colors: ColorTokens
    public let spacing: SpacingTokens
    public let radius: RadiusTokens
    public let typography: TypographyTokens
    public let shadows: ShadowTokens
    
    public init() {
        // MARK: - Neutral Color Palette
        self.colors = ColorTokens(
            // Primary - Slate Blue
            primary: Color(red: 0.39, green: 0.47, blue: 0.62),          // #64779E
            primaryAlt: Color(red: 0.5, green: 0.58, blue: 0.72),        // #8094B8 (Lighter for gradient)
            primaryHover: Color(red: 0.34, green: 0.42, blue: 0.57),     // #576B91
            primaryActive: Color(red: 0.29, green: 0.37, blue: 0.52),    // #4A5F84
            
            // Backgrounds
            background: Color(red: 0.98, green: 0.98, blue: 0.99),       // #FAFBFC
            backgroundSecondary: Color(red: 0.96, green: 0.97, blue: 0.98), // #F5F6F8
            backgroundTertiary: Color(red: 0.94, green: 0.95, blue: 0.96),  // #F0F2F5
            
            // Surfaces
            surface: Color.white,
            surfaceElevated: Color.white,
            surfaceHover: Color(red: 0.99, green: 0.99, blue: 0.99),     // #FCFCFD
            
            // Text
            textPrimary: Color(red: 0.15, green: 0.17, blue: 0.20),      // #262B33
            textSecondary: Color(red: 0.42, green: 0.45, blue: 0.50),    // #6B7380
            textTertiary: Color(red: 0.62, green: 0.65, blue: 0.70),     // #9EA5B3
            textInverse: Color.white,
            
            // Borders
            border: Color(red: 0.88, green: 0.90, blue: 0.92),           // #E1E5EB
            borderFocus: Color(red: 0.39, green: 0.47, blue: 0.62),      // #64779E
            borderSubtle: Color(red: 0.93, green: 0.94, blue: 0.96),     // #EDF0F3
            
            // Semantic Colors
            success: Color(red: 0.28, green: 0.65, blue: 0.42),          // #47A66B
            successBackground: Color(red: 0.93, green: 0.97, blue: 0.94), // #EDF8F1
            warning: Color(red: 0.91, green: 0.62, blue: 0.18),          // #E89E2E
            warningBackground: Color(red: 0.99, green: 0.97, blue: 0.93), // #FDF8ED
            error: Color(red: 0.85, green: 0.33, blue: 0.31),            // #D9544F
            errorBackground: Color(red: 0.98, green: 0.94, blue: 0.94),  // #FAF0F0
            info: Color(red: 0.27, green: 0.56, blue: 0.85),             // #458FD9
            infoBackground: Color(red: 0.93, green: 0.96, blue: 0.99),   // #EDF5FC
            
            // Chart Colors - Muted and Professional
            chartPrimary: Color(red: 0.39, green: 0.47, blue: 0.62),     // Slate Blue
            chartSecondary: Color(red: 0.55, green: 0.62, blue: 0.73),   // Light Slate
            chartTertiary: Color(red: 0.28, green: 0.65, blue: 0.42),    // Muted Green
            chartQuaternary: Color(red: 0.91, green: 0.62, blue: 0.18),  // Muted Orange
            chartQuinary: Color(red: 0.70, green: 0.45, blue: 0.68),     // Muted Mauve
            chartPalette: [
                Color(red: 0.39, green: 0.47, blue: 0.62),               // Slate Blue
                Color(red: 0.28, green: 0.65, blue: 0.42),               // Muted Green
                Color(red: 0.91, green: 0.62, blue: 0.18),               // Muted Orange
                Color(red: 0.55, green: 0.62, blue: 0.73),               // Light Slate
                Color(red: 0.70, green: 0.45, blue: 0.68),               // Muted Mauve
                Color(red: 0.27, green: 0.56, blue: 0.85),               // Info Blue
                Color(red: 0.85, green: 0.33, blue: 0.31)                // Muted Red
            ]
        )
        
        // MARK: - Spacing (Standard)
        self.spacing = SpacingTokens()
        
        // MARK: - Radius (Subtle Roundness)
        self.radius = RadiusTokens(
            none: 0,
            sm: 4,
            md: 6,
            lg: 8,
            xl: 12,
            full: 9999
        )
        
        // MARK: - Typography (Default Scale)
        self.typography = .defaultScale
        
        // MARK: - Shadows (Subtle)
        self.shadows = ShadowTokens(
            none: ShadowToken(
                color: .clear,
                radius: 0
            ),
            sm: ShadowToken(
                color: Color.black.opacity(0.04),
                radius: 3,
                x: 0,
                y: 1
            ),
            md: ShadowToken(
                color: Color.black.opacity(0.06),
                radius: 6,
                x: 0,
                y: 3
            ),
            lg: ShadowToken(
                color: Color.black.opacity(0.08),
                radius: 12,
                x: 0,
                y: 6
            ),
            xl: ShadowToken(
                color: Color.black.opacity(0.10),
                radius: 20,
                x: 0,
                y: 10
            )
        )
    }
}
