import SwiftUI

/// A themed card component that never hardcodes any styling values
public struct Card<Content: View>: View {
    @Environment(\.theme) private var theme
    
    private let content: Content
    private let style: CardStyle
    private let padding: CardPadding
    
    /// Creates a themed card
    /// - Parameters:
    ///   - style: Visual style of the card (default: .elevated)
    ///   - padding: Internal padding preset (default: .medium)
    ///   - content: The content to display inside the card
    public init(
        style: CardStyle = .elevated,
        padding: CardPadding = .medium,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.padding = padding
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(paddingValue)
            .background(backgroundColor)
            .overlay(borderOverlay)
            .cornerRadius(cornerRadius)
            .shadow(
                color: shadowStyle.color,
                radius: shadowStyle.radius,
                x: shadowStyle.x,
                y: shadowStyle.y
            )
    }
    
    // MARK: - Computed Properties (All From Theme)
    
    private var backgroundColor: Color {
        switch style {
        case .elevated:
            return theme.colors.surfaceElevated
        case .flat:
            return theme.colors.surface
        case .outlined:
            return theme.colors.surface
        case .subtle:
            return theme.colors.backgroundSecondary
        }
    }
    
    private var borderOverlay: some View {
        Group {
            if style == .outlined {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(theme.colors.border, lineWidth: 1)
            }
        }
    }
    
    private var cornerRadius: CGFloat {
        theme.radius.lg
    }
    
    private var shadowStyle: ShadowStyle {
        switch style {
        case .elevated:
            return theme.shadow.md
        case .flat:
            return theme.shadow.sm
        case .outlined:
            return theme.shadow.none
        case .subtle:
            return theme.shadow.sm
        }
    }
    
    private var paddingValue: CGFloat {
        switch padding {
        case .none:
            return theme.spacing.xs
        case .small:
            return theme.spacing.md
        case .medium:
            return theme.spacing.lg
        case .large:
            return theme.spacing.xl
        case .extraLarge:
            return theme.spacing.xxl
        }
    }
}

// MARK: - Card Style

public enum CardStyle {
    case elevated    // With shadow, elevated background
    case flat        // Minimal shadow, surface background
    case outlined    // Border only, no shadow
    case subtle      // Secondary background, subtle shadow
}

// MARK: - Card Padding

public enum CardPadding {
    case none
    case small
    case medium
    case large
    case extraLarge
}

// MARK: - Convenience Initializers

extension Card {
    /// Creates an elevated card with default padding
    public static func elevated(@ViewBuilder content: () -> Content) -> Card {
        Card(style: .elevated, padding: .medium, content: content)
    }
    
    /// Creates a flat card with default padding
    public static func flat(@ViewBuilder content: () -> Content) -> Card {
        Card(style: .flat, padding: .medium, content: content)
    }
    
    /// Creates an outlined card with default padding
    public static func outlined(@ViewBuilder content: () -> Content) -> Card {
        Card(style: .outlined, padding: .medium, content: content)
    }
}
