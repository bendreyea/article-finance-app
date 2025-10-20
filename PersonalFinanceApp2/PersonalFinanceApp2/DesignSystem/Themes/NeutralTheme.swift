import SwiftUI

/// A neutral theme with subtle colors and gentle contrasts for a professional feel
public struct NeutralTheme: AppTheme {
    public let name = "Neutral"
    
    public let colors = ColorTokens(
        // MARK: - Surface Colors
        backgroundPrimary: Color(red: 0.98, green: 0.98, blue: 0.99),     // Almost white
        backgroundSecondary: Color(red: 0.95, green: 0.95, blue: 0.96),   // Very light gray
        backgroundTertiary: Color(red: 0.92, green: 0.92, blue: 0.94),    // Light gray
        surface: Color.white,                                              // Pure white cards
        surfaceElevated: Color.white,                                      // Elevated surfaces
        
        // MARK: - Content Colors
        textPrimary: Color(red: 0.1, green: 0.1, blue: 0.12),
        textSecondary: Color(red: 0.4, green: 0.4, blue: 0.45),
        textTertiary: Color(red: 0.6, green: 0.6, blue: 0.65),
        textInverse: Color.white,
        
        // MARK: - Brand Colors
        brandPrimary: Color(red: 0.2, green: 0.4, blue: 0.8),            // Classic blue
        brandSecondary: Color(red: 0.3, green: 0.5, blue: 0.9),          // Lighter blue
        brandTertiary: Color(red: 0.5, green: 0.6, blue: 0.95),          // Very light blue
        
        // MARK: - Semantic Colors
        success: Color(red: 0.1, green: 0.7, blue: 0.3),                 // Forest green
        warning: Color(red: 0.9, green: 0.5, blue: 0.1),                 // Amber
        error: Color(red: 0.8, green: 0.2, blue: 0.2),                   // Red
        info: Color(red: 0.2, green: 0.6, blue: 0.9),                    // Blue
        
        // MARK: - Interactive Colors
        interactive: Color(red: 0.2, green: 0.4, blue: 0.8),             // Same as brand primary
        interactiveHover: Color(red: 0.25, green: 0.45, blue: 0.85),
        interactiveActive: Color(red: 0.15, green: 0.35, blue: 0.75),
        interactiveDisabled: Color(red: 0.7, green: 0.7, blue: 0.75),
        
        // MARK: - Border Colors
        border: Color(red: 0.85, green: 0.85, blue: 0.87),
        borderSubtle: Color(red: 0.9, green: 0.9, blue: 0.92),
        borderStrong: Color(red: 0.7, green: 0.7, blue: 0.75)
    )
    
    public let spacing = SpacingTokens()
    
    public let radius = RadiusTokens(
        card: 8,       // Subtle rounding
        button: 6,     // Gentle button rounding
        input: 4,
        badge: 999
    )
    
    public let typography = TypographyTokens()
    
    public let shadows = ShadowTokens(
        // Subtle shadows for gentle elevation
        card: ShadowDefinition(color: .black.opacity(0.05), radius: 4, x: 0, y: 2),
        button: ShadowDefinition(color: .black.opacity(0.08), radius: 2, x: 0, y: 1),
        modal: ShadowDefinition(color: .black.opacity(0.15), radius: 16, x: 0, y: 8),
        dropdown: ShadowDefinition(color: .black.opacity(0.1), radius: 6, x: 0, y: 2)
    )
    
    public init() {}
}
