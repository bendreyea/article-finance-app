import SwiftUI

/// A customizable donut-style gauge component perfect for displaying financial data like net worth, account balances, or progress toward goals
public struct DonutGauge: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    private let value: Double
    private let maxValue: Double
    private let title: String
    private let subtitle: String?
    private let size: GaugeSize
    private let animationDuration: Double
    
    // MARK: - Animation State
    @State private var animatedValue: Double = 0
    
    /// Creates a DonutGauge with the specified parameters
    /// - Parameters:
    ///   - value: Current value to display (e.g., current net worth)
    ///   - maxValue: Maximum value for the gauge (e.g., target net worth)
    ///   - title: Primary title text (e.g., "Net Worth")
    ///   - subtitle: Optional secondary text (e.g., "vs. last month")
    ///   - size: Size variant of the gauge
    ///   - animationDuration: Duration for value animation
    public init(
        value: Double,
        maxValue: Double,
        title: String,
        subtitle: String? = nil,
        size: GaugeSize = .medium,
        animationDuration: Double = 1.0
    ) {
        self.value = max(0, min(value, maxValue)) // Clamp value between 0 and maxValue
        self.maxValue = max(1, maxValue) // Ensure maxValue is at least 1
        self.title = title
        self.subtitle = subtitle
        self.size = size
        self.animationDuration = animationDuration
    }
    
    public var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(
                    theme.colors.border.opacity(0.2),
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round
                    )
                )
            
            // Progress ring with gradient
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    progressGradient,
                    style: StrokeStyle(
                        lineWidth: strokeWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90)) // Start from top
                .animation(.easeInOut(duration: animationDuration), value: animatedValue)
            
            // Center content
            VStack(spacing: theme.spacing.xs) {
                // Value display
                Text(formattedValue)
                    .font(valueFont)
                    .fontWeight(theme.typography.bold)
                    .foregroundColor(theme.colors.textPrimary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                
                // Title
                Text(title)
                    .font(titleFont)
                    .fontWeight(theme.typography.medium)
                    .foregroundColor(theme.colors.textPrimary)
                    .lineLimit(1)
                
                // Subtitle (if provided)
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(subtitleFont)
                        .foregroundColor(theme.colors.textSecondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            .padding(centerContentPadding)
        }
        .frame(width: dimensions.diameter, height: dimensions.diameter)
        .onAppear {
            // Animate to target value when view appears
            withAnimation(.easeInOut(duration: animationDuration)) {
                animatedValue = value
            }
        }
        .onChange(of: value) { _, newValue in
            // Animate when value changes
            withAnimation(.easeInOut(duration: animationDuration * 0.6)) {
                animatedValue = newValue
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(accessibilityValue)
        .accessibilityHint("Double tap to hear details")
    }
    
    // MARK: - Computed Properties
    
    /// Progress as a percentage (0.0 to 1.0)
    private var progress: Double {
        guard maxValue > 0 else { return 0 }
        return animatedValue / maxValue
    }
    
    /// Gradient for the progress ring
    private var progressGradient: AngularGradient {
        AngularGradient(
            gradient: Gradient(colors: [
                theme.colors.primary,
                theme.colors.primaryVariant,
                theme.colors.primary
            ]),
            center: .center,
            startAngle: .degrees(0),
            endAngle: .degrees(360)
        )
    }
    
    /// Formatted currency value
    private var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        
        // Format large numbers with K/M/B suffixes for better readability
        if abs(value) >= 1_000_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value / 1_000_000_000)) ?? "$0"
        } else if abs(value) >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value / 1_000_000)) ?? "$0"
        } else if abs(value) >= 10_000 {
            return formatter.string(from: NSNumber(value: value / 1_000)) ?? "$0"
        } else {
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: value)) ?? "$0"
        }
    }
    
    /// Size-specific dimensions
    private var dimensions: GaugeDimensions {
        switch size {
        case .small:
            return GaugeDimensions(diameter: 120, strokeWidth: 8)
        case .medium:
            return GaugeDimensions(diameter: 180, strokeWidth: 12)
        case .large:
            return GaugeDimensions(diameter: 240, strokeWidth: 16)
        case .custom(let diameter, let strokeWidth):
            return GaugeDimensions(diameter: diameter, strokeWidth: strokeWidth)
        }
    }
    
    /// Stroke width for the rings
    private var strokeWidth: CGFloat {
        dimensions.strokeWidth
    }
    
    /// Font for the main value
    private var valueFont: Font {
        switch size {
        case .small:
            return theme.typography.font(size: theme.typography.headline, weight: theme.typography.bold)
        case .medium:
            return theme.typography.font(size: theme.typography.title2, weight: theme.typography.bold)
        case .large:
            return theme.typography.font(size: theme.typography.title1, weight: theme.typography.bold)
        case .custom(let diameter, _):
            let fontSize = diameter * 0.12 // Scale font with diameter
            return theme.typography.font(size: fontSize, weight: theme.typography.bold)
        }
    }
    
    /// Font for the title
    private var titleFont: Font {
        switch size {
        case .small:
            return theme.typography.captionFont
        case .medium:
            return theme.typography.calloutFont
        case .large:
            return theme.typography.subheadFont
        case .custom(let diameter, _):
            let fontSize = diameter * 0.08
            return theme.typography.font(size: fontSize, weight: theme.typography.medium)
        }
    }
    
    /// Font for the subtitle
    private var subtitleFont: Font {
        switch size {
        case .small:
            return theme.typography.font(size: 10, weight: theme.typography.regular)
        case .medium:
            return theme.typography.captionFont
        case .large:
            return theme.typography.footnoteFont
        case .custom(let diameter, _):
            let fontSize = diameter * 0.06
            return theme.typography.font(size: fontSize, weight: theme.typography.regular)
        }
    }
    
    /// Padding for center content
    private var centerContentPadding: CGFloat {
        dimensions.diameter * 0.15
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: String {
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        percentageFormatter.maximumFractionDigits = 1
        
        let percentage = percentageFormatter.string(from: NSNumber(value: progress)) ?? "0%"
        
        if let subtitle = subtitle {
            return "\(title): \(formattedValue) out of \(formatCurrency(maxValue)), \(percentage) complete, \(subtitle)"
        } else {
            return "\(title): \(formattedValue) out of \(formatCurrency(maxValue)), \(percentage) complete"
        }
    }
    
    private var accessibilityValue: String {
        let percentageFormatter = NumberFormatter()
        percentageFormatter.numberStyle = .percent
        percentageFormatter.maximumFractionDigits = 1
        
        return percentageFormatter.string(from: NSNumber(value: progress)) ?? "0%"
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        
        if abs(value) >= 1_000_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value / 1_000_000_000)) ?? "$0"
        } else if abs(value) >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value / 1_000_000)) ?? "$0"
        } else if abs(value) >= 10_000 {
            return formatter.string(from: NSNumber(value: value / 1_000)) ?? "$0"
        } else {
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: value)) ?? "$0"
        }
    }
}

// MARK: - Supporting Types

/// Size variants for the DonutGauge
public enum GaugeSize {
    case small          // 120pt diameter
    case medium         // 180pt diameter  
    case large          // 240pt diameter
    case custom(diameter: CGFloat, strokeWidth: CGFloat)
}

/// Internal structure for gauge dimensions
private struct GaugeDimensions {
    let diameter: CGFloat
    let strokeWidth: CGFloat
}

// MARK: - Convenience Initializers

extension DonutGauge {
    /// Creates a DonutGauge for net worth display
    public static func netWorth(
        current: Double,
        target: Double,
        subtitle: String? = nil,
        size: GaugeSize = .medium
    ) -> DonutGauge {
        DonutGauge(
            value: current,
            maxValue: target,
            title: "Net Worth",
            subtitle: subtitle,
            size: size
        )
    }
    
    /// Creates a DonutGauge for savings goal progress
    public static func savingsGoal(
        saved: Double,
        goal: Double,
        subtitle: String? = nil,
        size: GaugeSize = .medium
    ) -> DonutGauge {
        DonutGauge(
            value: saved,
            maxValue: goal,
            title: "Savings Goal",
            subtitle: subtitle,
            size: size
        )
    }
    
    /// Creates a DonutGauge for budget tracking
    public static func budget(
        spent: Double,
        budget: Double,
        subtitle: String? = nil,
        size: GaugeSize = .medium
    ) -> DonutGauge {
        DonutGauge(
            value: spent,
            maxValue: budget,
            title: "Budget Used",
            subtitle: subtitle,
            size: size
        )
    }
}