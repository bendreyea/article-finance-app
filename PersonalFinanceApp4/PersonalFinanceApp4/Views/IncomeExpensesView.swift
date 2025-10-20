//
//  IncomeExpensesView.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// Income and Expenses view with chart and transaction table
struct IncomeExpensesView: View {
    @Environment(\.theme) private var theme
    let dataService: MockDataService
    let filter: DataFilter
    
    @State private var filteredTransactions: [TransactionRow] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                // Income vs Expenses Chart
                incomeExpenseChartSection
                
                // Transactions Table
                transactionsSection
            }
            .padding(theme.spacing.xl)
        }
        .onAppear {
            updateFilteredTransactions()
        }
        .onChange(of: filter.dateRange) { _, _ in
            updateFilteredTransactions()
        }
        .onChange(of: filter.searchQuery) { _, _ in
            updateFilteredTransactions()
        }
    }
    
    // MARK: - Income Expense Chart Section
    
    private var incomeExpenseChartSection: some View {
        let filteredData = dataService.filteredIncomeExpenseData(filter: filter)
        
        return IncomeExpenseChart(
            incomeData: filteredData.income,
            expenseData: filteredData.expenses,
            title: "Income vs Expenses",
            subtitle: "\(filter.dateRange.title) - \(filteredData.income.count) data points"
        )
    }
    
    // MARK: - Transactions Section
    
    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            // Header
            HStack {
                Text("All Transactions")
                    .font(theme.typography.headingMedium)
                    .foregroundColor(theme.colors.onSurface)
                
                Spacer()
                
                Text("\(filteredTransactions.count) transactions")
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
            }
            .padding(.horizontal, theme.spacing.md)
            
            // Table
            TransactionsTableView(
                transactions: filteredTransactions,
                onRowDoubleClick: { transaction in
                    print("Edit transaction: \(transaction.subcategory)")
                }
            )
            .frame(minHeight: 500)
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateFilteredTransactions() {
        filteredTransactions = dataService.filteredTransactions(filter: filter)
    }
}

#Preview("IncomeExpensesView - Vibrant Theme") {
    ThemeProvider(theme: VibrantTheme()) {
        IncomeExpensesView(
            dataService: MockDataService(),
            filter: DataFilter(dateRange: .month)
        )
    }
    .frame(width: 1200, height: 900)
}

#Preview("IncomeExpensesView - Neutral Theme") {
    ThemeProvider(theme: NeutralTheme()) {
        IncomeExpensesView(
            dataService: MockDataService(),
            filter: DataFilter(dateRange: .month)
        )
    }
    .frame(width: 1200, height: 900)
}
