import SwiftUI

/// Dashboard view showing overview of financial status
struct DashboardView: View {
    @Environment(\.theme) private var theme
    private let dataService = MockDataService.shared
    
    let dateRange: DateRange
    let searchText: String
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: theme.spacing.lg) {
                // Top overview cards
                overviewCards
                
                // Net worth gauge and income/expense chart
                mainChartsSection
                
                // Recent transactions and quick stats
                recentActivitySection
            }
            .padding(theme.spacing.md)
        }
    }
    
    // MARK: - Overview Cards
    private var overviewCards: some View {
        HStack(spacing: theme.spacing.md) {
            // Net Worth Card
            Card(elevation: .medium) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    HStack {
                        Text("Net Worth")
                            .cardTitle()
                        Spacer()
                        Image(systemName: "chart.line.uptrend.xyaxis")
                            .foregroundColor(theme.colors.success)
                    }
                    
                    Text(formatCurrency(dataService.netWorth))
                        .font(theme.typography.title1Font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    HStack {
                        Text("+12.5% this month")
                            .font(theme.typography.captionFont)
                            .foregroundColor(theme.colors.success)
                        Spacer()
                    }
                }
            }
            
            // Available Balance Card
            Card(elevation: .medium) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    HStack {
                        Text("Available Balance")
                            .cardTitle()
                        Spacer()
                        Image(systemName: "dollarsign.circle")
                            .foregroundColor(theme.colors.primary)
                    }
                    
                    Text(formatCurrency(dataService.availableBalance))
                        .font(theme.typography.title1Font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    HStack {
                        Text("Across 4 accounts")
                            .font(theme.typography.captionFont)
                            .foregroundColor(theme.colors.textSecondary)
                        Spacer()
                    }
                }
            }
            
            // Monthly Summary Card
            Card(elevation: .medium) {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    HStack {
                        Text("This Month")
                            .cardTitle()
                        Spacer()
                        Image(systemName: "calendar")
                            .foregroundColor(theme.colors.info)
                    }
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Income")
                                .font(theme.typography.captionFont)
                                .foregroundColor(theme.colors.textSecondary)
                            Text(formatCurrency(dataService.monthlyIncome))
                                .font(theme.typography.calloutFont)
                                .foregroundColor(theme.colors.success)
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 2) {
                            Text("Expenses")
                                .font(theme.typography.captionFont)
                                .foregroundColor(theme.colors.textSecondary)
                            Text(formatCurrency(dataService.monthlyExpenses))
                                .font(theme.typography.calloutFont)
                                .foregroundColor(theme.colors.error)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Main Charts Section
    private var mainChartsSection: some View {
        HStack(alignment: .top, spacing: theme.spacing.lg) {
            // Net Worth Donut Gauge
            DonutGauge.netWorth(
                current: dataService.netWorth,
                target: dataService.netWorthTarget,
                subtitle: "+12.5% this month"
            )
            .frame(maxWidth: .infinity)
            
            // Income vs Expenses Chart
            IncomeExpenseChart.demoCard(
                title: "Income vs Expenses",
                subtitle: "Last \(dateRange.days) days"
            )
            .frame(maxWidth: .infinity)
        }
    }
    
    // MARK: - Recent Activity Section
    private var recentActivitySection: some View {
        VStack(spacing: theme.spacing.md) {
            HStack {
                Text("Recent Activity")
                    .font(theme.typography.title3Font)
                    .foregroundColor(theme.colors.textPrimary)
                Spacer()
                Button("View All") {
                    // Navigate to transactions
                }
                .font(theme.typography.calloutFont)
                .foregroundColor(theme.colors.primary)
            }
            
            // Recent transactions preview
            Card {
                VStack(spacing: theme.spacing.sm) {
                    ForEach(filteredTransactions.prefix(5)) { transaction in
                        recentTransactionRow(transaction)
                        if transaction.id != filteredTransactions.prefix(5).last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    private func recentTransactionRow(_ transaction: TransactionRow) -> some View {
        HStack {
            // Category icon
            Image(systemName: transaction.category.icon)
                .foregroundColor(transaction.category.color)
                .frame(width: 20)
            
            // Transaction details
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.subCategory)
                    .font(theme.typography.calloutFont)
                    .foregroundColor(theme.colors.textPrimary)
                Text(transaction.payee)
                    .font(theme.typography.captionFont)
                    .foregroundColor(theme.colors.textSecondary)
            }
            
            Spacer()
            
            // Amount
            Text(formatCurrency(transaction.amount))
                .font(theme.typography.calloutFont)
                .foregroundColor(transaction.amount > 0 ? theme.colors.error : theme.colors.success)
        }
    }
    
    // MARK: - Computed Properties
    private var filteredTransactions: [TransactionRow] {
        let transactions = dataService.getTransactions(for: dateRange)
        if searchText.isEmpty {
            return transactions
        }
        return transactions.filter { transaction in
            transaction.subCategory.localizedCaseInsensitiveContains(searchText) ||
            transaction.payee.localizedCaseInsensitiveContains(searchText) ||
            transaction.description.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    // MARK: - Helper Functions
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        
        if abs(amount) >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: amount / 1_000_000)) ?? "$0M"
        } else if abs(amount) >= 1_000 {
            return formatter.string(from: NSNumber(value: amount / 1_000)) ?? "$0K"
        } else {
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: amount)) ?? "$0"
        }
    }
}

/// Income & Expenses view for transaction management
struct IncomeExpensesView: View {
    @Environment(\.theme) private var theme
    private let dataService = MockDataService.shared
    
    let dateRange: DateRange
    let searchText: String
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            // Income/Expense chart
            IncomeExpenseChart.demoCard(
                title: "Income vs Expenses Trend",
                subtitle: "Daily comparison for \(dateRange.rawValue.lowercased())"
            )
            .padding(.horizontal, theme.spacing.md)
            
            // Transactions table
            TransactionsTableView(
                transactions: filteredTransactions,
                onRowDoubleClick: { transaction in
                    print("Edit transaction: \(transaction.subCategory)")
                }
            )
            .padding(.horizontal, theme.spacing.md)
        }
    }
    
    private var filteredTransactions: [TransactionRow] {
        let transactions = dataService.getTransactions(for: dateRange)
        if searchText.isEmpty {
            return transactions
        }
        return transactions.filter { transaction in
            transaction.subCategory.localizedCaseInsensitiveContains(searchText) ||
            transaction.payee.localizedCaseInsensitiveContains(searchText) ||
            transaction.description.localizedCaseInsensitiveContains(searchText)
        }
    }
}

/// Assets & Goals view for portfolio and goal management
struct AssetsGoalsView: View {
    @Environment(\.theme) private var theme
    private let dataService = MockDataService.shared
    @State private var goals = GoalsListView.demoGoals
    
    let dateRange: DateRange
    let searchText: String
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.lg) {
                // Assets allocation pie chart
                AssetsPieCard.demo(
                    title: "Asset Allocation",
                    subtitle: "Investment portfolio breakdown"
                )
                .padding(.horizontal, theme.spacing.md)
                
                // Goals list
                Card {
                    GoalsListView(
                        goals: $goals,
                        onGoalUpdate: { updatedGoal in
                            print("Goal updated: \(updatedGoal.name)")
                        },
                        onGoalDelete: { deletedGoal in
                            print("Goal deleted: \(deletedGoal.name)")
                        }
                    )
                }
                .padding(.horizontal, theme.spacing.md)
            }
        }
    }
}