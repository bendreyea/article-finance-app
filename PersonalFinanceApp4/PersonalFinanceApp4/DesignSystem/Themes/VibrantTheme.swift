//
//  VibrantTheme.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// A vibrant, colorful theme with bold accent colors and high contrast.
/// Perfect for modern, energetic financial dashboards.
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
            // Primary: Bold purple/violet
            primary: Color(red: 0.45, green: 0.28, blue: 0.96),           // #7247F5
            primaryVariant: Color(red: 0.35, green: 0.20, blue: 0.85),    // #5933D9
            onPrimary: Color.white,
            
            // Secondary: Energetic cyan/teal
            secondary: Color(red: 0.12, green: 0.78, blue: 0.89),         // #1FC7E3
            secondaryVariant: Color(red: 0.08, green: 0.65, blue: 0.75),  // #14A6BF
            onSecondary: Color.white,
            
            // Backgrounds: Deep, rich tones
            background: Color(red: 0.07, green: 0.07, blue: 0.11),        // #121219
            backgroundElevated: Color(red: 0.10, green: 0.10, blue: 0.14), // #1A1A24
            surface: Color(red: 0.13, green: 0.13, blue: 0.18),           // #21212E
            surfaceVariant: Color(red: 0.16, green: 0.16, blue: 0.22),    // #292938
            
            // Content: High contrast text
            onBackground: Color(red: 0.98, green: 0.98, blue: 0.99),      // #FAFAFC
            onSurface: Color(red: 0.95, green: 0.95, blue: 0.97),         // #F2F2F7
            onSurfaceSecondary: Color(red: 0.70, green: 0.70, blue: 0.75), // #B3B3BF
            onSurfaceTertiary: Color(red: 0.50, green: 0.50, blue: 0.55),  // #808088
            
            // Semantic: Bold and clear
            success: Color(red: 0.20, green: 0.85, blue: 0.55),           // #33D98F
            warning: Color(red: 1.00, green: 0.70, blue: 0.20),           // #FFB333
            error: Color(red: 0.95, green: 0.30, blue: 0.35),             // #F24D59
            info: Color(red: 0.30, green: 0.65, blue: 1.00),              // #4DA6FF
            
            // Borders: Vibrant accents
            border: Color(red: 0.30, green: 0.30, blue: 0.38),            // #4D4D61
            borderSubtle: Color(red: 0.20, green: 0.20, blue: 0.26),      // #333342
            
            // Shadows: Deep and dramatic
            shadowLight: Color.black.opacity(0.3),
            shadowMedium: Color.black.opacity(0.5),
            shadowHeavy: Color.black.opacity(0.7),
            
            // Chart Palette: Vibrant, high-contrast colors for data visualization
            chartPalette: [
                Color(red: 0.45, green: 0.28, blue: 0.96),           // Purple #7247F5
                Color(red: 0.12, green: 0.78, blue: 0.89),           // Cyan #1FC7E3
                Color(red: 1.00, green: 0.70, blue: 0.20),           // Orange #FFB333
                Color(red: 0.20, green: 0.85, blue: 0.55),           // Green #33D98F
                Color(red: 0.95, green: 0.30, blue: 0.35),           // Red #F24D59
                Color(red: 0.30, green: 0.65, blue: 1.00),           // Blue #4DA6FF
                Color(red: 1.00, green: 0.45, blue: 0.70),           // Pink #FF73B3
                Color(red: 0.65, green: 0.85, blue: 0.30)            // Lime #A6D94D
            ]
        )
        
        // MARK: - Generous Spacing
        self.spacing = SpacingTokens(
            xxxs: 2,
            xxs: 4,
            xs: 8,
            sm: 12,
            md: 16,
            lg: 24,
            xl: 32,
            xxl: 48,
            xxxl: 64,
            cardPadding: 24,
            sectionSpacing: 32,
            componentSpacing: 20,
            iconSize: 22,
            iconSizeSmall: 18,
            iconSizeLarge: 28
        )
        
        // MARK: - Rounded Corners
        self.radius = RadiusTokens(
            none: 0,
            xs: 6,
            sm: 10,
            md: 14,
            lg: 18,
            xl: 22,
            xxl: 28,
            full: 9999,
            card: 16,
            button: 10,
            input: 10,
            chip: 20
        )
        
        // MARK: - Modern Typography
        self.typography = TypographyTokens(
            displayLarge: .system(size: 60, weight: .bold, design: .rounded),
            displayMedium: .system(size: 48, weight: .bold, design: .rounded),
            displaySmall: .system(size: 38, weight: .bold, design: .rounded),
            headingLarge: .system(size: 34, weight: .bold),
            headingMedium: .system(size: 26, weight: .bold),
            headingSmall: .system(size: 22, weight: .semibold),
            bodyLarge: .system(size: 17, weight: .regular),
            bodyMedium: .system(size: 15, weight: .regular),
            bodySmall: .system(size: 13, weight: .regular),
            labelLarge: .system(size: 15, weight: .semibold),
            labelMedium: .system(size: 13, weight: .semibold),
            labelSmall: .system(size: 11, weight: .semibold),
            caption: .system(size: 12, weight: .regular),
            overline: .system(size: 11, weight: .bold),
            mono: .system(size: 14, design: .monospaced)
        )
        
        // MARK: - Dramatic Shadows
        self.shadows = ShadowTokens(
            none: ShadowToken(radius: 0, opacity: 0),
            xs: ShadowToken(radius: 3, y: 2, opacity: 0.15),
            sm: ShadowToken(radius: 6, y: 3, opacity: 0.20),
            md: ShadowToken(radius: 10, y: 5, opacity: 0.25),
            lg: ShadowToken(radius: 16, y: 8, opacity: 0.30),
            xl: ShadowToken(radius: 22, y: 11, opacity: 0.35),
            xxl: ShadowToken(radius: 30, y: 15, opacity: 0.40),
            card: ShadowToken(radius: 12, y: 6, opacity: 0.25),
            cardHover: ShadowToken(radius: 18, y: 9, opacity: 0.30),
            modal: ShadowToken(radius: 30, y: 15, opacity: 0.40),
            dropdown: ShadowToken(radius: 16, y: 8, opacity: 0.30)
        )
    }
}
