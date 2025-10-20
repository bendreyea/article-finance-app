import Foundation

/// Border radius tokens for consistent rounded corners
public struct RadiusTokens {
    public let none: CGFloat
    public let sm: CGFloat
    public let md: CGFloat
    public let lg: CGFloat
    public let xl: CGFloat
    public let full: CGFloat
    
    public init(
        none: CGFloat = 0,
        sm: CGFloat = 4,
        md: CGFloat = 8,
        lg: CGFloat = 12,
        xl: CGFloat = 16,
        full: CGFloat = 9999
    ) {
        self.none = none
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.full = full
    }
}
