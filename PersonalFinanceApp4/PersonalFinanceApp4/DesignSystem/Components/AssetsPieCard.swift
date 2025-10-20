//
//  AssetsPieCard.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI
import Charts

/// A pie chart card component displaying asset allocation by category
/// Uses Swift Charts SectorMark with center total and external legend
public struct AssetsPieCard: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    public let assetData: [AssetCategoryData]
    public let title: String
    public let subtitle: String?
    public let showLegend: Bool
    public let showCenterTotal: Bool
    
    // MARK: - Computed Properties
    
    private var totalAssets: Double {
        assetData.reduce(0) { $0 + $1.totalValue }
    }
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    private let percentFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 1
        formatter.minimumFractionDigits = 0
        return formatter
    }()
    
    // MARK: - Initialization
    
    public init(
        assetData: [AssetCategoryData],
        title: String = "Asset Allocation",
        subtitle: String? = nil,
        showLegend: Bool = true,
        showCenterTotal: Bool = true
    ) {
        self.assetData = assetData
        self.title = title
        self.subtitle = subtitle
        self.showLegend = showLegend
        self.showCenterTotal = showCenterTotal
    }
    
    // MARK: - Body
    
    public var body: some View {
        Card(elevation: .medium, padding: .standard) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Header
                headerView
                
                // Chart and Legend layout
                if showLegend {
                    HStack(alignment: .top, spacing: theme.spacing.xl) {
                        // Pie Chart
                        pieChartView
                            .frame(maxWidth: .infinity)
                        
                        // Legend
                        legendView
                            .frame(width: 180)
                    }
                } else {
                    // Chart only
                    pieChartView
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            Text(title)
                .font(theme.typography.headingMedium)
                .foregroundColor(theme.colors.onSurface)
            
            if let subtitle = subtitle {
                Text(subtitle)
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
            }
        }
    }
    
    // MARK: - Pie Chart View
    
    private var pieChartView: some View {
        ZStack {
            // Pie Chart
            Chart(assetData) { categoryData in
                SectorMark(
                    angle: .value("Value", categoryData.totalValue),
                    innerRadius: .ratio(showCenterTotal ? 0.6 : 0.0),
                    angularInset: 2.0
                )
                .foregroundStyle(colorForCategory(categoryData.category))
                .cornerRadius(4)
            }
            .chartLegend(.hidden)
            .frame(height: 280)
            
            // Center Total
            if showCenterTotal {
                VStack(spacing: theme.spacing.xxs) {
                    Text("Total Assets")
                        .font(theme.typography.labelMedium)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                    
                    Text(currencyFormatter.string(from: NSNumber(value: totalAssets)) ?? "$0")
                        .font(theme.typography.headingLarge)
                        .foregroundColor(theme.colors.onSurface)
                        .fontWeight(.bold)
                }
            }
        }
    }
    
    // MARK: - Legend View
    
    private var legendView: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Categories")
                .font(theme.typography.labelLarge)
                .foregroundColor(theme.colors.onSurfaceSecondary)
                .padding(.bottom, theme.spacing.xxs)
            
            ScrollView {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    ForEach(assetData) { categoryData in
                        legendItemView(for: categoryData)
                    }
                }
            }
        }
    }
    
    // MARK: - Legend Item View
    
    private func legendItemView(for categoryData: AssetCategoryData) -> some View {
        HStack(alignment: .top, spacing: theme.spacing.sm) {
            // Color indicator
            Circle()
                .fill(colorForCategory(categoryData.category))
                .frame(width: 12, height: 12)
                .padding(.top, 4)
            
            VStack(alignment: .leading, spacing: theme.spacing.xxxs) {
                // Category name
                HStack {
                    Image(systemName: categoryData.category.icon)
                        .font(.system(size: 12))
                        .foregroundColor(theme.colors.onSurface)
                    
                    Text(categoryData.category.description)
                        .font(theme.typography.bodySmall)
                        .foregroundColor(theme.colors.onSurface)
                        .fontWeight(.medium)
                }
                
                // Value and percentage
                HStack(spacing: theme.spacing.xs) {
                    Text(currencyFormatter.string(from: NSNumber(value: categoryData.totalValue)) ?? "$0")
                        .font(theme.typography.labelSmall)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                    
                    Text("•")
                        .font(theme.typography.labelSmall)
                        .foregroundColor(theme.colors.onSurfaceTertiary)
                    
                    Text(percentFormatter.string(from: NSNumber(value: categoryData.percentage(of: totalAssets) / 100)) ?? "0%")
                        .font(theme.typography.labelSmall)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                }
            }
            
            Spacer()
        }
    }
    
    // MARK: - Helper Methods
    
    /// Get color for a category from the chart palette
    private func colorForCategory(_ category: AssetCategory) -> Color {
        let index = AssetCategory.allCases.firstIndex(of: category) ?? 0
        return theme.colors.chartPalette[index % theme.colors.chartPalette.count]
    }
}

// MARK: - Previews

#Preview("AssetsPieCard - Vibrant Theme") {
    ThemeProvider(theme: VibrantTheme()) {
        ScrollView {
            VStack(spacing: 24) {
                Text("Assets Pie Chart")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)
                
                AssetsPieCard(
                    assetData: AssetCategoryData.generateDemoData(),
                    title: "Asset Allocation",
                    subtitle: "By Category"
                )
            }
            .padding()
        }
    }
    .frame(width: 800, height: 600)
}

#Preview("AssetsPieCard - Neutral Theme") {
    ThemeProvider(theme: NeutralTheme()) {
        ScrollView {
            VStack(spacing: 24) {
                Text("Assets Pie Chart")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)
                
                AssetsPieCard(
                    assetData: AssetCategoryData.generateDemoData(),
                    title: "Asset Allocation",
                    subtitle: "By Category"
                )
            }
            .padding()
        }
    }
    .frame(width: 800, height: 600)
}

#Preview("AssetsPieCard - Without Legend") {
    ThemeProvider(theme: VibrantTheme()) {
        ScrollView {
            VStack(spacing: 24) {
                AssetsPieCard(
                    assetData: AssetCategoryData.generateDemoData(),
                    title: "Total Assets",
                    showLegend: false
                )
                .frame(width: 400)
            }
            .padding()
        }
    }
    .frame(width: 600, height: 500)
}

#Preview("AssetsPieCard - Full Pie (No Center)") {
    ThemeProvider(theme: NeutralTheme()) {
        ScrollView {
            VStack(spacing: 24) {
                AssetsPieCard(
                    assetData: AssetCategoryData.generateDemoData(),
                    title: "Asset Distribution",
                    subtitle: "All Accounts",
                    showCenterTotal: false
                )
            }
            .padding()
        }
    }
    .frame(width: 800, height: 600)
}

#Preview("AssetsPieCard - Side by Side Themes") {
    HStack(spacing: 24) {
        ThemeProvider(theme: VibrantTheme()) {
            AssetsPieCard(
                assetData: AssetCategoryData.generateDemoData(),
                title: "Vibrant Theme"
            )
            .frame(width: 700)
        }
        
        ThemeProvider(theme: NeutralTheme()) {
            AssetsPieCard(
                assetData: AssetCategoryData.generateDemoData(),
                title: "Neutral Theme"
            )
            .frame(width: 700)
        }
    }
    .padding()
    .frame(width: 1500, height: 500)
}
