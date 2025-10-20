import SwiftUI

/// Preview demonstrating side-by-side theme comparisons
struct CardPreview: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.xl) {
            // Theme Header
            Text(theme.name)
                .font(theme.typography.headingLarge)
                .foregroundColor(theme.colors.textPrimary)
            
            // Card Styles Demo
            VStack(spacing: theme.spacing.lg) {
                Card(style: .elevated) {
                    cardContent(title: "Elevated Card", subtitle: "With shadow elevation")
                }
                
                Card(style: .flat) {
                    cardContent(title: "Flat Card", subtitle: "Minimal shadow")
                }
                
                Card(style: .outlined) {
                    cardContent(title: "Outlined Card", subtitle: "Border only")
                }
                
                Card(style: .subtle) {
                    cardContent(title: "Subtle Card", subtitle: "Secondary background")
                }
            }
            
            // Padding Demo
            Card(style: .elevated, padding: .small) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Small Padding")
                        .font(theme.typography.labelMedium)
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
            
            // Color Palette
            colorPaletteSection
            
            // Typography Sample
            typographySection
        }
        .padding(theme.spacing.xl)
        .frame(maxWidth: 400)
    }
    
    @ViewBuilder
    private func cardContent(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text(title)
                .font(theme.typography.headingSmall)
                .foregroundColor(theme.colors.textPrimary)
            
            Text(subtitle)
                .font(theme.typography.bodyMedium)
                .foregroundColor(theme.colors.textSecondary)
            
            HStack(spacing: theme.spacing.sm) {
                colorDot(theme.colors.success)
                colorDot(theme.colors.warning)
                colorDot(theme.colors.error)
                colorDot(theme.colors.info)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var colorPaletteSection: some View {
        Card(style: .elevated) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Color Palette")
                    .font(theme.typography.headingSmall)
                    .foregroundColor(theme.colors.textPrimary)
                
                HStack(spacing: theme.spacing.sm) {
                    ForEach(0..<5, id: \.self) { index in
                        RoundedRectangle(cornerRadius: theme.radius.sm)
                            .fill(theme.colors.chartPrimary[index])
                            .frame(width: 40, height: 40)
                    }
                }
                
                HStack(spacing: theme.spacing.sm) {
                    colorSwatch(theme.colors.accentPrimary, "Accent")
                    colorSwatch(theme.colors.success, "Success")
                    colorSwatch(theme.colors.error, "Error")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var typographySection: some View {
        Card(style: .outlined) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Typography")
                    .font(theme.typography.headingSmall)
                    .foregroundColor(theme.colors.textPrimary)
                
                Text("Display Large")
                    .font(theme.typography.displaySmall)
                    .foregroundColor(theme.colors.textPrimary)
                
                Text("Body text with regular weight")
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.textSecondary)
                
                Text("Small label text")
                    .font(theme.typography.labelSmall)
                    .foregroundColor(theme.colors.textTertiary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func colorDot(_ color: Color) -> some View {
        Circle()
            .fill(color)
            .frame(width: 12, height: 12)
    }
    
    private func colorSwatch(_ color: Color, _ label: String) -> some View {
        VStack(spacing: theme.spacing.xs) {
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .fill(color)
                .frame(width: 50, height: 30)
            
            Text(label)
                .font(theme.typography.labelSmall)
                .foregroundColor(theme.colors.textTertiary)
        }
    }
}

#Preview("Side-by-Side Themes") {
    HStack(spacing: 40) {
        ScrollView {
            CardPreview()
                .themed(VibrantTheme())
        }
        .frame(maxHeight: 800)
        
        ScrollView {
            CardPreview()
                .themed(NeutralTheme())
        }
        .frame(maxHeight: 800)
    }
    .padding()
    .frame(minWidth: 900, minHeight: 800)
}

#Preview("Vibrant Theme") {
    ScrollView {
        CardPreview()
            .themed(VibrantTheme())
    }
    .frame(width: 450, height: 800)
}

#Preview("Neutral Theme") {
    ScrollView {
        CardPreview()
            .themed(NeutralTheme())
    }
    .frame(width: 450, height: 800)
}

#Preview("Interactive Theme Comparison") {
    ThemeComparisonView()
}

// Interactive comparison view
struct ThemeComparisonView: View {
    @State private var selectedTheme: ThemeSelection = .vibrant
    
    enum ThemeSelection: String, CaseIterable {
        case vibrant = "Vibrant"
        case neutral = "Neutral"
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Theme Picker
            Picker("Theme", selection: $selectedTheme) {
                ForEach(ThemeSelection.allCases, id: \.self) { theme in
                    Text(theme.rawValue).tag(theme)
                }
            }
            .pickerStyle(.segmented)
            .padding()
            
            // Preview Content
            ScrollView {
                CardPreview()
                    .themed(currentTheme)
            }
        }
        .frame(width: 450, height: 800)
    }
    
    private var currentTheme: AppTheme {
        switch selectedTheme {
        case .vibrant:
            return VibrantTheme()
        case .neutral:
            return NeutralTheme()
        }
    }
}
