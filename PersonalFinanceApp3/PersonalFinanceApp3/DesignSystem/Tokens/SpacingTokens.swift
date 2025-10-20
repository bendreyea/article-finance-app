import Foundation

/// Design system spacing tokens
public struct SpacingTokens {
    public let xxs: CGFloat    // 2
    public let xs: CGFloat     // 4
    public let sm: CGFloat     // 8
    public let md: CGFloat     // 12
    public let lg: CGFloat     // 16
    public let xl: CGFloat     // 24
    public let xxl: CGFloat    // 32
    public let xxxl: CGFloat   // 48
    
    public init(
        xxs: CGFloat = 2,
        xs: CGFloat = 4,
        sm: CGFloat = 8,
        md: CGFloat = 12,
        lg: CGFloat = 16,
        xl: CGFloat = 24,
        xxl: CGFloat = 32,
        xxxl: CGFloat = 48
    ) {
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
