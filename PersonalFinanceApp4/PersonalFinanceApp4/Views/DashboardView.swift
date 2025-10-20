//
//  DashboardView.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// Main dashboard view showing overview and key metrics
struct DashboardView: View {
    @Environment(\.theme) private var theme
    let dataService: MockDataService
    let filter: DataFilter
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                // Top metrics cards
                metricCardsSection
                
                // Net worth donut gauge
                netWorthSection
                
                // Income vs Expenses chart
                incomeExpensesSection
                
                // Quick summary cards
                summaryCardsSection
            }
            .padding(theme.spacing.xl)
        }
    }
    
    // MARK: - Metric Cards Section
    
    private var metricCardsSection: some View {
        HStack(spacing: theme.spacing.lg) {
            metricCard(
                title: "Available Balance",
                value: currencyFormatter.string(from: NSNumber(value: dataService.availableBalance)) ?? "$0",
                icon: "banknote",
                color: theme.colors.success
            )
            
            metricCard(
                title: "Total Assets",
                value: currencyFormatter.string(from: NSNumber(value: dataService.totalAssets)) ?? "$0",
                icon: "chart.line.uptrend.xyaxis",
                color: theme.colors.primary
            )
            
            metricCard(
                title: "Active Goals",
                value: "\(dataService.goals.filter { !$0.isCompleted }.count)",
                icon: "target",
                color: theme.colors.info
            )
        }
    }
    
    private func metricCard(title: String, value: String, icon: String, color: Color) -> some View {
        Card(elevation: .low, padding: .standard) {
            HStack(spacing: theme.spacing.md) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: 28))
                    .foregroundColor(color)
                    .frame(width: 56, height: 56)
                    .background(color.opacity(0.1))
                    .cornerRadius(theme.radius.md)
                
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text(title)
                        .font(theme.typography.labelMedium)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                    
                    Text(value)
                        .font(theme.typography.headingLarge)
                        .foregroundColor(theme.colors.onSurface)
                        .fontWeight(.bold)
                }
                
                Spacer()
            }
        }
    }
    
    // MARK: - Net Worth Section
    
    private var netWorthSection: some View {
        Card(elevation: .medium, padding: .standard) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                Text("Net Worth Overview")
                    .font(theme.typography.headingMedium)
                    .foregroundColor(theme.colors.onSurface)
                
                HStack(spacing: theme.spacing.xxxl) {
                    // Donut gauge
                    DonutGauge(
                        value: dataService.availableBalance,
                        max: dataService.totalAssets,
                        title: "Liquid Assets",
                        subtitle: "\(Int(dataService.availableBalance / dataService.totalAssets * 100))% of Total",
                        size: .large
                    )
                    .frame(width: 280, height: 280)
                    
                    // Breakdown list
                    VStack(alignment: .leading, spacing: theme.spacing.md) {
                        Text("Asset Breakdown")
                            .font(theme.typography.labelLarge)
                            .foregroundColor(theme.colors.onSurfaceSecondary)
                            .padding(.bottom, theme.spacing.xs)
                        
                        ForEach(dataService.aggregatedAssets.prefix(5)) { categoryData in
                            HStack {
                                Circle()
                                    .fill(theme.colors.primary)
                                    .frame(width: 8, height: 8)
                                
                                Text(categoryData.category.rawValue)
                                    .font(theme.typography.bodyMedium)
                                    .foregroundColor(theme.colors.onSurface)
                                
                                Spacer()
                                
                                Text(currencyFormatter.string(from: NSNumber(value: categoryData.totalValue)) ?? "$0")
                                    .font(theme.typography.bodyMedium)
                                    .foregroundColor(theme.colors.onSurfaceSecondary)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    // MARK: - Income vs Expenses Section
    
    private var incomeExpensesSection: some View {
        let filteredData = dataService.filteredIncomeExpenseData(filter: filter)
        
        return IncomeExpenseChart(
            incomeData: filteredData.income,
            expenseData: filteredData.expenses,
            title: "Income vs Expenses",
            subtitle: filter.dateRange.title
        )
    }
    
    // MARK: - Summary Cards Section
    
    private var summaryCardsSection: some View {
        HStack(spacing: theme.spacing.lg) {
            // Recent transactions summary
            Card(elevation: .low, padding: .standard) {
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    HStack {
                        Image(systemName: "list.bullet.rectangle")
                            .font(.system(size: 20))
                            .foregroundColor(theme.colors.primary)
                        
                        Text("Recent Transactions")
                            .font(theme.typography.headingSmall)
                            .foregroundColor(theme.colors.onSurface)
                        
                        Spacer()
                    }
                    
                    Text("\(dataService.transactions.prefix(10).count) transactions")
                        .font(theme.typography.bodyMedium)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        ForEach(dataService.transactions.prefix(5)) { transaction in
                            HStack {
                                Text(transaction.subcategory)
                                    .font(theme.typography.bodySmall)
                                    .foregroundColor(theme.colors.onSurface)
                                
                                Spacer()
                                
                                Text(currencyFormatter.string(from: NSNumber(value: transaction.amount)) ?? "$0")
                                    .font(theme.typography.bodySmall)
                                    .foregroundColor(transaction.category == .income ? theme.colors.success : theme.colors.onSurfaceSecondary)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                }
            }
            
            // Goals summary
            Card(elevation: .low, padding: .standard) {
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    HStack {
                        Image(systemName: "target")
                            .font(.system(size: 20))
                            .foregroundColor(theme.colors.primary)
                        
                        Text("Financial Goals")
                            .font(theme.typography.headingSmall)
                            .foregroundColor(theme.colors.onSurface)
                        
                        Spacer()
                    }
                    
                    Text("\(dataService.goals.count) active goals")
                        .font(theme.typography.bodyMedium)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        ForEach(dataService.goals.prefix(5)) { goal in
                            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                                HStack {
                                    Text(goal.name)
                                        .font(theme.typography.bodySmall)
                                        .foregroundColor(theme.colors.onSurface)
                                    
                                    Spacer()
                                    
                                    Text("\(Int(goal.progressPercentage))%")
                                        .font(theme.typography.labelSmall)
                                        .foregroundColor(theme.colors.onSurfaceSecondary)
                                }
                                
                                ProgressBar(
                                    progress: goal.progress,
                                    size: .small,
                                    showPercentage: false,
                                    color: .success
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview("DashboardView - Vibrant Theme") {
    ThemeProvider(theme: VibrantTheme()) {
        DashboardView(
            dataService: MockDataService(),
            filter: DataFilter(dateRange: .month)
        )
    }
    .frame(width: 1200, height: 900)
}

#Preview("DashboardView - Neutral Theme") {
    ThemeProvider(theme: NeutralTheme()) {
        DashboardView(
            dataService: MockDataService(),
            filter: DataFilter(dateRange: .month)
        )
    }
    .frame(width: 1200, height: 900)
}
