//
//  NeutralTheme.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// A neutral, professional theme with subtle colors and clean aesthetics.
/// Perfect for sophisticated, business-focused financial applications.
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
            // Primary: Refined slate blue
            primary: Color(red: 0.35, green: 0.45, blue: 0.60),           // #5973A6
            primaryVariant: Color(red: 0.28, green: 0.36, blue: 0.50),    // #475C80
            onPrimary: Color.white,
            
            // Secondary: Warm taupe
            secondary: Color(red: 0.55, green: 0.50, blue: 0.48),         // #8C807A
            secondaryVariant: Color(red: 0.45, green: 0.40, blue: 0.38),  // #736661
            onSecondary: Color.white,
            
            // Backgrounds: Light and airy
            background: Color(red: 0.97, green: 0.97, blue: 0.98),        // #F7F7FA
            backgroundElevated: Color.white,
            surface: Color.white,
            surfaceVariant: Color(red: 0.95, green: 0.95, blue: 0.96),    // #F2F2F5
            
            // Content: Professional gray tones
            onBackground: Color(red: 0.12, green: 0.12, blue: 0.15),      // #1F1F26
            onSurface: Color(red: 0.15, green: 0.15, blue: 0.18),         // #26262E
            onSurfaceSecondary: Color(red: 0.45, green: 0.45, blue: 0.48), // #737380
            onSurfaceTertiary: Color(red: 0.60, green: 0.60, blue: 0.63),  // #9999A1
            
            // Semantic: Subtle and professional
            success: Color(red: 0.28, green: 0.65, blue: 0.42),           // #47A66B
            warning: Color(red: 0.85, green: 0.60, blue: 0.25),           // #D99940
            error: Color(red: 0.80, green: 0.35, blue: 0.35),             // #CC5959
            info: Color(red: 0.35, green: 0.55, blue: 0.75),              // #598CBF
            
            // Borders: Soft dividers
            border: Color(red: 0.85, green: 0.85, blue: 0.87),            // #D9D9DE
            borderSubtle: Color(red: 0.90, green: 0.90, blue: 0.92),      // #E6E6EB
            
            // Shadows: Subtle depth
            shadowLight: Color.black.opacity(0.04),
            shadowMedium: Color.black.opacity(0.08),
            shadowHeavy: Color.black.opacity(0.12),
            
            // Chart Palette: Professional, harmonious colors for data visualization
            chartPalette: [
                Color(red: 0.35, green: 0.45, blue: 0.60),           // Slate Blue #5973A6
                Color(red: 0.28, green: 0.65, blue: 0.42),           // Green #47A66B
                Color(red: 0.85, green: 0.60, blue: 0.25),           // Orange #D99940
                Color(red: 0.35, green: 0.55, blue: 0.75),           // Blue #598CBF
                Color(red: 0.80, green: 0.35, blue: 0.35),           // Red #CC5959
                Color(red: 0.55, green: 0.50, blue: 0.48),           // Taupe #8C807A
                Color(red: 0.60, green: 0.40, blue: 0.70),           // Purple #9966B3
                Color(red: 0.70, green: 0.65, blue: 0.35)            // Gold #B3A659
            ]
        )
        
        // MARK: - Compact Spacing
        self.spacing = SpacingTokens(
            xxxs: 2,
            xxs: 4,
            xs: 8,
            sm: 12,
            md: 16,
            lg: 20,
            xl: 28,
            xxl: 40,
            xxxl: 56,
            cardPadding: 18,
            sectionSpacing: 20,
            componentSpacing: 14,
            iconSize: 18,
            iconSizeSmall: 14,
            iconSizeLarge: 22
        )
        
        // MARK: - Subtle Corners
        self.radius = RadiusTokens(
            none: 0,
            xs: 3,
            sm: 6,
            md: 9,
            lg: 12,
            xl: 16,
            xxl: 20,
            full: 9999,
            card: 10,
            button: 6,
            input: 6,
            chip: 14
        )
        
        // MARK: - Classic Typography
        self.typography = TypographyTokens(
            displayLarge: .system(size: 54, weight: .bold),
            displayMedium: .system(size: 42, weight: .bold),
            displaySmall: .system(size: 34, weight: .bold),
            headingLarge: .system(size: 30, weight: .semibold),
            headingMedium: .system(size: 22, weight: .semibold),
            headingSmall: .system(size: 18, weight: .semibold),
            bodyLarge: .system(size: 15, weight: .regular),
            bodyMedium: .system(size: 13, weight: .regular),
            bodySmall: .system(size: 11, weight: .regular),
            labelLarge: .system(size: 13, weight: .medium),
            labelMedium: .system(size: 11, weight: .medium),
            labelSmall: .system(size: 9, weight: .medium),
            caption: .system(size: 10, weight: .regular),
            overline: .system(size: 9, weight: .semibold),
            mono: .system(size: 12, design: .monospaced)
        )
        
        // MARK: - Gentle Shadows
        self.shadows = ShadowTokens(
            none: ShadowToken(radius: 0, opacity: 0),
            xs: ShadowToken(radius: 2, y: 1, opacity: 0.04),
            sm: ShadowToken(radius: 4, y: 2, opacity: 0.06),
            md: ShadowToken(radius: 6, y: 3, opacity: 0.08),
            lg: ShadowToken(radius: 10, y: 5, opacity: 0.10),
            xl: ShadowToken(radius: 14, y: 7, opacity: 0.12),
            xxl: ShadowToken(radius: 20, y: 10, opacity: 0.14),
            card: ShadowToken(radius: 6, y: 3, opacity: 0.08),
            cardHover: ShadowToken(radius: 10, y: 5, opacity: 0.10),
            modal: ShadowToken(radius: 20, y: 10, opacity: 0.15),
            dropdown: ShadowToken(radius: 10, y: 5, opacity: 0.12)
        )
    }
}
