import SwiftUI

/// Corner radius tokens for consistent rounded corners
public struct RadiusTokens {
    let none: CGFloat     // 0pt
    let xs: CGFloat       // 2pt
    let sm: CGFloat       // 4pt
    let md: CGFloat       // 6pt
    let lg: CGFloat       // 8pt
    let xl: CGFloat       // 12pt
    let xxl: CGFloat      // 16pt
    let pill: CGFloat     // 999pt (fully rounded)
    
    // MARK: - Semantic Radius
    let card: CGFloat
    let button: CGFloat
    let input: CGFloat
    let badge: CGFloat
    
    public init(
        none: CGFloat = 0,
        xs: CGFloat = 2,
        sm: CGFloat = 4,
        md: CGFloat = 6,
        lg: CGFloat = 8,
        xl: CGFloat = 12,
        xxl: CGFloat = 16,
        pill: CGFloat = 999,
        card: CGFloat = 12,
        button: CGFloat = 8,
        input: CGFloat = 6,
        badge: CGFloat = 999
    ) {
        self.none = none
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.xxl = xxl
        self.pill = pill
        self.card = card
        self.button = button
        self.input = input
        self.badge = badge
    }
}
