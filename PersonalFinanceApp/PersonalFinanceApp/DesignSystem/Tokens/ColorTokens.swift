import SwiftUI

/// Color tokens for theming
public struct ColorTokens {
    // MARK: - Primary Colors
    public let primary: Color
    public let primaryVariant: Color
    
    // MARK: - Secondary Colors
    public let secondary: Color
    public let secondaryVariant: Color
    
    // MARK: - Background Colors
    public let background: Color
    public let surface: Color
    public let surfaceVariant: Color
    
    // MARK: - Content Colors
    public let onPrimary: Color
    public let onSecondary: Color
    public let onBackground: Color
    public let onSurface: Color
    
    // MARK: - Semantic Colors
    public let success: Color
    public let warning: Color
    public let error: Color
    public let info: Color
    
    // MARK: - Text Colors
    public let textPrimary: Color
    public let textSecondary: Color
    public let textTertiary: Color
    
    // MARK: - Border Colors
    public let border: Color
    public let borderVariant: Color
    
    public init(
        primary: Color,
        primaryVariant: Color,
        secondary: Color,
        secondaryVariant: Color,
        background: Color,
        surface: Color,
        surfaceVariant: Color,
        onPrimary: Color,
        onSecondary: Color,
        onBackground: Color,
        onSurface: Color,
        success: Color,
        warning: Color,
        error: Color,
        info: Color,
        textPrimary: Color,
        textSecondary: Color,
        textTertiary: Color,
        border: Color,
        borderVariant: Color
    ) {
        self.primary = primary
        self.primaryVariant = primaryVariant
        self.secondary = secondary
        self.secondaryVariant = secondaryVariant
        self.background = background
        self.surface = surface
        self.surfaceVariant = surfaceVariant
        self.onPrimary = onPrimary
        self.onSecondary = onSecondary
        self.onBackground = onBackground
        self.onSurface = onSurface
        self.success = success
        self.warning = warning
        self.error = error
        self.info = info
        self.textPrimary = textPrimary
        self.textSecondary = textSecondary
        self.textTertiary = textTertiary
        self.border = border
        self.borderVariant = borderVariant
    }
}