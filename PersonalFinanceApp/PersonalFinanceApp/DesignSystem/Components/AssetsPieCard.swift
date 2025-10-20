import SwiftUI
import Charts

/// A data model representing an asset allocation
public struct AssetAllocation: Identifiable, Hashable {
    public let id = UUID()
    public let name: String
    public let value: Double
    public let category: AssetCategory
    
    public init(name: String, value: Double, category: AssetCategory) {
        self.name = name
        self.value = value
        self.category = category
    }
}

/// Asset categories for grouping and theming
public enum AssetCategory: String, CaseIterable, Identifiable {
    case stocks = "Stocks"
    case bonds = "Bonds"
    case realEstate = "Real Estate"
    case cash = "Cash"
    case crypto = "Cryptocurrency"
    case commodities = "Commodities"
    case other = "Other"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .stocks: return "chart.line.uptrend.xyaxis"
        case .bonds: return "doc.text"
        case .realEstate: return "house.fill"
        case .cash: return "dollarsign.circle"
        case .crypto: return "bitcoinsign.circle"
        case .commodities: return "cube.fill"
        case .other: return "questionmark.circle"
        }
    }
}

/// Extension to provide chart color palette
extension ColorTokens {
    /// Chart color palette for pie charts and data visualization
    public var chartPalette: [Color] {
        [
            primary,
            secondary,
            success,
            warning,
            error,
            info,
            Color(red: 0.8, green: 0.4, blue: 0.8),  // Purple
            Color(red: 0.4, green: 0.8, blue: 0.8),  // Cyan
            Color(red: 0.8, green: 0.8, blue: 0.4),  // Yellow-green
            Color(red: 0.9, green: 0.5, blue: 0.4)   // Coral
        ]
    }
}

/// A pie chart card component showing asset allocation with center total and external legend
public struct AssetsPieCard: View {
    @Environment(\.theme) private var theme
    
    private let assets: [AssetAllocation]
    private let title: String
    private let subtitle: String?
    private let showLegend: Bool
    private let animationDelay: Double
    
    /// Creates an AssetsPieCard with the specified data
    /// - Parameters:
    ///   - assets: Array of asset allocations to display
    ///   - title: Card title
    ///   - subtitle: Optional card subtitle
    ///   - showLegend: Whether to show the external legend
    ///   - animationDelay: Delay before chart animation starts
    public init(
        assets: [AssetAllocation],
        title: String = "Asset Allocation",
        subtitle: String? = nil,
        showLegend: Bool = true,
        animationDelay: Double = 0.0
    ) {
        self.assets = assets
        self.title = title
        self.subtitle = subtitle
        self.showLegend = showLegend
        self.animationDelay = animationDelay
    }
    
    public var body: some View {
        Card(elevation: .medium) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Header
                cardHeader
                
                if showLegend {
                    // Chart with external legend layout
                    HStack(spacing: theme.spacing.lg) {
                        // Pie chart
                        pieChart
                            .frame(width: 200, height: 200)
                        
                        // External legend
                        externalLegend
                    }
                } else {
                    // Chart only (centered)
                    HStack {
                        Spacer()
                        pieChart
                            .frame(width: 240, height: 240)
                        Spacer()
                    }
                }
            }
        }
    }
    
    // MARK: - Card Header
    private var cardHeader: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            HStack {
                Text(title)
                    .cardTitle()
                
                Spacer()
                
                // Total value
                totalValueView
            }
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .cardCaption()
            }
        }
    }
    
    // MARK: - Total Value Display
    private var totalValueView: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text("Total")
                .font(theme.typography.captionFont)
                .foregroundColor(theme.colors.textSecondary)
            
            Text(formatCurrency(totalValue))
                .font(theme.typography.font(size: theme.typography.title3, weight: theme.typography.bold))
                .foregroundColor(theme.colors.textPrimary)
        }
    }
    
    // MARK: - Pie Chart
    private var pieChart: some View {
        Chart(assets) { asset in
            SectorMark(
                angle: .value("Value", asset.value),
                innerRadius: .ratio(0.4),  // Creates donut effect
                angularInset: 2.0
            )
            .foregroundStyle(colorForAsset(asset))
            .opacity(0.9)
        }
        .overlay(
            // Center content
            centerContent
        )
        .animation(.easeInOut(duration: 1.0).delay(animationDelay), value: assets.count)
        .chartBackground { _ in
            Circle()
                .fill(theme.colors.surface)
                .shadow(theme.shadows.subtle)
        }
    }
    
    // MARK: - Center Content
    private var centerContent: some View {
        VStack(spacing: theme.spacing.xs) {
            Text(formatCurrency(totalValue))
                .font(theme.typography.font(size: theme.typography.title2, weight: theme.typography.bold))
                .foregroundColor(theme.colors.textPrimary)
            
            Text("Total Assets")
                .font(theme.typography.captionFont)
                .foregroundColor(theme.colors.textSecondary)
            
            if assets.count > 0 {
                Text("\(assets.count) Holdings")
                    .font(theme.typography.font(size: 10, weight: theme.typography.regular))
                    .foregroundColor(theme.colors.textTertiary)
            }
        }
    }
    
    // MARK: - External Legend
    private var externalLegend: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Holdings")
                .font(theme.typography.calloutFont)
                .foregroundColor(theme.colors.textPrimary)
                .fontWeight(theme.typography.medium)
            
            LazyVStack(alignment: .leading, spacing: theme.spacing.xs) {
                ForEach(sortedAssets) { asset in
                    legendItem(for: asset)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private func legendItem(for asset: AssetAllocation) -> some View {
        HStack(spacing: theme.spacing.sm) {
            // Color indicator
            Circle()
                .fill(colorForAsset(asset))
                .frame(width: 12, height: 12)
            
            // Asset info
            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(asset.name)
                        .font(theme.typography.calloutFont)
                        .foregroundColor(theme.colors.textPrimary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Text(formatCurrency(asset.value))
                        .font(theme.typography.font(size: theme.typography.callout, weight: theme.typography.semibold))
                        .foregroundColor(theme.colors.textPrimary)
                }
                
                HStack {
                    Text(asset.category.rawValue)
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Spacer()
                    
                    Text(formatPercentage(asset.value / totalValue))
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var totalValue: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    
    private var sortedAssets: [AssetAllocation] {
        assets.sorted { $0.value > $1.value }
    }
    
    // MARK: - Helper Functions
    
    private func colorForAsset(_ asset: AssetAllocation) -> Color {
        guard let index = sortedAssets.firstIndex(where: { $0.id == asset.id }) else {
            return theme.colors.chartPalette.first ?? theme.colors.primary
        }
        return theme.colors.chartPalette[index % theme.colors.chartPalette.count]
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        
        if abs(value) >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value / 1_000_000)) ?? "$0M"
        } else if abs(value) >= 1_000 {
            return formatter.string(from: NSNumber(value: value / 1_000)) ?? "$0K"
        } else {
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: value)) ?? "$0"
        }
    }
    
    private func formatPercentage(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: value)) ?? "0%"
    }
}

// MARK: - Demo Data and Convenience Initializers
extension AssetsPieCard {
    /// Sample asset data for previews and demos
    public static var demoAssets: [AssetAllocation] {
        [
            AssetAllocation(name: "S&P 500 Index", value: 125000, category: .stocks),
            AssetAllocation(name: "Tech Stocks", value: 85000, category: .stocks),
            AssetAllocation(name: "Government Bonds", value: 45000, category: .bonds),
            AssetAllocation(name: "Primary Residence", value: 280000, category: .realEstate),
            AssetAllocation(name: "Savings Account", value: 25000, category: .cash),
            AssetAllocation(name: "Bitcoin", value: 35000, category: .crypto),
            AssetAllocation(name: "Gold ETF", value: 15000, category: .commodities)
        ]
    }
    
    /// Creates an AssetsPieCard with demo data
    public static func demo(
        title: String = "Asset Portfolio",
        subtitle: String? = "Investment allocation",
        showLegend: Bool = true,
        animationDelay: Double = 0.0
    ) -> AssetsPieCard {
        AssetsPieCard(
            assets: demoAssets,
            title: title,
            subtitle: subtitle,
            showLegend: showLegend,
            animationDelay: animationDelay
        )
    }
}