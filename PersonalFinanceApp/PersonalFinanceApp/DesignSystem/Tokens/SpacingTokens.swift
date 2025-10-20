import SwiftUI

/// Spacing tokens for consistent layout spacing
public struct SpacingTokens {
    // MARK: - Base Spacing
    public let xs: CGFloat        // 4pt
    public let sm: CGFloat        // 8pt
    public let md: CGFloat        // 16pt
    public let lg: CGFloat        // 24pt
    public let xl: CGFloat        // 32pt
    public let xxl: CGFloat       // 48pt
    public let xxxl: CGFloat      // 64pt
    
    // MARK: - Semantic Spacing
    public let componentPadding: CGFloat
    public let sectionSpacing: CGFloat
    public let cardPadding: CGFloat
    public let buttonPadding: CGFloat
    public let iconSpacing: CGFloat
    
    public init(
        xs: CGFloat = 4,
        sm: CGFloat = 8,
        md: CGFloat = 16,
        lg: CGFloat = 24,
        xl: CGFloat = 32,
        xxl: CGFloat = 48,
        xxxl: CGFloat = 64,
        componentPadding: CGFloat? = nil,
        sectionSpacing: CGFloat? = nil,
        cardPadding: CGFloat? = nil,
        buttonPadding: CGFloat? = nil,
        iconSpacing: CGFloat? = nil
    ) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl
        self.componentPadding = componentPadding ?? md
        self.sectionSpacing = sectionSpacing ?? lg
        self.cardPadding = cardPadding ?? md
        self.buttonPadding = buttonPadding ?? sm
        self.iconSpacing = iconSpacing ?? xs
    }
}