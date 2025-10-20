import SwiftUI

// MARK: - Transaction Status

/// Transaction status for payment tracking
public enum TransactionStatus: String, CaseIterable, Codable {
    case paid
    case late
    case due
    
    public var displayName: String {
        rawValue.capitalized
    }
}

// MARK: - Transaction Row Model

/// Data model for a transaction row in the table
public struct TransactionRow: Identifiable, Hashable {
    public let id: UUID
    public let subCategory: String
    public let amount: Double
    public let billDueDate: Date
    public let status: TransactionStatus
    public let category: String
    public let merchant: String?
    public let notes: String?
    
    public init(
        id: UUID = UUID(),
        subCategory: String,
        amount: Double,
        billDueDate: Date,
        status: TransactionStatus,
        category: String,
        merchant: String? = nil,
        notes: String? = nil
    ) {
        self.id = id
        self.subCategory = subCategory
        self.amount = amount
        self.billDueDate = billDueDate
        self.status = status
        self.category = category
        self.merchant = merchant
        self.notes = notes
    }
}

// MARK: - Status Badge Component

/// A colored badge showing transaction status
public struct StatusBadge: View {
    @Environment(\.theme) private var theme
    
    private let status: TransactionStatus
    
    public init(status: TransactionStatus) {
        self.status = status
    }
    
    public var body: some View {
        HStack(spacing: theme.spacing.xxs) {
            Circle()
                .fill(statusColor)
                .frame(width: 8, height: 8)
            
            Text(status.displayName)
                .font(theme.typography.labelSmall.font)
                .foregroundColor(statusColor)
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.vertical, theme.spacing.xxs)
        .background(statusBackground)
        .cornerRadius(theme.radius.sm)
    }
    
    private var statusColor: Color {
        switch status {
        case .paid:
            return theme.colors.success
        case .late:
            return theme.colors.error
        case .due:
            return theme.colors.warning
        }
    }
    
    private var statusBackground: Color {
        switch status {
        case .paid:
            return theme.colors.successBackground
        case .late:
            return theme.colors.errorBackground
        case .due:
            return theme.colors.warningBackground
        }
    }
}

// MARK: - Category Sidebar

/// A sidebar list for filtering transactions by category
public struct CategorySidebar: View {
    @Environment(\.theme) private var theme
    
    @Binding var selectedCategory: String?
    let categories: [String]
    let transactionCounts: [String: Int]
    
    public init(
        selectedCategory: Binding<String?>,
        categories: [String],
        transactionCounts: [String: Int]
    ) {
        self._selectedCategory = selectedCategory
        self.categories = categories
        self.transactionCounts = transactionCounts
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Text("Categories")
                    .font(theme.typography.titleMedium.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                Spacer()
            }
            .padding(theme.spacing.md)
            .background(theme.colors.surface)
            
            Divider()
                .background(theme.colors.border)
            
            // Category List
            ScrollView {
                VStack(spacing: theme.spacing.xxs) {
                    // All Categories
                    categoryButton(
                        name: "All Categories",
                        count: transactionCounts.values.reduce(0, +),
                        icon: "square.grid.2x2",
                        isSelected: selectedCategory == nil
                    ) {
                        selectedCategory = nil
                    }
                    
                    Divider()
                        .background(theme.colors.borderSubtle)
                        .padding(.vertical, theme.spacing.xs)
                    
                    // Individual Categories
                    ForEach(categories.sorted(), id: \.self) { category in
                        categoryButton(
                            name: category,
                            count: transactionCounts[category] ?? 0,
                            icon: iconForCategory(category),
                            isSelected: selectedCategory == category
                        ) {
                            selectedCategory = category
                        }
                    }
                }
                .padding(theme.spacing.xs)
            }
        }
        .frame(width: 240)
        .background(theme.colors.backgroundSecondary)
    }
    
    private func categoryButton(
        name: String,
        count: Int,
        icon: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: theme.spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(isSelected ? theme.colors.primary : theme.colors.textSecondary)
                    .frame(width: 20)
                
                Text(name)
                    .font(theme.typography.bodyMedium.font)
                    .foregroundColor(isSelected ? theme.colors.primary : theme.colors.textPrimary)
                
                Spacer()
                
                Text("\(count)")
                    .font(theme.typography.labelSmall.font)
                    .foregroundColor(theme.colors.textTertiary)
                    .padding(.horizontal, theme.spacing.xs)
                    .padding(.vertical, theme.spacing.xxs)
                    .background(theme.colors.backgroundTertiary)
                    .cornerRadius(theme.radius.sm)
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(isSelected ? theme.colors.primary.opacity(0.1) : Color.clear)
            .cornerRadius(theme.radius.sm)
        }
        .buttonStyle(.plain)
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "housing": return "house.fill"
        case "food": return "fork.knife"
        case "transportation": return "car.fill"
        case "utilities": return "bolt.fill"
        case "entertainment": return "theatermasks.fill"
        case "healthcare": return "cross.case.fill"
        case "shopping": return "cart.fill"
        case "income": return "dollarsign.circle.fill"
        default: return "folder.fill"
        }
    }
}

// MARK: - Transactions Table View

/// A comprehensive table view for displaying and managing transactions
public struct TransactionsTableView: View {
    @Environment(\.theme) private var theme
    
    // Data
    @Binding var transactions: [TransactionRow]
    let onRowDoubleClick: (TransactionRow) -> Void
    
    // State
    @State private var sortOrder = [KeyPathComparator(\TransactionRow.billDueDate, order: .reverse)]
    @State private var selectedCategory: String? = nil
    @State private var searchText = ""
    @State private var selection = Set<TransactionRow.ID>()
    
    public init(
        transactions: Binding<[TransactionRow]>,
        onRowDoubleClick: @escaping (TransactionRow) -> Void
    ) {
        self._transactions = transactions
        self.onRowDoubleClick = onRowDoubleClick
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 0) {
            // Category Sidebar
            CategorySidebar(
                selectedCategory: $selectedCategory,
                categories: uniqueCategories,
                transactionCounts: categoryCounts
            )
            
            Divider()
                .background(theme.colors.border)
            
            // Main Content
            VStack(spacing: 0) {
                // Toolbar
                toolbar
                
                Divider()
                    .background(theme.colors.border)
                
                // Table
                tableView
            }
        }
        .background(theme.colors.background)
    }
    
    // MARK: - Toolbar
    
    private var toolbar: some View {
        HStack(spacing: theme.spacing.md) {
            // Search
            HStack(spacing: theme.spacing.xs) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(theme.colors.textTertiary)
                
                TextField("Search transactions...", text: $searchText)
                    .textFieldStyle(.plain)
                    .font(theme.typography.bodyMedium.font)
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(theme.colors.textTertiary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(theme.colors.backgroundSecondary)
            .cornerRadius(theme.radius.sm)
            .frame(width: 300)
            
            Spacer()
            
            // Summary Stats
            HStack(spacing: theme.spacing.lg) {
                statItem(
                    label: "Total",
                    value: "\(filteredTransactions.count)"
                )
                
                statItem(
                    label: "Paid",
                    value: "\(filteredTransactions.filter { $0.status == .paid }.count)",
                    color: theme.colors.success
                )
                
                statItem(
                    label: "Due",
                    value: "\(filteredTransactions.filter { $0.status == .due }.count)",
                    color: theme.colors.warning
                )
                
                statItem(
                    label: "Late",
                    value: "\(filteredTransactions.filter { $0.status == .late }.count)",
                    color: theme.colors.error
                )
            }
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surface)
    }
    
    private func statItem(label: String, value: String, color: Color? = nil) -> some View {
        VStack(alignment: .trailing, spacing: theme.spacing.xxs) {
            Text(value)
                .font(theme.typography.titleMedium.font)
                .foregroundColor(color ?? theme.colors.textPrimary)
            
            Text(label)
                .font(theme.typography.labelSmall.font)
                .foregroundColor(theme.colors.textSecondary)
        }
    }
    
    // MARK: - Table View
    
    private var tableView: some View {
        Table(filteredTransactions, selection: $selection, sortOrder: $sortOrder) {
            TableColumn("Sub Category", value: \.subCategory) { transaction in
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text(transaction.subCategory)
                        .font(theme.typography.bodyMedium.font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    if let merchant = transaction.merchant {
                        Text(merchant)
                            .font(theme.typography.labelSmall.font)
                            .foregroundColor(theme.colors.textTertiary)
                    }
                }
            }
            .width(min: 150, ideal: 200, max: 300)
            
            TableColumn("Amount", value: \.amount) { transaction in
                Text(formatCurrency(transaction.amount))
                    .font(theme.typography.bodyMedium.font)
                    .foregroundColor(
                        transaction.amount >= 0 ? theme.colors.success : theme.colors.error
                    )
                    .monospacedDigit()
            }
            .width(min: 100, ideal: 120, max: 150)
            
            TableColumn("Bill Due Date", value: \.billDueDate) { transaction in
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text(formatDate(transaction.billDueDate))
                        .font(theme.typography.bodyMedium.font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text(relativeDateString(transaction.billDueDate))
                        .font(theme.typography.labelSmall.font)
                        .foregroundColor(theme.colors.textTertiary)
                }
            }
            .width(min: 120, ideal: 150, max: 200)
            
            TableColumn("Status", value: \.status.rawValue) { transaction in
                StatusBadge(status: transaction.status)
            }
            .width(min: 100, ideal: 120, max: 150)
            
            TableColumn("Category", value: \.category) { transaction in
                HStack(spacing: theme.spacing.xs) {
                    Image(systemName: iconForCategory(transaction.category))
                        .font(.system(size: 12))
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Text(transaction.category)
                        .font(theme.typography.bodySmall.font)
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
            .width(min: 100, ideal: 130, max: 180)
        }
        .onChange(of: sortOrder) { _, newOrder in
            transactions.sort(using: newOrder)
        }
        // Note: Double-click functionality would require a custom Table implementation
        // For now, users can use the edit button in the toolbar
    }
    
    // MARK: - Computed Properties
    
    private var filteredTransactions: [TransactionRow] {
        var filtered = transactions
        
        // Filter by category
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        // Filter by search
        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                transaction.subCategory.localizedCaseInsensitiveContains(searchText) ||
                transaction.category.localizedCaseInsensitiveContains(searchText) ||
                transaction.merchant?.localizedCaseInsensitiveContains(searchText) ?? false
            }
        }
        
        return filtered
    }
    
    private var uniqueCategories: [String] {
        Array(Set(transactions.map { $0.category }))
    }
    
    private var categoryCounts: [String: Int] {
        Dictionary(grouping: transactions, by: { $0.category })
            .mapValues { $0.count }
    }
    
    // MARK: - Formatting Helpers
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        
        let prefix = value >= 0 ? "+" : ""
        return prefix + (formatter.string(from: NSNumber(value: abs(value))) ?? "$0.00")
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    private func relativeDateString(_ date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.day], from: now, to: date)
        
        if let days = components.day {
            if days == 0 {
                return "Today"
            } else if days == 1 {
                return "Tomorrow"
            } else if days == -1 {
                return "Yesterday"
            } else if days > 0 {
                return "In \(days) days"
            } else {
                return "\(-days) days ago"
            }
        }
        
        return ""
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "housing": return "house.fill"
        case "food": return "fork.knife"
        case "transportation": return "car.fill"
        case "utilities": return "bolt.fill"
        case "entertainment": return "theatermasks.fill"
        case "healthcare": return "cross.case.fill"
        case "shopping": return "cart.fill"
        case "income": return "dollarsign.circle.fill"
        default: return "folder.fill"
        }
    }
}

// MARK: - Demo Data Generator

/// Generates sample transaction data for previews and testing
public struct TransactionDemoData {
    public static func generateTransactions(count: Int = 50) -> [TransactionRow] {
        let categories = ["Housing", "Food", "Transportation", "Utilities", "Entertainment", "Healthcare", "Shopping"]
        let subCategories: [String: [String]] = [
            "Housing": ["Rent", "Mortgage", "Property Tax", "HOA Fees", "Home Insurance"],
            "Food": ["Groceries", "Restaurants", "Coffee", "Meal Delivery"],
            "Transportation": ["Gas", "Car Payment", "Insurance", "Maintenance", "Parking"],
            "Utilities": ["Electric", "Water", "Gas", "Internet", "Phone"],
            "Entertainment": ["Streaming", "Movies", "Concerts", "Games"],
            "Healthcare": ["Doctor Visit", "Pharmacy", "Dental", "Vision"],
            "Shopping": ["Clothing", "Electronics", "Home Goods", "Personal Care"]
        ]
        
        let merchants = [
            "Whole Foods", "Safeway", "Shell Gas", "Starbucks", "Netflix",
            "Amazon", "Target", "Best Buy", "AT&T", "PG&E", "Kaiser",
            "Uber", "Lyft", "Apple", "Nike", "Home Depot"
        ]
        
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<count).map { index in
            let category = categories.randomElement()!
            let subCategory = subCategories[category]?.randomElement() ?? "Other"
            
            // Generate date (past 30 days to next 30 days)
            let daysOffset = Int.random(in: -30...30)
            let dueDate = calendar.date(byAdding: .day, value: daysOffset, to: today)!
            
            // Determine status based on date
            let status: TransactionStatus
            if dueDate < today {
                status = Bool.random() ? .paid : .late
            } else if daysOffset <= 7 {
                status = .due
            } else {
                status = .paid
            }
            
            // Generate amount
            let baseAmount = Double.random(in: 50...500)
            let roundedAmount = (baseAmount * 100).rounded() / 100
            
            return TransactionRow(
                subCategory: subCategory,
                amount: roundedAmount,
                billDueDate: dueDate,
                status: status,
                category: category,
                merchant: merchants.randomElement(),
                notes: nil
            )
        }
    }
}

// MARK: - Preview

#Preview("Transactions Table - Vibrant") {
    @Previewable @State var transactions = TransactionDemoData.generateTransactions(count: 30)
    
    ThemeProvider(theme: VibrantTheme()) {
        TransactionsTableView(
            transactions: $transactions,
            onRowDoubleClick: { transaction in
                print("Double clicked: \(transaction.subCategory)")
            }
        )
        .frame(width: 1200, height: 800)
    }
}
