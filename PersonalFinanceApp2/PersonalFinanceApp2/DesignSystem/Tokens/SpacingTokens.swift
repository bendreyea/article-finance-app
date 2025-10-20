import SwiftUI

/// Spacing tokens for consistent layout
public struct SpacingTokens {
    // MARK: - Size Scale
    let xs: CGFloat      // 4pt
    let sm: CGFloat      // 8pt
    let md: CGFloat      // 12pt
    let lg: CGFloat      // 16pt
    let xl: CGFloat      // 20pt
    let xxl: CGFloat     // 24pt
    let xxxl: CGFloat    // 32pt
    let huge: CGFloat    // 48pt
    let massive: CGFloat // 64pt
    
    // MARK: - Semantic Spacing
    let cardPadding: CGFloat
    let sectionSpacing: CGFloat
    let componentSpacing: CGFloat
    let elementSpacing: CGFloat
    
    public init(
        xs: CGFloat = 4,
        sm: CGFloat = 8,
        md: CGFloat = 12,
        lg: CGFloat = 16,
        xl: CGFloat = 20,
        xxl: CGFloat = 24,
        xxxl: CGFloat = 32,
        huge: CGFloat = 48,
        massive: CGFloat = 64,
        cardPadding: CGFloat = 16,
        sectionSpacing: CGFloat = 24,
        componentSpacing: CGFloat = 12,
        elementSpacing: CGFloat = 8
    ) {
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.xxxl = xxxl
        self.huge = huge
        self.massive = massive
        self.cardPadding = cardPadding
        self.sectionSpacing = sectionSpacing
        self.componentSpacing = componentSpacing
        self.elementSpacing = elementSpacing
    }
}
