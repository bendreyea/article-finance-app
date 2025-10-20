import SwiftUI

/// Typography tokens for consistent text styling
public struct TypographyTokens {
    // MARK: - Font Families
    public let primary: String    // Main font family
    public let secondary: String  // Secondary font family (e.g., monospace for numbers)
    
    // MARK: - Font Sizes
    public let caption: CGFloat   // 10pt
    public let footnote: CGFloat  // 12pt
    public let body: CGFloat      // 14pt
    public let callout: CGFloat   // 15pt
    public let subhead: CGFloat   // 16pt
    public let headline: CGFloat  // 18pt
    public let title3: CGFloat    // 20pt
    public let title2: CGFloat    // 22pt
    public let title1: CGFloat    // 28pt
    public let largeTitle: CGFloat // 34pt
    
    // MARK: - Font Weights
    public let light: Font.Weight
    public let regular: Font.Weight
    public let medium: Font.Weight
    public let semibold: Font.Weight
    public let bold: Font.Weight
    
    // MARK: - Line Heights
    public let lineHeightTight: CGFloat   // 1.2
    public let lineHeightNormal: CGFloat  // 1.4
    public let lineHeightRelaxed: CGFloat // 1.6
    
    // MARK: - Letter Spacing
    public let letterSpacingTight: CGFloat   // -0.5pt
    public let letterSpacingNormal: CGFloat  // 0pt
    public let letterSpacingWide: CGFloat    // 0.5pt
    
    public init(
        primary: String = ".AppleSystemUIFont",
        secondary: String = "SF Mono",
        caption: CGFloat = 10,
        footnote: CGFloat = 12,
        body: CGFloat = 14,
        callout: CGFloat = 15,
        subhead: CGFloat = 16,
        headline: CGFloat = 18,
        title3: CGFloat = 20,
        title2: CGFloat = 22,
        title1: CGFloat = 28,
        largeTitle: CGFloat = 34,
        light: Font.Weight = .light,
        regular: Font.Weight = .regular,
        medium: Font.Weight = .medium,
        semibold: Font.Weight = .semibold,
        bold: Font.Weight = .bold,
        lineHeightTight: CGFloat = 1.2,
        lineHeightNormal: CGFloat = 1.4,
        lineHeightRelaxed: CGFloat = 1.6,
        letterSpacingTight: CGFloat = -0.5,
        letterSpacingNormal: CGFloat = 0,
        letterSpacingWide: CGFloat = 0.5
    ) {
        self.primary = primary
        self.secondary = secondary
        self.caption = caption
        self.footnote = footnote
        self.body = body
        self.callout = callout
        self.subhead = subhead
        self.headline = headline
        self.title3 = title3
        self.title2 = title2
        self.title1 = title1
        self.largeTitle = largeTitle
        self.light = light
        self.regular = regular
        self.medium = medium
        self.semibold = semibold
        self.bold = bold
        self.lineHeightTight = lineHeightTight
        self.lineHeightNormal = lineHeightNormal
        self.lineHeightRelaxed = lineHeightRelaxed
        self.letterSpacingTight = letterSpacingTight
        self.letterSpacingNormal = letterSpacingNormal
        self.letterSpacingWide = letterSpacingWide
    }
}

// MARK: - Font Helpers
extension TypographyTokens {
    /// Creates a Font with the specified size and weight
    public func font(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        return Font.system(size: size, weight: weight)
    }
    
    /// Typography styles for common text elements
    public var captionFont: Font { font(size: caption, weight: regular) }
    public var footnoteFont: Font { font(size: footnote, weight: regular) }
    public var bodyFont: Font { font(size: body, weight: regular) }
    public var calloutFont: Font { font(size: callout, weight: regular) }
    public var subheadFont: Font { font(size: subhead, weight: medium) }
    public var headlineFont: Font { font(size: headline, weight: semibold) }
    public var title3Font: Font { font(size: title3, weight: semibold) }
    public var title2Font: Font { font(size: title2, weight: bold) }
    public var title1Font: Font { font(size: title1, weight: bold) }
    public var largeTitleFont: Font { font(size: largeTitle, weight: bold) }
}