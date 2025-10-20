//
//  DonutGauge.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// A circular gauge component that displays progress as a stroked ring with a gradient.
/// The center shows a currency-formatted value with optional title and subtitle.
///
/// Example usage:
/// ```swift
/// DonutGauge(
///     value: 156789.50,
///     max: 200000,
///     title: "Net Worth",
///     subtitle: "Total Assets"
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
    private let showPercentage: Bool
    
    // MARK: - Computed Properties
    
    /// The percentage value (0.0 to 1.0) for the gauge
    private var percentage: Double {
        guard max > 0 else { return 0 }
        return min(Swift.max(value / max, 0), 1.0)
    }
    
    /// The angle in degrees for the progress arc
    private var progressAngle: Double {
        percentage * 360
    }
    
    /// Formatted currency string for the value
    private var formattedValue: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = value >= 1000 ? 0 : 2
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
    
    /// Formatted percentage string
    private var formattedPercentage: String {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = .percent
        percentFormatter.maximumFractionDigits = 1
        percentFormatter.minimumFractionDigits = 0
        
        return percentFormatter.string(from: NSNumber(value: percentage)) ?? "0%"
    }
    
    /// Accessibility label for VoiceOver
    private var accessibilityLabel: String {
        var label = "\(title): \(formattedValue) of \(formattedMax)"
        if let subtitle = subtitle {
            label += ", \(subtitle)"
        }
        label += ", \(formattedPercentage) complete"
        return label
    }
    
    /// Formatted max value for accessibility
    private var formattedMax: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: max)) ?? "$0"
    }
    
    // MARK: - Initialization
    
    public init(
        value: Double,
        max: Double,
        title: String,
        subtitle: String? = nil,
        size: GaugeSize = .medium,
        showPercentage: Bool = false
    ) {
        self.value = value
        self.max = max
        self.title = title
        self.subtitle = subtitle
        self.size = size
        self.showPercentage = showPercentage
    }
    
    // MARK: - Body
    
    public var body: some View {
        ZStack {
            // Background ring
            backgroundRing
            
            // Progress ring with gradient
            progressRing
            
            // Center content
            centerContent
        }
        .frame(width: size.diameter, height: size.diameter)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityValue(formattedPercentage)
        .accessibilityHint("Circular progress indicator")
    }
    
    // MARK: - Subviews
    
    /// The background ring that shows the full circle
    private var backgroundRing: some View {
        Circle()
            .stroke(
                theme.colors.surfaceVariant,
                style: StrokeStyle(
                    lineWidth: size.strokeWidth,
                    lineCap: .round
                )
            )
    }
    
    /// The progress ring with gradient
    private var progressRing: some View {
        Circle()
            .trim(from: 0, to: percentage)
            .stroke(
                AngularGradient(
                    gradient: Gradient(colors: [
                        theme.colors.primary,
                        theme.colors.primaryVariant,
                        theme.colors.primary
                    ]),
                    center: .center,
                    startAngle: .degrees(-90),
                    endAngle: .degrees(270)
                ),
                style: StrokeStyle(
                    lineWidth: size.strokeWidth,
                    lineCap: .round
                )
            )
            .rotationEffect(.degrees(-90))
            .animation(.easeInOut(duration: 1.0), value: percentage)
    }
    
    /// The center content showing value, title, and subtitle
    private var centerContent: some View {
        VStack(spacing: size.contentSpacing) {
            // Main value
            Text(formattedValue)
                .font(size.valueFont(theme))
                .fontWeight(theme.typography.weightBold)
                .foregroundColor(theme.colors.onBackground)
                .minimumScaleFactor(0.7)
                .lineLimit(1)
            
            // Percentage (optional)
            if showPercentage {
                Text(formattedPercentage)
                    .font(size.percentageFont(theme))
                    .foregroundColor(theme.colors.onSurfaceSecondary)
            }
            
            // Title
            Text(title)
                .font(size.titleFont(theme))
                .fontWeight(theme.typography.weightMedium)
                .foregroundColor(theme.colors.onSurfaceSecondary)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            // Subtitle (optional)
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(size.subtitleFont(theme))
                    .foregroundColor(theme.colors.onSurfaceTertiary)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
            }
        }
        .padding(size.innerPadding)
    }
}

// MARK: - Gauge Size

/// Defines the size variants for the DonutGauge
public enum GaugeSize {
    case small
    case medium
    case large
    case custom(diameter: CGFloat, strokeWidth: CGFloat)
    
    /// The outer diameter of the gauge
    var diameter: CGFloat {
        switch self {
        case .small: return 120
        case .medium: return 200
        case .large: return 280
        case .custom(let diameter, _): return diameter
        }
    }
    
    /// The width of the stroke ring
    var strokeWidth: CGFloat {
        switch self {
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        case .custom(_, let strokeWidth): return strokeWidth
        }
    }
    
    /// The padding inside the gauge for content
    var innerPadding: CGFloat {
        diameter * 0.15
    }
    
    /// Spacing between center content elements
    var contentSpacing: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        case .large: return 6
        case .custom: return 4
        }
    }
    
    /// Font for the main value
    func valueFont(_ theme: AppTheme) -> Font {
        switch self {
        case .small: return theme.typography.headingMedium
        case .medium: return theme.typography.displaySmall
        case .large: return theme.typography.displayLarge
        case .custom: return theme.typography.displaySmall
        }
    }
    
    /// Font for the percentage
    func percentageFont(_ theme: AppTheme) -> Font {
        switch self {
        case .small: return theme.typography.bodySmall
        case .medium: return theme.typography.bodyMedium
        case .large: return theme.typography.bodyLarge
        case .custom: return theme.typography.bodyMedium
        }
    }
    
    /// Font for the title
    func titleFont(_ theme: AppTheme) -> Font {
        switch self {
        case .small: return theme.typography.labelSmall
        case .medium: return theme.typography.labelMedium
        case .large: return theme.typography.labelLarge
        case .custom: return theme.typography.labelMedium
        }
    }
    
    /// Font for the subtitle
    func subtitleFont(_ theme: AppTheme) -> Font {
        switch self {
        case .small: return theme.typography.caption
        case .medium: return theme.typography.caption
        case .large: return theme.typography.bodySmall
        case .custom: return theme.typography.caption
        }
    }
}

// MARK: - Previews

#Preview("DonutGauge Sizes - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        ScrollView {
            VStack(spacing: 40) {
                Text("DonutGauge Sizes")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)
                
                // Small
                VStack(spacing: 8) {
                    DonutGauge(
                        value: 75000,
                        max: 100000,
                        title: "Net Worth",
                        subtitle: "Small Size",
                        size: .small
                    )
                    Text("Small (120pt)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Medium
                VStack(spacing: 8) {
                    DonutGauge(
                        value: 156789.50,
                        max: 200000,
                        title: "Net Worth",
                        subtitle: "Medium Size",
                        size: .medium
                    )
                    Text("Medium (200pt)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                // Large
                VStack(spacing: 8) {
                    DonutGauge(
                        value: 350000,
                        max: 500000,
                        title: "Net Worth",
                        subtitle: "Large Size",
                        size: .large
                    )
                    Text("Large (280pt)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }
    .frame(width: 400, height: 1200)
}

#Preview("DonutGauge Progress Levels - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 32) {
            Text("Progress Levels")
                .font(.system(size: 24, weight: .bold))
            
            HStack(spacing: 24) {
                VStack {
                    DonutGauge(
                        value: 15000,
                        max: 100000,
                        title: "15%",
                        subtitle: "Low",
                        size: .medium
                    )
                }
                
                VStack {
                    DonutGauge(
                        value: 50000,
                        max: 100000,
                        title: "50%",
                        subtitle: "Half",
                        size: .medium
                    )
                }
                
                VStack {
                    DonutGauge(
                        value: 95000,
                        max: 100000,
                        title: "95%",
                        subtitle: "Almost Full",
                        size: .medium
                    )
                }
            }
        }
        .padding(40)
    }
    .frame(width: 800, height: 400)
}

#Preview("DonutGauge with Percentage - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 32) {
            Text("With Percentage Display")
                .font(.system(size: 24, weight: .bold))
            
            DonutGauge(
                value: 156789.50,
                max: 200000,
                title: "Net Worth",
                subtitle: "Total Assets",
                size: .large,
                showPercentage: true
            )
        }
        .padding(40)
    }
    .frame(width: 400, height: 500)
}

#Preview("DonutGauge Side-by-Side Themes") {
    HStack(spacing: 0) {
        // Vibrant Theme
        ThemeProvider(theme: VibrantTheme()) {
            VStack(spacing: 24) {
                Text("Vibrant Theme")
                    .font(.system(size: 20, weight: .semibold))
                
                DonutGauge(
                    value: 156789.50,
                    max: 200000,
                    title: "Net Worth",
                    subtitle: "Total Assets",
                    size: .large,
                    showPercentage: true
                )
                
                DonutGauge(
                    value: 8450,
                    max: 10000,
                    title: "Monthly Income",
                    size: .medium
                )
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        Divider()
        
        // Neutral Theme
        ThemeProvider(theme: NeutralTheme()) {
            VStack(spacing: 24) {
                Text("Neutral Theme")
                    .font(.system(size: 20, weight: .semibold))
                
                DonutGauge(
                    value: 156789.50,
                    max: 200000,
                    title: "Net Worth",
                    subtitle: "Total Assets",
                    size: .large,
                    showPercentage: true
                )
                
                DonutGauge(
                    value: 8450,
                    max: 10000,
                    title: "Monthly Income",
                    size: .medium
                )
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    .frame(width: 1000, height: 700)
}

#Preview("DonutGauge in Card - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 24) {
            Text("DonutGauge in Card")
                .font(.system(size: 24, weight: .bold))
            
            Card(elevation: .medium) {
                VStack(spacing: 16) {
                    DonutGauge(
                        value: 156789.50,
                        max: 200000,
                        title: "Net Worth",
                        subtitle: "Total Assets",
                        size: .large,
                        showPercentage: true
                    )
                    
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Target")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$200,000")
                                .font(.headline)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Remaining")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("$43,210")
                                .font(.headline)
                        }
                    }
                }
            }
            .frame(width: 350)
        }
        .padding(40)
    }
    .frame(width: 500, height: 600)
}

#Preview("DonutGauge Edge Cases - Neutral") {
    ThemeProvider(theme: NeutralTheme()) {
        VStack(spacing: 32) {
            Text("Edge Cases")
                .font(.system(size: 24, weight: .bold))
            
            HStack(spacing: 24) {
                // Empty (0%)
                VStack {
                    DonutGauge(
                        value: 0,
                        max: 100000,
                        title: "Empty",
                        subtitle: "0%",
                        size: .medium
                    )
                }
                
                // Full (100%)
                VStack {
                    DonutGauge(
                        value: 100000,
                        max: 100000,
                        title: "Full",
                        subtitle: "100%",
                        size: .medium
                    )
                }
                
                // Over max
                VStack {
                    DonutGauge(
                        value: 125000,
                        max: 100000,
                        title: "Over Max",
                        subtitle: "Capped at 100%",
                        size: .medium
                    )
                }
            }
        }
        .padding(40)
    }
    .frame(width: 900, height: 400)
}
