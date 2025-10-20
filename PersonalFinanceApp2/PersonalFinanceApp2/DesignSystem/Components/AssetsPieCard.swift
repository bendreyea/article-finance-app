import SwiftUI
import Charts

// MARK: - Asset Data Model
public struct AssetItem: Identifiable {
    public let id = UUID()
    public let name: String
    public let value: Double
    public let category: String
    
    public init(name: String, value: Double, category: String) {
        self.name = name
        self.value = value
        self.category = category
    }
}

// MARK: - Assets Pie Card
public struct AssetsPieCard: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    private let assets: [AssetItem]
    private let title: String
    private let subtitle: String?
    
    // MARK: - Computed Properties
    private var totalValue: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    
    private var formattedTotal: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: totalValue)) ?? "$0"
    }
    
    private var assetsByCategory: [(category: String, value: Double, percentage: Double)] {
        let grouped = Dictionary(grouping: assets, by: { $0.category })
        return grouped.map { category, items in
            let value = items.reduce(0) { $0 + $1.value }
            let percentage = totalValue > 0 ? (value / totalValue) * 100 : 0
            return (category, value, percentage)
        }
        .sorted { $0.value > $1.value }
    }
    
    // MARK: - Initializer
    public init(
        assets: [AssetItem],
        title: String = "Assets Breakdown",
        subtitle: String? = nil
    ) {
        self.assets = assets
        self.title = title
        self.subtitle = subtitle
    }
    
    // MARK: - Body
    public var body: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text(title)
                        .font(theme.typography.headline)
                        .fontWeight(theme.typography.semibold)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(theme.typography.footnote)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                }
                
                HStack(spacing: theme.spacing.xxl) {
                    // Pie Chart with Center Total
                    ZStack {
                        Chart(assetsByCategory, id: \.category) { item in
                            SectorMark(
                                angle: .value("Value", item.value),
                                innerRadius: .ratio(0.6),
                                angularInset: 1.5
                            )
                            .foregroundStyle(by: .value("Category", item.category))
                            .cornerRadius(4)
                        }
                        .chartForegroundStyleScale(chartColors)
                        .chartLegend(.hidden)
                        .frame(width: 200, height: 200)
                        
                        // Center Total
                        VStack(spacing: theme.spacing.xs) {
                            Text("Total Assets")
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.textSecondary)
                            
                            Text(formattedTotal)
                                .font(theme.typography.title2)
                                .fontWeight(theme.typography.bold)
                                .foregroundColor(theme.colors.textPrimary)
                        }
                    }
                    
                    // External Legend
                    VStack(alignment: .leading, spacing: theme.spacing.md) {
                        ForEach(Array(assetsByCategory.enumerated()), id: \.element.category) { index, item in
                            AssetLegendItem(
                                category: item.category,
                                value: item.value,
                                percentage: item.percentage,
                                color: chartColor(for: index)
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .accessibilityElement(children: .ignore)
                .accessibilityLabel(accessibilityLabel)
            }
        }
    }
    
    // MARK: - Helper Methods
    private var chartColors: KeyValuePairs<String, Color> {
        var pairs: [(String, Color)] = []
        for (index, item) in assetsByCategory.enumerated() {
            pairs.append((item.category, chartColor(for: index)))
        }
        
        // Convert to KeyValuePairs using a switch on count
        switch pairs.count {
        case 0: return [:]
        case 1: return [pairs[0].0: pairs[0].1]
        case 2: return [pairs[0].0: pairs[0].1, pairs[1].0: pairs[1].1]
        case 3: return [pairs[0].0: pairs[0].1, pairs[1].0: pairs[1].1, pairs[2].0: pairs[2].1]
        case 4: return [pairs[0].0: pairs[0].1, pairs[1].0: pairs[1].1, pairs[2].0: pairs[2].1, pairs[3].0: pairs[3].1]
        case 5: return [pairs[0].0: pairs[0].1, pairs[1].0: pairs[1].1, pairs[2].0: pairs[2].1, pairs[3].0: pairs[3].1, pairs[4].0: pairs[4].1]
        case 6: return [pairs[0].0: pairs[0].1, pairs[1].0: pairs[1].1, pairs[2].0: pairs[2].1, pairs[3].0: pairs[3].1, pairs[4].0: pairs[4].1, pairs[5].0: pairs[5].1]
        case 7: return [pairs[0].0: pairs[0].1, pairs[1].0: pairs[1].1, pairs[2].0: pairs[2].1, pairs[3].0: pairs[3].1, pairs[4].0: pairs[4].1, pairs[5].0: pairs[5].1, pairs[6].0: pairs[6].1]
        default: return [pairs[0].0: pairs[0].1, pairs[1].0: pairs[1].1, pairs[2].0: pairs[2].1, pairs[3].0: pairs[3].1, pairs[4].0: pairs[4].1, pairs[5].0: pairs[5].1, pairs[6].0: pairs[6].1, pairs[7].0: pairs[7].1]
        }
    }
    
    private func chartColor(for index: Int) -> Color {
        let palette = chartPalette
        return palette[index % palette.count]
    }
    
    private var chartPalette: [Color] {
        [
            theme.colors.brandPrimary,
            theme.colors.brandSecondary,
            theme.colors.success,
            theme.colors.info,
            theme.colors.warning,
            theme.colors.brandTertiary,
            Color(red: 0.6, green: 0.4, blue: 0.8),  // Purple
            Color(red: 0.2, green: 0.7, blue: 0.7),  // Teal
        ]
    }
    
    private var accessibilityLabel: String {
        let items = assetsByCategory.map { "\($0.category): \(formatCurrency($0.value))" }.joined(separator: ", ")
        return "\(title). Total: \(formattedTotal). Breakdown: \(items)"
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

// MARK: - Asset Legend Item
private struct AssetLegendItem: View {
    @Environment(\.theme) private var theme
    
    let category: String
    let value: Double
    let percentage: Double
    let color: Color
    
    var body: some View {
        HStack(spacing: theme.spacing.sm) {
            // Color indicator
            RoundedRectangle(cornerRadius: 2)
                .fill(color)
                .frame(width: 12, height: 12)
            
            // Category and value
            VStack(alignment: .leading, spacing: 2) {
                Text(category)
                    .font(theme.typography.subheadline)
                    .fontWeight(theme.typography.medium)
                    .foregroundColor(theme.colors.textPrimary)
                
                HStack(spacing: theme.spacing.xs) {
                    Text(formatCurrency(value))
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Text("•")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.textTertiary)
                    
                    Text(String(format: "%.1f%%", percentage))
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
            
            Spacer()
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        
        if abs(value) >= 1_000_000 {
            return "$\(String(format: "%.1f", value / 1_000_000))M"
        } else if abs(value) >= 1_000 {
            return "$\(String(format: "%.1f", value / 1_000))K"
        } else {
            return formatter.string(from: NSNumber(value: value)) ?? "$0"
        }
    }
}

// MARK: - Demo Data
public struct AssetDemoData {
    public static func generateAssets() -> [AssetItem] {
        [
            AssetItem(name: "Savings Account", value: 25000, category: "Cash"),
            AssetItem(name: "Checking Account", value: 8500, category: "Cash"),
            AssetItem(name: "Emergency Fund", value: 15000, category: "Cash"),
            
            AssetItem(name: "S&P 500 Index", value: 45000, category: "Investments"),
            AssetItem(name: "Tech Stocks", value: 28000, category: "Investments"),
            AssetItem(name: "Bonds", value: 12000, category: "Investments"),
            
            AssetItem(name: "401(k)", value: 85000, category: "Retirement"),
            AssetItem(name: "IRA", value: 42000, category: "Retirement"),
            
            AssetItem(name: "Primary Residence", value: 350000, category: "Real Estate"),
            AssetItem(name: "Rental Property", value: 180000, category: "Real Estate"),
            
            AssetItem(name: "Car", value: 28000, category: "Vehicles"),
            AssetItem(name: "Motorcycle", value: 12000, category: "Vehicles"),
        ]
    }
}

// MARK: - Preview Provider
#Preview("Assets Pie Card - Vibrant Theme") {
    let vibrantTheme = VibrantTheme()
    
    VStack(spacing: 24) {
        AssetsPieCard(
            assets: AssetDemoData.generateAssets(),
            title: "Assets Breakdown",
            subtitle: "Total portfolio value"
        )
        
        AssetsPieCard(
            assets: Array(AssetDemoData.generateAssets().prefix(6)),
            title: "Liquid Assets",
            subtitle: "Cash and investments only"
        )
    }
    .padding(24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(vibrantTheme.colors.backgroundPrimary)
    .theme(vibrantTheme)
}

#Preview("Assets Pie Card - Neutral Theme") {
    let neutralTheme = NeutralTheme()
    
    VStack(spacing: 24) {
        AssetsPieCard(
            assets: AssetDemoData.generateAssets(),
            title: "Assets Breakdown",
            subtitle: "Total portfolio value"
        )
    }
    .padding(24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(neutralTheme.colors.backgroundPrimary)
    .theme(neutralTheme)
}
