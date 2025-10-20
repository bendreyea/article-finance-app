//
//  ColorTokens.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// Semantic color tokens for the design system.
/// These represent the color palette used throughout the application.
public struct ColorTokens {
    // MARK: - Primary Colors
    public let primary: Color
    public let primaryVariant: Color
    public let onPrimary: Color
    
    // MARK: - Secondary Colors
    public let secondary: Color
    public let secondaryVariant: Color
    public let onSecondary: Color
    
    // MARK: - Background Colors
    public let background: Color
    public let backgroundElevated: Color
    public let surface: Color
    public let surfaceVariant: Color
    
    // MARK: - Content Colors
    public let onBackground: Color
    public let onSurface: Color
    public let onSurfaceSecondary: Color
    public let onSurfaceTertiary: Color
    
    // MARK: - Semantic Colors
    public let success: Color
    public let warning: Color
    public let error: Color
    public let info: Color
    
    // MARK: - Border Colors
    public let border: Color
    public let borderSubtle: Color
    
    // MARK: - Shadow Colors
    public let shadowLight: Color
    public let shadowMedium: Color
    public let shadowHeavy: Color
    
    // MARK: - Chart Colors
    public let chartPalette: [Color]
    
    public init(
        primary: Color,
        primaryVariant: Color,
        onPrimary: Color,
        secondary: Color,
        secondaryVariant: Color,
        onSecondary: Color,
        background: Color,
        backgroundElevated: Color,
        surface: Color,
        surfaceVariant: Color,
        onBackground: Color,
        onSurface: Color,
        onSurfaceSecondary: Color,
        onSurfaceTertiary: Color,
        success: Color,
        warning: Color,
        error: Color,
        info: Color,
        border: Color,
        borderSubtle: Color,
        shadowLight: Color,
        shadowMedium: Color,
        shadowHeavy: Color,
        chartPalette: [Color]
    ) {
        self.primary = primary
        self.primaryVariant = primaryVariant
        self.onPrimary = onPrimary
        self.secondary = secondary
        self.secondaryVariant = secondaryVariant
        self.onSecondary = onSecondary
        self.background = background
        self.backgroundElevated = backgroundElevated
        self.surface = surface
        self.surfaceVariant = surfaceVariant
        self.onBackground = onBackground
        self.onSurface = onSurface
        self.onSurfaceSecondary = onSurfaceSecondary
        self.onSurfaceTertiary = onSurfaceTertiary
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
        self.border = border
        self.borderSubtle = borderSubtle
        self.shadowLight = shadowLight
        self.shadowMedium = shadowMedium
        self.shadowHeavy = shadowHeavy
        self.chartPalette = chartPalette
    }
}
