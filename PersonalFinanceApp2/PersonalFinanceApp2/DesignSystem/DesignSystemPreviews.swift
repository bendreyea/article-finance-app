import SwiftUI

/// Preview showcasing the design system with both themes side-by-side
struct DesignSystemPreviews: View {
    var body: some View {
        HStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Vibrant Theme")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ThemeShowcase()
                    .theme(VibrantTheme())
            }
            
            VStack(alignment: .leading, spacing: 16) {
                Text("Neutral Theme")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ThemeShowcase()
                    .theme(NeutralTheme())
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

/// A comprehensive showcase of design system components
private struct ThemeShowcase: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sectionSpacing) {
            // Colors Section
            ColorsSection()
            
            // Typography Section
            TypographySection()
            
            // Cards Section
            CardsSection()
            
            // Interactive Elements
            InteractiveSection()
        }
        .frame(width: 320)
    }
}

// MARK: - Color Showcase
private struct ColorsSection: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.componentSpacing) {
                Text("Colors")
                    .font(theme.typography.headline)
                    .fontWeight(theme.typography.semibold)
                    .foregroundColor(theme.colors.textPrimary)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: theme.spacing.sm), count: 3), spacing: theme.spacing.sm) {
                    ColorSwatch(color: theme.colors.brandPrimary, label: "Primary")
                    ColorSwatch(color: theme.colors.brandSecondary, label: "Secondary")
                    ColorSwatch(color: theme.colors.success, label: "Success")
                    ColorSwatch(color: theme.colors.warning, label: "Warning")
                    ColorSwatch(color: theme.colors.error, label: "Error")
                    ColorSwatch(color: theme.colors.info, label: "Info")
                }
            }
        }
    }
}

private struct ColorSwatch: View {
    @Environment(\.theme) private var theme
    let color: Color
    let label: String
    
    var body: some View {
        VStack(spacing: theme.spacing.xs) {
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .fill(color)
                .frame(height: 32)
            
            Text(label)
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.textSecondary)
        }
    }
}

// MARK: - Typography Showcase
private struct TypographySection: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.componentSpacing) {
                Text("Typography")
                    .font(theme.typography.headline)
                    .fontWeight(theme.typography.semibold)
                    .foregroundColor(theme.colors.textPrimary)
                
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Large Title")
                        .font(theme.typography.largeTitle)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Title 1")
                        .font(theme.typography.title1)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Headline")
                        .font(theme.typography.headline)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Body text for regular content")
                        .font(theme.typography.body)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Text("Caption text for supplementary information")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.textTertiary)
                }
            }
        }
    }
}

// MARK: - Cards Showcase
private struct CardsSection: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.componentSpacing) {
            Text("Cards & Surfaces")
                .font(theme.typography.headline)
                .fontWeight(theme.typography.semibold)
                .foregroundColor(theme.colors.textPrimary)
            
            Card(backgroundColor: .surface) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Default Card")
                        .font(theme.typography.subheadline)
                        .fontWeight(theme.typography.medium)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("This is a standard card with default styling applied from the theme.")
                        .font(theme.typography.body)
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
            
            Card(backgroundColor: .surfaceElevated, shadow: .button) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Elevated Card")
                        .font(theme.typography.subheadline)
                        .fontWeight(theme.typography.medium)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("This card uses elevated surface styling.")
                        .font(theme.typography.body)
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
        }
    }
}

// MARK: - Interactive Elements Showcase
private struct InteractiveSection: View {
    @Environment(\.theme) private var theme
    @State private var isToggled = false
    
    var body: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.componentSpacing) {
                Text("Interactive Elements")
                    .font(theme.typography.headline)
                    .fontWeight(theme.typography.semibold)
                    .foregroundColor(theme.colors.textPrimary)
                
                VStack(spacing: theme.spacing.md) {
                    // Primary Button
                    Button("Primary Action") {
                        // Action
                    }
                    .buttonStyle(ThemedButtonStyle(style: .primary))
                    
                    // Secondary Button
                    Button("Secondary Action") {
                        // Action
                    }
                    .buttonStyle(ThemedButtonStyle(style: .secondary))
                    
                    // Toggle
                    Toggle("Enable Feature", isOn: $isToggled)
                        .toggleStyle(ThemedToggleStyle())
                }
            }
        }
    }
}

// MARK: - Themed Button Style
private struct ThemedButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    
    enum Style {
        case primary
        case secondary
    }
    
    let style: Style
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.typography.callout)
            .fontWeight(theme.typography.medium)
            .foregroundColor(foregroundColor)
            .padding(.horizontal, theme.spacing.lg)
            .padding(.vertical, theme.spacing.md)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.button))
            .shadow(from: theme.shadows.button)
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return theme.colors.brandPrimary
        case .secondary:
            return theme.colors.surface
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return theme.colors.textInverse
        case .secondary:
            return theme.colors.brandPrimary
        }
    }
}

// MARK: - Themed Toggle Style
private struct ThemedToggleStyle: ToggleStyle {
    @Environment(\.theme) private var theme
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
                .font(theme.typography.body)
                .foregroundColor(theme.colors.textPrimary)
            
            Spacer()
            
            RoundedRectangle(cornerRadius: theme.radius.pill)
                .fill(configuration.isOn ? theme.colors.brandPrimary : theme.colors.border)
                .frame(width: 48, height: 28)
                .overlay(
                    Circle()
                        .fill(theme.colors.surface)
                        .frame(width: 24, height: 24)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

#Preview("Design System Showcase") {
    DesignSystemPreviews()
}
