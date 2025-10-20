import SwiftUI

/// Transaction row data model
public struct TransactionRow: Identifiable, Hashable {
    public let id: UUID
    public let subCategory: String
    public let category: TransactionCategory
    public let amount: Double
    public let billDueDate: Date
    public let status: TransactionStatus
    public let description: String
    
    public init(
        id: UUID = UUID(),
        subCategory: String,
        category: TransactionCategory,
        amount: Double,
        billDueDate: Date,
        status: TransactionStatus,
        description: String = ""
    ) {
        self.id = id
        self.subCategory = subCategory
        self.category = category
        self.amount = amount
        self.billDueDate = billDueDate
        self.status = status
        self.description = description
    }
}

/// Transaction category
public enum TransactionCategory: String, CaseIterable, Identifiable {
    case income = "Income"
    case foodDining = "Food & Dining"
    case transportation = "Transportation"
    case utilities = "Utilities"
    case entertainment = "Entertainment"
    case healthcare = "Healthcare"
    case shopping = "Shopping"
    case housing = "Housing"
    case other = "Other"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .income: return "dollarsign.circle.fill"
        case .foodDining: return "fork.knife"
        case .transportation: return "car.fill"
        case .utilities: return "bolt.fill"
        case .entertainment: return "tv.fill"
        case .healthcare: return "cross.case.fill"
        case .shopping: return "cart.fill"
        case .housing: return "house.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
}

/// Transaction status
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

/// Status badge component
struct StatusBadge: View {
    @Environment(\.theme) private var theme
    let status: TransactionStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(theme.typography.labelSmall)
            .foregroundColor(textColor)
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(backgroundColor)
            .cornerRadius(theme.radius.sm)
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

/// Sort field for transactions
enum TransactionSortField {
    case subCategory
    case amount
    case billDueDate
    case status
}

/// Transactions table view with sortable columns and search
public struct TransactionsTableView: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    @State private var transactions: [TransactionRow]
    @State private var sortOrder: [KeyPathComparator<TransactionRow>] = [
        .init(\.billDueDate, order: .reverse)
    ]
    @State private var searchText: String = ""
    @State private var selectedCategory: TransactionCategory? = nil
    @State private var selection = Set<TransactionRow.ID>()
    
    private let onRowDoubleClick: ((TransactionRow) -> Void)?
    
    // MARK: - Computed Properties
    
    private var filteredTransactions: [TransactionRow] {
        var filtered = transactions
        
        // Filter by category
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            filtered = filtered.filter { transaction in
                transaction.subCategory.localizedCaseInsensitiveContains(searchText) ||
                transaction.description.localizedCaseInsensitiveContains(searchText) ||
                transaction.category.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return filtered.sorted(using: sortOrder)
    }
    
    private var categoryCounts: [TransactionCategory: Int] {
        Dictionary(grouping: transactions, by: \.category)
            .mapValues { $0.count }
    }
    
    // MARK: - Initialization
    
    /// Creates a transactions table view
    /// - Parameters:
    ///   - transactions: Initial transactions to display
    ///   - onRowDoubleClick: Optional callback when row is double-clicked
    public init(
        transactions: [TransactionRow],
        onRowDoubleClick: ((TransactionRow) -> Void)? = nil
    ) {
        _transactions = State(initialValue: transactions)
        self.onRowDoubleClick = onRowDoubleClick
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: 0) {
            // Category Sidebar
            CategorySidebar(
                categories: TransactionCategory.allCases,
                selectedCategory: $selectedCategory,
                categoryCounts: categoryCounts
            )
            .frame(width: 220)
            
            Divider()
                .background(theme.colors.border)
            
            // Main Table Area
            VStack(spacing: 0) {
                // Toolbar
                toolbar
                
                Divider()
                    .background(theme.colors.border)
                
                // Table
                Table(filteredTransactions, selection: $selection, sortOrder: $sortOrder) {
                    TableColumn("SubCategory", value: \.subCategory) { transaction in
                        HStack(spacing: theme.spacing.sm) {
                            Image(systemName: transaction.category.icon)
                                .foregroundColor(theme.colors.accentPrimary)
                                .frame(width: 20)
                            
                            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                                Text(transaction.subCategory)
                                    .font(theme.typography.bodyMedium)
                                    .foregroundColor(theme.colors.textPrimary)
                                
                                if !transaction.description.isEmpty {
                                    Text(transaction.description)
                                        .font(theme.typography.labelSmall)
                                        .foregroundColor(theme.colors.textTertiary)
                                }
                            }
                        }
                    }
                    .width(min: 150, ideal: 250)
                    
                    TableColumn("Amount", value: \.amount) { transaction in
                        Text(formatCurrency(transaction.amount))
                            .font(theme.typography.monoMedium)
                            .foregroundColor(
                                transaction.category == .income
                                    ? theme.colors.success
                                    : theme.colors.textPrimary
                            )
                    }
                    .width(min: 100, ideal: 120)
                    
                    TableColumn("Bill Due Date", value: \.billDueDate) { transaction in
                        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                            Text(formatDate(transaction.billDueDate))
                                .font(theme.typography.bodyMedium)
                                .foregroundColor(theme.colors.textPrimary)
                            
                            Text(relativeDateString(transaction.billDueDate))
                                .font(theme.typography.labelSmall)
                                .foregroundColor(theme.colors.textTertiary)
                        }
                    }
                    .width(min: 120, ideal: 150)
                    
                    TableColumn("Status") { transaction in
                        StatusBadge(status: transaction.status)
                    }
                    .width(min: 80, ideal: 100)
                }
                .onTapGesture(count: 2) {
                    if let selectedId = selection.first,
                       let transaction = filteredTransactions.first(where: { $0.id == selectedId }) {
                        onRowDoubleClick?(transaction)
                    }
                }
            }
        }
        .background(theme.colors.background)
    }
    
    // MARK: - Toolbar
    
    private var toolbar: some View {
        HStack(spacing: theme.spacing.md) {
            // Search
            HStack(spacing: theme.spacing.sm) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(theme.colors.textTertiary)
                    .font(theme.typography.bodyMedium)
                
                TextField("Search transactions...", text: $searchText)
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
            .frame(maxWidth: 400)
            
            Spacer()
            
            // Results count
            Text("\(filteredTransactions.count) transactions")
                .font(theme.typography.labelMedium)
                .foregroundColor(theme.colors.textSecondary)
            
            // Action buttons
            Button(action: {}) {
                Label("Import", systemImage: "square.and.arrow.down")
            }
            .buttonStyle(.plain)
            .foregroundColor(theme.colors.accentPrimary)
            .font(theme.typography.labelMedium)
            
            Button(action: {}) {
                Label("Add", systemImage: "plus")
            }
            .buttonStyle(.plain)
            .foregroundColor(theme.colors.accentPrimary)
            .font(theme.typography.labelMedium)
        }
        .padding(theme.spacing.lg)
    }
    
    // MARK: - Helper Methods
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
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
                return "\(-days) days ago"
            }
        }
    }
}

// MARK: - Category Sidebar

struct CategorySidebar: View {
    @Environment(\.theme) private var theme
    
    let categories: [TransactionCategory]
    @Binding var selectedCategory: TransactionCategory?
    let categoryCounts: [TransactionCategory: Int]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Text("Categories")
                .font(theme.typography.headingSmall)
                .foregroundColor(theme.colors.textPrimary)
                .padding(theme.spacing.lg)
            
            Divider()
                .background(theme.colors.border)
            
            // All transactions option
            CategoryItem(
                icon: "list.bullet",
                title: "All Transactions",
                count: categoryCounts.values.reduce(0, +),
                isSelected: selectedCategory == nil
            )
            .contentShape(Rectangle())
            .onTapGesture {
                selectedCategory = nil
            }
            
            Divider()
                .background(theme.colors.borderSubtle)
                .padding(.leading, theme.spacing.lg)
            
            // Category list
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(categories) { category in
                        CategoryItem(
                            icon: category.icon,
                            title: category.rawValue,
                            count: categoryCounts[category] ?? 0,
                            isSelected: selectedCategory == category
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedCategory = category
                        }
                    }
                }
            }
            
            Spacer()
        }
        .background(theme.colors.surface)
    }
}

struct CategoryItem: View {
    @Environment(\.theme) private var theme
    
    let icon: String
    let title: String
    let count: Int
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: theme.spacing.md) {
            Image(systemName: icon)
                .foregroundColor(isSelected ? theme.colors.accentPrimary : theme.colors.textSecondary)
                .frame(width: 20)
                .font(theme.typography.bodyMedium)
            
            Text(title)
                .font(theme.typography.bodyMedium)
                .foregroundColor(isSelected ? theme.colors.accentPrimary : theme.colors.textPrimary)
            
            Spacer()
            
            Text("\(count)")
                .font(theme.typography.labelSmall)
                .foregroundColor(theme.colors.textTertiary)
                .padding(.horizontal, theme.spacing.sm)
                .padding(.vertical, theme.spacing.xxs)
                .background(
                    isSelected
                        ? theme.colors.accentPrimary.opacity(0.1)
                        : theme.colors.backgroundTertiary
                )
                .cornerRadius(theme.radius.sm)
        }
        .padding(.horizontal, theme.spacing.lg)
        .padding(.vertical, theme.spacing.sm)
        .background(isSelected ? theme.colors.accentPrimary.opacity(0.08) : Color.clear)
    }
}

// MARK: - Demo Data

extension TransactionRow {
    static func generateDemoData() -> [TransactionRow] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            // Income
            TransactionRow(
                subCategory: "Monthly Salary",
                category: .income,
                amount: 4500.00,
                billDueDate: calendar.date(byAdding: .day, value: -15, to: today)!,
                status: .paid,
                description: "Tech Corp Inc."
            ),
            TransactionRow(
                subCategory: "Freelance Project",
                category: .income,
                amount: 1200.00,
                billDueDate: calendar.date(byAdding: .day, value: -5, to: today)!,
                status: .paid,
                description: "Web design client"
            ),
            
            // Food & Dining
            TransactionRow(
                subCategory: "Grocery Shopping",
                category: .foodDining,
                amount: 156.78,
                billDueDate: calendar.date(byAdding: .day, value: -3, to: today)!,
                status: .paid,
                description: "Whole Foods Market"
            ),
            TransactionRow(
                subCategory: "Restaurant",
                category: .foodDining,
                amount: 67.50,
                billDueDate: calendar.date(byAdding: .day, value: -1, to: today)!,
                status: .paid,
                description: "Italian Bistro"
            ),
            
            // Utilities
            TransactionRow(
                subCategory: "Electric Bill",
                category: .utilities,
                amount: 125.00,
                billDueDate: calendar.date(byAdding: .day, value: 2, to: today)!,
                status: .due,
                description: "PG&E"
            ),
            TransactionRow(
                subCategory: "Internet Service",
                category: .utilities,
                amount: 79.99,
                billDueDate: calendar.date(byAdding: .day, value: 5, to: today)!,
                status: .due,
                description: "Comcast"
            ),
            TransactionRow(
                subCategory: "Water Bill",
                category: .utilities,
                amount: 45.00,
                billDueDate: calendar.date(byAdding: .day, value: -2, to: today)!,
                status: .late,
                description: "City Water Dept"
            ),
            
            // Transportation
            TransactionRow(
                subCategory: "Gas Station",
                category: .transportation,
                amount: 52.30,
                billDueDate: calendar.date(byAdding: .day, value: -4, to: today)!,
                status: .paid,
                description: "Shell"
            ),
            TransactionRow(
                subCategory: "Car Insurance",
                category: .transportation,
                amount: 145.00,
                billDueDate: calendar.date(byAdding: .day, value: 10, to: today)!,
                status: .due,
                description: "State Farm"
            ),
            
            // Entertainment
            TransactionRow(
                subCategory: "Streaming Services",
                category: .entertainment,
                amount: 29.99,
                billDueDate: calendar.date(byAdding: .day, value: -7, to: today)!,
                status: .paid,
                description: "Netflix, Spotify"
            ),
            TransactionRow(
                subCategory: "Movie Tickets",
                category: .entertainment,
                amount: 35.00,
                billDueDate: calendar.date(byAdding: .day, value: -2, to: today)!,
                status: .paid,
                description: "AMC Theaters"
            ),
            
            // Healthcare
            TransactionRow(
                subCategory: "Health Insurance",
                category: .healthcare,
                amount: 320.00,
                billDueDate: calendar.date(byAdding: .day, value: 1, to: today)!,
                status: .due,
                description: "Blue Cross"
            ),
            TransactionRow(
                subCategory: "Pharmacy",
                category: .healthcare,
                amount: 45.00,
                billDueDate: calendar.date(byAdding: .day, value: -3, to: today)!,
                status: .paid,
                description: "CVS Prescription"
            ),
            
            // Shopping
            TransactionRow(
                subCategory: "Clothing",
                category: .shopping,
                amount: 89.99,
                billDueDate: calendar.date(byAdding: .day, value: -6, to: today)!,
                status: .paid,
                description: "Gap"
            ),
            TransactionRow(
                subCategory: "Electronics",
                category: .shopping,
                amount: 234.50,
                billDueDate: calendar.date(byAdding: .day, value: -8, to: today)!,
                status: .paid,
                description: "Best Buy - Headphones"
            ),
            
            // Housing
            TransactionRow(
                subCategory: "Rent",
                category: .housing,
                amount: 1850.00,
                billDueDate: calendar.date(byAdding: .day, value: -10, to: today)!,
                status: .paid,
                description: "Monthly rent payment"
            ),
            TransactionRow(
                subCategory: "Home Maintenance",
                category: .housing,
                amount: 175.00,
                billDueDate: calendar.date(byAdding: .day, value: 3, to: today)!,
                status: .due,
                description: "Plumber visit"
            ),
        ]
    }
}

// MARK: - Previews

#Preview("Transactions Table - Vibrant") {
    TransactionsTableView(
        transactions: TransactionRow.generateDemoData()
    ) { transaction in
        print("Double-clicked: \(transaction.subCategory)")
    }
    .themed(VibrantTheme())
    .frame(width: 1200, height: 700)
}

#Preview("Transactions Table - Neutral") {
    TransactionsTableView(
        transactions: TransactionRow.generateDemoData()
    ) { transaction in
        print("Double-clicked: \(transaction.subCategory)")
    }
    .themed(NeutralTheme())
    .frame(width: 1200, height: 700)
}

#Preview("Transactions Table - Side by Side") {
    HStack(spacing: 40) {
        TransactionsTableView(
            transactions: TransactionRow.generateDemoData()
        )
        .themed(VibrantTheme())
        
        TransactionsTableView(
            transactions: TransactionRow.generateDemoData()
        )
        .themed(NeutralTheme())
    }
    .padding(20)
    .frame(width: 2500, height: 800)
}

#Preview("Filtered View - Food & Dining") {
    TransactionsTableView(
        transactions: TransactionRow.generateDemoData()
    )
    .themed(VibrantTheme())
    .frame(width: 1200, height: 700)
    .onAppear {
        // Simulate category filter
    }
}
