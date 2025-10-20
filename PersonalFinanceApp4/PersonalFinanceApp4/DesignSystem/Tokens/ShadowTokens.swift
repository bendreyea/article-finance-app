//
//  ShadowTokens.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import Foundation

/// Shadow token definition for creating elevation effects.
public struct ShadowToken {
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    public let opacity: Double
    
    public init(radius: CGFloat, x: CGFloat = 0, y: CGFloat = 0, opacity: Double = 0.1) {
        self.radius = radius
        self.x = x
        self.y = y
        self.opacity = opacity
    }
}

/// Shadow tokens for consistent elevation and depth.
public struct ShadowTokens {
    // MARK: - Elevation Shadows
    public let none: ShadowToken
    public let xs: ShadowToken
    public let sm: ShadowToken
    public let md: ShadowToken
    public let lg: ShadowToken
    public let xl: ShadowToken
    public let xxl: ShadowToken
    
    // MARK: - Semantic Shadows
    public let card: ShadowToken
    public let cardHover: ShadowToken
    public let modal: ShadowToken
    public let dropdown: ShadowToken
    
    public init(
        none: ShadowToken = ShadowToken(radius: 0, opacity: 0),
        xs: ShadowToken = ShadowToken(radius: 2, y: 1, opacity: 0.05),
        sm: ShadowToken = ShadowToken(radius: 4, y: 2, opacity: 0.08),
        md: ShadowToken = ShadowToken(radius: 8, y: 4, opacity: 0.1),
        lg: ShadowToken = ShadowToken(radius: 12, y: 6, opacity: 0.12),
        xl: ShadowToken = ShadowToken(radius: 16, y: 8, opacity: 0.15),
        xxl: ShadowToken = ShadowToken(radius: 24, y: 12, opacity: 0.18),
        card: ShadowToken = ShadowToken(radius: 8, y: 4, opacity: 0.1),
        cardHover: ShadowToken = ShadowToken(radius: 12, y: 6, opacity: 0.12),
        modal: ShadowToken = ShadowToken(radius: 24, y: 12, opacity: 0.2),
        dropdown: ShadowToken = ShadowToken(radius: 12, y: 6, opacity: 0.15)
    ) {
        self.none = none
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.card = card
        self.cardHover = cardHover
        self.modal = modal
        self.dropdown = dropdown
    }
}
