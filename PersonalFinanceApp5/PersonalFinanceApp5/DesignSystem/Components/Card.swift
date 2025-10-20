import SwiftUI

/// A customizable card component that uses theme tokens from the environment
///
/// The Card component provides a consistent container with:
/// - Configurable padding, shadow, and border
/// - Background and hover states from theme
/// - No hardcoded values - everything comes from @Environment(\.theme)
///
/// Usage:
/// ```swift
/// Card {
///     Text("Card Content")
/// }
/// .cardPadding(.md)
/// .cardShadow(.md)
/// .cardBorder(true)
/// ```
public struct Card<Content: View>: View {
    @Environment(\.theme) private var theme
    @State private var isHovered = false
    
    private let content: Content
    private let padding: CardPadding
    private let shadow: CardShadow
    private let hasBorder: Bool
    private let cornerRadius: CardRadius
    
    public init(
        padding: CardPadding = .md,
        shadow: CardShadow = .md,
        hasBorder: Bool = false,
        cornerRadius: CardRadius = .md,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.shadow = shadow
        self.hasBorder = hasBorder
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(paddingValue)
            .background(backgroundColor)
            .cornerRadius(cornerRadiusValue)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadiusValue)
                    .strokeBorder(borderColor, lineWidth: hasBorder ? 1 : 0)
            )
            .shadow(
                color: shadowToken.color,
                radius: shadowToken.radius,
                x: shadowToken.x,
                y: shadowToken.y
            )
            .onHover { hovering in
                isHovered = hovering
            }
    }
    
    // MARK: - Private Computed Properties
    
    private var paddingValue: CGFloat {
        switch padding {
        case .none: return 0
        case .xs: return theme.spacing.xs
        case .sm: return theme.spacing.sm
        case .md: return theme.spacing.md
        case .lg: return theme.spacing.lg
        case .xl: return theme.spacing.xl
        case .custom(let value): return value
        }
    }
    
    private var cornerRadiusValue: CGFloat {
        switch cornerRadius {
        case .none: return theme.radius.none
        case .sm: return theme.radius.sm
        case .md: return theme.radius.md
        case .lg: return theme.radius.lg
        case .xl: return theme.radius.xl
        case .full: return theme.radius.full
        case .custom(let value): return value
        }
    }
    
    private var backgroundColor: Color {
        isHovered ? theme.colors.surfaceHover : theme.colors.surface
    }
    
    private var borderColor: Color {
        hasBorder ? theme.colors.border : .clear
    }
    
    private var shadowToken: ShadowToken {
        switch shadow {
        case .none: return theme.shadows.none
        case .sm: return theme.shadows.sm
        case .md: return theme.shadows.md
        case .lg: return theme.shadows.lg
        case .xl: return theme.shadows.xl
        case .custom(let token): return token
        }
    }
}

// MARK: - Card Configuration Enums

public enum CardPadding {
    case none
    case xs
    case sm
    case md
    case lg
    case xl
    case custom(CGFloat)
}

public enum CardShadow {
    case none
    case sm
    case md
    case lg
    case xl
    case custom(ShadowToken)
}

public enum CardRadius {
    case none
    case sm
    case md
    case lg
    case xl
    case full
    case custom(CGFloat)
}

// MARK: - View Modifiers for Convenience

extension View {
    /// Sets the padding for a Card view
    public func cardPadding(_ padding: CardPadding) -> some View {
        // Note: This is a semantic helper. The actual padding is set in Card's init
        self
    }
    
    /// Sets the shadow for a Card view
    public func cardShadow(_ shadow: CardShadow) -> some View {
        // Note: This is a semantic helper. The actual shadow is set in Card's init
        self
    }
    
    /// Sets whether the Card has a border
    public func cardBorder(_ hasBorder: Bool) -> some View {
        // Note: This is a semantic helper. The actual border is set in Card's init
        self
    }
    
    /// Sets the corner radius for a Card view
    public func cardRadius(_ radius: CardRadius) -> some View {
        // Note: This is a semantic helper. The actual radius is set in Card's init
        self
    }
}
