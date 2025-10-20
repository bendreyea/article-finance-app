import SwiftUI

/// Shadow tokens for consistent elevation and depth
public struct ShadowTokens {
    // MARK: - Shadow Definitions
    let none: ShadowDefinition
    let xs: ShadowDefinition
    let sm: ShadowDefinition
    let md: ShadowDefinition
    let lg: ShadowDefinition
    let xl: ShadowDefinition
    
    // MARK: - Semantic Shadows
    let card: ShadowDefinition
    let button: ShadowDefinition
    let modal: ShadowDefinition
    let dropdown: ShadowDefinition
    
    public init(
        none: ShadowDefinition = ShadowDefinition(),
        xs: ShadowDefinition = ShadowDefinition(color: .black.opacity(0.05), radius: 1, x: 0, y: 1),
        sm: ShadowDefinition = ShadowDefinition(color: .black.opacity(0.08), radius: 2, x: 0, y: 1),
        md: ShadowDefinition = ShadowDefinition(color: .black.opacity(0.1), radius: 4, x: 0, y: 2),
        lg: ShadowDefinition = ShadowDefinition(color: .black.opacity(0.12), radius: 8, x: 0, y: 4),
        xl: ShadowDefinition = ShadowDefinition(color: .black.opacity(0.15), radius: 16, x: 0, y: 8),
        card: ShadowDefinition = ShadowDefinition(color: .black.opacity(0.08), radius: 3, x: 0, y: 1),
        button: ShadowDefinition = ShadowDefinition(color: .black.opacity(0.1), radius: 2, x: 0, y: 1),
        modal: ShadowDefinition = ShadowDefinition(color: .black.opacity(0.2), radius: 20, x: 0, y: 10),
        dropdown: ShadowDefinition = ShadowDefinition(color: .black.opacity(0.12), radius: 6, x: 0, y: 2)
    ) {
        self.none = none
        self.xs = xs
        self.sm = sm
        self.md = md
        self.lg = lg
        self.xl = xl
        self.card = card
        self.button = button
        self.modal = modal
        self.dropdown = dropdown
    }
}

/// A shadow definition containing all properties needed for consistent shadows
public struct ShadowDefinition {
    let color: Color
    let radius: CGFloat
    let x: CGFloat
    let y: CGFloat
    
    public init(
        color: Color = .clear,
        radius: CGFloat = 0,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) {
        self.color = color
        self.radius = radius
        self.x = x
        self.y = y
    }
}

// MARK: - View Extension for Shadow Application
public extension View {
    func shadow(from definition: ShadowDefinition) -> some View {
        self.shadow(
            color: definition.color,
            radius: definition.radius,
            x: definition.x,
            y: definition.y
        )
    }
}
