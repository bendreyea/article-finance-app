import SwiftUI

/// Comprehensive previews for AppShell and related components
struct AppShellPreviews: View {
    var body: some View {
        TabView {
            // Full AppShell
            fullAppShellTab
                .tabItem {
                    Label("Complete App", systemImage: "app.fill")
                }
            
            // Individual views
            individualViewsTab
                .tabItem {
                    Label("Individual Views", systemImage: "rectangle.grid.1x2")
                }
            
            // Theme comparison
            themeComparisonTab
                .tabItem {
                    Label("Themes", systemImage: "paintbrush.pointed")
                }
            
            // Data showcase
            dataShowcaseTab
                .tabItem {
                    Label("Mock Data", systemImage: "chart.bar.doc.horizontal")
                }
        }
    }
    
    // MARK: - Full AppShell Tab
    private var fullAppShellTab: some View {
        AppShell()
    }
    
    // MARK: - Individual Views Tab
    private var individualViewsTab: some View {
        NavigationView {
            List {
                NavigationLink("Dashboard View") {
                    DashboardView(dateRange: .month, searchText: "")
                        .theme(VibrantTheme())
                        .navigationTitle("Dashboard")
                }
                
                NavigationLink("Income & Expenses View") {
                    IncomeExpensesView(dateRange: .month, searchText: "")
                        .theme(VibrantTheme())
                        .navigationTitle("Income & Expenses")
                }
                
                NavigationLink("Assets & Goals View") {
                    AssetsGoalsView(dateRange: .month, searchText: "")
                        .theme(VibrantTheme())
                        .navigationTitle("Assets & Goals")
                }
            }
            .navigationTitle("Individual Views")
        }
    }
    
    // MARK: - Theme Comparison Tab
    private var themeComparisonTab: some View {
        VStack(spacing: 20) {
            Text("AppShell Theme Comparison")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            HStack(spacing: 20) {
                VStack {
                    Text("Vibrant Theme")
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    AppShellShowcase()
                        .theme(VibrantTheme())
                        .frame(height: 600)
                }
                
                VStack {
                    Text("Neutral Theme")
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    AppShellShowcase()
                        .theme(NeutralTheme())
                        .frame(height: 600)
                }
            }
            .padding()
        }
    }
    
    // MARK: - Data Showcase Tab
    private var dataShowcaseTab: some View {
        NavigationView {
            MockDataShowcase()
                .navigationTitle("Mock Data Service")
        }
    }
}

/// Compact AppShell showcase for theme comparison
private struct AppShellShowcase: View {
    @Environment(\.theme) private var theme
    @State private var selectedSection: AppSection = .dashboard
    @State private var dateRange: DateRange = .month
    @State private var searchText: String = ""
    
    var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text("Personal Finance")
                    .font(theme.typography.headlineFont)
                    .foregroundColor(theme.colors.textPrimary)
                    .padding(.horizontal, theme.spacing.md)
                    .padding(.top, theme.spacing.md)
                
                ForEach(AppSection.allCases) { section in
                    Button(action: { selectedSection = section }) {
                        HStack(spacing: theme.spacing.sm) {
                            Image(systemName: section.icon)
                                .foregroundColor(theme.colors.primary)
                                .frame(width: 20)
                            
                            Text(section.rawValue)
                                .font(theme.typography.calloutFont)
                                .foregroundColor(theme.colors.textPrimary)
                            
                            Spacer()
                        }
                        .padding(.horizontal, theme.spacing.md)
                        .padding(.vertical, theme.spacing.xs)
                        .background(selectedSection == section ? theme.colors.primary.opacity(0.1) : Color.clear)
                        .cornerRadius(theme.radius.sm)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.horizontal, theme.spacing.sm)
                }
                
                Spacer()
            }
            .frame(width: 200)
            .background(theme.colors.surfaceVariant)
            
            // Main content
            VStack(spacing: 0) {
                // Toolbar
                HStack(spacing: theme.spacing.md) {
                    Text(selectedSection.rawValue)
                        .font(theme.typography.title2Font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Spacer()
                    
                    // Date range picker (mini)
                    Picker("Range", selection: $dateRange) {
                        ForEach([DateRange.week, DateRange.month]) { range in
                            Text(range.rawValue.prefix(2)).tag(range)
                        }
                    }
                    .pickerStyle(.segmented)
                    .frame(width: 80)
                    
                    // Search field (mini)
                    HStack(spacing: 4) {
                        Image(systemName: "magnifyingglass")
                            .font(.caption)
                        TextField("Search", text: $searchText)
                            .font(.caption)
                    }
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(theme.colors.surfaceVariant)
                    .cornerRadius(4)
                    .frame(width: 60)
                }
                .padding(theme.spacing.sm)
                .background(theme.colors.surface)
                
                // Content preview
                contentPreview
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(theme.colors.background)
            }
        }
        .background(theme.colors.background)
        .cornerRadius(theme.radius.xl)
    }
    
    @ViewBuilder
    private var contentPreview: some View {
        switch selectedSection {
        case .dashboard:
            DashboardPreview()
        case .incomeExpenses:
            IncomeExpensesPreview()
        case .assetsGoals:
            AssetsGoalsPreview()
        }
    }
}

// MARK: - Content Previews
private struct DashboardPreview: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.md) {
                // Overview cards (mini)
                HStack(spacing: theme.spacing.sm) {
                    miniCard(title: "Net Worth", value: "$285K", color: theme.colors.success)
                    miniCard(title: "Balance", value: "$45K", color: theme.colors.primary)
                    miniCard(title: "Income", value: "$8.5K", color: theme.colors.info)
                }
                
                // Charts preview
                HStack(spacing: theme.spacing.sm) {
                    DonutGauge(
                        value: 285000,
                        maxValue: 350000,
                        title: "Net Worth",
                        size: .small
                    )
                    
                    RoundedRectangle(cornerRadius: theme.radius.md)
                        .fill(theme.colors.surface)
                        .frame(height: 120)
                        .overlay(
                            Text("Income vs\nExpenses Chart")
                                .font(theme.typography.captionFont)
                                .multilineTextAlignment(.center)
                        )
                }
            }
            .padding(theme.spacing.sm)
        }
    }
    
    private func miniCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 2) {
            Text(title)
                .font(theme.typography.captionFont)
                .foregroundColor(theme.colors.textSecondary)
            Text(value)
                .font(theme.typography.calloutFont)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, theme.spacing.xs)
        .background(theme.colors.surface)
        .cornerRadius(theme.radius.sm)
    }
}

private struct IncomeExpensesPreview: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            // Chart placeholder
            RoundedRectangle(cornerRadius: theme.radius.md)
                .fill(theme.colors.surface)
                .frame(height: 120)
                .overlay(
                    Text("Income vs Expenses\nTrend Chart")
                        .font(theme.typography.calloutFont)
                        .multilineTextAlignment(.center)
                )
            
            // Transactions table preview
            VStack(spacing: theme.spacing.xs) {
                ForEach(0..<3) { index in
                    HStack {
                        Circle()
                            .fill(theme.colors.primary)
                            .frame(width: 8, height: 8)
                        Text("Transaction \(index + 1)")
                            .font(theme.typography.captionFont)
                        Spacer()
                        Text("$\(index * 50 + 25)")
                            .font(theme.typography.captionFont)
                            .foregroundColor(theme.colors.error)
                    }
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.vertical, 2)
                    .background(theme.colors.surface)
                    .cornerRadius(theme.radius.sm)
                }
            }
        }
        .padding(theme.spacing.sm)
    }
}

private struct AssetsGoalsPreview: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            // Pie chart preview
            Circle()
                .fill(theme.colors.surface)
                .frame(width: 100, height: 100)
                .overlay(
                    Text("Asset\nPie Chart")
                        .font(theme.typography.captionFont)
                        .multilineTextAlignment(.center)
                )
            
            // Goals list preview
            VStack(spacing: theme.spacing.xs) {
                ForEach(0..<2) { index in
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text("Goal \(index + 1)")
                                .font(theme.typography.calloutFont)
                            Spacer()
                            Text("\((index + 1) * 30)%")
                                .font(theme.typography.captionFont)
                        }
                        
                        ProgressBar(progress: Double(index + 1) * 0.3, height: 6)
                    }
                    .padding(theme.spacing.xs)
                    .background(theme.colors.surface)
                    .cornerRadius(theme.radius.sm)
                }
            }
        }
        .padding(theme.spacing.sm)
    }
}

// MARK: - Mock Data Showcase
private struct MockDataShowcase: View {
    @Environment(\.theme) private var theme
    private let dataService = MockDataService.shared
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: theme.spacing.lg) {
                // Overview data
                overviewDataSection
                
                // Transaction samples
                transactionSamplesSection
                
                // Account balances
                accountBalancesSection
                
                // Historical data
                historicalDataSection
            }
            .padding(theme.spacing.md)
        }
    }
    
    private var overviewDataSection: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Overview Data")
                    .cardTitle()
                
                VStack(spacing: theme.spacing.sm) {
                    dataRow("Net Worth", formatCurrency(dataService.netWorth))
                    dataRow("Available Balance", formatCurrency(dataService.availableBalance))
                    dataRow("Monthly Income", formatCurrency(dataService.monthlyIncome))
                    dataRow("Monthly Expenses", formatCurrency(dataService.monthlyExpenses))
                }
            }
        }
    }
    
    private var transactionSamplesSection: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Sample Transactions")
                    .cardTitle()
                
                VStack(spacing: theme.spacing.xs) {
                    ForEach(dataService.getTransactions(for: .week).prefix(5)) { transaction in
                        HStack {
                            Image(systemName: transaction.category.icon)
                                .foregroundColor(transaction.category.color)
                                .frame(width: 16)
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(transaction.subCategory)
                                    .font(theme.typography.calloutFont)
                                    .foregroundColor(theme.colors.textPrimary)
                                Text(transaction.payee)
                                    .font(theme.typography.captionFont)
                                    .foregroundColor(theme.colors.textSecondary)
                            }
                            
                            Spacer()
                            
                            Text(formatCurrency(transaction.amount))
                                .font(theme.typography.calloutFont)
                                .foregroundColor(transaction.amount > 0 ? theme.colors.error : theme.colors.success)
                        }
                        .padding(.vertical, 2)
                        
                        if transaction.id != dataService.getTransactions(for: .week).prefix(5).last?.id {
                            Divider()
                        }
                    }
                }
            }
        }
    }
    
    private var accountBalancesSection: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Account Balances")
                    .cardTitle()
                
                VStack(spacing: theme.spacing.sm) {
                    ForEach(dataService.getAccountBalances()) { account in
                        HStack {
                            Image(systemName: account.type.icon)
                                .foregroundColor(account.type.color)
                                .frame(width: 20)
                            
                            Text(account.name)
                                .font(theme.typography.calloutFont)
                                .foregroundColor(theme.colors.textPrimary)
                            
                            Spacer()
                            
                            Text(formatCurrency(account.balance))
                                .font(theme.typography.calloutFont)
                                .foregroundColor(theme.colors.textPrimary)
                        }
                    }
                }
            }
        }
    }
    
    private var historicalDataSection: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Historical Net Worth")
                    .cardTitle()
                
                VStack(spacing: theme.spacing.xs) {
                    ForEach(dataService.getNetWorthHistory(months: 6)) { dataPoint in
                        HStack {
                            Text(formatDate(dataPoint.date))
                                .font(theme.typography.captionFont)
                                .foregroundColor(theme.colors.textSecondary)
                            
                            Spacer()
                            
                            Text(formatCurrency(dataPoint.netWorth))
                                .font(theme.typography.calloutFont)
                                .foregroundColor(theme.colors.textPrimary)
                        }
                    }
                }
            }
        }
    }
    
    private func dataRow(_ label: String, _ value: String) -> some View {
        HStack {
            Text(label)
                .font(theme.typography.calloutFont)
                .foregroundColor(theme.colors.textSecondary)
            Spacer()
            Text(value)
                .font(theme.typography.calloutFont)
                .foregroundColor(theme.colors.textPrimary)
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Preview Provider
#Preview("Complete AppShell") {
    AppShell()
}

#Preview("AppShell Previews") {
    AppShellPreviews()
}

#Preview("Dashboard View Only") {
    NavigationView {
        DashboardView(dateRange: .month, searchText: "")
            .navigationTitle("Dashboard")
    }
    .theme(VibrantTheme())
}

#Preview("Income & Expenses View Only") {
    NavigationView {
        IncomeExpensesView(dateRange: .month, searchText: "")
            .navigationTitle("Income & Expenses")
    }
    .theme(VibrantTheme())
}

#Preview("Assets & Goals View Only") {
    NavigationView {
        AssetsGoalsView(dateRange: .month, searchText: "")
            .navigationTitle("Assets & Goals")
    }
    .theme(VibrantTheme())
}

#Preview("Mock Data Service") {
    NavigationView {
        MockDataShowcase()
            .navigationTitle("Mock Data")
    }
    .theme(VibrantTheme())
}