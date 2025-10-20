//
//  ChartCard.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// A specialized card component designed for displaying charts and visualizations.
/// Extends the base Card with chart-specific styling and optional header/footer sections.
///
/// Example usage:
/// ```swift
/// ChartCard(
///     title: "Income vs Expenses",
///     subtitle: "Last 30 Days",
///     showLegend: true
/// ) {
///     // Chart content here
/// }
/// ```
public struct ChartCard<Content: View>: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    private let title: String?
    private let subtitle: String?
    private let showLegend: Bool
    private let elevation: CardElevation
    private let content: Content
    
    // MARK: - Initialization
    
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        showLegend: Bool = false,
        elevation: CardElevation = .medium,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.showLegend = showLegend
        self.elevation = elevation
        self.content = content()
    }
    
    // MARK: - Body
    
    public var body: some View {
        Card(elevation: elevation, padding: .none) {
            VStack(alignment: .leading, spacing: 0) {
                // Header (if title or subtitle provided)
                if title != nil || subtitle != nil {
                    headerSection
                        .padding(.horizontal, theme.spacing.cardPadding)
                        .padding(.top, theme.spacing.cardPadding)
                        .padding(.bottom, theme.spacing.md)
                }
                
                // Chart content
                content
                    .padding(.horizontal, theme.spacing.cardPadding)
                    .padding(.bottom, theme.spacing.cardPadding)
                
                // Legend note (if needed)
                if showLegend {
                    legendNote
                        .padding(.horizontal, theme.spacing.cardPadding)
                        .padding(.bottom, theme.spacing.sm)
                }
            }
        }
    }
    
    // MARK: - Subviews
    
    @ViewBuilder
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            if let title = title {
                Text(title)
                    .font(theme.typography.headingMedium)
                    .foregroundColor(theme.colors.onSurface)
            }
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
            }
        }
    }
    
    private var legendNote: some View {
        HStack(spacing: theme.spacing.xs) {
            Image(systemName: "info.circle")
                .font(.system(size: theme.spacing.iconSizeSmall))
                .foregroundColor(theme.colors.onSurfaceTertiary)
            
            Text("Tap legend items to toggle series visibility")
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.onSurfaceTertiary)
        }
        .padding(.top, theme.spacing.xs)
    }
}

// MARK: - Previews

#Preview("ChartCard - Basic") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 24) {
            ChartCard(
                title: "Sample Chart",
                subtitle: "Last 30 Days"
            ) {
                Rectangle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(height: 200)
                    .overlay(
                        Text("Chart Content Here")
                            .foregroundColor(.secondary)
                    )
            }
        }
        .padding()
    }
    .frame(width: 500, height: 400)
}

#Preview("ChartCard - Variants") {
    ThemeProvider(theme: NeutralTheme()) {
        VStack(spacing: 24) {
            // With title only
            ChartCard(title: "Title Only") {
                Rectangle()
                    .fill(Color.green.opacity(0.2))
                    .frame(height: 150)
            }
            
            // With title and subtitle
            ChartCard(
                title: "With Subtitle",
                subtitle: "Additional context"
            ) {
                Rectangle()
                    .fill(Color.orange.opacity(0.2))
                    .frame(height: 150)
            }
            
            // With legend
            ChartCard(
                title: "With Legend",
                showLegend: true
            ) {
                Rectangle()
                    .fill(Color.purple.opacity(0.2))
                    .frame(height: 150)
            }
        }
        .padding()
    }
    .frame(width: 500, height: 700)
}
