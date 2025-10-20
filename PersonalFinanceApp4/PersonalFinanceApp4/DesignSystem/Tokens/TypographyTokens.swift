//
//  TypographyTokens.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// Typography tokens for consistent text styling.
public struct TypographyTokens {
    // MARK: - Heading Styles
    public let displayLarge: Font
    public let displayMedium: Font
    public let displaySmall: Font
    
    public let headingLarge: Font
    public let headingMedium: Font
    public let headingSmall: Font
    
    // MARK: - Body Styles
    public let bodyLarge: Font
    public let bodyMedium: Font
    public let bodySmall: Font
    
    // MARK: - Label Styles
    public let labelLarge: Font
    public let labelMedium: Font
    public let labelSmall: Font
    
    // MARK: - Special Styles
    public let caption: Font
    public let overline: Font
    public let mono: Font
    
    // MARK: - Line Heights
    public let lineHeightTight: CGFloat
    public let lineHeightNormal: CGFloat
    public let lineHeightRelaxed: CGFloat
    
    // MARK: - Font Weights
    public let weightLight: Font.Weight
    public let weightRegular: Font.Weight
    public let weightMedium: Font.Weight
    public let weightSemibold: Font.Weight
    public let weightBold: Font.Weight
    
    public init(
        displayLarge: Font = .system(size: 57, weight: .bold),
        displayMedium: Font = .system(size: 45, weight: .bold),
        displaySmall: Font = .system(size: 36, weight: .bold),
        headingLarge: Font = .system(size: 32, weight: .semibold),
        headingMedium: Font = .system(size: 24, weight: .semibold),
        headingSmall: Font = .system(size: 20, weight: .semibold),
        bodyLarge: Font = .system(size: 16, weight: .regular),
        bodyMedium: Font = .system(size: 14, weight: .regular),
        bodySmall: Font = .system(size: 12, weight: .regular),
        labelLarge: Font = .system(size: 14, weight: .medium),
        labelMedium: Font = .system(size: 12, weight: .medium),
        labelSmall: Font = .system(size: 10, weight: .medium),
        caption: Font = .system(size: 11, weight: .regular),
        overline: Font = .system(size: 10, weight: .semibold),
        mono: Font = .system(size: 13, design: .monospaced),
        lineHeightTight: CGFloat = 1.2,
        lineHeightNormal: CGFloat = 1.5,
        lineHeightRelaxed: CGFloat = 1.75,
        weightLight: Font.Weight = .light,
        weightRegular: Font.Weight = .regular,
        weightMedium: Font.Weight = .medium,
        weightSemibold: Font.Weight = .semibold,
        weightBold: Font.Weight = .bold
    ) {
        self.displayLarge = displayLarge
        self.displayMedium = displayMedium
        self.displaySmall = displaySmall
        self.headingLarge = headingLarge
        self.headingMedium = headingMedium
        self.headingSmall = headingSmall
        self.bodyLarge = bodyLarge
        self.bodyMedium = bodyMedium
        self.bodySmall = bodySmall
        self.labelLarge = labelLarge
        self.labelMedium = labelMedium
        self.labelSmall = labelSmall
        self.caption = caption
        self.overline = overline
        self.mono = mono
        self.lineHeightTight = lineHeightTight
        self.lineHeightNormal = lineHeightNormal
        self.lineHeightRelaxed = lineHeightRelaxed
        self.weightLight = weightLight
        self.weightRegular = weightRegular
        self.weightMedium = weightMedium
        self.weightSemibold = weightSemibold
        self.weightBold = weightBold
    }
}
