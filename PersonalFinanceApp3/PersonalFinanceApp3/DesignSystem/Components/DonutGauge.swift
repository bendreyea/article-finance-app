import SwiftUI

/// A reusable donut gauge component for visualizing progress or metrics
public struct DonutGauge: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    private let value: Double
    private let max: Double
    private let title: String
    private let subtitle: String?
    private let size: GaugeSize
    
    // MARK: - Computed Properties
    
    private var progress: Double {
        guard max > 0 else { return 0 }
        return min(Swift.max(value / max, 0), 1.0)
    }
    
    private var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
    
    private var percentageValue: String {
        let percentage = progress * 100
        return String(format: "%.0f%%", percentage)
    }
    
    private var lineWidth: CGFloat {
        switch size {
        case .small:
            return theme.spacing.sm
        case .medium:
            return theme.spacing.md
        case .large:
            return theme.spacing.lg
        case .extraLarge:
            return theme.spacing.xl
        }
    }
    
    private var gaugeSize: CGFloat {
        switch size {
        case .small:
            return 120
        case .medium:
            return 180
        case .large:
            return 240
        case .extraLarge:
            return 320
        }
    }
    
    private var titleFont: Font {
        switch size {
        case .small:
            return theme.typography.labelSmall
        case .medium:
            return theme.typography.labelMedium
        case .large:
            return theme.typography.labelLarge
        case .extraLarge:
            return theme.typography.headingSmall
        }
    }
    
    private var valueFont: Font {
        switch size {
        case .small:
            return theme.typography.headingMedium
        case .medium:
            return theme.typography.headingLarge
        case .large:
            return theme.typography.displaySmall
        case .extraLarge:
            return theme.typography.displayMedium
        }
    }
    
    private var subtitleFont: Font {
        switch size {
        case .small:
            return theme.typography.labelSmall
        case .medium:
            return theme.typography.labelMedium
        case .large:
            return theme.typography.bodyMedium
        case .extraLarge:
            return theme.typography.bodyLarge
        }
    }
    
    // MARK: - Initialization
    
    /// Creates a donut gauge
    /// - Parameters:
    ///   - value: Current value to display
    ///   - max: Maximum value (for calculating progress)
    ///   - title: Title displayed above the gauge
    ///   - subtitle: Optional subtitle displayed below the value
    ///   - size: Size preset for the gauge (default: .medium)
    public init(
        value: Double,
        max: Double,
        title: String,
        subtitle: String? = nil,
        size: GaugeSize = .medium
    ) {
        self.value = value
        self.max = max
        self.title = title
        self.subtitle = subtitle
        self.size = size
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: theme.spacing.md) {
            // Title
            Text(title)
                .font(titleFont)
                .foregroundColor(theme.colors.textSecondary)
            
            // Donut Gauge
            ZStack {
                // Background Ring
                Circle()
                    .stroke(
                        theme.colors.backgroundTertiary,
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                    )
                
                // Progress Ring with Gradient
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                theme.colors.accentPrimary,
                                theme.colors.accentSecondary
                            ]),
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(-90 + 360 * progress)
                        ),
                        style: StrokeStyle(
                            lineWidth: lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                
                // Center Content
                VStack(spacing: theme.spacing.xs) {
                    Text(formattedValue)
                        .font(valueFont)
                        .fontWeight(.bold)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(subtitleFont)
                            .foregroundColor(theme.colors.textTertiary)
                    }
                }
            }
            .frame(width: gaugeSize, height: gaugeSize)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityDescription)
        .accessibilityValue("\(formattedValue) out of \(formatCurrency(max))")
    }
    
    // MARK: - Helper Methods
    
    private var accessibilityDescription: String {
        var description = "\(title). "
        description += "Current value: \(formattedValue) out of \(formatCurrency(max)). "
        description += "That's \(percentageValue) of the maximum. "
        if let subtitle = subtitle {
            description += subtitle
        }
        return description
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// MARK: - Gauge Size

/// Size presets for the DonutGauge
public enum GaugeSize {
    case small
    case medium
    case large
    case extraLarge
}

// MARK: - Previews

#Preview("Donut Gauge Sizes - Vibrant") {
    VStack(spacing: 40) {
        HStack(spacing: 40) {
            DonutGauge(
                value: 45280,
                max: 100000,
                title: "Net Worth",
                subtitle: "Small",
                size: .small
            )
            
            DonutGauge(
                value: 45280,
                max: 100000,
                title: "Net Worth",
                subtitle: "Medium",
                size: .medium
            )
        }
        
        HStack(spacing: 40) {
            DonutGauge(
                value: 45280,
                max: 100000,
                title: "Net Worth",
                subtitle: "Large",
                size: .large
            )
            
            DonutGauge(
                value: 45280,
                max: 100000,
                title: "Net Worth",
                subtitle: "Extra Large",
                size: .extraLarge
            )
        }
    }
    .padding(40)
    .themed(VibrantTheme())
    .frame(width: 900, height: 700)
}

#Preview("Donut Gauge Progress Levels - Vibrant") {
    HStack(spacing: 40) {
        DonutGauge(
            value: 15000,
            max: 100000,
            title: "Savings Goal",
            subtitle: "15% Complete",
            size: .large
        )
        
        DonutGauge(
            value: 50000,
            max: 100000,
            title: "Savings Goal",
            subtitle: "50% Complete",
            size: .large
        )
        
        DonutGauge(
            value: 87500,
            max: 100000,
            title: "Savings Goal",
            subtitle: "87.5% Complete",
            size: .large
        )
    }
    .padding(40)
    .themed(VibrantTheme())
    .frame(width: 900, height: 400)
}

#Preview("Donut Gauge - Side by Side Themes") {
    HStack(spacing: 60) {
        VStack(spacing: 30) {
            Text("Vibrant Theme")
                .font(.title)
                .fontWeight(.semibold)
            
            DonutGauge(
                value: 45280,
                max: 100000,
                title: "Net Worth",
                subtitle: "45% of goal",
                size: .large
            )
            
            DonutGauge(
                value: 8450,
                max: 10000,
                title: "Monthly Income",
                subtitle: "84.5% of target",
                size: .medium
            )
        }
        .themed(VibrantTheme())
        
        VStack(spacing: 30) {
            Text("Neutral Theme")
                .font(.title)
                .fontWeight(.semibold)
            
            DonutGauge(
                value: 45280,
                max: 100000,
                title: "Net Worth",
                subtitle: "45% of goal",
                size: .large
            )
            
            DonutGauge(
                value: 8450,
                max: 10000,
                title: "Monthly Income",
                subtitle: "84.5% of target",
                size: .medium
            )
        }
        .themed(NeutralTheme())
    }
    .padding(40)
    .frame(width: 1000, height: 600)
}

#Preview("Finance Dashboard with Donut Gauge - Vibrant") {
    FinanceDashboardWithGauges()
        .themed(VibrantTheme())
        .frame(width: 900, height: 700)
}

#Preview("Finance Dashboard with Donut Gauge - Neutral") {
    FinanceDashboardWithGauges()
        .themed(NeutralTheme())
        .frame(width: 900, height: 700)
}

// MARK: - Example Dashboard

struct FinanceDashboardWithGauges: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                // Header
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Financial Overview")
                        .font(theme.typography.displaySmall)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Track your progress towards financial goals")
                        .font(theme.typography.bodyMedium)
                        .foregroundColor(theme.colors.textSecondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Gauges Grid
                HStack(spacing: theme.spacing.xl) {
                    Card(style: .elevated) {
                        DonutGauge(
                            value: 45280,
                            max: 100000,
                            title: "Net Worth Goal",
                            subtitle: "45% Complete",
                            size: .large
                        )
                    }
                    
                    VStack(spacing: theme.spacing.lg) {
                        Card(style: .elevated, padding: .medium) {
                            DonutGauge(
                                value: 8450,
                                max: 10000,
                                title: "Monthly Income",
                                subtitle: "Target: $10,000",
                                size: .medium
                            )
                        }
                        
                        Card(style: .elevated, padding: .medium) {
                            DonutGauge(
                                value: 3280,
                                max: 5000,
                                title: "Monthly Expenses",
                                subtitle: "Budget: $5,000",
                                size: .medium
                            )
                        }
                    }
                }
                
                // Small Gauges Row
                HStack(spacing: theme.spacing.lg) {
                    Card(style: .outlined) {
                        DonutGauge(
                            value: 2400,
                            max: 3000,
                            title: "Emergency Fund",
                            subtitle: "80% funded",
                            size: .small
                        )
                    }
                    
                    Card(style: .outlined) {
                        DonutGauge(
                            value: 1850,
                            max: 2000,
                            title: "Investment Goal",
                            subtitle: "92.5% complete",
                            size: .small
                        )
                    }
                    
                    Card(style: .outlined) {
                        DonutGauge(
                            value: 750,
                            max: 1000,
                            title: "Vacation Fund",
                            subtitle: "75% saved",
                            size: .small
                        )
                    }
                }
            }
            .padding(theme.spacing.xxl)
        }
        .background(theme.colors.background)
    }
}
