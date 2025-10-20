import SwiftUI
import Combine

// MARK: - Mock Data Service
public class MockDataService: ObservableObject {
    // MARK: - Published Properties
    @Published public var netWorth: Double = 125000
    @Published public var netWorthGoal: Double = 200000
    @Published public var availableBalance: Double = 45000
    @Published public var goals: [GoalItem]
    
    // MARK: - Private Properties
    private var allTransactions: [TransactionRow]
    public var assets: [AssetItem]
    
    // MARK: - Initializer
    public init() {
        // Initialize goals
        self.goals = GoalDemoData.generateGoals()
        
        // Initialize assets
        self.assets = AssetDemoData.generateAssets()
        
        // Initialize transactions
        self.allTransactions = TransactionDemoData.generateTransactions(count: 100)
    }
    
    // MARK: - Income & Expense Data
    public func incomeData(for range: DateRange) -> [(Date, Double)] {
        let days = daysForRange(range)
        return FinancialDemoData.generateIncomeData(days: days)
    }
    
    public func expenseData(for range: DateRange) -> [(Date, Double)] {
        let days = daysForRange(range)
        return FinancialDemoData.generateExpenseData(days: days)
    }
    
    public func totalIncome(for range: DateRange) -> Double {
        let data = incomeData(for: range)
        return data.reduce(0) { $0 + $1.1 }
    }
    
    public func totalExpenses(for range: DateRange) -> Double {
        let data = expenseData(for: range)
        return data.reduce(0) { $0 + $1.1 }
    }
    
    // MARK: - Transaction Data
    public func transactions(for range: DateRange) -> [TransactionRow] {
        let days = daysForRange(range)
        let calendar = Calendar.current
        let cutoffDate = calendar.date(byAdding: .day, value: -days, to: Date()) ?? Date()
        
        return allTransactions.filter { transaction in
            transaction.billDueDate >= cutoffDate
        }
    }
    
    public var recentTransactionsCount: Int {
        let calendar = Calendar.current
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        return allTransactions.filter { $0.billDueDate >= weekAgo }.count
    }
    
    public var upcomingBillsCount: Int {
        let calendar = Calendar.current
        let today = Date()
        let twoWeeksFromNow = calendar.date(byAdding: .day, value: 14, to: today) ?? today
        
        return allTransactions.filter { transaction in
            transaction.status != .paid &&
            transaction.billDueDate >= today &&
            transaction.billDueDate <= twoWeeksFromNow
        }.count
    }
    
    // MARK: - Helper Methods
    private func daysForRange(_ range: DateRange) -> Int {
        switch range {
        case .week:
            return 7
        case .month:
            return 30
        case .quarter:
            return 90
        case .year:
            return 365
        }
    }
    
    // MARK: - Update Methods
    public func updateGoal(_ goal: GoalItem) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }
    
    public func addAsset(_ asset: AssetItem) {
        assets.append(asset)
        recalculateNetWorth()
    }
    
    public func removeAsset(_ asset: AssetItem) {
        assets.removeAll { $0.id == asset.id }
        recalculateNetWorth()
    }
    
    private func recalculateNetWorth() {
        netWorth = assets.reduce(0) { $0 + $1.value }
    }
    
    // MARK: - Category Breakdown
    public func categoryBreakdown(for range: DateRange) -> [(category: String, amount: Double)] {
        let filteredTransactions = transactions(for: range)
        let grouped = Dictionary(grouping: filteredTransactions, by: { $0.category })
        
        return grouped.map { category, transactions in
            let total = transactions.reduce(0) { $0 + $1.amount }
            return (category, total)
        }
        .sorted { $0.amount > $1.amount }
    }
    
    // MARK: - Account Summary
    public struct AccountSummary {
        public let name: String
        public let balance: Double
        public let type: String
    }
    
    public var accounts: [AccountSummary] {
        [
            AccountSummary(name: "Checking Account", balance: 8500, type: "Checking"),
            AccountSummary(name: "Savings Account", balance: 25000, type: "Savings"),
            AccountSummary(name: "Credit Card", balance: -2800, type: "Credit"),
            AccountSummary(name: "Investment Account", balance: 45000, type: "Investment"),
        ]
    }
    
    // MARK: - Budget Data
    public struct BudgetCategory {
        public let name: String
        public let budgeted: Double
        public let spent: Double
        
        public var remaining: Double {
            budgeted - spent
        }
        
        public var progress: Double {
            guard budgeted > 0 else { return 0 }
            return min(spent / budgeted, 1.0)
        }
    }
    
    public func budgetCategories(for range: DateRange) -> [BudgetCategory] {
        let multiplier: Double
        
        switch range {
        case .week:
            multiplier = 0.25
        case .month:
            multiplier = 1.0
        case .quarter:
            multiplier = 3.0
        case .year:
            multiplier = 12.0
        }
        
        return [
            BudgetCategory(
                name: "Housing",
                budgeted: 2000 * multiplier,
                spent: 1800 * multiplier
            ),
            BudgetCategory(
                name: "Food",
                budgeted: 600 * multiplier,
                spent: 720 * multiplier
            ),
            BudgetCategory(
                name: "Transportation",
                budgeted: 400 * multiplier,
                spent: 350 * multiplier
            ),
            BudgetCategory(
                name: "Entertainment",
                budgeted: 300 * multiplier,
                spent: 280 * multiplier
            ),
            BudgetCategory(
                name: "Utilities",
                budgeted: 250 * multiplier,
                spent: 240 * multiplier
            ),
        ]
    }
    
    // MARK: - Search Methods
    public func searchTransactions(_ query: String) -> [TransactionRow] {
        if query.isEmpty {
            return allTransactions
        }
        
        return allTransactions.filter { transaction in
            transaction.subCategory.localizedCaseInsensitiveContains(query) ||
            transaction.category.localizedCaseInsensitiveContains(query)
        }
    }
    
    public func searchAssets(_ query: String) -> [AssetItem] {
        if query.isEmpty {
            return assets
        }
        
        return assets.filter { asset in
            asset.name.localizedCaseInsensitiveContains(query) ||
            asset.category.localizedCaseInsensitiveContains(query)
        }
    }
    
    public func searchGoals(_ query: String) -> [GoalItem] {
        if query.isEmpty {
            return goals
        }
        
        return goals.filter { goal in
            goal.name.localizedCaseInsensitiveContains(query) ||
            goal.category.localizedCaseInsensitiveContains(query)
        }
    }
    
    // MARK: - Statistics
    public func savingsRate(for range: DateRange) -> Double {
        let income = totalIncome(for: range)
        let expenses = totalExpenses(for: range)
        
        guard income > 0 else { return 0 }
        return ((income - expenses) / income) * 100
    }
    
    public func netCashFlow(for range: DateRange) -> Double {
        totalIncome(for: range) - totalExpenses(for: range)
    }
    
    public func monthlyAverage(for range: DateRange) -> Double {
        let months: Double
        
        switch range {
        case .week:
            months = 0.25
        case .month:
            months = 1.0
        case .quarter:
            months = 3.0
        case .year:
            months = 12.0
        }
        
        return totalExpenses(for: range) / months
    }
}

// MARK: - Preview Helper
extension MockDataService {
    public static var preview: MockDataService {
        MockDataService()
    }
}
