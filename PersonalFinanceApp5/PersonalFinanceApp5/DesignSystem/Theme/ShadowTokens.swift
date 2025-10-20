import SwiftUI

/// Shadow token representing a complete shadow style
public struct ShadowToken {
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    public init(
        color: Color,
        radius: CGFloat,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

/// Shadow tokens for elevation and depth
public struct ShadowTokens {
    public let none: ShadowToken
    public let sm: ShadowToken
    public let md: ShadowToken
    public let lg: ShadowToken
    public let xl: ShadowToken
    
    public init(
        none: ShadowToken,
        sm: ShadowToken,
        md: ShadowToken,
        lg: ShadowToken,
        xl: ShadowToken
    ) {
        self.none = none
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
    }
}
