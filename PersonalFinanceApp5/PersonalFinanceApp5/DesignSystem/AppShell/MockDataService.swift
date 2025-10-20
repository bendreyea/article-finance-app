import Foundation
import Combine

// MARK: - Mock Data Service

/// Mocked data service providing sample financial data
@MainActor
public class MockDataService: ObservableObject {
    // Published properties
    @Published public var transactions: [TransactionRow] = []
    @Published public var assets: [AssetData] = []
    @Published public var goals: [GoalItem] = []
    @Published public var chartData: [ChartDataPoint] = []
    
    // State
    @Published public var isLoading = false
    @Published public var lastUpdated = Date()
    
    public init() {
        loadMockData()
    }
    
    // MARK: - Load Mock Data
    
    public func loadMockData() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.transactions = TransactionDemoData.generateTransactions(count: 50)
            self?.assets = AssetDemoData.generateAssets()
            self?.goals = GoalDemoData.generateGoals()
            
            // Generate chart data (combine income and expenses into single dataset)
            let incomeData = ChartDemoData.generateIncomeData(days: 30)
            let expenseData = ChartDemoData.generateExpenseData(days: 30)
            self?.chartData = zip(incomeData, expenseData).map { income, expense in
                ChartDataPoint(date: income.0, value: income.1 - expense.1)
            }
            
            self?.lastUpdated = Date()
            self?.isLoading = false
        }
    }
    
    // MARK: - Refresh
    
    public func refresh() {
        loadMockData()
    }
    
    // MARK: - Transactions
    
    public func addTransaction(_ transaction: TransactionRow) {
        transactions.append(transaction)
    }
    
    public func updateTransaction(_ transaction: TransactionRow) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
        }
    }
    
    public func deleteTransaction(_ transaction: TransactionRow) {
        transactions.removeAll { $0.id == transaction.id }
    }
    
    // MARK: - Assets
    
    public func addAsset(_ asset: AssetData) {
        assets.append(asset)
    }
    
    public func updateAsset(_ asset: AssetData) {
        if let index = assets.firstIndex(where: { $0.id == asset.id }) {
            assets[index] = asset
        }
    }
    
    public func deleteAsset(_ asset: AssetData) {
        assets.removeAll { $0.id == asset.id }
    }
    
    // MARK: - Goals
    
    public func addGoal(_ goal: GoalItem) {
        goals.append(goal)
    }
    
    public func updateGoal(_ goal: GoalItem) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }
    
    public func deleteGoal(_ goal: GoalItem) {
        goals.removeAll { $0.id == goal.id }
    }
    
    // MARK: - Computed Properties
    
    public var totalAssets: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    
    public var totalIncome: Double {
        transactions.filter { $0.amount > 0 }.reduce(0) { $0 + $1.amount }
    }
    
    public var totalExpenses: Double {
        transactions.filter { $0.amount < 0 }.reduce(0) { $0 + abs($1.amount) }
    }
    
    public var netCashFlow: Double {
        totalIncome - totalExpenses
    }
    
    public var completedGoals: Int {
        goals.filter { $0.isCompleted }.count
    }
    
    public var averageGoalProgress: Double {
        guard !goals.isEmpty else { return 0 }
        return goals.reduce(0.0) { $0 + $1.progress } / Double(goals.count)
    }
}

// MARK: - App State

/// Global app state management
@MainActor
public class AppState: ObservableObject {
    // Navigation
    @Published public var selectedDestination: NavigationDestination = .dashboard
    @Published public var dateRange: DateRange = .month
    @Published public var searchText: String = ""
    
    // Services
    public let dataService: MockDataService
    
    // Theme
    @Published public var isDarkMode: Bool = false
    @Published public var selectedTheme: ThemeSelection = .vibrant
    
    public init() {
        self.dataService = MockDataService()
    }
    
    // MARK: - Search
    
    public func clearSearch() {
        searchText = ""
    }
    
    public var hasActiveSearch: Bool {
        !searchText.isEmpty
    }
    
    // MARK: - Navigation
    
    public func navigate(to destination: NavigationDestination) {
        selectedDestination = destination
        clearSearch()
    }
}

// MARK: - Theme Selection

public enum ThemeSelection: String, CaseIterable {
    case vibrant
    case neutral
    
    public var displayName: String {
        switch self {
        case .vibrant: return "Vibrant"
        case .neutral: return "Neutral"
        }
    }
    
    public func makeTheme() -> AppTheme {
        switch self {
        case .vibrant: return VibrantTheme()
        case .neutral: return NeutralTheme()
        }
    }
}
