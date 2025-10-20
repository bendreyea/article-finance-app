import SwiftUI

/// A circular donut-style gauge component that displays a value as a percentage of maximum
///
/// The DonutGauge features:
/// - Stroked ring with rounded line caps
/// - Gradient from theme primary to primaryAlt colors
/// - Center display with formatted currency value
/// - Title and optional subtitle
/// - Configurable size (small, medium, large, custom)
/// - Full VoiceOver accessibility support
/// - No hardcoded colors - everything from @Environment(\.theme)
///
/// Usage:
/// ```swift
/// DonutGauge(
///     value: 45678.90,
///     max: 100000,
///     title: "Net Worth",
///     subtitle: "Total Assets",
///     size: .large
/// )
/// ```
public struct DonutGauge: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    private let value: Double
    private let max: Double
    private let title: String
    private let subtitle: String?
    private let size: GaugeSize
    
    // MARK: - Computed Properties
    
    private var percentage: Double {
        guard max > 0 else { return 0 }
        return min(value / max, 1.0)
    }
    
    private var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    private var percentageText: String {
        "\(Int(percentage * 100))%"
    }
    
    // MARK: - Size Configuration
    
    private var diameter: CGFloat {
        switch size {
        case .small: return 120
        case .medium: return 180
        case .large: return 240
        case .custom(let value): return value
        }
    }
    
    private var strokeWidth: CGFloat {
        diameter * 0.12 // 12% of diameter
    }
    
    private var valueFontSize: CGFloat {
        diameter * 0.15 // 15% of diameter
    }
    
    private var percentageFontSize: CGFloat {
        diameter * 0.09 // 9% of diameter
    }
    
    private var titleFontSize: CGFloat {
        diameter * 0.08 // 8% of diameter
    }
    
    private var subtitleFontSize: CGFloat {
        diameter * 0.06 // 6% of diameter
    }
    
    // MARK: - Initialization
    
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
            // Gauge Ring
            ZStack {
                // Background ring
                Circle()
                    .stroke(
                        theme.colors.backgroundSecondary,
                        style: StrokeStyle(
                            lineWidth: strokeWidth,
                            lineCap: .round
                        )
                    )
                
                // Foreground progress ring with gradient
                Circle()
                    .trim(from: 0, to: percentage)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                theme.colors.primary,
                                theme.colors.primaryAlt,
                                theme.colors.primary
                            ]),
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(270 * percentage - 90)
                        ),
                        style: StrokeStyle(
                            lineWidth: strokeWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.8), value: percentage)
                
                // Center content
                VStack(spacing: theme.spacing.xxs) {
                    // Main value
                    Text(formattedValue)
                        .font(.system(size: valueFontSize, weight: .bold, design: .rounded))
                        .foregroundColor(theme.colors.textPrimary)
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                    
                    // Percentage
                    Text(percentageText)
                        .font(.system(size: percentageFontSize, weight: .medium, design: .rounded))
                        .foregroundColor(theme.colors.textSecondary)
                }
                .padding(strokeWidth)
            }
            .frame(width: diameter, height: diameter)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityValue(accessibilityValue)
            .accessibilityAddTraits(.updatesFrequently)
            
            // Labels below gauge
            VStack(spacing: theme.spacing.xxs) {
                Text(title)
                    .font(.system(size: titleFontSize, weight: .semibold))
                    .foregroundColor(theme.colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: subtitleFontSize, weight: .regular))
                        .foregroundColor(theme.colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
    
    // MARK: - Accessibility
    
    private var accessibilityLabel: String {
        if let subtitle = subtitle {
            return "\(title), \(subtitle)"
        }
        return title
    }
    
    private var accessibilityValue: String {
        let percentageRounded = Int(percentage * 100)
        return "\(formattedValue), \(percentageRounded) percent of \(formatCurrency(max))"
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

// MARK: - Gauge Size

public enum GaugeSize {
    case small      // 120pt diameter
    case medium     // 180pt diameter
    case large      // 240pt diameter
    case custom(CGFloat)
}

// MARK: - Preview Helpers

#Preview("DonutGauge - Vibrant Theme") {
    ThemeProvider(theme: VibrantTheme()) {
        DonutGaugePreviewContent()
    }
    .frame(width: 800, height: 600)
    .padding(40)
}

#Preview("DonutGauge - Neutral Theme") {
    ThemeProvider(theme: NeutralTheme()) {
        DonutGaugePreviewContent()
    }
    .frame(width: 800, height: 600)
    .padding(40)
}

struct DonutGaugePreviewContent: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.xl) {
            // Size comparison
            HStack(spacing: theme.spacing.xl) {
                DonutGauge(
                    value: 45678.90,
                    max: 100000,
                    title: "Small",
                    subtitle: "120pt",
                    size: .small
                )
                
                DonutGauge(
                    value: 45678.90,
                    max: 100000,
                    title: "Medium",
                    subtitle: "180pt",
                    size: .medium
                )
                
                DonutGauge(
                    value: 45678.90,
                    max: 100000,
                    title: "Large",
                    subtitle: "240pt",
                    size: .large
                )
            }
        }
        .padding(theme.spacing.xl)
        .background(theme.colors.background)
    }
}
