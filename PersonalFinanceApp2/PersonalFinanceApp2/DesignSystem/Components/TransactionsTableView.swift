import SwiftUI

// MARK: - Transaction Model
public struct TransactionRow: Identifiable {
    public let id: UUID
    public var subCategory: String
    public var amount: Double
    public var billDueDate: Date
    public var status: TransactionStatus
    public var category: String
    
    public init(
        id: UUID = UUID(),
        subCategory: String,
        amount: Double,
        billDueDate: Date,
        status: TransactionStatus,
        category: String
    ) {
        self.id = id
        self.subCategory = subCategory
        self.amount = amount
        self.billDueDate = billDueDate
        self.status = status
        self.category = category
    }
}

// MARK: - Transaction Status
public enum TransactionStatus: String, CaseIterable {
    case paid = "Paid"
    case due = "Due"
    case late = "Late"
    
    public var sortOrder: Int {
        switch self {
        case .late: return 0
        case .due: return 1
        case .paid: return 2
        }
    }
}

// MARK: - Transactions Table View
public struct TransactionsTableView: View {
    @Environment(\.theme) private var theme
    
    // MARK: - State
    @State private var sortOrder: [KeyPathComparator<TransactionRow>] = [
        .init(\.billDueDate, order: .forward)
    ]
    @State private var searchText: String = ""
    @State private var selectedCategory: String?
    @State private var selection = Set<TransactionRow.ID>()
    
    // MARK: - Properties
    private let transactions: [TransactionRow]
    private let onRowDoubleClick: ((TransactionRow) -> Void)?
    
    // MARK: - Computed Properties
    private var categories: [String] {
        let allCategories = Array(Set(transactions.map { $0.category })).sorted()
        return allCategories
    }
    
    private var filteredTransactions: [TransactionRow] {
        var filtered = transactions
        
        // Filter by category
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Filter by search
        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                transaction.subCategory.localizedCaseInsensitiveContains(searchText) ||
                transaction.category.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered
    }
    
    private var sortedTransactions: [TransactionRow] {
        filteredTransactions.sorted(using: sortOrder)
    }
    
    // MARK: - Initializer
    public init(
        transactions: [TransactionRow],
        onRowDoubleClick: ((TransactionRow) -> Void)? = nil
    ) {
        self.transactions = transactions
        self.onRowDoubleClick = onRowDoubleClick
    }
    
    // MARK: - Body
    public var body: some View {
        HStack(spacing: 0) {
            // Left Sidebar
            CategorySidebar(
                categories: categories,
                selectedCategory: $selectedCategory
            )
            
            // Main Table Area
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(searchText: $searchText)
                    .padding(theme.spacing.md)
                
                Divider()
                    .background(theme.colors.border)
                
                // Table
                if sortedTransactions.isEmpty {
                    EmptyStateView(
                        message: searchText.isEmpty ? "No transactions found" : "No results for '\(searchText)'"
                    )
                } else {
                    Table(sortedTransactions, selection: $selection, sortOrder: $sortOrder) {
                        TableColumn("Sub Category", value: \.subCategory) { transaction in
                            Text(transaction.subCategory)
                                .font(theme.typography.body)
                                .foregroundColor(theme.colors.textPrimary)
                        }
                        .width(min: 150, ideal: 200, max: 300)
                        
                        TableColumn("Amount", value: \.amount) { transaction in
                            Text(formatCurrency(transaction.amount))
                                .font(theme.typography.body)
                                .fontWeight(theme.typography.medium)
                                .foregroundColor(amountColor(transaction.amount))
                        }
                        .width(min: 100, ideal: 120)
                        
                        TableColumn("Bill Due Date", value: \.billDueDate) { transaction in
                            Text(formatDate(transaction.billDueDate))
                                .font(theme.typography.body)
                                .foregroundColor(theme.colors.textSecondary)
                        }
                        .width(min: 120, ideal: 150)
                        
                        TableColumn("Status", value: \.status.sortOrder) { transaction in
                            StatusBadge(status: transaction.status)
                        }
                        .width(min: 100, ideal: 120)
                    }
                    .tableStyle(.inset)
                }
                
                // Footer with count
                Divider()
                    .background(theme.colors.border)
                
                HStack {
                    Text("\(sortedTransactions.count) transaction\(sortedTransactions.count == 1 ? "" : "s")")
                        .font(theme.typography.footnote)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Spacer()
                    
                    if selection.count > 0 {
                        Text("\(selection.count) selected")
                            .font(theme.typography.footnote)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                }
                .padding(theme.spacing.md)
            }
            .background(theme.colors.surface)
        }
    }
    
    // MARK: - Helper Methods
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func amountColor(_ amount: Double) -> Color {
        if amount < 0 {
            return theme.colors.error
        } else if amount > 0 {
            return theme.colors.success
        } else {
            return theme.colors.textPrimary
        }
    }
}

// MARK: - Status Badge Component
public struct StatusBadge: View {
    @Environment(\.theme) private var theme
    let status: TransactionStatus
    
    public var body: some View {
        HStack(spacing: theme.spacing.xs) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(status.rawValue)
                .font(theme.typography.footnote)
                .fontWeight(theme.typography.medium)
                .foregroundColor(theme.colors.textPrimary)
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.xs)
        .background(statusColor.opacity(0.15))
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.badge))
    }
    
    private var statusColor: Color {
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

// MARK: - Category Sidebar
public struct CategorySidebar: View {
    @Environment(\.theme) private var theme
    
    let categories: [String]
    @Binding var selectedCategory: String?
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Categories")
                    .font(theme.typography.headline)
                    .fontWeight(theme.typography.semibold)
                    .foregroundColor(theme.colors.textPrimary)
                
                Spacer()
            }
            .padding(theme.spacing.md)
            
            Divider()
                .background(theme.colors.border)
            
            // All Categories option
            CategoryItem(
                title: "All Categories",
                isSelected: selectedCategory == nil
            ) {
                selectedCategory = nil
            }
            
            Divider()
                .background(theme.colors.borderSubtle)
            
            // Category List
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(categories, id: \.self) { category in
                        CategoryItem(
                            title: category,
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                        
                        if category != categories.last {
                            Divider()
                                .background(theme.colors.borderSubtle)
                        }
                    }
                }
            }
            
            Spacer()
        }
        .frame(width: 200)
        .background(theme.colors.backgroundSecondary)
        .overlay(alignment: .trailing) {
            Divider()
                .background(theme.colors.border)
        }
    }
}

// MARK: - Category Item
private struct CategoryItem: View {
    @Environment(\.theme) private var theme
    
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(theme.typography.body)
                    .foregroundColor(isSelected ? theme.colors.brandPrimary : theme.colors.textPrimary)
                    .fontWeight(isSelected ? theme.typography.medium : theme.typography.regular)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(theme.typography.footnote)
                        .foregroundColor(theme.colors.brandPrimary)
                }
            }
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.sm)
            .background(isSelected ? theme.colors.brandPrimary.opacity(0.1) : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Search Bar
private struct SearchBar: View {
    @Environment(\.theme) private var theme
    @Binding var searchText: String
    
    var body: some View {
        HStack(spacing: theme.spacing.sm) {
            Image(systemName: "magnifyingglass")
                .font(theme.typography.body)
                .foregroundColor(theme.colors.textSecondary)
            
            TextField("Search transactions...", text: $searchText)
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
        .background(theme.colors.backgroundTertiary)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.input))
        .overlay(
            RoundedRectangle(cornerRadius: theme.radius.input)
                .stroke(theme.colors.border, lineWidth: 1)
        )
    }
}

// MARK: - Empty State View
private struct EmptyStateView: View {
    @Environment(\.theme) private var theme
    let message: String
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 48))
                .foregroundColor(theme.colors.textTertiary)
            
            Text(message)
                .font(theme.typography.body)
                .foregroundColor(theme.colors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.surface)
    }
}

// MARK: - Demo Data
public struct TransactionDemoData {
    public static func generateTransactions(count: Int = 50) -> [TransactionRow] {
        let categories = ["Housing", "Transportation", "Food", "Entertainment", "Utilities", "Healthcare", "Shopping"]
        let subCategories = [
            "Housing": ["Rent", "Mortgage", "Property Tax", "Home Insurance"],
            "Transportation": ["Gas", "Car Payment", "Insurance", "Maintenance", "Public Transit"],
            "Food": ["Groceries", "Restaurants", "Coffee Shops", "Delivery"],
            "Entertainment": ["Streaming Services", "Movies", "Concerts", "Games"],
            "Utilities": ["Electric", "Water", "Internet", "Phone", "Gas"],
            "Healthcare": ["Insurance", "Prescriptions", "Doctor Visits", "Dental"],
            "Shopping": ["Clothing", "Electronics", "Home Goods", "Gifts"]
        ]
        
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<count).map { index in
            let category = categories.randomElement()!
            let subCategory = subCategories[category]?.randomElement() ?? "Misc"
            
            // Generate dates spread over the past 60 days
            let daysAgo = Int.random(in: 0...60)
            let dueDate = calendar.date(byAdding: .day, value: -daysAgo, to: today) ?? today
            
            // Determine status based on due date
            let status: TransactionStatus
            let daysDifference = calendar.dateComponents([.day], from: dueDate, to: today).day ?? 0
            
            if daysDifference < -5 {
                status = .due
            } else if daysDifference >= -5 && daysDifference < 0 {
                status = Bool.random() ? .due : .paid
            } else if daysDifference >= 0 && daysDifference <= 3 {
                status = Bool.random() ? .paid : .late
            } else {
                status = .paid
            }
            
            // Generate amount
            let amount = Double.random(in: 20...800)
            
            return TransactionRow(
                subCategory: subCategory,
                amount: amount,
                billDueDate: dueDate,
                status: status,
                category: category
            )
        }
    }
}

// MARK: - Preview Provider
#Preview("Transactions Table - Vibrant Theme") {
    TransactionsTableView(
        transactions: TransactionDemoData.generateTransactions(count: 30)
    ) { transaction in
        print("Double clicked: \(transaction.subCategory)")
    }
    .frame(minWidth: 800, minHeight: 600)
    .theme(VibrantTheme())
}

#Preview("Transactions Table - Neutral Theme") {
    TransactionsTableView(
        transactions: TransactionDemoData.generateTransactions(count: 50)
    ) { transaction in
        print("Edit transaction: \(transaction.id)")
    }
    .frame(minWidth: 800, minHeight: 600)
    .theme(NeutralTheme())
}

#Preview("Status Badges") {
    HStack(spacing: 16) {
        StatusBadge(status: .paid)
        StatusBadge(status: .due)
        StatusBadge(status: .late)
    }
    .padding(32)
    .theme(NeutralTheme())
}

#Preview("Category Sidebar") {
    CategorySidebar(
        categories: ["Housing", "Transportation", "Food", "Entertainment"],
        selectedCategory: .constant("Food")
    )
    .frame(height: 400)
    .theme(VibrantTheme())
}
