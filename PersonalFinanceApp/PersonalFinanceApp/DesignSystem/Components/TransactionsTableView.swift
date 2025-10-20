import SwiftUI

/// A data model representing a financial transaction
public struct TransactionRow: Identifiable, Hashable {
    public let id = UUID()
    public let category: TransactionCategory
    public let subCategory: String
    public let amount: Double
    public let billDueDate: Date
    public let status: TransactionStatus
    public let description: String
    public let payee: String
    
    public init(
        category: TransactionCategory,
        subCategory: String,
        amount: Double,
        billDueDate: Date,
        status: TransactionStatus,
        description: String,
        payee: String
    ) {
        self.category = category
        self.subCategory = subCategory
        self.amount = amount
        self.billDueDate = billDueDate
        self.status = status
        self.description = description
        self.payee = payee
    }
}

/// Transaction categories for filtering
public enum TransactionCategory: String, CaseIterable, Identifiable {
    case housing = "Housing"
    case transportation = "Transportation"
    case food = "Food & Dining"
    case utilities = "Utilities"
    case healthcare = "Healthcare"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case income = "Income"
    case savings = "Savings & Investments"
    case other = "Other"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .housing: return "house.fill"
        case .transportation: return "car.fill"
        case .food: return "fork.knife"
        case .utilities: return "bolt.fill"
        case .healthcare: return "cross.fill"
        case .entertainment: return "tv.fill"
        case .shopping: return "bag.fill"
        case .income: return "dollarsign.circle.fill"
        case .savings: return "banknote.fill"
        case .other: return "questionmark.circle.fill"
        }
    }
    
    public var color: Color {
        switch self {
        case .housing: return .blue
        case .transportation: return .orange
        case .food: return .green
        case .utilities: return .yellow
        case .healthcare: return .red
        case .entertainment: return .purple
        case .shopping: return .pink
        case .income: return .mint
        case .savings: return .indigo
        case .other: return .gray
        }
    }
}

/// Transaction status enumeration
public enum TransactionStatus: String, CaseIterable, Identifiable {
    case paid = "Paid"
    case due = "Due"
    case late = "Late"
    
    public var id: String { rawValue }
}

/// Sort fields for transactions
public enum TransactionSortField: String, CaseIterable {
    case subCategory = "Sub Category"
    case amount = "Amount"
    case billDueDate = "Due Date"
    case status = "Status"
    case payee = "Payee"
}

/// A colored status badge component
public struct StatusBadge: View {
    @Environment(\.theme) private var theme
    let status: TransactionStatus
    
    public init(status: TransactionStatus) {
        self.status = status
    }
    
    public var body: some View {
        Text(status.rawValue)
            .font(theme.typography.captionFont)
            .fontWeight(theme.typography.medium)
            .foregroundColor(textColor)
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(backgroundColor)
            .cornerRadius(theme.radius.badge)
    }
    
    private var backgroundColor: Color {
        switch status {
        case .paid:
            return theme.colors.success.opacity(0.15)
        case .due:
            return theme.colors.warning.opacity(0.15)
        case .late:
            return theme.colors.error.opacity(0.15)
        }
    }
    
    private var textColor: Color {
        switch status {
        case .paid:
            return theme.colors.success
        case .due:
            return theme.colors.warning
        case .late:
            return theme.colors.error
        }
    }
}

/// Category sidebar for filtering transactions
public struct CategorySidebar: View {
    @Environment(\.theme) private var theme
    @Binding var selectedCategory: TransactionCategory?
    let transactionCounts: [TransactionCategory: Int]
    
    public init(
        selectedCategory: Binding<TransactionCategory?>,
        transactionCounts: [TransactionCategory: Int] = [:]
    ) {
        self._selectedCategory = selectedCategory
        self.transactionCounts = transactionCounts
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            // Header
            Text("Categories")
                .font(theme.typography.headlineFont)
                .foregroundColor(theme.colors.textPrimary)
                .padding(.horizontal, theme.spacing.md)
                .padding(.top, theme.spacing.md)
            
            // All Categories option
            CategoryRow(
                category: nil,
                count: transactionCounts.values.reduce(0, +),
                isSelected: selectedCategory == nil
            ) {
                selectedCategory = nil
            }
            
            Divider()
                .padding(.horizontal, theme.spacing.md)
            
            // Category list
            ScrollView {
                LazyVStack(spacing: theme.spacing.xs) {
                    ForEach(TransactionCategory.allCases) { category in
                        CategoryRow(
                            category: category,
                            count: transactionCounts[category] ?? 0,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(.horizontal, theme.spacing.sm)
            }
            
            Spacer()
        }
        .background(theme.colors.surfaceVariant)
        .frame(width: 240)
    }
}

/// Individual category row in the sidebar
private struct CategoryRow: View {
    @Environment(\.theme) private var theme
    let category: TransactionCategory?
    let count: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: theme.spacing.sm) {
                // Icon
                Image(systemName: category?.icon ?? "list.bullet")
                    .foregroundColor(category?.color ?? theme.colors.textSecondary)
                    .frame(width: 16)
                
                // Category name
                Text(category?.rawValue ?? "All Categories")
                    .font(theme.typography.calloutFont)
                    .foregroundColor(theme.colors.textPrimary)
                
                Spacer()
                
                // Count
                if count > 0 {
                    Text("\(count)")
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                        .padding(.horizontal, theme.spacing.xs)
                        .padding(.vertical, 2)
                        .background(theme.colors.border.opacity(0.3))
                        .cornerRadius(theme.radius.sm)
                }
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(isSelected ? theme.colors.primary.opacity(0.1) : Color.clear)
            .cornerRadius(theme.radius.sm)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

/// Main transactions table view with sidebar and search functionality
public struct TransactionsTableView: View {
    @Environment(\.theme) private var theme
    
    // Data
    private let transactions: [TransactionRow]
    private let onRowDoubleClick: (TransactionRow) -> Void
    
    // Search and filtering
    @State private var searchText = ""
    @State private var selectedCategory: TransactionCategory? = nil
    
    // Sorting
    @State private var sortOrder = [KeyPathComparator(\TransactionRow.billDueDate, order: .reverse)]
    
    // Selection
    @State private var selectedTransaction: TransactionRow.ID?
    
    public init(
        transactions: [TransactionRow],
        onRowDoubleClick: @escaping (TransactionRow) -> Void = { _ in }
    ) {
        self.transactions = transactions
        self.onRowDoubleClick = onRowDoubleClick
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            // Left sidebar
            CategorySidebar(
                selectedCategory: $selectedCategory,
                transactionCounts: transactionCounts
            )
            
            // Main content area
            VStack(spacing: 0) {
                // Search bar
                searchBar
                
                // Table view
                tableView
            }
            .background(theme.colors.background)
        }
    }
    
    // MARK: - Search Bar
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.colors.textSecondary)
            
            TextField("Search transactions...", text: $searchText)
                .font(theme.typography.bodyFont)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !searchText.isEmpty {
                Button("Clear") {
                    searchText = ""
                }
                .font(theme.typography.captionFont)
                .foregroundColor(theme.colors.primary)
            }
        }
        .padding(theme.spacing.sm)
        .background(theme.colors.surface)
        .cornerRadius(theme.radius.input)
        .padding(theme.spacing.md)
        .shadow(theme.shadows.subtle)
    }
    
    // MARK: - Table View
    private var tableView: some View {
        Table(filteredTransactions, selection: $selectedTransaction, sortOrder: $sortOrder) {
            // Sub Category Column
            TableColumn("Sub Category", value: \TransactionRow.subCategory) { transaction in
                VStack(alignment: .leading, spacing: 2) {
                    Text(transaction.subCategory)
                        .font(theme.typography.bodyFont)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text(transaction.description)
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                        .lineLimit(1)
                }
            }
            .width(min: 150, ideal: 200, max: 300)
            
            // Payee Column
            TableColumn("Payee", value: \TransactionRow.payee) { transaction in
                Text(transaction.payee)
                    .font(theme.typography.bodyFont)
                    .foregroundColor(theme.colors.textPrimary)
            }
            .width(min: 100, ideal: 150, max: 200)
            
            // Amount Column
            TableColumn("Amount", value: \TransactionRow.amount) { transaction in
                HStack {
                    Spacer()
                    Text(formatCurrency(transaction.amount))
                        .font(theme.typography.font(size: theme.typography.callout, weight: theme.typography.semibold))
                        .foregroundColor(amountColor(for: transaction))
                }
            }
            .width(min: 100, ideal: 120, max: 150)
            
            // Due Date Column
            TableColumn("Due Date", value: \TransactionRow.billDueDate) { transaction in
                VStack(alignment: .leading, spacing: 2) {
                    Text(formatDate(transaction.billDueDate))
                        .font(theme.typography.bodyFont)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text(relativeDateString(transaction.billDueDate))
                        .font(theme.typography.captionFont)
                        .foregroundColor(dueDateColor(for: transaction.billDueDate))
                }
            }
            .width(min: 100, ideal: 130, max: 160)
            
            // Status Column
            TableColumn("Status", value: \TransactionRow.status.rawValue) { transaction in
                HStack {
                    StatusBadge(status: transaction.status)
                    Spacer()
                }
            }
            .width(min: 80, ideal: 100, max: 120)
        }
        .onChange(of: sortOrder) { _, newOrder in
            // Handle sort order changes if needed
        }
        .onTapGesture(count: 2) {
            if let selectedId = selectedTransaction,
               let transaction = transactions.first(where: { $0.id == selectedId }) {
                onRowDoubleClick(transaction)
            }
        }
    }
    
    // MARK: - Computed Properties
    
    /// Filtered transactions based on search and category
    private var filteredTransactions: [TransactionRow] {
        var filtered = transactions
        
        // Filter by category
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            let lowercasedSearch = searchText.lowercased()
            filtered = filtered.filter { transaction in
                transaction.subCategory.lowercased().contains(lowercasedSearch) ||
                transaction.description.lowercased().contains(lowercasedSearch) ||
                transaction.payee.lowercased().contains(lowercasedSearch)
            }
        }
        
        return filtered.sorted(using: sortOrder)
    }
    
    /// Transaction counts by category for sidebar
    private var transactionCounts: [TransactionCategory: Int] {
        Dictionary(grouping: transactions, by: \.category)
            .mapValues { $0.count }
    }
    
    // MARK: - Helper Functions
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func relativeDateString(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInTomorrow(date) {
            return "Tomorrow"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let days = calendar.dateComponents([.day], from: now, to: date).day ?? 0
            if days > 0 {
                return "In \(days) days"
            } else {
                return "\(abs(days)) days ago"
            }
        }
    }
    
    private func amountColor(for transaction: TransactionRow) -> Color {
        switch transaction.category {
        case .income:
            return theme.colors.success
        default:
            return transaction.amount > 0 ? theme.colors.error : theme.colors.success
        }
    }
    
    private func dueDateColor(for date: Date) -> Color {
        let calendar = Calendar.current
        let now = Date()
        let days = calendar.dateComponents([.day], from: now, to: date).day ?? 0
        
        if days < 0 {
            return theme.colors.error // Overdue
        } else if days <= 3 {
            return theme.colors.warning // Due soon
        } else {
            return theme.colors.textSecondary // Normal
        }
    }
}

// MARK: - Demo Data
extension TransactionsTableView {
    /// Sample transactions for previews and demos
    public static var demoTransactions: [TransactionRow] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            TransactionRow(
                category: .housing,
                subCategory: "Rent",
                amount: 2500.00,
                billDueDate: calendar.date(byAdding: .day, value: 5, to: today) ?? today,
                status: .due,
                description: "Monthly apartment rent",
                payee: "Property Management LLC"
            ),
            TransactionRow(
                category: .utilities,
                subCategory: "Electricity",
                amount: 145.67,
                billDueDate: calendar.date(byAdding: .day, value: -2, to: today) ?? today,
                status: .late,
                description: "Electric bill - September",
                payee: "City Power & Light"
            ),
            TransactionRow(
                category: .food,
                subCategory: "Groceries",
                amount: 89.32,
                billDueDate: today,
                status: .paid,
                description: "Weekly grocery shopping",
                payee: "SuperMarket Plus"
            ),
            TransactionRow(
                category: .transportation,
                subCategory: "Gas",
                amount: 65.00,
                billDueDate: calendar.date(byAdding: .day, value: 1, to: today) ?? today,
                status: .due,
                description: "Fuel purchase",
                payee: "Shell Station"
            ),
            TransactionRow(
                category: .income,
                subCategory: "Salary",
                amount: -4500.00,
                billDueDate: calendar.date(byAdding: .day, value: 15, to: today) ?? today,
                status: .due,
                description: "Bi-weekly salary",
                payee: "Tech Company Inc"
            ),
            TransactionRow(
                category: .entertainment,
                subCategory: "Streaming",
                amount: 15.99,
                billDueDate: calendar.date(byAdding: .day, value: 10, to: today) ?? today,
                status: .paid,
                description: "Netflix subscription",
                payee: "Netflix"
            ),
            TransactionRow(
                category: .healthcare,
                subCategory: "Insurance",
                amount: 350.00,
                billDueDate: calendar.date(byAdding: .day, value: 20, to: today) ?? today,
                status: .due,
                description: "Health insurance premium",
                payee: "HealthCare Partners"
            ),
            TransactionRow(
                category: .shopping,
                subCategory: "Clothing",
                amount: 120.50,
                billDueDate: calendar.date(byAdding: .day, value: -5, to: today) ?? today,
                status: .paid,
                description: "Online clothing purchase",
                payee: "Fashion Store"
            )
        ]
    }
    
    /// Creates a demo TransactionsTableView
    public static func demo(onRowDoubleClick: @escaping (TransactionRow) -> Void = { _ in }) -> TransactionsTableView {
        TransactionsTableView(
            transactions: demoTransactions,
            onRowDoubleClick: onRowDoubleClick
        )
    }
}