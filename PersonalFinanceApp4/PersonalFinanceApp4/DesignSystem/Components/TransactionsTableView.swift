//
//  TransactionsTableView.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// A comprehensive table view for displaying and managing transactions.
/// Features sortable columns, search, category filtering, and row actions.
///
/// Example usage:
/// ```swift
/// TransactionsTableView(
///     transactions: transactions,
///     onRowDoubleClick: { transaction in
///         // Handle edit
///     }
/// )
/// ```
public struct TransactionsTableView: View {
    @Environment(\.theme) private var theme
    
    // MARK: - State
    
    @State private var sortOrder = [KeyPathComparator(\TransactionRow.dueDate, order: .forward)]
    @State private var searchText = ""
    @State private var selectedCategory: TransactionCategory? = nil
    @State private var selection = Set<TransactionRow.ID>()
    
    // MARK: - Properties
    
    private let transactions: [TransactionRow]
    private let onRowDoubleClick: ((TransactionRow) -> Void)?
    private let showSidebar: Bool
    
    // MARK: - Computed Properties
    
    /// Filtered and sorted transactions
    private var filteredTransactions: [TransactionRow] {
        var filtered = transactions
        
        // Filter by category
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                transaction.subcategory.localizedCaseInsensitiveContains(searchText) ||
                transaction.category.rawValue.localizedCaseInsensitiveContains(searchText) ||
                (transaction.notes?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
        
        // Sort
        filtered.sort(using: sortOrder)
        
        return filtered
    }
    
    /// Category counts for sidebar
    private var categoryCounts: [TransactionCategory: Int] {
        Dictionary(grouping: transactions, by: \.category)
            .mapValues { $0.count }
    }
    
    // MARK: - Initialization
    
    public init(
        transactions: [TransactionRow],
        onRowDoubleClick: ((TransactionRow) -> Void)? = nil,
        showSidebar: Bool = true
    ) {
        self.transactions = transactions
        self.onRowDoubleClick = onRowDoubleClick
        self.showSidebar = showSidebar
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 0) {
            // Sidebar
            if showSidebar {
                CategorySidebar(
                    selectedCategory: $selectedCategory,
                    categoryCounts: categoryCounts
                )
                
                Divider()
            }
            
            // Main content
            VStack(spacing: 0) {
                // Toolbar
                toolbar
                
                Divider()
                
                // Table
                tableContent
            }
            .background(theme.colors.background)
        }
    }
    
    // MARK: - Toolbar
    
    private var toolbar: some View {
        HStack(spacing: theme.spacing.md) {
            // Search field
            HStack(spacing: theme.spacing.xs) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(theme.colors.onSurfaceSecondary)
                    .font(.system(size: theme.spacing.iconSizeSmall))
                
                TextField("Search transactions...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(theme.typography.bodyMedium)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(theme.colors.onSurfaceSecondary)
                            .font(.system(size: theme.spacing.iconSizeSmall))
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(theme.spacing.sm)
            .background(theme.colors.surface)
            .cornerRadius(theme.radius.input)
            .frame(maxWidth: 300)
            
            Spacer()
            
            // Results count
            Text("\(filteredTransactions.count) transactions")
                .font(theme.typography.bodySmall)
                .foregroundColor(theme.colors.onSurfaceSecondary)
            
            // Clear filters button
            if selectedCategory != nil || !searchText.isEmpty {
                Button("Clear Filters") {
                    selectedCategory = nil
                    searchText = ""
                }
                .font(theme.typography.labelMedium)
                .foregroundColor(theme.colors.primary)
                .buttonStyle(.plain)
            }
        }
        .padding(theme.spacing.md)
        .background(theme.colors.backgroundElevated)
    }
    
    // MARK: - Table Content
    
    private var tableContent: some View {
        Table(filteredTransactions, selection: $selection, sortOrder: $sortOrder) {
            // Category Column
            TableColumn("Category") { transaction in
                HStack(spacing: theme.spacing.xs) {
                    Image(systemName: transaction.category.icon)
                        .font(.system(size: theme.spacing.iconSizeSmall))
                        .foregroundColor(theme.colors.primary)
                    
                    Text(transaction.category.rawValue)
                        .font(theme.typography.bodyMedium)
                        .foregroundColor(theme.colors.onSurface)
                }
            }
            .width(min: 120, ideal: 140, max: 180)
            
            // Subcategory Column (Sortable)
            TableColumn("Subcategory", value: \.subcategory) { transaction in
                Text(transaction.subcategory)
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.onSurface)
            }
            .width(min: 120, ideal: 160, max: 200)
            
            // Amount Column (Sortable)
            TableColumn("Amount", value: \.amount) { transaction in
                Text(formatCurrency(transaction.amount))
                    .font(theme.typography.bodyMedium)
                    .fontWeight(theme.typography.weightSemibold)
                    .foregroundColor(
                        transaction.category == .income 
                            ? theme.colors.success 
                            : theme.colors.onSurface
                    )
            }
            .width(min: 100, ideal: 120, max: 150)
            
            // Due Date Column (Sortable)
            TableColumn("Due Date", value: \.dueDate) { transaction in
                Text(formatDate(transaction.dueDate))
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.onSurface)
            }
            .width(min: 100, ideal: 120, max: 150)
            
            // Status Column (Sortable by priority)
            TableColumn("Status", value: \.status) { transaction in
                StatusBadge(status: transaction.status, size: .small)
            }
            .width(min: 100, ideal: 120, max: 150)
            
            // Notes Column
            TableColumn("Notes") { transaction in
                if let notes = transaction.notes {
                    Text(notes)
                        .font(theme.typography.bodySmall)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                        .lineLimit(1)
                } else {
                    Text("—")
                        .font(theme.typography.bodySmall)
                        .foregroundColor(theme.colors.onSurfaceTertiary)
                }
            }
            .width(min: 100, ideal: 150)
        }
        .onTapGesture(count: 2) {
            if let selectedId = selection.first,
               let transaction = filteredTransactions.first(where: { $0.id == selectedId }) {
                onRowDoubleClick?(transaction)
            }
        }
    }
    
    // MARK: - Formatting Helpers
    
    /// Format amount as currency
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    /// Format date
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        return formatter.string(from: date)
    }
}

// MARK: - Sorting Support

extension TransactionStatus: Comparable {
    public static func < (lhs: TransactionStatus, rhs: TransactionStatus) -> Bool {
        lhs.priority < rhs.priority
    }
}

// MARK: - Previews

#Preview("TransactionsTableView - Full") {
    ThemeProvider(theme: VibrantTheme()) {
        TransactionsTableView(
            transactions: TransactionRow.generateDemoData(count: 25),
            onRowDoubleClick: { transaction in
                print("Double-clicked: \(transaction.subcategory)")
            }
        )
    }
    .frame(width: 1200, height: 700)
}

#Preview("TransactionsTableView - No Sidebar") {
    ThemeProvider(theme: VibrantTheme()) {
        TransactionsTableView(
            transactions: TransactionRow.generateDemoData(count: 20),
            showSidebar: false
        )
    }
    .frame(width: 900, height: 600)
}

#Preview("TransactionsTableView - Neutral Theme") {
    ThemeProvider(theme: NeutralTheme()) {
        TransactionsTableView(
            transactions: TransactionRow.generateDemoData(count: 25),
            onRowDoubleClick: { transaction in
                print("Edit: \(transaction.subcategory)")
            }
        )
    }
    .frame(width: 1200, height: 700)
}

#Preview("TransactionsTableView - Few Transactions") {
    ThemeProvider(theme: VibrantTheme()) {
        TransactionsTableView(
            transactions: TransactionRow.generateDemoData(count: 5)
        )
    }
    .frame(width: 1200, height: 500)
}

#Preview("TransactionsTableView - In Card") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 24) {
            Text("Transactions Dashboard")
                .font(.system(size: 28, weight: .bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            Card(elevation: .medium, padding: .none) {
                TransactionsTableView(
                    transactions: TransactionRow.generateDemoData(count: 15),
                    onRowDoubleClick: { transaction in
                        print("Edit: \(transaction.subcategory)")
                    }
                )
                .frame(height: 500)
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
    .frame(width: 1300, height: 700)
}
