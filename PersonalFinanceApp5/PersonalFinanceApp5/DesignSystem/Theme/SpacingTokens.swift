import Foundation

/// Spacing tokens for consistent layout
public struct SpacingTokens {
    public let xxxs: CGFloat  // 2pt
    public let xxs: CGFloat   // 4pt
    public let xs: CGFloat    // 8pt
    public let sm: CGFloat    // 12pt
    public let md: CGFloat    // 16pt
    public let lg: CGFloat    // 24pt
    public let xl: CGFloat    // 32pt
    public let xxl: CGFloat   // 48pt
    public let xxxl: CGFloat  // 64pt
    
    public init(
        xxxs: CGFloat = 2,
        xxs: CGFloat = 4,
        xs: CGFloat = 8,
        sm: CGFloat = 12,
        md: CGFloat = 16,
        lg: CGFloat = 24,
        xl: CGFloat = 32,
        xxl: CGFloat = 48,
        xxxl: CGFloat = 64
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
    }
}
