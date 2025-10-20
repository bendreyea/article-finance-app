import SwiftUI

/// Shadow tokens for consistent elevation and depth
public struct ShadowTokens {
    // MARK: - Shadow Properties
    public let color: Color
    public let radius: CGFloat
    public let x: CGFloat
    public let y: CGFloat
    
    // MARK: - Predefined Shadow Levels
    public static func none() -> ShadowTokens {
        ShadowTokens(color: .clear, radius: 0, x: 0, y: 0)
    }
    
    public static func sm(color: Color = .black.opacity(0.1)) -> ShadowTokens {
        ShadowTokens(color: color, radius: 2, x: 0, y: 1)
    }
    
    public static func md(color: Color = .black.opacity(0.1)) -> ShadowTokens {
        ShadowTokens(color: color, radius: 4, x: 0, y: 2)
    }
    
    public static func lg(color: Color = .black.opacity(0.1)) -> ShadowTokens {
        ShadowTokens(color: color, radius: 8, x: 0, y: 4)
    }
    
    public static func xl(color: Color = .black.opacity(0.15)) -> ShadowTokens {
        ShadowTokens(color: color, radius: 12, x: 0, y: 6)
    }
    
    public static func xxl(color: Color = .black.opacity(0.2)) -> ShadowTokens {
        ShadowTokens(color: color, radius: 20, x: 0, y: 10)
    }
    
    public init(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

/// Collection of shadow tokens for different use cases
public struct ShadowCollection {
    public let none: ShadowTokens
    public let subtle: ShadowTokens
    public let card: ShadowTokens
    public let elevated: ShadowTokens
    public let modal: ShadowTokens
    public let dramatic: ShadowTokens
    
    public init(
        none: ShadowTokens = .none(),
        subtle: ShadowTokens = .sm(),
        card: ShadowTokens = .md(),
        elevated: ShadowTokens = .lg(),
        modal: ShadowTokens = .xl(),
        dramatic: ShadowTokens = .xxl()
    ) {
        self.none = none
        self.subtle = subtle
        self.card = card
        self.elevated = elevated
        self.modal = modal
        self.dramatic = dramatic
    }
}

// MARK: - View Extensions for Shadow Application
extension View {
    /// Apply shadow tokens to a view
    public func shadow(_ shadowTokens: ShadowTokens) -> some View {
        self.shadow(
            color: shadowTokens.color,
            radius: shadowTokens.radius,
            x: shadowTokens.x,
            y: shadowTokens.y
        )
    }
}