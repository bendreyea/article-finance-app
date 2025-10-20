import SwiftUI

/// Border radius tokens for consistent corner rounding
public struct RadiusTokens {
    // MARK: - Base Radius
    public let none: CGFloat      // 0pt
    public let xs: CGFloat        // 2pt
    public let sm: CGFloat        // 4pt
    public let md: CGFloat        // 8pt
    public let lg: CGFloat        // 12pt
    public let xl: CGFloat        // 16pt
    public let xxl: CGFloat       // 24pt
    public let full: CGFloat      // 9999pt (circular)
    
    // MARK: - Semantic Radius
    public let button: CGFloat
    public let card: CGFloat
    public let input: CGFloat
    public let badge: CGFloat
    public let modal: CGFloat
    
    public init(
        none: CGFloat = 0,
        xs: CGFloat = 2,
        sm: CGFloat = 4,
        md: CGFloat = 8,
        lg: CGFloat = 12,
        xl: CGFloat = 16,
        xxl: CGFloat = 24,
        full: CGFloat = 9999,
        button: CGFloat? = nil,
        card: CGFloat? = nil,
        input: CGFloat? = nil,
        badge: CGFloat? = nil,
        modal: CGFloat? = nil
    ) {
        self.none = none
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.full = full
        self.button = button ?? md
        self.card = card ?? lg
        self.input = input ?? sm
        self.badge = badge ?? full
        self.modal = modal ?? xl
    }
}