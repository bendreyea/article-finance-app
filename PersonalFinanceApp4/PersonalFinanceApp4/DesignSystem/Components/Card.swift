//
//  Card.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// A flexible card component that reads all styling from the current theme.
/// This component NEVER hardcodes values - everything comes from @Environment(\.theme).
///
/// Example usage:
/// ```swift
/// Card {
///     VStack(alignment: .leading, spacing: 12) {
///         Text("Balance")
///             .font(theme.typography.labelMedium)
///         Text("$12,345.67")
///             .font(theme.typography.headingLarge)
///     }
/// }
/// ```
public struct Card<Content: View>: View {
    @Environment(\.theme) private var theme
    
    private let content: Content
    private let elevation: CardElevation
    private let padding: CardPadding
    
    public init(
        elevation: CardElevation = .medium,
        padding: CardPadding = .standard,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.elevation = elevation
        self.padding = padding
    }
    
    public var body: some View {
        content
            .padding(paddingValue)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(theme.colors.surface)
            .cornerRadius(theme.radius.card)
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.card)
                    .strokeBorder(theme.colors.border, lineWidth: borderWidth)
            )
            .shadow(
                color: shadowColor,
                radius: shadowToken.radius,
                x: shadowToken.x,
                y: shadowToken.y
            )
    }
    
    // MARK: - Computed Properties (All theme-driven)
    
    private var paddingValue: CGFloat {
        switch padding {
        case .none:
            return 0
        case .compact:
            return theme.spacing.md
        case .standard:
            return theme.spacing.cardPadding
        case .spacious:
            return theme.spacing.lg
        case .custom(let value):
            return value
        }
    }
    
    private var shadowToken: ShadowToken {
        switch elevation {
        case .none:
            return theme.shadows.none
        case .low:
            return theme.shadows.sm
        case .medium:
            return theme.shadows.card
        case .high:
            return theme.shadows.lg
        }
    }
    
    private var shadowColor: Color {
        switch elevation {
        case .none:
            return .clear
        case .low:
            return theme.colors.shadowLight
        case .medium:
            return theme.colors.shadowMedium
        case .high:
            return theme.colors.shadowHeavy
        }
    }
    
    private var borderWidth: CGFloat {
        // Subtle border for definition
        return 1.0
    }
}

// MARK: - Card Configuration Enums

/// Defines the elevation (shadow depth) of a card.
public enum CardElevation {
    case none
    case low
    case medium
    case high
}

/// Defines the internal padding of a card.
public enum CardPadding {
    case none
    case compact
    case standard
    case spacious
    case custom(CGFloat)
}

// MARK: - Card Variants

extension Card {
    /// A hoverable card that increases elevation on hover.
    public func hoverable() -> some View {
        HoverableCard(elevation: elevation, padding: padding) {
            content
        }
    }
}

/// Internal hoverable card implementation.
private struct HoverableCard<Content: View>: View {
    @Environment(\.theme) private var theme
    @State private var isHovered = false
    
    private let content: Content
    private let elevation: CardElevation
    private let padding: CardPadding
    
    init(
        elevation: CardElevation,
        padding: CardPadding,
        @ViewBuilder content: () -> Content
    ) {
        self.elevation = elevation
        self.padding = padding
        self.content = content()
    }
    
    var body: some View {
        Card(
            elevation: isHovered ? .high : elevation,
            padding: padding
        ) {
            content
        }
        .scaleEffect(isHovered ? 1.02 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}

// MARK: - Previews

#Preview("Card Styles") {
    VStack(spacing: 24) {
        Card(elevation: .none) {
            VStack(alignment: .leading, spacing: 8) {
                Text("No Elevation")
                    .font(.headline)
                Text("A flat card with no shadow")
                    .font(.caption)
            }
        }
        
        Card(elevation: .low) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Low Elevation")
                    .font(.headline)
                Text("Subtle shadow for gentle depth")
                    .font(.caption)
            }
        }
        
        Card(elevation: .medium) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Medium Elevation")
                    .font(.headline)
                Text("Standard card shadow (default)")
                    .font(.caption)
            }
        }
        
        Card(elevation: .high) {
            VStack(alignment: .leading, spacing: 8) {
                Text("High Elevation")
                    .font(.headline)
                Text("Prominent shadow for emphasis")
                    .font(.caption)
            }
        }
    }
    .padding()
    .withTheme(VibrantTheme())
}
