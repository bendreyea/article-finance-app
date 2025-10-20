import SwiftUI

/// Comprehensive previews for DonutGauge component showing various scenarios
struct DonutGaugeShowcase: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xxl) {
                // Header
                VStack(spacing: theme.spacing.xs) {
                    Text("DonutGauge Component")
                        .font(theme.typography.displaySmall.font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Circular gauge with gradient ring and currency display")
                        .font(theme.typography.bodyMedium.font)
                        .foregroundColor(theme.colors.textSecondary)
                }
                .padding(.top, theme.spacing.xl)
                
                // Size Variations
                sizeVariationsSection
                
                // Value Variations
                valueVariationsSection
                
                // In Card Context
                cardContextSection
                
                // Financial Dashboard Example
                dashboardExampleSection
            }
            .padding(theme.spacing.xl)
        }
        .background(theme.colors.background)
    }
    
    // MARK: - Size Variations
    
    private var sizeVariationsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Size Variations")
                .font(theme.typography.titleLarge.font)
                .foregroundColor(theme.colors.textPrimary)
            
            HStack(spacing: theme.spacing.xl) {
                DonutGauge(
                    value: 1234.56,
                    max: 5000,
                    title: "Small",
                    subtitle: "120pt diameter",
                    size: .small
                )
                
                DonutGauge(
                    value: 12345.67,
                    max: 25000,
                    title: "Medium",
                    subtitle: "180pt diameter",
                    size: .medium
                )
                
                DonutGauge(
                    value: 45678.90,
                    max: 100000,
                    title: "Large",
                    subtitle: "240pt diameter",
                    size: .large
                )
            }
        }
    }
    
    // MARK: - Value Variations
    
    private var valueVariationsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Progress Variations")
                .font(theme.typography.titleLarge.font)
                .foregroundColor(theme.colors.textPrimary)
            
            HStack(spacing: theme.spacing.xl) {
                DonutGauge(
                    value: 2500,
                    max: 10000,
                    title: "25% Progress",
                    subtitle: "Getting started",
                    size: .medium
                )
                
                DonutGauge(
                    value: 5000,
                    max: 10000,
                    title: "50% Progress",
                    subtitle: "Halfway there",
                    size: .medium
                )
                
                DonutGauge(
                    value: 7500,
                    max: 10000,
                    title: "75% Progress",
                    subtitle: "Almost complete",
                    size: .medium
                )
                
                DonutGauge(
                    value: 9800,
                    max: 10000,
                    title: "98% Progress",
                    subtitle: "Nearly done",
                    size: .medium
                )
            }
        }
    }
    
    // MARK: - Card Context
    
    private var cardContextSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("In Card Component")
                .font(theme.typography.titleLarge.font)
                .foregroundColor(theme.colors.textPrimary)
            
            HStack(spacing: theme.spacing.md) {
                Card(padding: .lg, shadow: .md, cornerRadius: .lg) {
                    DonutGauge(
                        value: 45678.90,
                        max: 100000,
                        title: "Net Worth",
                        subtitle: "Total Assets",
                        size: .large
                    )
                    .frame(maxWidth: .infinity)
                }
                .frame(width: 350)
                
                Card(padding: .lg, shadow: .md, cornerRadius: .lg) {
                    VStack(spacing: theme.spacing.lg) {
                        DonutGauge(
                            value: 3450.00,
                            max: 5000,
                            title: "Monthly Budget",
                            subtitle: "Remaining",
                            size: .medium
                        )
                        
                        VStack(alignment: .leading, spacing: theme.spacing.sm) {
                            budgetItem(
                                label: "Spent",
                                amount: "$1,550.00",
                                color: theme.colors.error
                            )
                            budgetItem(
                                label: "Remaining",
                                amount: "$3,450.00",
                                color: theme.colors.success
                            )
                            budgetItem(
                                label: "Budget",
                                amount: "$5,000.00",
                                color: theme.colors.textSecondary
                            )
                        }
                        .padding(.horizontal, theme.spacing.md)
                    }
                }
                .frame(width: 350)
            }
        }
    }
    
    private func budgetItem(label: String, amount: String, color: Color) -> some View {
        HStack {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(label)
                .font(theme.typography.bodySmall.font)
                .foregroundColor(theme.colors.textSecondary)
            
            Spacer()
            
            Text(amount)
                .font(theme.typography.bodyMedium.font)
                .foregroundColor(theme.colors.textPrimary)
        }
    }
    
    // MARK: - Dashboard Example
    
    private var dashboardExampleSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Financial Dashboard")
                .font(theme.typography.titleLarge.font)
                .foregroundColor(theme.colors.textPrimary)
            
            HStack(alignment: .top, spacing: theme.spacing.md) {
                // Main Net Worth Gauge
                Card(padding: .xl, shadow: .lg, cornerRadius: .lg) {
                    VStack(spacing: theme.spacing.lg) {
                        DonutGauge(
                            value: 156789.50,
                            max: 250000,
                            title: "Net Worth",
                            subtitle: "Goal: $250K by Dec 2026",
                            size: .large
                        )
                        
                        HStack(spacing: theme.spacing.lg) {
                            statColumn(
                                label: "Assets",
                                value: "$189,450",
                                icon: "arrow.up.circle.fill",
                                color: theme.colors.success
                            )
                            
                            ThemedDivider(style: .subtle)
                                .frame(width: 1, height: 40)
                            
                            statColumn(
                                label: "Liabilities",
                                value: "$32,660",
                                icon: "arrow.down.circle.fill",
                                color: theme.colors.error
                            )
                            
                            ThemedDivider(style: .subtle)
                                .frame(width: 1, height: 40)
                            
                            statColumn(
                                label: "Growth",
                                value: "+12.5%",
                                icon: "chart.line.uptrend.xyaxis",
                                color: theme.colors.primary
                            )
                        }
                        .padding(.horizontal, theme.spacing.md)
                    }
                }
                
                // Secondary Gauges
                VStack(spacing: theme.spacing.md) {
                    Card(padding: .lg, shadow: .md, cornerRadius: .md) {
                        DonutGauge(
                            value: 12500,
                            max: 15000,
                            title: "Emergency Fund",
                            subtitle: "3 months expenses",
                            size: .medium
                        )
                    }
                    
                    Card(padding: .lg, shadow: .md, cornerRadius: .md) {
                        DonutGauge(
                            value: 45000,
                            max: 50000,
                            title: "Retirement",
                            subtitle: "Annual contribution",
                            size: .medium
                        )
                    }
                }
            }
        }
    }
    
    private func statColumn(label: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: theme.spacing.xs) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)
            
            Text(value)
                .font(theme.typography.titleMedium.font)
                .foregroundColor(theme.colors.textPrimary)
            
            Text(label)
                .font(theme.typography.labelSmall.font)
                .foregroundColor(theme.colors.textSecondary)
        }
    }
}

// MARK: - Theme Comparison

struct DonutGaugeComparison: View {
    var body: some View {
        HStack(spacing: 40) {
            // Vibrant Theme
            VStack(spacing: 20) {
                Text("Vibrant Theme")
                    .font(.system(size: 24, weight: .bold))
                
                ThemeProvider(theme: VibrantTheme()) {
                    comparisonContent
                }
            }
            
            // Neutral Theme
            VStack(spacing: 20) {
                Text("Neutral Theme")
                    .font(.system(size: 24, weight: .bold))
                
                ThemeProvider(theme: NeutralTheme()) {
                    comparisonContent
                }
            }
        }
        .padding(40)
        .background(Color(white: 0.95))
    }
    
    private var comparisonContent: some View {
        VStack(spacing: 24) {
            DonutGauge(
                value: 45678.90,
                max: 100000,
                title: "Net Worth",
                subtitle: "Total Assets",
                size: .large
            )
            
            HStack(spacing: 16) {
                DonutGauge(
                    value: 2500,
                    max: 5000,
                    title: "Budget",
                    size: .small
                )
                
                DonutGauge(
                    value: 7500,
                    max: 10000,
                    title: "Goal",
                    size: .small
                )
            }
        }
        .frame(width: 400)
    }
}

// MARK: - Animated Example

struct DonutGaugeAnimatedDemo: View {
    @Environment(\.theme) private var theme
    @State private var value: Double = 0
    
    let max: Double = 100000
    
    var body: some View {
        VStack(spacing: theme.spacing.xl) {
            Text("Animated DonutGauge")
                .font(theme.typography.titleLarge.font)
                .foregroundColor(theme.colors.textPrimary)
            
            DonutGauge(
                value: value,
                max: max,
                title: "Savings Goal",
                subtitle: "House Down Payment",
                size: .large
            )
            
            VStack(spacing: theme.spacing.md) {
                Slider(value: $value, in: 0...max)
                    .frame(width: 300)
                
                HStack(spacing: theme.spacing.md) {
                    Button("0%") { withAnimation { value = 0 } }
                    Button("25%") { withAnimation { value = max * 0.25 } }
                    Button("50%") { withAnimation { value = max * 0.5 } }
                    Button("75%") { withAnimation { value = max * 0.75 } }
                    Button("100%") { withAnimation { value = max } }
                }
            }
            .padding(theme.spacing.lg)
        }
        .padding(theme.spacing.xxl)
        .background(theme.colors.background)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5)) {
                value = 45678.90
            }
        }
    }
}

// MARK: - Previews

#Preview("Showcase - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        DonutGaugeShowcase()
    }
    .frame(width: 1200, height: 1400)
}

#Preview("Showcase - Neutral") {
    ThemeProvider(theme: NeutralTheme()) {
        DonutGaugeShowcase()
    }
    .frame(width: 1200, height: 1400)
}

#Preview("Theme Comparison") {
    DonutGaugeComparison()
        .frame(width: 1000, height: 600)
}

#Preview("Animated Demo - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        DonutGaugeAnimatedDemo()
    }
    .frame(width: 600, height: 600)
}

#Preview("Animated Demo - Neutral") {
    ThemeProvider(theme: NeutralTheme()) {
        DonutGaugeAnimatedDemo()
    }
    .frame(width: 600, height: 600)
}

#Preview("Single Gauge - Large") {
    ThemeProvider(theme: VibrantTheme()) {
        DonutGauge(
            value: 45678.90,
            max: 100000,
            title: "Net Worth",
            subtitle: "Total Assets",
            size: .large
        )
        .padding(40)
    }
    .frame(width: 400, height: 400)
    .background(Color(white: 0.95))
}
