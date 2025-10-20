import SwiftUI

/// A themed card component that reads all styling from the environment theme
public struct Card<Content: View>: View {
    @Environment(\.theme) private var theme
    
    private let content: Content
    private let padding: EdgeInsets?
    private let backgroundColor: CardBackgroundColor
    private let border: CardBorder
    private let shadow: CardShadow
    
    // MARK: - Configuration Types
    public enum CardBackgroundColor {
        case surface
        case surfaceElevated
        case custom(Color)
    }
    
    public enum CardBorder {
        case none
        case subtle
        case strong
        case custom(Color, width: CGFloat = 1)
    }
    
    public enum CardShadow {
        case none
        case card
        case button
        case custom(ShadowDefinition)
    }
    
    // MARK: - Initializers
    public init(
        padding: EdgeInsets? = nil,
        backgroundColor: CardBackgroundColor = .surface,
        border: CardBorder = .subtle,
        shadow: CardShadow = .card,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.padding = padding
        self.backgroundColor = backgroundColor
        self.border = border
        self.shadow = shadow
    }
    
    public var body: some View {
        content
            .padding(resolvedPadding)
            .background(resolvedBackgroundColor)
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.card)
                    .stroke(resolvedBorderColor, lineWidth: resolvedBorderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.card))
            .shadow(from: resolvedShadow)
    }
    
    // MARK: - Computed Properties
    private var resolvedPadding: EdgeInsets {
        padding ?? EdgeInsets(
            top: theme.spacing.cardPadding,
            leading: theme.spacing.cardPadding,
            bottom: theme.spacing.cardPadding,
            trailing: theme.spacing.cardPadding
        )
    }
    
    private var resolvedBackgroundColor: Color {
        switch backgroundColor {
        case .surface:
            return theme.colors.surface
        case .surfaceElevated:
            return theme.colors.surfaceElevated
        case .custom(let color):
            return color
        }
    }
    
    private var resolvedBorderColor: Color {
        switch border {
        case .none:
            return .clear
        case .subtle:
            return theme.colors.borderSubtle
        case .strong:
            return theme.colors.borderStrong
        case .custom(let color, _):
            return color
        }
    }
    
    private var resolvedBorderWidth: CGFloat {
        switch border {
        case .none:
            return 0
        case .subtle, .strong:
            return 1
        case .custom(_, let width):
            return width
        }
    }
    
    private var resolvedShadow: ShadowDefinition {
        switch shadow {
        case .none:
            return theme.shadows.none
        case .card:
            return theme.shadows.card
        case .button:
            return theme.shadows.button
        case .custom(let definition):
            return definition
        }
    }
}

// MARK: - Convenience Initializers
public extension Card {
    /// Create a card with just content and default styling
    init(@ViewBuilder content: () -> Content) {
        self.init(
            padding: nil,
            backgroundColor: .surface,
            border: .subtle,
            shadow: .card,
            content: content
        )
    }
    
    /// Create a card with custom padding
    init(
        padding: CGFloat,
        @ViewBuilder content: () -> Content
    ) {
        self.init(
            padding: EdgeInsets(top: padding, leading: padding, bottom: padding, trailing: padding),
            backgroundColor: .surface,
            border: .subtle,
            shadow: .card,
            content: content
        )
    }
}
