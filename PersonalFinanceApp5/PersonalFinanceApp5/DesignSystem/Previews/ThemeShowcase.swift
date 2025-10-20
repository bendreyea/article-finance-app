import SwiftUI

/// Comprehensive preview showcasing both themes side-by-side
struct ThemeShowcase: View {
    var body: some View {
        HStack(spacing: 40) {
            // Vibrant Theme Column
            VStack(spacing: 20) {
                Text("Vibrant Theme")
                    .font(.system(size: 24, weight: .bold))
                
                ThemeProvider(theme: VibrantTheme()) {
                    ThemePreviewContent()
                }
            }
            .frame(maxWidth: .infinity)
            
            // Neutral Theme Column
            VStack(spacing: 20) {
                Text("Neutral Theme")
                    .font(.system(size: 24, weight: .bold))
                
                ThemeProvider(theme: NeutralTheme()) {
                    ThemePreviewContent()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .padding(40)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(white: 0.95))
    }
}

/// Reusable preview content that demonstrates theme usage
struct ThemePreviewContent: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Color Swatches
                colorSwatchesSection
                
                // Cards with Different Styles
                cardVariationsSection
                
                // Typography Examples
                typographySection
                
                // Semantic Colors
                semanticColorsSection
            }
            .padding()
        }
        .frame(maxHeight: 800)
        .background(theme.colors.background)
    }
    
    // MARK: - Color Swatches
    
    private var colorSwatchesSection: some View {
        Card(padding: .md, shadow: .md) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Primary Colors")
                    .font(theme.typography.titleMedium.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                HStack(spacing: theme.spacing.sm) {
                    colorSwatch(theme.colors.primary, "Primary")
                    colorSwatch(theme.colors.primaryHover, "Hover")
                    colorSwatch(theme.colors.primaryActive, "Active")
                }
            }
        }
    }
    
    private func colorSwatch(_ color: Color, _ label: String) -> some View {
        VStack(spacing: theme.spacing.xs) {
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .fill(color)
                .frame(width: 60, height: 60)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.radius.sm)
                        .strokeBorder(theme.colors.border, lineWidth: 1)
                )
            
            Text(label)
                .font(theme.typography.labelSmall.font)
                .foregroundColor(theme.colors.textSecondary)
        }
    }
    
    // MARK: - Card Variations
    
    private var cardVariationsSection: some View {
        VStack(spacing: theme.spacing.md) {
            Card(padding: .sm, shadow: .sm, hasBorder: false) {
                cardContent("Small Card", "sm padding, sm shadow")
            }
            
            Card(padding: .md, shadow: .md, hasBorder: true) {
                cardContent("Medium Card", "md padding, md shadow, border")
            }
            
            Card(padding: .lg, shadow: .lg, hasBorder: false) {
                cardContent("Large Card", "lg padding, lg shadow")
            }
        }
    }
    
    private func cardContent(_ title: String, _ description: String) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            Text(title)
                .font(theme.typography.titleMedium.font)
                .foregroundColor(theme.colors.textPrimary)
            
            Text(description)
                .font(theme.typography.bodySmall.font)
                .foregroundColor(theme.colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Typography
    
    private var typographySection: some View {
        Card(padding: .md, shadow: .md) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text("Typography Scale")
                    .font(theme.typography.titleLarge.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                typographyExample(theme.typography.headlineLarge, "Headline Large")
                typographyExample(theme.typography.headlineMedium, "Headline Medium")
                typographyExample(theme.typography.titleMedium, "Title Medium")
                typographyExample(theme.typography.bodyMedium, "Body Medium")
                typographyExample(theme.typography.labelMedium, "Label Medium")
            }
        }
    }
    
    private func typographyExample(_ token: TypographyToken, _ label: String) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            Text(label)
                .font(token.font)
                .foregroundColor(theme.colors.textPrimary)
            
            Text("Size: \(Int(token.size))pt • Weight: \(token.weight.description)")
                .font(theme.typography.labelSmall.font)
                .foregroundColor(theme.colors.textTertiary)
        }
    }
    
    // MARK: - Semantic Colors
    
    private var semanticColorsSection: some View {
        Card(padding: .md, shadow: .md) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Semantic Colors")
                    .font(theme.typography.titleMedium.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                VStack(spacing: theme.spacing.xs) {
                    semanticBadge(
                        color: theme.colors.success,
                        background: theme.colors.successBackground,
                        label: "Success"
                    )
                    
                    semanticBadge(
                        color: theme.colors.warning,
                        background: theme.colors.warningBackground,
                        label: "Warning"
                    )
                    
                    semanticBadge(
                        color: theme.colors.error,
                        background: theme.colors.errorBackground,
                        label: "Error"
                    )
                    
                    semanticBadge(
                        color: theme.colors.info,
                        background: theme.colors.infoBackground,
                        label: "Info"
                    )
                }
            }
        }
    }
    
    private func semanticBadge(color: Color, background: Color, label: String) -> some View {
        HStack {
            Text(label)
                .font(theme.typography.labelMedium.font)
                .foregroundColor(color)
            
            Spacer()
            
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
        }
        .padding(theme.spacing.sm)
        .background(background)
        .cornerRadius(theme.radius.sm)
    }
}

// MARK: - Weight Description Extension

extension Font.Weight {
    var description: String {
        switch self {
        case .ultraLight: return "Ultra Light"
        case .thin: return "Thin"
        case .light: return "Light"
        case .regular: return "Regular"
        case .medium: return "Medium"
        case .semibold: return "Semibold"
        case .bold: return "Bold"
        case .heavy: return "Heavy"
        case .black: return "Black"
        default: return "Custom"
        }
    }
}

// MARK: - Previews

#Preview("Theme Showcase") {
    ThemeShowcase()
        .frame(width: 1400, height: 900)
}

#Preview("Vibrant Theme Only") {
    ThemeProvider(theme: VibrantTheme()) {
        ThemePreviewContent()
    }
    .frame(width: 600, height: 900)
}

#Preview("Neutral Theme Only") {
    ThemeProvider(theme: NeutralTheme()) {
        ThemePreviewContent()
    }
    .frame(width: 600, height: 900)
}
