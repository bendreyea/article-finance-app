import SwiftUI

/// Design system shadow tokens
public struct ShadowTokens {
    public let none: ShadowStyle
    public let sm: ShadowStyle
    public let md: ShadowStyle
    public let lg: ShadowStyle
    public let xl: ShadowStyle
    
    public init(
        none: ShadowStyle = ShadowStyle(color: .clear, radius: 0, x: 0, y: 0),
        sm: ShadowStyle = ShadowStyle(color: .black.opacity(0.05), radius: 2, x: 0, y: 1),
        md: ShadowStyle = ShadowStyle(color: .black.opacity(0.08), radius: 4, x: 0, y: 2),
        lg: ShadowStyle = ShadowStyle(color: .black.opacity(0.10), radius: 8, x: 0, y: 4),
        xl: ShadowStyle = ShadowStyle(color: .black.opacity(0.12), radius: 16, x: 0, y: 8)
    ) {
        self.none = none
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
    }
}

/// Shadow style definition
public struct ShadowStyle {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}
