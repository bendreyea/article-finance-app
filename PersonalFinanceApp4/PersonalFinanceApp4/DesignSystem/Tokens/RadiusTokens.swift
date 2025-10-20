//
//  RadiusTokens.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import Foundation

/// Border radius tokens for consistent corner rounding.
public struct RadiusTokens {
    // MARK: - Base Radius
    public let none: CGFloat      // 0
    public let xs: CGFloat        // 4pt
    public let sm: CGFloat        // 8pt
    public let md: CGFloat        // 12pt
    public let lg: CGFloat        // 16pt
    public let xl: CGFloat        // 20pt
    public let xxl: CGFloat       // 24pt
    public let full: CGFloat      // 9999 (fully rounded)
    
    // MARK: - Semantic Radius
    public let card: CGFloat
    public let button: CGFloat
    public let input: CGFloat
    public let chip: CGFloat
    
    public init(
        none: CGFloat = 0,
        xs: CGFloat = 4,
        sm: CGFloat = 8,
        md: CGFloat = 12,
        lg: CGFloat = 16,
        xl: CGFloat = 20,
        xxl: CGFloat = 24,
        full: CGFloat = 9999,
        card: CGFloat = 12,
        button: CGFloat = 8,
        input: CGFloat = 8,
        chip: CGFloat = 16
    ) {
        self.none = none
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.full = full
        self.card = card
        self.button = button
        self.input = input
        self.chip = chip
    }
}
