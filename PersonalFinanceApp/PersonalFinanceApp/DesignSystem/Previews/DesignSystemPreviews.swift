import SwiftUI

/// Comprehensive previews showcasing both themes side-by-side
struct DesignSystemPreviews: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Theme Comparison Header
                Text("Design System Themes")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Side-by-side theme comparison
                HStack(alignment: .top, spacing: 24) {
                    VStack {
                        Text("Vibrant Theme")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                        
                        ThemeShowcase()
                            .theme(VibrantTheme())
                    }
                    
                    VStack {
                        Text("Neutral Theme")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                        
                        ThemeShowcase()
                            .theme(NeutralTheme())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

/// Individual theme showcase displaying all components
private struct ThemeShowcase: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.lg) {
            // Color Palette Section
            ColorPalettePreview()
            
            // Card Variations Section
            CardVariationsPreview()
            
            // Typography Section
            TypographyPreview()
            
            // Interactive Elements Section
            InteractiveElementsPreview()
        }
        .padding(theme.spacing.md)
        .background(theme.colors.background)
        .cornerRadius(theme.radius.xl)
    }
}

// MARK: - Color Palette Preview
private struct ColorPalettePreview: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Colors")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: theme.spacing.xs) {
                ColorSwatch("Primary", color: theme.colors.primary)
                ColorSwatch("Secondary", color: theme.colors.secondary)
                ColorSwatch("Success", color: theme.colors.success)
                ColorSwatch("Warning", color: theme.colors.warning)
                ColorSwatch("Error", color: theme.colors.error)
                ColorSwatch("Info", color: theme.colors.info)
                ColorSwatch("Surface", color: theme.colors.surface)
                ColorSwatch("Background", color: theme.colors.background)
            }
        }
    }
}

private struct ColorSwatch: View {
    @Environment(\.theme) private var theme
    let name: String
    let color: Color
    
    init(_ name: String, color: Color) {
        self.name = name
        self.color = color
    }
    
    var body: some View {
        VStack(spacing: theme.spacing.xs) {
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .fill(color)
                .frame(height: 32)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.radius.sm)
                        .stroke(theme.colors.border, lineWidth: 0.5)
                )
            
            Text(name)
                .font(theme.typography.captionFont)
                .foregroundColor(theme.colors.textSecondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}

// MARK: - Card Variations Preview
private struct CardVariationsPreview: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Card Styles")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            VStack(spacing: theme.spacing.sm) {
                // Default Card
                Card {
                    CardContent(title: "Default Card", description: "Standard surface with shadow")
                }
                
                // Outlined Card
                Card.outlined {
                    CardContent(title: "Outlined Card", description: "Border with minimal shadow")
                }
                
                // Filled Card
                Card.filled {
                    CardContent(title: "Filled Card", description: "Surface variant background")
                }
            }
        }
    }
}

private struct CardContent: View {
    @Environment(\.theme) private var theme
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                Text(title)
                    .cardTitle()
                
                Text(description)
                    .cardCaption()
            }
            
            Spacer()
            
            // Sample financial data
            VStack(alignment: .trailing, spacing: theme.spacing.xs) {
                Text("$1,234.56")
                    .font(theme.typography.font(size: theme.typography.callout, weight: theme.typography.semibold))
                    .foregroundColor(theme.colors.success)
                
                Text("+12.3%")
                    .font(theme.typography.captionFont)
                    .foregroundColor(theme.colors.success)
            }
        }
    }
}

// MARK: - Typography Preview
private struct TypographyPreview: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Typography")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            Card {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text("Large Title")
                        .font(theme.typography.largeTitleFont)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Title 1 - Main Headers")
                        .font(theme.typography.title1Font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Headline - Section Headers")
                        .font(theme.typography.headlineFont)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Body - Regular content and descriptions")
                        .font(theme.typography.bodyFont)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Caption - Small supporting text")
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

// MARK: - Interactive Elements Preview
private struct InteractiveElementsPreview: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Interactive Elements")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            Card {
                VStack(spacing: theme.spacing.md) {
                    // Buttons Row
                    HStack(spacing: theme.spacing.sm) {
                        ThemedButton(title: "Primary", style: .primary)
                        ThemedButton(title: "Secondary", style: .secondary)
                    }
                    
                    // Status Indicators
                    HStack(spacing: theme.spacing.sm) {
                        StatusBadge(status: .paid)
                        StatusBadge(status: .due)
                        StatusBadge(status: .late)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

// MARK: - Supporting Components for Preview
private struct ThemedButton: View {
    @Environment(\.theme) private var theme
    let title: String
    let style: ButtonStyle
    
    enum ButtonStyle {
        case primary, secondary
    }
    
    var body: some View {
        Button(title) {
            // Preview action
        }
        .font(theme.typography.font(size: theme.typography.callout, weight: theme.typography.medium))
        .foregroundColor(foregroundColor)
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.buttonPadding)
        .background(backgroundColor)
        .cornerRadius(theme.radius.button)
        .shadow(theme.shadows.subtle)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return theme.colors.primary
        case .secondary:
            return theme.colors.secondary
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return theme.colors.onPrimary
        case .secondary:
            return theme.colors.onSecondary
        }
    }
}

// MARK: - Preview Provider
#Preview("Design System Comparison") {
    DesignSystemPreviews()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}

#Preview("Vibrant Theme Only") {
    ThemeShowcase()
        .theme(VibrantTheme())
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}

#Preview("Neutral Theme Only") {
    ThemeShowcase()
        .theme(NeutralTheme())
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}