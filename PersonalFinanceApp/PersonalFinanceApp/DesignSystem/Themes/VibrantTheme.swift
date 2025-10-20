import SwiftUI

/// Vibrant theme implementation with energetic colors suitable for a finance app
public struct VibrantTheme: AppTheme {
    
    public let name = "Vibrant"
    public let isDark = false
    
    public let colors = ColorTokens(
        // Primary Colors - Financial Green with Energy
        primary: Color(red: 0.0, green: 0.7, blue: 0.4),           // #00B366 - Vibrant Green
        primaryVariant: Color(red: 0.0, green: 0.6, blue: 0.35),   // #009959 - Darker Green
        
        // Secondary Colors - Complementary Blue
        secondary: Color(red: 0.2, green: 0.4, blue: 0.9),         // #3366E6 - Vibrant Blue
        secondaryVariant: Color(red: 0.15, green: 0.35, blue: 0.8), // #2659CC - Darker Blue
        
        // Background Colors
        background: Color(red: 0.98, green: 0.99, blue: 1.0),      // #FAFCFF - Very Light Blue-tinted White
        surface: Color.white,                                        // #FFFFFF - Pure White
        surfaceVariant: Color(red: 0.95, green: 0.97, blue: 0.99), // #F2F7FC - Light Blue-gray
        
        // Content Colors
        onPrimary: Color.white,
        onSecondary: Color.white,
        onBackground: Color(red: 0.1, green: 0.1, blue: 0.1),      // #1A1A1A - Very Dark Gray
        onSurface: Color(red: 0.1, green: 0.1, blue: 0.1),         // #1A1A1A - Very Dark Gray
        
        // Semantic Colors
        success: Color(red: 0.0, green: 0.75, blue: 0.3),          // #00BF4D - Success Green
        warning: Color(red: 1.0, green: 0.6, blue: 0.0),           // #FF9900 - Warning Orange
        error: Color(red: 0.9, green: 0.2, blue: 0.2),             // #E63333 - Error Red
        info: Color(red: 0.2, green: 0.6, blue: 0.9),              // #3399E6 - Info Blue
        
        // Text Colors
        textPrimary: Color(red: 0.1, green: 0.1, blue: 0.1),       // #1A1A1A - Primary Text
        textSecondary: Color(red: 0.4, green: 0.4, blue: 0.4),     // #666666 - Secondary Text
        textTertiary: Color(red: 0.6, green: 0.6, blue: 0.6),      // #999999 - Tertiary Text
        
        // Border Colors
        border: Color(red: 0.85, green: 0.85, blue: 0.85),         // #D9D9D9 - Light Border
        borderVariant: Color(red: 0.9, green: 0.9, blue: 0.9)      // #E6E6E6 - Very Light Border
    )
    
    public let spacing = SpacingTokens()
    
    public let radius = RadiusTokens()
    
    public let typography = TypographyTokens()
    
    public let shadows = ShadowCollection(
        none: .none(),
        subtle: .sm(color: .black.opacity(0.08)),
        card: .md(color: .black.opacity(0.12)),
        elevated: .lg(color: .black.opacity(0.15)),
        modal: .xl(color: .black.opacity(0.2)),
        dramatic: .xxl(color: .black.opacity(0.25))
    )
    
    public init() {}
}