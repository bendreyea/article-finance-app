import SwiftUI

/// Comprehensive previews for DonutGauge component showcasing various use cases
struct DonutGaugePreviews: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                Text("DonutGauge Component")
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
                        
                        DonutGaugeShowcase()
                            .theme(VibrantTheme())
                    }
                    
                    VStack {
                        Text("Neutral Theme")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                        
                        DonutGaugeShowcase()
                            .theme(NeutralTheme())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

/// Individual theme showcase for DonutGauge components
private struct DonutGaugeShowcase: View {
    @Environment(\.theme) private var theme
    @State private var animatedValues = [75000.0, 45000.0, 2800.0]
    
    var body: some View {
        VStack(spacing: theme.spacing.lg) {
            // Size Variations Section
            sizeVariationsSection
            
            // Financial Use Cases Section  
            financialUseCasesSection
            
            // Interactive Demo Section
            interactiveDemoSection
        }
        .padding(theme.spacing.md)
        .background(theme.colors.background)
        .cornerRadius(theme.radius.xl)
    }
    
    // MARK: - Size Variations
    private var sizeVariationsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Size Variations")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            HStack(spacing: theme.spacing.lg) {
                VStack {
                    DonutGauge(
                        value: 75000,
                        maxValue: 100000,
                        title: "Small",
                        subtitle: "120pt",
                        size: .small
                    )
                    
                    Text("Small")
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                }
                
                VStack {
                    DonutGauge(
                        value: 75000,
                        maxValue: 100000,
                        title: "Medium",
                        subtitle: "180pt",
                        size: .medium
                    )
                    
                    Text("Medium (Default)")
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                }
                
                VStack {
                    DonutGauge(
                        value: 75000,
                        maxValue: 100000,
                        title: "Large",
                        subtitle: "240pt",
                        size: .large
                    )
                    
                    Text("Large")
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
        }
    }
    
    // MARK: - Financial Use Cases
    private var financialUseCasesSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Financial Use Cases")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: theme.spacing.md) {
                // Net Worth Gauge
                Card {
                    DonutGauge.netWorth(
                        current: animatedValues[0],
                        target: 100000,
                        subtitle: "+12.5% this month"
                    )
                }
                
                // Savings Goal Gauge
                Card {
                    DonutGauge.savingsGoal(
                        saved: animatedValues[1], 
                        goal: 50000,
                        subtitle: "Emergency Fund"
                    )
                }
                
                // Budget Tracking Gauge
                Card {
                    DonutGauge.budget(
                        spent: animatedValues[2],
                        budget: 3500,
                        subtitle: "October 2025"
                    )
                }
                
                // Investment Portfolio
                Card {
                    DonutGauge(
                        value: 125000,
                        maxValue: 200000,
                        title: "Portfolio",
                        subtitle: "Retirement Goal"
                    )
                }
            }
        }
    }
    
    // MARK: - Interactive Demo
    private var interactiveDemoSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Interactive Demo")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            Card {
                VStack(spacing: theme.spacing.lg) {
                    DonutGauge(
                        value: animatedValues[0],
                        maxValue: 100000,
                        title: "Net Worth",
                        subtitle: "Tap buttons to change",
                        size: .medium
                    )
                    
                    HStack(spacing: theme.spacing.md) {
                        InteractiveButton(title: "Increase", action: increaseValue)
                        InteractiveButton(title: "Decrease", action: decreaseValue) 
                        InteractiveButton(title: "Reset", action: resetValue)
                    }
                }
            }
        }
    }
    
    // MARK: - Interactive Actions
    private func increaseValue() {
        withAnimation(.easeInOut(duration: 0.5)) {
            animatedValues[0] = min(animatedValues[0] + 10000, 100000)
        }
    }
    
    private func decreaseValue() {
        withAnimation(.easeInOut(duration: 0.5)) {
            animatedValues[0] = max(animatedValues[0] - 10000, 0)
        }
    }
    
    private func resetValue() {
        withAnimation(.easeInOut(duration: 0.8)) {
            animatedValues[0] = 75000
        }
    }
}

// MARK: - Supporting Components
private struct InteractiveButton: View {
    @Environment(\.theme) private var theme
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(theme.typography.font(size: theme.typography.callout, weight: theme.typography.medium))
                .foregroundColor(theme.colors.onPrimary)
                .padding(.horizontal, theme.spacing.md)
                .padding(.vertical, theme.spacing.sm)
                .background(theme.colors.primary)
                .cornerRadius(theme.radius.button)
        }
        .shadow(theme.shadows.subtle)
    }
}

// MARK: - Additional Use Case Examples
extension DonutGaugePreviews {
    /// Demonstrates various value formatting scenarios
    static var valueFormattingExamples: some View {
        VStack(spacing: 16) {
            Text("Value Formatting Examples")
                .font(.title2)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 16) {
                // Small values
                DonutGauge(
                    value: 1234.56,
                    maxValue: 5000,
                    title: "Small Amount",
                    subtitle: "Precise formatting",
                    size: .small
                )
                
                // Thousands
                DonutGauge(
                    value: 45000,
                    maxValue: 50000,
                    title: "Thousands",
                    subtitle: "K suffix",
                    size: .small
                )
                
                // Millions
                DonutGauge(
                    value: 2500000,
                    maxValue: 5000000,
                    title: "Millions",
                    subtitle: "M suffix",
                    size: .small
                )
                
                // Billions
                DonutGauge(
                    value: 1200000000,
                    maxValue: 2000000000,
                    title: "Billions",
                    subtitle: "B suffix",
                    size: .small
                )
                
                // Zero value
                DonutGauge(
                    value: 0,
                    maxValue: 10000,
                    title: "Zero Value",
                    subtitle: "Starting point",
                    size: .small
                )
                
                // Maximum value
                DonutGauge(
                    value: 10000,
                    maxValue: 10000,
                    title: "Complete",
                    subtitle: "100% achieved",
                    size: .small
                )
            }
        }
        .theme(VibrantTheme())
        .padding()
    }
}

// MARK: - Preview Provider
#Preview("DonutGauge Comparison") {
    DonutGaugePreviews()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}

#Preview("Vibrant Theme Only") {
    DonutGaugeShowcase()
        .theme(VibrantTheme())
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}

#Preview("Neutral Theme Only") {
    DonutGaugeShowcase()
        .theme(NeutralTheme())
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}

#Preview("Value Formatting Examples") {
    DonutGaugePreviews.valueFormattingExamples
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}

#Preview("Accessibility Test") {
    VStack(spacing: 32) {
        Text("Accessibility Test")
            .font(.title)
            .fontWeight(.bold)
        
        Text("Use VoiceOver to test accessibility features")
            .font(.body)
            .foregroundColor(.secondary)
        
        DonutGauge.netWorth(
            current: 75000,
            target: 100000,
            subtitle: "Target for 2025"
        )
        .theme(VibrantTheme())
    }
    .padding()
}