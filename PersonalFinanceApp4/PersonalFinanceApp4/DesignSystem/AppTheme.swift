//
//  AppTheme.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import Foundation

/// The main theme protocol that defines the complete design system.
/// All concrete themes must implement this protocol to provide consistent token access.
public protocol AppTheme {
    /// The unique identifier for this theme.
    var name: String { get }
    
    /// Color tokens defining the theme's color palette.
    var colors: ColorTokens { get }
    
    /// Spacing tokens for consistent layout and padding.
    var spacing: SpacingTokens { get }
    
    /// Border radius tokens for consistent corner rounding.
    var radius: RadiusTokens { get }
    
    /// Typography tokens for consistent text styling.
    var typography: TypographyTokens { get }
    
    /// Shadow tokens for elevation and depth effects.
    var shadows: ShadowTokens { get }
}
