import SwiftUI

/// Typography tokens for consistent text styling
public struct TypographyTokens {
    // MARK: - Font Sizes
    let caption: Font
    let footnote: Font
    let subheadline: Font
    let callout: Font
    let body: Font
    let headline: Font
    let title3: Font
    let title2: Font
    let title1: Font
    let largeTitle: Font
    
    // MARK: - Font Weights
    let light: Font.Weight
    let regular: Font.Weight
    let medium: Font.Weight
    let semibold: Font.Weight
    let bold: Font.Weight
    
    // MARK: - Line Heights (as multipliers)
    let tight: CGFloat       // 1.1
    let normal: CGFloat      // 1.4
    let relaxed: CGFloat     // 1.6
    
    public init(
        caption: Font = .caption,
        footnote: Font = .footnote,
        subheadline: Font = .subheadline,
        callout: Font = .callout,
        body: Font = .body,
        headline: Font = .headline,
        title3: Font = .title3,
        title2: Font = .title2,
        title1: Font = .title,
        largeTitle: Font = .largeTitle,
        light: Font.Weight = .light,
        regular: Font.Weight = .regular,
        medium: Font.Weight = .medium,
        semibold: Font.Weight = .semibold,
        bold: Font.Weight = .bold,
        tight: CGFloat = 1.1,
        normal: CGFloat = 1.4,
        relaxed: CGFloat = 1.6
    ) {
        self.caption = caption
        self.footnote = footnote
        self.subheadline = subheadline
        self.callout = callout
        self.body = body
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
        self.tight = tight
        self.normal = normal
        self.relaxed = relaxed
    }
}
