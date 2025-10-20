//
//  DesignSystemPreviews.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// Comprehensive preview showcasing both themes side-by-side with various components.
struct DesignSystemPreviews: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                headerSection
                
                HStack(alignment: .top, spacing: 0) {
                    // Vibrant Theme
                    themeColumn(theme: VibrantTheme())
                    
                    Divider()
                    
                    // Neutral Theme
                    themeColumn(theme: NeutralTheme())
                }
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("Design System Preview")
                .font(.system(size: 28, weight: .bold))
            Text("Side-by-Side Theme Comparison")
                .font(.system(size: 14, weight: .regular))
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.gray.opacity(0.1))
    }
    
    private func themeColumn(theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 24) {
            // Theme name
            Text(theme.name)
                .font(theme.typography.headingLarge)
                .foregroundColor(theme.colors.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top)
            
            Group {
                // Color palette section
                colorPaletteSection(theme: theme)
                
                // Typography section
                typographySection(theme: theme)
                
                // Card examples
                cardExamplesSection(theme: theme)
                
                // Spacing examples
                spacingSection(theme: theme)
                
                // Shadow examples
                shadowSection(theme: theme)
            }
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity)
        .background(theme.colors.background)
        .withTheme(theme)
    }
    
    // MARK: - Color Palette Section
    
    private func colorPaletteSection(theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Color Palette")
                .font(theme.typography.headingMedium)
                .foregroundColor(theme.colors.onBackground)
            
            VStack(spacing: 8) {
                colorRow(theme: theme, label: "Primary", color: theme.colors.primary)
                colorRow(theme: theme, label: "Secondary", color: theme.colors.secondary)
                colorRow(theme: theme, label: "Success", color: theme.colors.success)
                colorRow(theme: theme, label: "Warning", color: theme.colors.warning)
                colorRow(theme: theme, label: "Error", color: theme.colors.error)
                colorRow(theme: theme, label: "Info", color: theme.colors.info)
            }
        }
    }
    
    private func colorRow(theme: AppTheme, label: String, color: Color) -> some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .fill(color)
                .frame(width: 40, height: 40)
            
            Text(label)
                .font(theme.typography.bodyMedium)
                .foregroundColor(theme.colors.onSurface)
            
            Spacer()
        }
        .padding(theme.spacing.sm)
        .background(theme.colors.surface)
        .cornerRadius(theme.radius.sm)
    }
    
    // MARK: - Typography Section
    
    private func typographySection(theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Typography")
                .font(theme.typography.headingMedium)
                .foregroundColor(theme.colors.onBackground)
            
            Card {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Display Large")
                        .font(theme.typography.displaySmall)
                        .foregroundColor(theme.colors.onSurface)
                    
                    Text("Heading Large")
                        .font(theme.typography.headingLarge)
                        .foregroundColor(theme.colors.onSurface)
                    
                    Text("Heading Medium")
                        .font(theme.typography.headingMedium)
                        .foregroundColor(theme.colors.onSurface)
                    
                    Text("Body Large - Lorem ipsum dolor sit amet")
                        .font(theme.typography.bodyLarge)
                        .foregroundColor(theme.colors.onSurface)
                    
                    Text("Body Medium - Lorem ipsum dolor sit amet")
                        .font(theme.typography.bodyMedium)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                    
                    Text("Caption - Additional information")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.onSurfaceTertiary)
                }
            }
        }
    }
    
    // MARK: - Card Examples Section
    
    private func cardExamplesSection(theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Card Variations")
                .font(theme.typography.headingMedium)
                .foregroundColor(theme.colors.onBackground)
            
            Card(elevation: .low, padding: .compact) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Low Elevation")
                        .font(theme.typography.labelLarge)
                        .foregroundColor(theme.colors.onSurface)
                    Text("Compact padding")
                        .font(theme.typography.bodySmall)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                }
            }
            
            Card(elevation: .medium) {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "dollarsign.circle.fill")
                            .font(.system(size: theme.spacing.iconSizeLarge))
                            .foregroundColor(theme.colors.primary)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Total Balance")
                                .font(theme.typography.labelMedium)
                                .foregroundColor(theme.colors.onSurfaceSecondary)
                            Text("$42,573.89")
                                .font(theme.typography.headingMedium)
                                .foregroundColor(theme.colors.onSurface)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        statusPill(theme: theme, label: "↑ 12.5%", color: theme.colors.success)
                        Text("vs last month")
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.onSurfaceTertiary)
                    }
                }
            }
            
            Card(elevation: .high, padding: .spacious) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("High Elevation")
                        .font(theme.typography.labelLarge)
                        .foregroundColor(theme.colors.onSurface)
                    Text("Spacious padding")
                        .font(theme.typography.bodySmall)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                }
            }
        }
    }
    
    private func statusPill(theme: AppTheme, label: String, color: Color) -> some View {
        Text(label)
            .font(theme.typography.labelSmall)
            .foregroundColor(color)
            .padding(.horizontal, theme.spacing.xs)
            .padding(.vertical, theme.spacing.xxs)
            .background(color.opacity(0.15))
            .cornerRadius(theme.radius.chip)
    }
    
    // MARK: - Spacing Section
    
    private func spacingSection(theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spacing Scale")
                .font(theme.typography.headingMedium)
                .foregroundColor(theme.colors.onBackground)
            
            Card {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    spacingBar(theme: theme, label: "XS", width: theme.spacing.xs * 4)
                    spacingBar(theme: theme, label: "SM", width: theme.spacing.sm * 4)
                    spacingBar(theme: theme, label: "MD", width: theme.spacing.md * 4)
                    spacingBar(theme: theme, label: "LG", width: theme.spacing.lg * 4)
                    spacingBar(theme: theme, label: "XL", width: theme.spacing.xl * 4)
                }
            }
        }
    }
    
    private func spacingBar(theme: AppTheme, label: String, width: CGFloat) -> some View {
        HStack(spacing: 8) {
            Text(label)
                .font(theme.typography.labelSmall)
                .foregroundColor(theme.colors.onSurfaceSecondary)
                .frame(width: 30, alignment: .leading)
            
            RoundedRectangle(cornerRadius: theme.radius.xs)
                .fill(theme.colors.primary)
                .frame(width: width, height: 8)
            
            Spacer()
        }
    }
    
    // MARK: - Shadow Section
    
    private func shadowSection(theme: AppTheme) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Shadow Elevations")
                .font(theme.typography.headingMedium)
                .foregroundColor(theme.colors.onBackground)
            
            HStack(spacing: theme.spacing.md) {
                shadowBox(theme: theme, label: "SM", shadow: theme.shadows.sm)
                shadowBox(theme: theme, label: "MD", shadow: theme.shadows.md)
                shadowBox(theme: theme, label: "LG", shadow: theme.shadows.lg)
            }
            
            Spacer().frame(height: 20)
        }
    }
    
    private func shadowBox(theme: AppTheme, label: String, shadow: ShadowToken) -> some View {
        VStack {
            Text(label)
                .font(theme.typography.labelSmall)
                .foregroundColor(theme.colors.onSurfaceSecondary)
        }
        .frame(width: 60, height: 60)
        .background(theme.colors.surface)
        .cornerRadius(theme.radius.md)
        .shadow(
            color: theme.colors.shadowMedium,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}

// MARK: - Individual Theme Previews

#Preview("Vibrant Theme Full") {
    ThemeProvider(theme: VibrantTheme()) {
        ScrollView {
            VStack(spacing: 24) {
                fullThemeDemo()
            }
            .padding()
        }
    }
    .frame(width: 400, height: 800)
}

#Preview("Neutral Theme Full") {
    ThemeProvider(theme: NeutralTheme()) {
        ScrollView {
            VStack(spacing: 24) {
                fullThemeDemo()
            }
            .padding()
        }
    }
    .frame(width: 400, height: 800)
}

#Preview("Side by Side") {
    DesignSystemPreviews()
        .frame(width: 1200, height: 900)
}

// MARK: - Helper Views

private func fullThemeDemo() -> some View {
    @Environment(\.theme) var theme
    
    return VStack(alignment: .leading, spacing: 24) {
        // Header
        VStack(alignment: .leading, spacing: 8) {
            Text("Dashboard")
                .font(theme.typography.displaySmall)
                .foregroundColor(theme.colors.onBackground)
            Text("Welcome back!")
                .font(theme.typography.bodyLarge)
                .foregroundColor(theme.colors.onSurfaceSecondary)
        }
        
        // Stats cards
        HStack(spacing: 16) {
            statCard(
                theme: theme,
                icon: "chart.line.uptrend.xyaxis",
                title: "Revenue",
                value: "$23,456",
                change: "+15.3%",
                isPositive: true
            )
            
            statCard(
                theme: theme,
                icon: "arrow.down.circle",
                title: "Expenses",
                value: "$12,890",
                change: "-8.2%",
                isPositive: true
            )
        }
        
        // Recent activity
        Card {
            VStack(alignment: .leading, spacing: 16) {
                Text("Recent Activity")
                    .font(theme.typography.headingSmall)
                    .foregroundColor(theme.colors.onSurface)
                
                ForEach(0..<3) { index in
                    activityRow(
                        theme: theme,
                        title: "Transaction \(index + 1)",
                        subtitle: "2 hours ago",
                        amount: "$\(Int.random(in: 100...999))"
                    )
                    
                    if index < 2 {
                        Divider()
                    }
                }
            }
        }
    }
}

private func statCard(
    theme: AppTheme,
    icon: String,
    title: String,
    value: String,
    change: String,
    isPositive: Bool
) -> some View {
    Card {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: theme.spacing.iconSize))
                    .foregroundColor(theme.colors.primary)
                Spacer()
            }
            
            Text(title)
                .font(theme.typography.labelMedium)
                .foregroundColor(theme.colors.onSurfaceSecondary)
            
            Text(value)
                .font(theme.typography.headingLarge)
                .foregroundColor(theme.colors.onSurface)
            
            Text(change)
                .font(theme.typography.labelSmall)
                .foregroundColor(isPositive ? theme.colors.success : theme.colors.error)
        }
    }
}

private func activityRow(
    theme: AppTheme,
    title: String,
    subtitle: String,
    amount: String
) -> some View {
    HStack {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(theme.typography.bodyMedium)
                .foregroundColor(theme.colors.onSurface)
            Text(subtitle)
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.onSurfaceTertiary)
        }
        
        Spacer()
        
        Text(amount)
            .font(theme.typography.labelLarge)
            .foregroundColor(theme.colors.onSurface)
    }
}
