import SwiftUI

// MARK: - Navigation Sections
public enum NavigationSection: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case incomeExpenses = "Income & Expenses"
    case assetsGoals = "Assets & Goals"
    
    public var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .dashboard:
            return "chart.pie.fill"
        case .incomeExpenses:
            return "dollarsign.circle.fill"
        case .assetsGoals:
            return "target"
        }
    }
}

// MARK: - Date Range Options
public enum DateRange: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case quarter = "Quarter"
    case year = "Year"
    
    public var id: String { rawValue }
}

// MARK: - App Shell
public struct AppShell: View {
    @Environment(\.theme) private var theme
    
    // MARK: - State
    @State private var selectedSection: NavigationSection = .dashboard
    @State private var selectedDateRange: DateRange = .month
    @State private var searchText: String = ""
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    // MARK: - Data Services
    @StateObject private var dataService = MockDataService()
    
    public init() {}
    
    // MARK: - Body
    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar
            SidebarView(selectedSection: $selectedSection)
                .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 250)
        } detail: {
            // Detail Content
            DetailView(
                section: selectedSection,
                dateRange: $selectedDateRange,
                searchText: $searchText,
                dataService: dataService
            )
        }
        .navigationSplitViewStyle(.balanced)
    }
}

// MARK: - Sidebar View
private struct SidebarView: View {
    @Environment(\.theme) private var theme
    @Binding var selectedSection: NavigationSection
    
    var body: some View {
        List(NavigationSection.allCases, selection: $selectedSection) { section in
            NavigationLink(value: section) {
                Label {
                    Text(section.rawValue)
                        .font(theme.typography.body)
                        .foregroundColor(theme.colors.textPrimary)
                } icon: {
                    Image(systemName: section.icon)
                        .font(theme.typography.body)
                        .foregroundColor(selectedSection == section ? theme.colors.brandPrimary : theme.colors.textSecondary)
                }
            }
        }
        .listStyle(.sidebar)
        .navigationTitle("Finance")
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: toggleSidebar) {
                    Image(systemName: "sidebar.left")
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
        }
    }
    
    private func toggleSidebar() {
        #if os(macOS)
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
        #endif
    }
}

// MARK: - Detail View
private struct DetailView: View {
    @Environment(\.theme) private var theme
    
    let section: NavigationSection
    @Binding var dateRange: DateRange
    @Binding var searchText: String
    @ObservedObject var dataService: MockDataService
    
    var body: some View {
        VStack(spacing: 0) {
            // Top Toolbar
            TopToolbar(
                dateRange: $dateRange,
                searchText: $searchText,
                searchPlaceholder: searchPlaceholder
            )
            
            Divider()
                .background(theme.colors.border)
            
            // Content
            ScrollView {
                contentView
                    .padding(theme.spacing.xxl)
            }
            .background(theme.colors.backgroundPrimary)
        }
        .navigationTitle(section.rawValue)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch section {
        case .dashboard:
            DashboardView(
                dataService: dataService,
                dateRange: dateRange,
                searchText: searchText
            )
        case .incomeExpenses:
            IncomeExpensesView(
                dataService: dataService,
                dateRange: dateRange,
                searchText: searchText
            )
        case .assetsGoals:
            AssetsGoalsView(
                dataService: dataService,
                searchText: searchText
            )
        }
    }
    
    private var searchPlaceholder: String {
        switch section {
        case .dashboard:
            return "Search dashboard..."
        case .incomeExpenses:
            return "Search transactions..."
        case .assetsGoals:
            return "Search assets and goals..."
        }
    }
}

// MARK: - Top Toolbar
private struct TopToolbar: View {
    @Environment(\.theme) private var theme
    
    @Binding var dateRange: DateRange
    @Binding var searchText: String
    let searchPlaceholder: String
    
    var body: some View {
        HStack(spacing: theme.spacing.lg) {
            // Date Range Picker
            Picker("Date Range", selection: $dateRange) {
                ForEach(DateRange.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .frame(width: 300)
            
            Spacer()
            
            // Search Field
            HStack(spacing: theme.spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.textSecondary)
                
                TextField(searchPlaceholder, text: $searchText)
                    .textFieldStyle(.plain)
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.textPrimary)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(theme.typography.body)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(theme.spacing.sm)
            .frame(width: 250)
            .background(theme.colors.surface)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.input))
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.input)
                    .stroke(theme.colors.border, lineWidth: 1)
            )
        }
        .padding(theme.spacing.md)
        .background(theme.colors.backgroundSecondary)
    }
}

// MARK: - Dashboard View
private struct DashboardView: View {
    @Environment(\.theme) private var theme
    @ObservedObject var dataService: MockDataService
    let dateRange: DateRange
    let searchText: String
    
    var body: some View {
        VStack(spacing: theme.spacing.xxl) {
            // Net Worth Gauge
            HStack(spacing: theme.spacing.xxl) {
                DonutGauge(
                    value: dataService.netWorth,
                    max: dataService.netWorthGoal,
                    title: "Net Worth",
                    subtitle: "Total value",
                    size: .large
                )
                
                VStack(alignment: .leading, spacing: theme.spacing.lg) {
                    StatCard(
                        title: "Available Balance",
                        value: dataService.availableBalance,
                        icon: "banknote.fill",
                        color: theme.colors.success
                    )
                    
                    StatCard(
                        title: "Total Income",
                        value: dataService.totalIncome(for: dateRange),
                        icon: "arrow.down.circle.fill",
                        color: theme.colors.info
                    )
                    
                    StatCard(
                        title: "Total Expenses",
                        value: dataService.totalExpenses(for: dateRange),
                        icon: "arrow.up.circle.fill",
                        color: theme.colors.error
                    )
                }
            }
            
            // Income & Expenses Chart
            IncomeExpenseChart(
                income: dataService.incomeData(for: dateRange),
                expenses: dataService.expenseData(for: dateRange),
                title: "Income & Expenses",
                subtitle: dateRangeSubtitle
            )
            
            // Quick Stats Grid
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: theme.spacing.lg) {
                Card {
                    VStack(alignment: .leading, spacing: theme.spacing.md) {
                        Text("Recent Transactions")
                            .font(theme.typography.headline)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("\(dataService.recentTransactionsCount) this week")
                            .font(theme.typography.body)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Card {
                    VStack(alignment: .leading, spacing: theme.spacing.md) {
                        Text("Upcoming Bills")
                            .font(theme.typography.headline)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("\(dataService.upcomingBillsCount) due soon")
                            .font(theme.typography.body)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
    
    private var dateRangeSubtitle: String {
        "Last \(dateRange.rawValue.lowercased())"
    }
}

// MARK: - Stat Card
private struct StatCard: View {
    @Environment(\.theme) private var theme
    
    let title: String
    let value: Double
    let icon: String
    let color: Color
    
    var body: some View {
        HStack(spacing: theme.spacing.md) {
            Image(systemName: icon)
                .font(theme.typography.title2)
                .foregroundColor(color)
                .frame(width: 44, height: 44)
                .background(color.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
            
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                Text(title)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.textSecondary)
                
                Text(formatCurrency(value))
                    .font(theme.typography.title3)
                    .fontWeight(theme.typography.semibold)
                    .foregroundColor(theme.colors.textPrimary)
            }
            
            Spacer()
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surface)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.card))
        .shadow(from: theme.shadows.card)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

// MARK: - Income & Expenses View
private struct IncomeExpensesView: View {
    @Environment(\.theme) private var theme
    @ObservedObject var dataService: MockDataService
    let dateRange: DateRange
    let searchText: String
    
    var body: some View {
        VStack(spacing: theme.spacing.xxl) {
            // Chart
            IncomeExpenseChart(
                income: dataService.incomeData(for: dateRange),
                expenses: dataService.expenseData(for: dateRange),
                title: "Income & Expenses Trend",
                subtitle: "Track your cash flow over time"
            )
            
            // Transactions Table
            TransactionsTableView(
                transactions: filteredTransactions
            ) { transaction in
                print("Edit transaction: \(transaction.id)")
            }
            .frame(height: 500)
        }
    }
    
    private var filteredTransactions: [TransactionRow] {
        let transactions = dataService.transactions(for: dateRange)
        
        if searchText.isEmpty {
            return transactions
        }
        
        return transactions.filter { transaction in
            transaction.subCategory.localizedCaseInsensitiveContains(searchText) ||
            transaction.category.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Assets & Goals View
private struct AssetsGoalsView: View {
    @Environment(\.theme) private var theme
    @ObservedObject var dataService: MockDataService
    let searchText: String
    
    var body: some View {
        VStack(spacing: theme.spacing.xxl) {
            // Assets Pie Chart
            AssetsPieCard(
                assets: filteredAssets,
                title: "Assets Breakdown",
                subtitle: "Your complete portfolio"
            )
            
            // Goals List
            GoalsListView(
                goals: $dataService.goals,
                title: "Financial Goals",
                subtitle: "Track your progress toward financial milestones"
            )
        }
    }
    
    private var filteredAssets: [AssetItem] {
        if searchText.isEmpty {
            return dataService.assets
        }
        
        return dataService.assets.filter { asset in
            asset.name.localizedCaseInsensitiveContains(searchText) ||
            asset.category.localizedCaseInsensitiveContains(searchText)
        }
    }
}

// MARK: - Preview Provider
#Preview("App Shell - Vibrant Theme") {
    AppShell()
        .frame(minWidth: 1200, minHeight: 800)
        .theme(VibrantTheme())
}

#Preview("App Shell - Neutral Theme") {
    AppShell()
        .frame(minWidth: 1200, minHeight: 800)
        .theme(NeutralTheme())
}
