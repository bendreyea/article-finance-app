import SwiftUI

/// A reusable donut gauge component for visualizing progress with themed styling
public struct DonutGauge: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    private let value: Double
    private let max: Double
    private let title: String
    private let subtitle: String?
    private let size: DonutGaugeSize
    
    // MARK: - Size Configuration
    public enum DonutGaugeSize {
        case small
        case medium
        case large
        case custom(diameter: CGFloat, lineWidth: CGFloat)
        
        var diameter: CGFloat {
            switch self {
            case .small: return 120
            case .medium: return 180
            case .large: return 240
            case .custom(let diameter, _): return diameter
            }
        }
        
        var lineWidth: CGFloat {
            switch self {
            case .small: return 12
            case .medium: return 16
            case .large: return 20
            case .custom(_, let lineWidth): return lineWidth
            }
        }
    }
    
    // MARK: - Initializer
    public init(
        value: Double,
        max: Double,
        title: String,
        subtitle: String? = nil,
        size: DonutGaugeSize = .medium
    ) {
        self.value = value
        self.max = max
        self.title = title
        self.subtitle = subtitle
        self.size = size
    }
    
    // MARK: - Computed Properties
    private var progress: Double {
        guard max > 0 else { return 0 }
        return min(Swift.max(value / max, 0), 1)
    }
    
    private var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
    
    private var formattedMax: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: max)) ?? "$0"
    }
    
    private var percentageText: String {
        let percentage = progress * 100
        return String(format: "%.0f%%", percentage)
    }
    
    private var accessibilityLabel: String {
        let baseLabel = "\(title): \(formattedValue) of \(formattedMax), \(percentageText)"
        if let subtitle = subtitle {
            return "\(baseLabel). \(subtitle)"
        }
        return baseLabel
    }
    
    // MARK: - Body
    public var body: some View {
        VStack(spacing: theme.spacing.md) {
            ZStack {
                // Background ring
                Circle()
                    .stroke(
                        theme.colors.border,
                        style: StrokeStyle(
                            lineWidth: size.lineWidth,
                            lineCap: .round
                        )
                    )
                
                // Progress ring with gradient
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        AngularGradient(
                            gradient: Gradient(colors: [
                                theme.colors.brandPrimary,
                                theme.colors.brandSecondary
                            ]),
                            center: .center,
                            startAngle: .degrees(-90),
                            endAngle: .degrees(-90 + (360 * progress))
                        ),
                        style: StrokeStyle(
                            lineWidth: size.lineWidth,
                            lineCap: .round
                        )
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 0.8), value: progress)
                
                // Center content
                VStack(spacing: theme.spacing.xs) {
                    Text(formattedValue)
                        .font(valueFontSize)
                        .fontWeight(theme.typography.bold)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text(percentageText)
                        .font(percentageFontSize)
                        .fontWeight(theme.typography.medium)
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
            .frame(width: size.diameter, height: size.diameter)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabel)
            .accessibilityValue("\(percentageText)")
            .accessibilityAddTraits(.updatesFrequently)
            
            // Labels
            VStack(spacing: theme.spacing.xs) {
                Text(title)
                    .font(theme.typography.headline)
                    .fontWeight(theme.typography.semibold)
                    .foregroundColor(theme.colors.textPrimary)
                    .multilineTextAlignment(.center)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(theme.typography.footnote)
                        .foregroundColor(theme.colors.textSecondary)
                        .multilineTextAlignment(.center)
                }
            }
            .accessibilityHidden(true)
        }
    }
    
    // MARK: - Dynamic Font Sizes
    private var valueFontSize: Font {
        switch size {
        case .small:
            return theme.typography.title3
        case .medium:
            return theme.typography.title1
        case .large:
            return theme.typography.largeTitle
        case .custom(let diameter, _):
            if diameter < 140 {
                return theme.typography.title3
            } else if diameter < 200 {
                return theme.typography.title1
            } else {
                return theme.typography.largeTitle
            }
        }
    }
    
    private var percentageFontSize: Font {
        switch size {
        case .small:
            return theme.typography.caption
        case .medium:
            return theme.typography.subheadline
        case .large:
            return theme.typography.callout
        case .custom(let diameter, _):
            if diameter < 140 {
                return theme.typography.caption
            } else if diameter < 200 {
                return theme.typography.subheadline
            } else {
                return theme.typography.callout
            }
        }
    }
}

// MARK: - Preview Provider
#Preview("Donut Gauge - Vibrant Theme") {
    let vibrantTheme = VibrantTheme()
    
    VStack(spacing: 32) {
        DonutGauge(
            value: 12500,
            max: 20000,
            title: "Net Worth",
            subtitle: "Total assets",
            size: .large
        )
        
        HStack(spacing: 24) {
            DonutGauge(
                value: 3200,
                max: 5000,
                title: "Savings",
                size: .small
            )
            
            DonutGauge(
                value: 8500,
                max: 10000,
                title: "Investments",
                subtitle: "YTD Growth",
                size: .medium
            )
        }
    }
    .padding(32)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(vibrantTheme.colors.backgroundPrimary)
    .theme(vibrantTheme)
}

#Preview("Donut Gauge - Neutral Theme") {
    let neutralTheme = NeutralTheme()
    
    VStack(spacing: 32) {
        DonutGauge(
            value: 12500,
            max: 20000,
            title: "Net Worth",
            subtitle: "Total assets",
            size: .large
        )
        
        HStack(spacing: 24) {
            DonutGauge(
                value: 3200,
                max: 5000,
                title: "Savings",
                size: .small
            )
            
            DonutGauge(
                value: 8500,
                max: 10000,
                title: "Investments",
                subtitle: "YTD Growth",
                size: .medium
            )
        }
    }
    .padding(32)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(neutralTheme.colors.backgroundPrimary)
    .theme(neutralTheme)
}

#Preview("Donut Gauge - Size Comparison") {
    HStack(spacing: 32) {
        VStack(spacing: 16) {
            Text("Small")
                .font(.caption)
            DonutGauge(
                value: 7500,
                max: 10000,
                title: "Progress",
                size: .small
            )
        }
        
        VStack(spacing: 16) {
            Text("Medium")
                .font(.caption)
            DonutGauge(
                value: 7500,
                max: 10000,
                title: "Progress",
                size: .medium
            )
        }
        
        VStack(spacing: 16) {
            Text("Large")
                .font(.caption)
            DonutGauge(
                value: 7500,
                max: 10000,
                title: "Progress",
                size: .large
            )
        }
    }
    .padding(32)
    .theme(NeutralTheme())
}

#Preview("Donut Gauge - Edge Cases") {
    VStack(spacing: 32) {
        HStack(spacing: 24) {
            DonutGauge(
                value: 0,
                max: 10000,
                title: "Empty",
                subtitle: "0%",
                size: .medium
            )
            
            DonutGauge(
                value: 10000,
                max: 10000,
                title: "Full",
                subtitle: "100%",
                size: .medium
            )
        }
        
        DonutGauge(
            value: 15000,
            max: 10000,
            title: "Over Limit",
            subtitle: "Exceeds max (capped at 100%)",
            size: .medium
        )
    }
    .padding(32)
    .theme(VibrantTheme())
}
