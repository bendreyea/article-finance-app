import SwiftUI

/// Color tokens for theming
public struct ColorTokens {
    // MARK: - Surface Colors
    let backgroundPrimary: Color
    let backgroundSecondary: Color
    let backgroundTertiary: Color
    let surface: Color
    let surfaceElevated: Color
    
    // MARK: - Content Colors
    let textPrimary: Color
    let textSecondary: Color
    let textTertiary: Color
    let textInverse: Color
    
    // MARK: - Brand Colors
    let brandPrimary: Color
    let brandSecondary: Color
    let brandTertiary: Color
    
    // MARK: - Semantic Colors
    let success: Color
    let warning: Color
    let error: Color
    let info: Color
    
    // MARK: - Interactive Colors
    let interactive: Color
    let interactiveHover: Color
    let interactiveActive: Color
    let interactiveDisabled: Color
    
    // MARK: - Border Colors
    let border: Color
    let borderSubtle: Color
    let borderStrong: Color
    
    public init(
        backgroundPrimary: Color,
        backgroundSecondary: Color,
        backgroundTertiary: Color,
        surface: Color,
        surfaceElevated: Color,
        textPrimary: Color,
        textSecondary: Color,
        textTertiary: Color,
        textInverse: Color,
        brandPrimary: Color,
        brandSecondary: Color,
        brandTertiary: Color,
        success: Color,
        warning: Color,
        error: Color,
        info: Color,
        interactive: Color,
        interactiveHover: Color,
        interactiveActive: Color,
        interactiveDisabled: Color,
        border: Color,
        borderSubtle: Color,
        borderStrong: Color
    ) {
        self.backgroundPrimary = backgroundPrimary
        self.backgroundSecondary = backgroundSecondary
        self.backgroundTertiary = backgroundTertiary
        self.surface = surface
        self.surfaceElevated = surfaceElevated
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.textInverse = textInverse
        self.brandPrimary = brandPrimary
        self.brandSecondary = brandSecondary
        self.brandTertiary = brandTertiary
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
        self.interactive = interactive
        self.interactiveHover = interactiveHover
        self.interactiveActive = interactiveActive
        self.interactiveDisabled = interactiveDisabled
        self.border = border
        self.borderSubtle = borderSubtle
        self.borderStrong = borderStrong
    }
}
