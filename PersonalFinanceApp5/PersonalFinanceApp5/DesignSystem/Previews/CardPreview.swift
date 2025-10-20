import SwiftUI

/// Preview demonstrating Card component with both themes
struct CardPreview: View {
    var body: some View {
        HStack(spacing: 40) {
            // Vibrant Theme Cards
            VStack(spacing: 20) {
                Text("Vibrant Theme")
                    .font(.system(size: 20, weight: .semibold))
                
                ThemeProvider(theme: VibrantTheme()) {
                    cardExamples
                }
            }
            
            // Neutral Theme Cards
            VStack(spacing: 20) {
                Text("Neutral Theme")
                    .font(.system(size: 20, weight: .semibold))
                
                ThemeProvider(theme: NeutralTheme()) {
                    cardExamples
                }
            }
        }
        .padding(40)
        .background(Color(white: 0.95))
    }
    
    private var cardExamples: some View {
        VStack(spacing: 16) {
            // Basic Card
            basicCard
            
            // Financial Summary Card
            financialCard
            
            // Chart Card
            chartCard
        }
        .frame(width: 320)
    }
    
    // MARK: - Card Examples
    
    private var basicCard: some View {
        Card(padding: .md, shadow: .sm, hasBorder: false, cornerRadius: .md) {
            CardContentExample(
                title: "Basic Card",
                subtitle: "Default styling",
                value: "$1,234.56"
            )
        }
    }
    
    private var financialCard: some View {
        Card(padding: .lg, shadow: .md, hasBorder: true, cornerRadius: .lg) {
            FinancialCardContent()
        }
    }
    
    private var chartCard: some View {
        Card(padding: .md, shadow: .lg, hasBorder: false, cornerRadius: .md) {
            ChartCardContent()
        }
    }
}

// MARK: - Card Content Components

struct CardContentExample: View {
    @Environment(\.theme) private var theme
    
    let title: String
    let subtitle: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text(title)
                .font(theme.typography.titleMedium.font)
                .foregroundColor(theme.colors.textPrimary)
            
            Text(subtitle)
                .font(theme.typography.bodySmall.font)
                .foregroundColor(theme.colors.textSecondary)
            
            Divider()
                .background(theme.colors.border)
            
            Text(value)
                .font(theme.typography.headlineMedium.font)
                .foregroundColor(theme.colors.primary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct FinancialCardContent: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            HStack {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text("Net Worth")
                        .font(theme.typography.labelMedium.font)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Text("$45,678.90")
                        .font(theme.typography.headlineLarge.font)
                        .foregroundColor(theme.colors.textPrimary)
                }
                
                Spacer()
                
                // Status indicator
                VStack(alignment: .trailing, spacing: theme.spacing.xxs) {
                    HStack(spacing: theme.spacing.xxs) {
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 12, weight: .bold))
                        Text("+12.5%")
                            .font(theme.typography.labelSmall.font)
                    }
                    .foregroundColor(theme.colors.success)
                    .padding(.horizontal, theme.spacing.xs)
                    .padding(.vertical, theme.spacing.xxs)
                    .background(theme.colors.successBackground)
                    .cornerRadius(theme.radius.sm)
                    
                    Text("vs last month")
                        .font(theme.typography.labelSmall.font)
                        .foregroundColor(theme.colors.textTertiary)
                }
            }
            
            // Mini metrics
            HStack(spacing: theme.spacing.md) {
                metricItem(label: "Income", value: "$5,200", color: theme.colors.success)
                metricItem(label: "Expenses", value: "$3,450", color: theme.colors.error)
            }
        }
    }
    
    private func metricItem(label: String, value: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            Text(label)
                .font(theme.typography.labelSmall.font)
                .foregroundColor(theme.colors.textTertiary)
            
            Text(value)
                .font(theme.typography.titleSmall.font)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct ChartCardContent: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Spending by Category")
                .font(theme.typography.titleMedium.font)
                .foregroundColor(theme.colors.textPrimary)
            
            // Simulated chart bars
            VStack(spacing: theme.spacing.xs) {
                chartBar(label: "Housing", percentage: 0.45, color: theme.colors.chartPrimary)
                chartBar(label: "Food", percentage: 0.25, color: theme.colors.chartSecondary)
                chartBar(label: "Transport", percentage: 0.15, color: theme.colors.chartTertiary)
                chartBar(label: "Other", percentage: 0.15, color: theme.colors.chartQuaternary)
            }
        }
    }
    
    private func chartBar(label: String, percentage: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            HStack {
                Text(label)
                    .font(theme.typography.labelMedium.font)
                    .foregroundColor(theme.colors.textSecondary)
                
                Spacer()
                
                Text("\(Int(percentage * 100))%")
                    .font(theme.typography.labelMedium.font)
                    .foregroundColor(theme.colors.textPrimary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background bar
                    RoundedRectangle(cornerRadius: theme.radius.sm)
                        .fill(theme.colors.backgroundSecondary)
                    
                    // Filled bar
                    RoundedRectangle(cornerRadius: theme.radius.sm)
                        .fill(color)
                        .frame(width: geometry.size.width * percentage)
                }
            }
            .frame(height: 8)
        }
    }
}

// MARK: - Previews

#Preview("Card Comparison") {
    CardPreview()
        .frame(width: 800, height: 800)
}

#Preview("Single Card - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        Card(padding: .lg, shadow: .md) {
            FinancialCardContent()
        }
        .frame(width: 350)
    }
    .padding(40)
    .background(Color(white: 0.95))
}

#Preview("Single Card - Neutral") {
    ThemeProvider(theme: NeutralTheme()) {
        Card(padding: .lg, shadow: .md) {
            FinancialCardContent()
        }
        .frame(width: 350)
    }
    .padding(40)
    .background(Color(white: 0.95))
}
