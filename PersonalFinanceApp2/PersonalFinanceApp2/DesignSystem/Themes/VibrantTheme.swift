import SwiftUI

/// A vibrant theme with bold colors and high contrast for an energetic feel
public struct VibrantTheme: AppTheme {
    public let name = "Vibrant"
    
    public let colors = ColorTokens(
        // MARK: - Surface Colors
        backgroundPrimary: Color(red: 0.05, green: 0.05, blue: 0.1),      // Deep navy
        backgroundSecondary: Color(red: 0.08, green: 0.08, blue: 0.14),   // Slightly lighter navy
        backgroundTertiary: Color(red: 0.12, green: 0.12, blue: 0.18),    // Medium navy
        surface: Color(red: 0.15, green: 0.15, blue: 0.22),              // Card background
        surfaceElevated: Color(red: 0.18, green: 0.18, blue: 0.26),      // Elevated surface
        
        // MARK: - Content Colors
        textPrimary: Color.white,
        textSecondary: Color(red: 0.8, green: 0.8, blue: 0.9),
        textTertiary: Color(red: 0.6, green: 0.6, blue: 0.75),
        textInverse: Color(red: 0.1, green: 0.1, blue: 0.2),
        
        // MARK: - Brand Colors
        brandPrimary: Color(red: 0.0, green: 0.7, blue: 1.0),            // Vibrant cyan
        brandSecondary: Color(red: 0.5, green: 0.2, blue: 1.0),          // Electric purple
        brandTertiary: Color(red: 1.0, green: 0.3, blue: 0.6),           // Hot pink
        
        // MARK: - Semantic Colors
        success: Color(red: 0.0, green: 0.9, blue: 0.4),                 // Bright green
        warning: Color(red: 1.0, green: 0.6, blue: 0.0),                 // Orange
        error: Color(red: 1.0, green: 0.2, blue: 0.4),                   // Bright red
        info: Color(red: 0.2, green: 0.8, blue: 1.0),                    // Light blue
        
        // MARK: - Interactive Colors
        interactive: Color(red: 0.0, green: 0.7, blue: 1.0),             // Same as brand primary
        interactiveHover: Color(red: 0.2, green: 0.75, blue: 1.0),
        interactiveActive: Color(red: 0.0, green: 0.6, blue: 0.9),
        interactiveDisabled: Color(red: 0.3, green: 0.3, blue: 0.4),
        
        // MARK: - Border Colors
        border: Color(red: 0.25, green: 0.25, blue: 0.35),
        borderSubtle: Color(red: 0.2, green: 0.2, blue: 0.3),
        borderStrong: Color(red: 0.4, green: 0.4, blue: 0.5)
    )
    
    public let spacing = SpacingTokens()
    
    public let radius = RadiusTokens(
        card: 16,      // More rounded for vibrant feel
        button: 12,    // Rounder buttons
        input: 8,
        badge: 999
    )
    
    public let typography = TypographyTokens()
    
    public let shadows = ShadowTokens(
        // More pronounced shadows for depth
        card: ShadowDefinition(color: .black.opacity(0.15), radius: 8, x: 0, y: 3),
        button: ShadowDefinition(color: .black.opacity(0.2), radius: 4, x: 0, y: 2),
        modal: ShadowDefinition(color: .black.opacity(0.3), radius: 24, x: 0, y: 12),
        dropdown: ShadowDefinition(color: .black.opacity(0.18), radius: 8, x: 0, y: 3)
    )
    
    public init() {}
}
