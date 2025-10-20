import SwiftUI

// MARK: - Dashboard View

struct DashboardView: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                // Header
                header
                
                // Key Metrics
                metricsGrid
                
                // Charts Section
                HStack(alignment: .top, spacing: theme.spacing.lg) {
                    // Net Worth Gauge
                    Card(shadow: .md) {
                        DonutGauge(
                            value: appState.dataService.totalAssets,
                            max: 1_000_000,
                            title: "Net Worth",
                            subtitle: "Target: $1M",
                            size: .medium
                        )
                        .padding(theme.spacing.lg)
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Income/Expense Chart
                    IncomeExpenseChart(
                        income: incomeChartData,
                        expenses: expenseChartData
                    )
                    .frame(maxWidth: .infinity)
                }
                
                // Recent Activity
                recentActivity
            }
            .padding(theme.spacing.xl)
        }
        .background(theme.colors.background)
    }
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                Text("Dashboard")
                    .font(theme.typography.displaySmall.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                Text(dateRangeText)
                    .font(theme.typography.bodyMedium.font)
                    .foregroundColor(theme.colors.textSecondary)
            }
            
            Spacer()
            
            if appState.dataService.isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            }
        }
    }
    
    private var metricsGrid: some View {
        HStack(spacing: theme.spacing.lg) {
            metricCard(
                title: "Total Assets",
                value: formatCurrency(appState.dataService.totalAssets),
                change: "+12.5%",
                isPositive: true,
                icon: "chart.line.uptrend.xyaxis"
            )
            
            metricCard(
                title: "Monthly Income",
                value: formatCurrency(appState.dataService.totalIncome),
                change: "+8.2%",
                isPositive: true,
                icon: "arrow.down.circle.fill"
            )
            
            metricCard(
                title: "Monthly Expenses",
                value: formatCurrency(appState.dataService.totalExpenses),
                change: "-3.1%",
                isPositive: true,
                icon: "arrow.up.circle.fill"
            )
            
            metricCard(
                title: "Net Cash Flow",
                value: formatCurrency(appState.dataService.netCashFlow),
                change: appState.dataService.netCashFlow >= 0 ? "+15.3%" : "-5.2%",
                isPositive: appState.dataService.netCashFlow >= 0,
                icon: "dollarsign.circle.fill"
            )
        }
    }
    
    private func metricCard(
        title: String,
        value: String,
        change: String,
        isPositive: Bool,
        icon: String
    ) -> some View {
        Card(shadow: .sm) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(theme.colors.primary)
                    
                    Spacer()
                    
                    HStack(spacing: theme.spacing.xxs) {
                        Image(systemName: isPositive ? "arrow.up" : "arrow.down")
                            .font(.system(size: 10, weight: .bold))
                        
                        Text(change)
                            .font(theme.typography.labelSmall.font)
                    }
                    .foregroundColor(isPositive ? theme.colors.success : theme.colors.error)
                }
                
                Text(title)
                    .font(theme.typography.labelMedium.font)
                    .foregroundColor(theme.colors.textSecondary)
                
                Text(value)
                    .font(theme.typography.titleLarge.font)
                    .foregroundColor(theme.colors.textPrimary)
                    .monospacedDigit()
            }
            .padding(theme.spacing.lg)
        }
    }
    
    private var recentActivity: some View {
        Card(shadow: .sm) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                HStack {
                    Text("Recent Transactions")
                        .font(theme.typography.titleMedium.font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Spacer()
                    
                    Button("View All") {
                        appState.navigate(to: .incomeExpenses)
                    }
                    .buttonStyle(.plain)
                    .font(theme.typography.labelMedium.font)
                    .foregroundColor(theme.colors.primary)
                }
                
                Divider()
                    .background(theme.colors.border)
                
                ForEach(appState.dataService.transactions.prefix(5)) { transaction in
                    HStack {
                        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                            Text(transaction.subCategory)
                                .font(theme.typography.bodyMedium.font)
                                .foregroundColor(theme.colors.textPrimary)
                            
                            Text(transaction.category)
                                .font(theme.typography.labelSmall.font)
                                .foregroundColor(theme.colors.textTertiary)
                        }
                        
                        Spacer()
                        
                        Text(formatAmount(transaction.amount))
                            .font(theme.typography.bodyMedium.font)
                            .foregroundColor(
                                transaction.amount >= 0
                                    ? theme.colors.success
                                    : theme.colors.error
                            )
                            .monospacedDigit()
                    }
                    .padding(.vertical, theme.spacing.xs)
                }
            }
            .padding(theme.spacing.lg)
        }
    }
    
    private var dateRangeText: String {
        "Showing data for \(appState.dateRange.displayName.lowercased())"
    }
    
    private var incomeChartData: [(Date, Double)] {
        appState.dataService.chartData.map { point in
            (point.date, max(0, point.value))
        }
    }
    
    private var expenseChartData: [(Date, Double)] {
        appState.dataService.chartData.map { point in
            (point.date, abs(min(0, point.value - 5000)))
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: abs(value))) ?? "$0"
    }
    
    private func formatAmount(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        let prefix = value >= 0 ? "+" : ""
        return prefix + (formatter.string(from: NSNumber(value: abs(value))) ?? "$0")
    }
}

// MARK: - Income & Expenses View

struct IncomeExpensesView: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        TransactionsTableContent()
            .environmentObject(appState)
            .environmentObject(appState.dataService)
    }
}

private struct TransactionsTableContent: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataService: MockDataService
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text("Income & Expenses")
                        .font(theme.typography.displaySmall.font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("\(filteredTransactions.count) transactions")
                        .font(theme.typography.bodyMedium.font)
                        .foregroundColor(theme.colors.textSecondary)
                }
                
                Spacer()
            }
            .padding(theme.spacing.xl)
            .background(theme.colors.background)
            
            // Transactions Table
            TransactionsTableView(
                transactions: $dataService.transactions,
                onRowDoubleClick: { transaction in
                    print("Edit transaction: \(transaction.id)")
                }
            )
        }
    }
    
    private var filteredTransactions: [TransactionRow] {
        let transactions = dataService.transactions
        
        guard !appState.searchText.isEmpty else {
            return transactions
        }
        
        return transactions.filter { transaction in
            transaction.subCategory.localizedCaseInsensitiveContains(appState.searchText) ||
            transaction.category.localizedCaseInsensitiveContains(appState.searchText) ||
            transaction.merchant?.localizedCaseInsensitiveContains(appState.searchText) ?? false
        }
    }
}

// MARK: - Assets & Goals View

struct AssetsGoalsView: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        AssetsGoalsContent()
            .environmentObject(appState)
            .environmentObject(appState.dataService)
    }
}

private struct AssetsGoalsContent: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var dataService: MockDataService
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: theme.spacing.xs) {
                        Text("Assets & Goals")
                            .font(theme.typography.displaySmall.font)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("Track your wealth and objectives")
                            .font(theme.typography.bodyMedium.font)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: theme.spacing.xxs) {
                        Text("Net Worth")
                            .font(theme.typography.labelSmall.font)
                            .foregroundColor(theme.colors.textSecondary)
                        
                        Text(formatCurrency(dataService.totalAssets))
                            .font(theme.typography.titleLarge.font)
                            .foregroundColor(theme.colors.primary)
                            .monospacedDigit()
                    }
                }
                .padding(.horizontal, theme.spacing.xl)
                .padding(.top, theme.spacing.xl)
                
                // Assets Pie Chart
                AssetsPieCard(assets: dataService.assets)
                    .padding(.horizontal, theme.spacing.xl)
                
                // Goals List
                Card {
                    GoalsListView(
                        goals: $dataService.goals,
                        onGoalUpdate: { goal in
                            dataService.updateGoal(goal)
                        },
                        onGoalDelete: { goal in
                            dataService.deleteGoal(goal)
                        }
                    )
                }
                .padding(.horizontal, theme.spacing.xl)
                .padding(.bottom, theme.spacing.xl)
            }
        }
        .background(theme.colors.background)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}
