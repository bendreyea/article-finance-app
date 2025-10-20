//
//  SpacingTokens.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import Foundation

/// Spacing tokens for consistent layout throughout the application.
/// Uses an 8pt grid system as the foundation.
public struct SpacingTokens {
    // MARK: - Base Spacing
    public let xxxs: CGFloat  // 2pt
    public let xxs: CGFloat   // 4pt
    public let xs: CGFloat    // 8pt
    public let sm: CGFloat    // 12pt
    public let md: CGFloat    // 16pt
    public let lg: CGFloat    // 24pt
    public let xl: CGFloat    // 32pt
    public let xxl: CGFloat   // 48pt
    public let xxxl: CGFloat  // 64pt
    
    // MARK: - Semantic Spacing
    public let cardPadding: CGFloat
    public let sectionSpacing: CGFloat
    public let componentSpacing: CGFloat
    public let iconSize: CGFloat
    public let iconSizeSmall: CGFloat
    public let iconSizeLarge: CGFloat
    
    public init(
        xxxs: CGFloat = 2,
        xxs: CGFloat = 4,
        xs: CGFloat = 8,
        sm: CGFloat = 12,
        md: CGFloat = 16,
        lg: CGFloat = 24,
        xl: CGFloat = 32,
        xxl: CGFloat = 48,
        xxxl: CGFloat = 64,
        cardPadding: CGFloat = 20,
        sectionSpacing: CGFloat = 24,
        componentSpacing: CGFloat = 16,
        iconSize: CGFloat = 20,
        iconSizeSmall: CGFloat = 16,
        iconSizeLarge: CGFloat = 24
    ) {
        self.xxxs = xxxs
        self.xxs = xxs
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl
        self.cardPadding = cardPadding
        self.sectionSpacing = sectionSpacing
        self.componentSpacing = componentSpacing
        self.iconSize = iconSize
        self.iconSizeSmall = iconSizeSmall
        self.iconSizeLarge = iconSizeLarge
    }
}
