import SwiftUI
import Combine

// MARK: - Navigation Route

/// Application navigation routes
public enum AppRoute: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case incomeExpenses = "Income & Expenses"
    case assetsGoals = "Assets & Goals"
    
    public var id: String { rawValue }
    
    public var icon: String {
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

// MARK: - Date Range

/// Date range filter options
public enum DateRange: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case quarter = "Quarter"
    case year = "Year"
    case all = "All"
    
    public var id: String { rawValue }
}

// MARK: - App Shell

/// Main application shell with navigation and routing
public struct AppShell: View {
    @Environment(\.theme) private var theme
    
    @State private var selectedRoute: AppRoute? = .dashboard
    @State private var dateRange: DateRange = .month
    @State private var searchText: String = ""
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    // Data services
    @StateObject private var dataService = MockDataService()
    
    public init() {}
    
    public var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar
            sidebar
        } detail: {
            // Main content area
            detailView
        }
        .navigationSplitViewStyle(.balanced)
    }
    
    // MARK: - Sidebar
    
    private var sidebar: some View {
        VStack(spacing: 0) {
            // App header
            appHeader
            
            Divider()
                .background(theme.colors.border)
            
            // Navigation list
            List(AppRoute.allCases, selection: $selectedRoute) { route in
                NavigationLink(value: route) {
                    Label {
                        Text(route.rawValue)
                            .font(theme.typography.bodyMedium)
                    } icon: {
                        Image(systemName: route.icon)
                            .foregroundColor(
                                selectedRoute == route
                                    ? theme.colors.accentPrimary
                                    : theme.colors.textSecondary
                            )
                    }
                }
                .listItemTint(theme.colors.accentPrimary)
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
            .background(theme.colors.surface)
            
            Spacer()
            
            // Footer
            sidebarFooter
        }
        .navigationSplitViewColumnWidth(min: 200, ideal: 250, max: 300)
        .background(theme.colors.surface)
    }
    
    private var appHeader: some View {
        VStack(spacing: theme.spacing.sm) {
            HStack(spacing: theme.spacing.md) {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                theme.colors.accentPrimary,
                                theme.colors.accentSecondary
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "dollarsign")
                            .foregroundColor(.white)
                            .font(.system(size: 20, weight: .bold))
                    )
                
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text("FinanceApp")
                        .font(theme.typography.headingSmall)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Personal Finance")
                        .font(theme.typography.labelSmall)
                        .foregroundColor(theme.colors.textTertiary)
                }
                
                Spacer()
            }
            .padding(theme.spacing.lg)
        }
    }
    
    private var sidebarFooter: some View {
        VStack(spacing: 0) {
            Divider()
                .background(theme.colors.border)
            
            HStack(spacing: theme.spacing.md) {
                Image(systemName: "person.circle.fill")
                    .foregroundColor(theme.colors.textSecondary)
                    .font(.system(size: 28))
                
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text("John Doe")
                        .font(theme.typography.bodyMedium)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("john@example.com")
                        .font(theme.typography.labelSmall)
                        .foregroundColor(theme.colors.textTertiary)
                }
                
                Spacer()
                
                Menu {
                    Button("Settings") {}
                    Button("Preferences") {}
                    Divider()
                    Button("Sign Out") {}
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .foregroundColor(theme.colors.textSecondary)
                }
                .menuStyle(.borderlessButton)
            }
            .padding(theme.spacing.lg)
        }
        .background(theme.colors.backgroundSecondary)
    }
    
    // MARK: - Detail View
    
    private var detailView: some View {
        VStack(spacing: 0) {
            // Toolbar
            toolbar
            
            Divider()
                .background(theme.colors.border)
            
            // Content
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(theme.colors.background)
    }
    
    private var toolbar: some View {
        HStack(spacing: theme.spacing.xl) {
            // Date range segmented control
            Picker("Date Range", selection: $dateRange) {
                ForEach(DateRange.allCases) { range in
                    Text(range.rawValue).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 400)
            
            Spacer()
            
            // Search field
            HStack(spacing: theme.spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(theme.colors.textTertiary)
                    .font(theme.typography.bodyMedium)
                
                TextField(searchPlaceholder, text: $searchText)
                    .textFieldStyle(.plain)
                    .font(theme.typography.bodyMedium)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(theme.colors.textTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.sm)
            .background(theme.colors.backgroundSecondary)
            .cornerRadius(theme.radius.md)
            .frame(width: 300)
        }
        .padding(theme.spacing.lg)
        .background(theme.colors.surface)
    }
    
    private var searchPlaceholder: String {
        switch selectedRoute {
        case .dashboard:
            return "Search dashboard..."
        case .incomeExpenses:
            return "Search transactions..."
        case .assetsGoals:
            return "Search assets and goals..."
        case .none:
            return "Search..."
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedRoute {
        case .dashboard:
            DashboardView(
                dateRange: dateRange,
                searchText: searchText,
                dataService: dataService
            )
        case .incomeExpenses:
            IncomeExpensesView(
                dateRange: dateRange,
                searchText: searchText,
                dataService: dataService
            )
        case .assetsGoals:
            AssetsGoalsView(
                dateRange: dateRange,
                searchText: searchText,
                dataService: dataService
            )
        case .none:
            EmptyView()
        }
    }
}

// MARK: - Dashboard View

struct DashboardView: View {
    @Environment(\.theme) private var theme
    
    let dateRange: DateRange
    let searchText: String
    @ObservedObject var dataService: MockDataService
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        Text("Dashboard")
                            .font(theme.typography.displayMedium)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("Your financial overview for \(dateRange.rawValue.lowercased())")
                            .font(theme.typography.bodyMedium)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(currentDate)
                        .font(theme.typography.bodyMedium)
                        .foregroundColor(theme.colors.textSecondary)
                }
                
                // Net Worth Gauge
                HStack(spacing: theme.spacing.xl) {
                    Card(style: .elevated) {
                        DonutGauge(
                            value: dataService.netWorth,
                            max: 1000000,
                            title: "Net Worth",
                            subtitle: "\(Int(dataService.netWorth / 10000))% of $1M goal",
                            size: .extraLarge
                        )
                    }
                    
                    // Stats Cards
                    VStack(spacing: theme.spacing.lg) {
                        statCard(
                            title: "Available Balance",
                            value: formatCurrency(dataService.availableBalance),
                            change: "+12.5%",
                            isPositive: true
                        )
                        
                        statCard(
                            title: "Monthly Income",
                            value: formatCurrency(dataService.monthlyIncome),
                            change: "+5.2%",
                            isPositive: true
                        )
                        
                        statCard(
                            title: "Monthly Expenses",
                            value: formatCurrency(dataService.monthlyExpenses),
                            change: "-8.1%",
                            isPositive: true
                        )
                    }
                }
                
                // Income & Expenses Chart
                ChartCard(
                    title: "Income & Expenses Trend",
                    subtitle: "Last 30 Days"
                ) {
                    IncomeExpenseChart(
                        income: dataService.incomeData,
                        expenses: dataService.expenseData
                    )
                }
                
                // Quick Stats Grid
                HStack(spacing: theme.spacing.lg) {
                    Card(style: .outlined, padding: .medium) {
                        quickStat(
                            icon: "arrow.up.circle.fill",
                            title: "Total Income",
                            value: formatCurrency(18450),
                            color: theme.colors.success
                        )
                    }
                    
                    Card(style: .outlined, padding: .medium) {
                        quickStat(
                            icon: "arrow.down.circle.fill",
                            title: "Total Expenses",
                            value: formatCurrency(9280),
                            color: theme.colors.error
                        )
                    }
                    
                    Card(style: .outlined, padding: .medium) {
                        quickStat(
                            icon: "banknote.fill",
                            title: "Net Savings",
                            value: formatCurrency(9170),
                            color: theme.colors.accentPrimary
                        )
                    }
                }
            }
            .padding(theme.spacing.xxl)
        }
    }
    
    private func statCard(title: String, value: String, change: String, isPositive: Bool) -> some View {
        Card(style: .flat, padding: .medium) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(title)
                    .font(theme.typography.labelMedium)
                    .foregroundColor(theme.colors.textSecondary)
                
                Text(value)
                    .font(theme.typography.headingLarge)
                    .foregroundColor(theme.colors.textPrimary)
                
                HStack(spacing: theme.spacing.xs) {
                    Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                        .font(theme.typography.labelSmall)
                    Text(change)
                        .font(theme.typography.labelMedium)
                }
                .foregroundColor(isPositive ? theme.colors.success : theme.colors.error)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private func quickStat(icon: String, title: String, value: String, color: Color) -> some View {
        HStack(spacing: theme.spacing.md) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 32))
            
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                Text(title)
                    .font(theme.typography.labelMedium)
                    .foregroundColor(theme.colors.textSecondary)
                
                Text(value)
                    .font(theme.typography.headingMedium)
                    .foregroundColor(theme.colors.textPrimary)
            }
            
            Spacer()
        }
    }
    
    private var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: Date())
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// MARK: - Income & Expenses View

struct IncomeExpensesView: View {
    @Environment(\.theme) private var theme
    
    let dateRange: DateRange
    let searchText: String
    @ObservedObject var dataService: MockDataService
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Income & Expenses")
                        .font(theme.typography.displayMedium)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Manage your transactions")
                        .font(theme.typography.bodyMedium)
                        .foregroundColor(theme.colors.textSecondary)
                }
                
                Spacer()
            }
            .padding(theme.spacing.xxl)
            .background(theme.colors.background)
            
            // Transactions Table
            TransactionsTableView(
                transactions: filteredTransactions
            ) { transaction in
                print("Edit transaction: \(transaction.subCategory)")
            }
        }
    }
    
    private var filteredTransactions: [TransactionRow] {
        var transactions = dataService.transactions
        
        if !searchText.isEmpty {
            transactions = transactions.filter {
                $0.subCategory.localizedCaseInsensitiveContains(searchText) ||
                $0.description.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return transactions
    }
}

// MARK: - Assets & Goals View

struct AssetsGoalsView: View {
    @Environment(\.theme) private var theme
    
    let dateRange: DateRange
    let searchText: String
    @ObservedObject var dataService: MockDataService
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        Text("Assets & Goals")
                            .font(theme.typography.displayMedium)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("Track your wealth and financial objectives")
                            .font(theme.typography.bodyMedium)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    
                    Spacer()
                }
                
                // Summary Cards
                HStack(spacing: theme.spacing.lg) {
                    Card(style: .elevated, padding: .large) {
                        VStack(alignment: .leading, spacing: theme.spacing.md) {
                            HStack {
                                Image(systemName: "briefcase.fill")
                                    .foregroundColor(theme.colors.accentPrimary)
                                    .font(.system(size: 24))
                                
                                Spacer()
                            }
                            
                            Text("Total Assets")
                                .font(theme.typography.labelMedium)
                                .foregroundColor(theme.colors.textSecondary)
                            
                            Text(formatCurrency(dataService.totalAssets))
                                .font(theme.typography.displaySmall)
                                .foregroundColor(theme.colors.textPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Card(style: .elevated, padding: .large) {
                        VStack(alignment: .leading, spacing: theme.spacing.md) {
                            HStack {
                                Image(systemName: "target")
                                    .foregroundColor(theme.colors.success)
                                    .font(.system(size: 24))
                                
                                Spacer()
                            }
                            
                            Text("Goals Progress")
                                .font(theme.typography.labelMedium)
                                .foregroundColor(theme.colors.textSecondary)
                            
                            Text("\(dataService.completedGoals)/\(dataService.totalGoals)")
                                .font(theme.typography.displaySmall)
                                .foregroundColor(theme.colors.textPrimary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
                // Assets and Goals
                HStack(alignment: .top, spacing: theme.spacing.xl) {
                    AssetsPieCard(assets: dataService.assets)
                        .frame(maxWidth: .infinity)
                    
                    GoalsListView(goals: dataService.goals) { goal in
                        dataService.updateGoal(goal)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(theme.spacing.xxl)
        }
        .background(theme.colors.background)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        
        if amount >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: amount / 1_000_000))?.appending("M") ?? "$0"
        }
        
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// MARK: - Mock Data Service

/// Mock data service for the application
class MockDataService: ObservableObject {
    // Dashboard data
    @Published var netWorth: Double = 668000
    @Published var availableBalance: Double = 20000
    @Published var monthlyIncome: Double = 8450
    @Published var monthlyExpenses: Double = 3280
    
    // Chart data
    @Published var incomeData: [(Date, Double)]
    @Published var expenseData: [(Date, Double)]
    
    // Transactions
    @Published var transactions: [TransactionRow]
    
    // Assets
    @Published var assets: [AssetItem]
    @Published var totalAssets: Double = 668000
    
    // Goals
    @Published var goals: [GoalItem]
    @Published var completedGoals: Int = 1
    @Published var totalGoals: Int = 6
    
    init() {
        // Initialize chart data
        let chartData = ChartDemoData.generateMonthlyData(
            baseIncome: 6000,
            baseExpense: 3500,
            variance: 1200
        )
        self.incomeData = chartData.income
        self.expenseData = chartData.expenses
        
        // Initialize transactions
        self.transactions = TransactionRow.generateDemoData()
        
        // Initialize assets
        self.assets = AssetItem.generateDemoData()
        
        // Initialize goals
        self.goals = GoalItem.generateDemoData()
    }
    
    func updateGoal(_ goal: GoalItem) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            completedGoals = goals.filter(\.isCompleted).count
        }
    }
}

// MARK: - Previews

#Preview("App Shell - Vibrant Theme") {
    AppShell()
        .themed(VibrantTheme())
        .frame(minWidth: 1400, minHeight: 900)
}

#Preview("App Shell - Neutral Theme") {
    AppShell()
        .themed(NeutralTheme())
        .frame(minWidth: 1400, minHeight: 900)
}

#Preview("Dashboard Only - Vibrant") {
    DashboardView(
        dateRange: .month,
        searchText: "",
        dataService: MockDataService()
    )
    .themed(VibrantTheme())
    .frame(width: 1200, height: 900)
}

#Preview("Income & Expenses - Vibrant") {
    IncomeExpensesView(
        dateRange: .month,
        searchText: "",
        dataService: MockDataService()
    )
    .themed(VibrantTheme())
    .frame(width: 1200, height: 900)
}

#Preview("Assets & Goals - Vibrant") {
    AssetsGoalsView(
        dateRange: .month,
        searchText: "",
        dataService: MockDataService()
    )
    .themed(VibrantTheme())
    .frame(width: 1200, height: 900)
}
