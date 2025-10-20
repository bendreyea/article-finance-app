import SwiftUI

/// A versatile card component that adapts its appearance based on the current theme
public struct Card<Content: View>: View {
    @Environment(\.theme) private var theme
    
    private let content: Content
    private let style: CardStyle
    private let elevation: CardElevation
    private let padding: EdgeInsets?
    
    /// Creates a card with the specified content and styling options
    /// - Parameters:
    ///   - style: The visual style of the card
    ///   - elevation: The shadow elevation level
    ///   - padding: Custom padding override (uses theme default if nil)
    ///   - content: The content to display inside the card
    public init(
        style: CardStyle = .default,
        elevation: CardElevation = .medium,
        padding: EdgeInsets? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.elevation = elevation
        self.padding = padding
        self.content = content()
    }
    
    public var body: some View {
        content
            .padding(effectivePadding)
            .background(backgroundColor)
            .cornerRadius(theme.radius.card)
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.card)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(shadowTokens)
    }
    
    // MARK: - Private Computed Properties
    
    private var effectivePadding: EdgeInsets {
        padding ?? EdgeInsets(
            top: theme.spacing.cardPadding,
            leading: theme.spacing.cardPadding,
            bottom: theme.spacing.cardPadding,
            trailing: theme.spacing.cardPadding
        )
    }
    
    private var backgroundColor: Color {
        switch style {
        case .default:
            return theme.colors.surface
        case .elevated:
            return theme.colors.surface
        case .outlined:
            return theme.colors.surface
        case .filled:
            return theme.colors.surfaceVariant
        case .primary:
            return theme.colors.primary
        case .secondary:
            return theme.colors.secondary
        }
    }
    
    private var borderColor: Color {
        switch style {
        case .outlined:
            return theme.colors.border
        default:
            return Color.clear
        }
    }
    
    private var borderWidth: CGFloat {
        switch style {
        case .outlined:
            return 1
        default:
            return 0
        }
    }
    
    private var shadowTokens: ShadowTokens {
        switch elevation {
        case .none:
            return theme.shadows.none
        case .subtle:
            return theme.shadows.subtle
        case .medium:
            return theme.shadows.card
        case .high:
            return theme.shadows.elevated
        case .dramatic:
            return theme.shadows.dramatic
        }
    }
}

// MARK: - Card Style
public enum CardStyle {
    case `default`      // Standard surface color with shadow
    case elevated       // Same as default but with higher elevation
    case outlined       // Surface color with border, minimal shadow
    case filled         // Surface variant color
    case primary        // Primary color background
    case secondary      // Secondary color background
}

// MARK: - Card Elevation
public enum CardElevation {
    case none           // No shadow
    case subtle         // Very light shadow
    case medium         // Standard card shadow
    case high           // Elevated shadow
    case dramatic       // High impact shadow
}

// MARK: - Convenience Initializers
extension Card {
    /// Creates a standard card with default styling
    public init(@ViewBuilder content: () -> Content) {
        self.init(style: .default, elevation: .medium, content: content)
    }
    
    /// Creates an outlined card with border and minimal shadow
    public static func outlined(@ViewBuilder content: () -> Content) -> Card {
        Card(style: .outlined, elevation: .subtle, content: content)
    }
    
    /// Creates an elevated card with higher shadow
    public static func elevated(@ViewBuilder content: () -> Content) -> Card {
        Card(style: .elevated, elevation: .high, content: content)
    }
    
    /// Creates a filled card with surface variant background
    public static func filled(@ViewBuilder content: () -> Content) -> Card {
        Card(style: .filled, elevation: .medium, content: content)
    }
}

// MARK: - Theme-Aware Text Styles for Card Content
extension Text {
    /// Applies card title styling from the current theme
    public func cardTitle() -> some View {
        CardTitleText(self)
    }
    
    /// Applies card body styling from the current theme
    public func cardBody() -> some View {
        CardBodyText(self)
    }
    
    /// Applies card caption styling from the current theme
    public func cardCaption() -> some View {
        CardCaptionText(self)
    }
}

// MARK: - Internal Text Style Views
private struct CardTitleText: View {
    @Environment(\.theme) private var theme
    private let text: Text
    
    init(_ text: Text) {
        self.text = text
    }
    
    var body: some View {
        text
            .font(theme.typography.headlineFont)
            .foregroundColor(theme.colors.textPrimary)
    }
}

private struct CardBodyText: View {
    @Environment(\.theme) private var theme
    private let text: Text
    
    init(_ text: Text) {
        self.text = text
    }
    
    var body: some View {
        text
            .font(theme.typography.bodyFont)
            .foregroundColor(theme.colors.textPrimary)
    }
}

private struct CardCaptionText: View {
    @Environment(\.theme) private var theme
    private let text: Text
    
    init(_ text: Text) {
        self.text = text
    }
    
    var body: some View {
        text
            .font(theme.typography.captionFont)
            .foregroundColor(theme.colors.textSecondary)
    }
}