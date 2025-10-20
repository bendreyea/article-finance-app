//
//  MockDataService.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import Foundation
import Observation

/// Observable data service providing mocked financial data
@Observable
class MockDataService {
    // MARK: - Published Data
    
    var transactions: [TransactionRow]
    var assets: [AssetItem]
    var goals: [Goal]
    var incomeData: [(Date, Double)]
    var expenseData: [(Date, Double)]
    
    // MARK: - Computed Properties
    
    var aggregatedAssets: [AssetCategoryData] {
        AssetCategoryData.aggregate(from: assets)
    }
    
    var totalAssets: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    
    var totalIncome: Double {
        incomeData.reduce(0) { $0 + $1.1 }
    }
    
    var totalExpenses: Double {
        expenseData.reduce(0) { $0 + $1.1 }
    }
    
    var netWorth: Double {
        totalAssets
    }
    
    var availableBalance: Double {
        // Sum of checking and savings
        assets
            .filter { $0.category == .checking || $0.category == .savings }
            .reduce(0) { $0 + $1.value }
    }
    
    // MARK: - Initialization
    
    init() {
        // Generate demo data
        self.transactions = TransactionRow.generateDemoData(count: 30)
        self.assets = AssetItem.generateDemoData(count: 15)
        self.goals = Goal.generateDemoData(count: 8)
        
        // Generate income/expense data
        let chartData = IncomeExpenseChart.generateMonthlyDemoData()
        self.incomeData = chartData.income
        self.expenseData = chartData.expenses
    }
    
    // MARK: - Filtering Methods
    
    /// Filter transactions by date range and search query
    func filteredTransactions(filter: DataFilter) -> [TransactionRow] {
        transactions.filter { transaction in
            // Date filter
            guard filter.contains(date: transaction.dueDate) else { return false }
            
            // Search filter
            guard filter.searchQuery.isEmpty ||
                  filter.matches(text: transaction.subcategory) ||
                  filter.matches(text: transaction.category.rawValue) ||
                  filter.matches(text: transaction.notes ?? "") else { return false }
            
            return true
        }
    }
    
    /// Filter assets by search query
    func filteredAssets(filter: DataFilter) -> [AssetItem] {
        assets.filter { asset in
            guard filter.searchQuery.isEmpty ||
                  filter.matches(text: asset.name) ||
                  filter.matches(text: asset.category.rawValue) ||
                  filter.matches(text: asset.institutionName ?? "") else { return false }
            
            return true
        }
    }
    
    /// Filter goals by search query
    func filteredGoals(filter: DataFilter) -> [Goal] {
        goals.filter { goal in
            guard filter.searchQuery.isEmpty ||
                  filter.matches(text: goal.name) ||
                  filter.matches(text: goal.category.rawValue) ||
                  filter.matches(text: goal.notes ?? "") else { return false }
            
            return true
        }
    }
    
    /// Filter income/expense data by date range
    func filteredIncomeExpenseData(filter: DataFilter) -> (income: [(Date, Double)], expenses: [(Date, Double)]) {
        let filteredIncome = incomeData.filter { filter.contains(date: $0.0) }
        let filteredExpenses = expenseData.filter { filter.contains(date: $0.0) }
        return (filteredIncome, filteredExpenses)
    }
    
    // MARK: - CRUD Operations
    
    func addTransaction(_ transaction: TransactionRow) {
        transactions.append(transaction)
    }
    
    func updateTransaction(_ transaction: TransactionRow) {
        if let index = transactions.firstIndex(where: { $0.id == transaction.id }) {
            transactions[index] = transaction
        }
    }
    
    func deleteTransaction(_ transaction: TransactionRow) {
        transactions.removeAll { $0.id == transaction.id }
    }
    
    func addAsset(_ asset: AssetItem) {
        assets.append(asset)
    }
    
    func updateAsset(_ asset: AssetItem) {
        if let index = assets.firstIndex(where: { $0.id == asset.id }) {
            assets[index] = asset
        }
    }
    
    func deleteAsset(_ asset: AssetItem) {
        assets.removeAll { $0.id == asset.id }
    }
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
        }
    }
    
    func deleteGoal(_ goal: Goal) {
        goals.removeAll { $0.id == goal.id }
    }
    
    // MARK: - Refresh
    
    func refresh() async {
        // Simulate API call
        try? await Task.sleep(for: .seconds(1))
        
        // Regenerate data
        transactions = TransactionRow.generateDemoData(count: 30)
        assets = AssetItem.generateDemoData(count: 15)
        goals = Goal.generateDemoData(count: 8)
        
        let chartData = IncomeExpenseChart.generateMonthlyDemoData()
        incomeData = chartData.income
        expenseData = chartData.expenses
    }
}
