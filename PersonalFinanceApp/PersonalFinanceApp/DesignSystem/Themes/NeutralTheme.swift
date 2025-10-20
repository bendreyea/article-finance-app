import SwiftUI

/// Neutral theme implementation with subdued, professional colors
public struct NeutralTheme: AppTheme {
    
    public let name = "Neutral"
    public let isDark = false
    
    public let colors = ColorTokens(
        // Primary Colors - Sophisticated Blue-gray
        primary: Color(red: 0.3, green: 0.4, blue: 0.5),           // #4D6680 - Muted Blue-gray
        primaryVariant: Color(red: 0.25, green: 0.35, blue: 0.45), // #405973 - Darker Blue-gray
        
        // Secondary Colors - Warm Gray
        secondary: Color(red: 0.5, green: 0.45, blue: 0.4),        // #807366 - Warm Gray
        secondaryVariant: Color(red: 0.45, green: 0.4, blue: 0.35), // #736659 - Darker Warm Gray
        
        // Background Colors
        background: Color(red: 0.97, green: 0.97, blue: 0.97),     // #F7F7F7 - Very Light Gray
        surface: Color(red: 0.99, green: 0.99, blue: 0.99),        // #FCFCFC - Off-white
        surfaceVariant: Color(red: 0.94, green: 0.94, blue: 0.94), // #F0F0F0 - Light Gray
        
        // Content Colors
        onPrimary: Color.white,
        onSecondary: Color.white,
        onBackground: Color(red: 0.15, green: 0.15, blue: 0.15),   // #262626 - Dark Gray
        onSurface: Color(red: 0.15, green: 0.15, blue: 0.15),      // #262626 - Dark Gray
        
        // Semantic Colors
        success: Color(red: 0.2, green: 0.6, blue: 0.3),           // #339950 - Muted Green
        warning: Color(red: 0.8, green: 0.5, blue: 0.1),           // #CC8019 - Muted Orange
        error: Color(red: 0.7, green: 0.25, blue: 0.25),           // #B34040 - Muted Red
        info: Color(red: 0.3, green: 0.5, blue: 0.7),              // #4D80B3 - Muted Blue
        
        // Text Colors
        textPrimary: Color(red: 0.15, green: 0.15, blue: 0.15),    // #262626 - Primary Text
        textSecondary: Color(red: 0.45, green: 0.45, blue: 0.45),  // #737373 - Secondary Text
        textTertiary: Color(red: 0.65, green: 0.65, blue: 0.65),   // #A6A6A6 - Tertiary Text
        
        // Border Colors
        border: Color(red: 0.8, green: 0.8, blue: 0.8),            // #CCCCCC - Border
        borderVariant: Color(red: 0.9, green: 0.9, blue: 0.9)      // #E6E6E6 - Light Border
    )
    
    public let spacing = SpacingTokens()
    
    public let radius = RadiusTokens(
        // Slightly more rounded for a softer feel
        button: 6,
        card: 8,
        input: 4,
        badge: 9999,
        modal: 12
    )
    
    public let typography = TypographyTokens()
    
    public let shadows = ShadowCollection(
        none: .none(),
        subtle: .sm(color: .black.opacity(0.06)),
        card: .md(color: .black.opacity(0.08)),
        elevated: .lg(color: .black.opacity(0.1)),
        modal: .xl(color: .black.opacity(0.12)),
        dramatic: .xxl(color: .black.opacity(0.15))
    )
    
    public init() {}
}