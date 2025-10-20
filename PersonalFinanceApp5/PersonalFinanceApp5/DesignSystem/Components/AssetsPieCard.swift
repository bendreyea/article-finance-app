import SwiftUI
import Charts

// MARK: - Asset Data Model

/// Data model for an asset in the pie chart
public struct AssetData: Identifiable, Hashable {
    public let id: UUID
    public let name: String
    public let value: Double
    public let category: String
    public let description: String?
    
    public init(
        id: UUID = UUID(),
        name: String,
        value: Double,
        category: String,
        description: String? = nil
    ) {
        self.id = id
        self.name = name
        self.value = value
        self.category = category
        self.description = description
    }
}

// MARK: - Assets Pie Card

/// A card displaying assets in a pie chart with center total and external legend
public struct AssetsPieCard: View {
    @Environment(\.theme) private var theme
    
    // Data
    let assets: [AssetData]
    let title: String
    let showLegend: Bool
    
    // State
    @State private var selectedAsset: AssetData?
    
    public init(
        assets: [AssetData],
        title: String = "Assets",
        showLegend: Bool = true
    ) {
        self.assets = assets
        self.title = title
        self.showLegend = showLegend
    }
    
    // MARK: - Body
    
    public var body: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                        Text(title)
                            .font(theme.typography.titleLarge.font)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("\(assets.count) assets")
                            .font(theme.typography.labelMedium.font)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    // Total Value Badge
                    VStack(alignment: .trailing, spacing: theme.spacing.xxs) {
                        Text("Total Value")
                            .font(theme.typography.labelSmall.font)
                            .foregroundColor(theme.colors.textSecondary)
                        
                        Text(formatCurrency(totalValue))
                            .font(theme.typography.titleLarge.font)
                            .foregroundColor(theme.colors.primary)
                            .monospacedDigit()
                    }
                }
                
                // Chart and Legend
                HStack(alignment: .top, spacing: theme.spacing.xl) {
                    // Pie Chart
                    pieChart
                        .frame(width: 280, height: 280)
                    
                    // Legend
                    if showLegend {
                        legend
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
            .padding(theme.spacing.lg)
        }
    }
    
    // MARK: - Pie Chart
    
    private var pieChart: some View {
        ZStack {
            // Chart
            Chart(assets) { asset in
                SectorMark(
                    angle: .value("Value", asset.value),
                    innerRadius: .ratio(0.55),
                    angularInset: 1.5
                )
                .foregroundStyle(colorForIndex(assets.firstIndex(of: asset) ?? 0))
                .opacity(selectedAsset == nil || selectedAsset == asset ? 1.0 : 0.3)
            }
            .chartAngleSelection(value: $selectedAsset)
            .chartLegend(.hidden)
            
            // Center Content
            VStack(spacing: theme.spacing.xs) {
                if let selected = selectedAsset {
                    Text(selected.name)
                        .font(theme.typography.bodyMedium.font)
                        .foregroundColor(theme.colors.textSecondary)
                        .lineLimit(2)
                        .multilineTextAlignment(.center)
                    
                    Text(formatCurrency(selected.value))
                        .font(theme.typography.titleLarge.font)
                        .foregroundColor(theme.colors.textPrimary)
                        .monospacedDigit()
                    
                    Text(formatPercentage(selected.value / totalValue))
                        .font(theme.typography.labelMedium.font)
                        .foregroundColor(theme.colors.primary)
                } else {
                    Text("Total")
                        .font(theme.typography.bodyMedium.font)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Text(formatCurrency(totalValue))
                        .font(theme.typography.titleLarge.font)
                        .foregroundColor(theme.colors.textPrimary)
                        .monospacedDigit()
                    
                    Text("\(assets.count) assets")
                        .font(theme.typography.labelMedium.font)
                        .foregroundColor(theme.colors.textTertiary)
                }
            }
            .frame(maxWidth: 120)
            .padding(theme.spacing.md)
        }
    }
    
    // MARK: - Legend
    
    private var legend: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            ForEach(Array(assets.enumerated()), id: \.element.id) { index, asset in
                legendItem(asset: asset, index: index)
            }
        }
    }
    
    private func legendItem(asset: AssetData, index: Int) -> some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedAsset = selectedAsset == asset ? nil : asset
            }
        } label: {
            HStack(spacing: theme.spacing.sm) {
                // Color Indicator
                RoundedRectangle(cornerRadius: theme.radius.sm)
                    .fill(colorForIndex(index))
                    .frame(width: 16, height: 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: theme.radius.sm)
                            .strokeBorder(
                                theme.colors.border.opacity(0.3),
                                lineWidth: 1
                            )
                    )
                
                // Asset Info
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    HStack {
                        Text(asset.name)
                            .font(theme.typography.bodyMedium.font)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Spacer()
                        
                        Text(formatCurrency(asset.value))
                            .font(theme.typography.bodyMedium.font)
                            .foregroundColor(theme.colors.textPrimary)
                            .monospacedDigit()
                    }
                    
                    HStack {
                        Text(asset.category)
                            .font(theme.typography.labelSmall.font)
                            .foregroundColor(theme.colors.textTertiary)
                        
                        Spacer()
                        
                        Text(formatPercentage(asset.value / totalValue))
                            .font(theme.typography.labelSmall.font)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                }
            }
            .padding(theme.spacing.sm)
            .background(
                selectedAsset == asset
                    ? theme.colors.primary.opacity(0.08)
                    : Color.clear
            )
            .cornerRadius(theme.radius.sm)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Computed Properties
    
    private var totalValue: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    
    // MARK: - Helpers
    
    private func colorForIndex(_ index: Int) -> Color {
        let palette = theme.colors.chartPalette
        return palette[index % palette.count]
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        if value >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value / 1_000_000))?.replacingOccurrences(of: ".0", with: "") ?? "$0" + "M"
        } else if value >= 1_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value / 1_000))?.replacingOccurrences(of: ".0", with: "") ?? "$0" + "K"
        } else {
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: value)) ?? "$0"
        }
    }
    
    private func formatPercentage(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "0%"
    }
}

// MARK: - Chart Extension for Angle Selection

extension Chart {
    func chartAngleSelection(value: Binding<AssetData?>) -> some View {
        self.chartAngleSelection(value: Binding(
            get: { value.wrappedValue?.value },
            set: { newValue in
                // This is a simplified implementation
                // In production, you'd need to map the angle back to the asset
            }
        ))
    }
}

// MARK: - Asset Demo Data Generator

/// Generates sample asset data for previews and testing
public struct AssetDemoData {
    public static func generateAssets() -> [AssetData] {
        return [
            AssetData(
                name: "401(k)",
                value: 125_000,
                category: "Retirement",
                description: "Employer-sponsored retirement account"
            ),
            AssetData(
                name: "Roth IRA",
                value: 45_000,
                category: "Retirement",
                description: "Individual retirement account"
            ),
            AssetData(
                name: "Brokerage",
                value: 82_500,
                category: "Investment",
                description: "Taxable investment account"
            ),
            AssetData(
                name: "Savings",
                value: 25_000,
                category: "Cash",
                description: "Emergency fund"
            ),
            AssetData(
                name: "Checking",
                value: 8_500,
                category: "Cash",
                description: "Primary checking account"
            ),
            AssetData(
                name: "Real Estate",
                value: 350_000,
                category: "Property",
                description: "Primary residence equity"
            ),
            AssetData(
                name: "Crypto",
                value: 15_000,
                category: "Alternative",
                description: "Cryptocurrency holdings"
            )
        ]
    }
    
    public static func generateRandomAssets(count: Int = 5) -> [AssetData] {
        let categories = ["Retirement", "Investment", "Cash", "Property", "Alternative"]
        let names = [
            "Retirement": ["401(k)", "Roth IRA", "Traditional IRA", "Pension"],
            "Investment": ["Brokerage", "Stocks", "Bonds", "ETFs"],
            "Cash": ["Savings", "Checking", "Money Market", "CD"],
            "Property": ["Real Estate", "Home Equity", "Rental Property"],
            "Alternative": ["Crypto", "Commodities", "Collectibles"]
        ]
        
        return (0..<count).map { _ in
            let category = categories.randomElement()!
            let name = names[category]?.randomElement() ?? "Asset"
            let value = Double.random(in: 5_000...200_000)
            
            return AssetData(
                name: name,
                value: value,
                category: category
            )
        }
    }
}

// MARK: - Preview

#Preview("Assets Pie - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 24) {
            AssetsPieCard(assets: AssetDemoData.generateAssets())
                .frame(height: 400)
            
            HStack(spacing: 24) {
                AssetsPieCard(
                    assets: AssetDemoData.generateAssets().prefix(4).map { $0 },
                    title: "Retirement",
                    showLegend: false
                )
                
                AssetsPieCard(
                    assets: AssetDemoData.generateAssets().suffix(3).map { $0 },
                    title: "Liquid Assets",
                    showLegend: false
                )
            }
        }
        .padding()
        .frame(width: 1200)
        .background(VibrantTheme().colors.background)
    }
}
