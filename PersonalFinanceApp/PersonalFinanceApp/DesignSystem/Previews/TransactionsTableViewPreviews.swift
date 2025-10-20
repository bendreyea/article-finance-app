import SwiftUI

/// Comprehensive previews for TransactionsTableView component
struct TransactionsTableViewPreviews: View {
    var body: some View {
        TabView {
            // Full demo tab
            fullDemoTab
                .tabItem {
                    Label("Full Demo", systemImage: "table")
                }
            
            // Theme comparison tab
            themeComparisonTab
                .tabItem {
                    Label("Themes", systemImage: "paintbrush")
                }
            
            // Interactive demo tab
            interactiveDemoTab
                .tabItem {
                    Label("Interactive", systemImage: "hand.tap")
                }
        }
    }
    
    // MARK: - Full Demo Tab
    private var fullDemoTab: some View {
        NavigationView {
            TransactionsTableView.demo { transaction in
                print("Double-clicked transaction: \(transaction.subCategory)")
            }
            .navigationTitle("Transactions")
        }
        .theme(VibrantTheme())
    }
    
    // MARK: - Theme Comparison Tab
    private var themeComparisonTab: some View {
        VStack(spacing: 20) {
            Text("TransactionsTableView Themes")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            HStack(spacing: 20) {
                // Vibrant theme
                VStack {
                    Text("Vibrant Theme")
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    TransactionsTableViewShowcase()
                        .theme(VibrantTheme())
                        .frame(height: 600)
                }
                
                // Neutral theme
                VStack {
                    Text("Neutral Theme")
                        .font(.headline)
                        .padding(.bottom, 8)
                    
                    TransactionsTableViewShowcase()
                        .theme(NeutralTheme())
                        .frame(height: 600)
                }
            }
            .padding()
        }
    }
    
    // MARK: - Interactive Demo Tab
    private var interactiveDemoTab: some View {
        InteractiveTransactionsDemo()
            .theme(VibrantTheme())
    }
}

/// Showcase component for theme comparison
private struct TransactionsTableViewShowcase: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            // Status badges showcase
            statusBadgesSection
            
            // Category sidebar showcase
            categorySidebarSection
            
            // Mini table showcase
            miniTableSection
        }
        .padding(theme.spacing.md)
        .background(theme.colors.background)
        .cornerRadius(theme.radius.xl)
    }
    
    private var statusBadgesSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Status Badges")
                .font(theme.typography.headlineFont)
                .foregroundColor(theme.colors.textPrimary)
            
            HStack(spacing: theme.spacing.md) {
                StatusBadge(status: .paid)
                StatusBadge(status: .due)
                StatusBadge(status: .late)
            }
        }
    }
    
    private var categorySidebarSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Category Sidebar")
                .font(theme.typography.headlineFont)
                .foregroundColor(theme.colors.textPrimary)
            
            CategorySidebar(
                selectedCategory: .constant(.housing),
                transactionCounts: [
                    .housing: 5,
                    .utilities: 3,
                    .food: 12,
                    .transportation: 8
                ]
            )
            .frame(height: 200)
        }
    }
    
    private var miniTableSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Table Columns")
                .font(theme.typography.headlineFont)
                .foregroundColor(theme.colors.textPrimary)
            
            // Sample table row content
            VStack(spacing: theme.spacing.xs) {
                sampleTableRow(
                    subCategory: "Rent",
                    description: "Monthly apartment rent",
                    payee: "Property LLC",
                    amount: 2500.00,
                    date: Date(),
                    status: .due
                )
                
                sampleTableRow(
                    subCategory: "Groceries", 
                    description: "Weekly shopping",
                    payee: "SuperMarket",
                    amount: 89.32,
                    date: Date(),
                    status: .paid
                )
                
                sampleTableRow(
                    subCategory: "Electricity",
                    description: "Monthly utility bill",
                    payee: "Power Company",
                    amount: 145.67,
                    date: Calendar.current.date(byAdding: .day, value: -2, to: Date()) ?? Date(),
                    status: .late
                )
            }
            .padding(theme.spacing.sm)
            .background(theme.colors.surface)
            .cornerRadius(theme.radius.md)
        }
    }
    
    private func sampleTableRow(
        subCategory: String,
        description: String,
        payee: String,
        amount: Double,
        date: Date,
        status: TransactionStatus
    ) -> some View {
        HStack {
            // Sub Category
            VStack(alignment: .leading, spacing: 2) {
                Text(subCategory)
                    .font(theme.typography.bodyFont)
                    .foregroundColor(theme.colors.textPrimary)
                Text(description)
                    .font(theme.typography.captionFont)
                    .foregroundColor(theme.colors.textSecondary)
                    .lineLimit(1)
            }
            .frame(width: 80, alignment: .leading)
            
            Spacer()
            
            // Amount
            Text(formatCurrency(amount))
                .font(theme.typography.font(size: theme.typography.callout, weight: theme.typography.semibold))
                .foregroundColor(amount > 0 ? theme.colors.error : theme.colors.success)
                .frame(width: 80, alignment: .trailing)
            
            // Status
            StatusBadge(status: status)
                .frame(width: 60)
        }
        .padding(.vertical, theme.spacing.xs)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

/// Interactive demo with controls
private struct InteractiveTransactionsDemo: View {
    @Environment(\.theme) private var theme
    @State private var transactions = TransactionsTableView.demoTransactions
    @State private var selectedRowInfo: String = "No row selected"
    @State private var showAddTransaction = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Controls section
                controlsSection
                
                // Main table
                TransactionsTableView(
                    transactions: transactions
                ) { transaction in
                    selectedRowInfo = "Double-clicked: \(transaction.subCategory) - \(formatCurrency(transaction.amount))"
                }
            }
            .navigationTitle("Interactive Demo")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Transaction") {
                        showAddTransaction = true
                    }
                }
            }
        }
        .sheet(isPresented: $showAddTransaction) {
            AddTransactionSheet { newTransaction in
                transactions.append(newTransaction)
            }
        }
    }
    
    private var controlsSection: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Interactive Controls")
                    .cardTitle()
                
                HStack {
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        Text("Actions:")
                            .font(theme.typography.calloutFont)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("• Click sidebar to filter by category")
                            Text("• Use search bar to find transactions")
                            Text("• Click column headers to sort")
                            Text("• Double-click row to edit (see below)")
                        }
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        Text("Last Action:")
                            .font(theme.typography.calloutFont)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text(selectedRowInfo)
                            .font(theme.typography.captionFont)
                            .foregroundColor(theme.colors.primary)
                            .padding(theme.spacing.xs)
                            .background(theme.colors.primary.opacity(0.1))
                            .cornerRadius(theme.radius.sm)
                    }
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
}

/// Simple add transaction sheet for demo
private struct AddTransactionSheet: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    
    let onAdd: (TransactionRow) -> Void
    
    @State private var category: TransactionCategory = .other
    @State private var subCategory = ""
    @State private var amount = ""
    @State private var payee = ""
    @State private var description = ""
    @State private var dueDate = Date()
    @State private var status: TransactionStatus = .due
    
    var body: some View {
        NavigationView {
            Form {
                Section("Transaction Details") {
                    Picker("Category", selection: $category) {
                        ForEach(TransactionCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                    
                    TextField("Sub Category", text: $subCategory)
                    TextField("Description", text: $description)
                    TextField("Payee", text: $payee)
                }
                
                Section("Amount & Date") {
                    TextField("Amount", text: $amount)
                    
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    
                    Picker("Status", selection: $status) {
                        ForEach(TransactionStatus.allCases) { stat in
                            Text(stat.rawValue).tag(stat)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addTransaction()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !subCategory.isEmpty && !amount.isEmpty && !payee.isEmpty && Double(amount) != nil
    }
    
    private func addTransaction() {
        guard let amountValue = Double(amount) else { return }
        
        let transaction = TransactionRow(
            category: category,
            subCategory: subCategory,
            amount: amountValue,
            billDueDate: dueDate,
            status: status,
            description: description,
            payee: payee
        )
        
        onAdd(transaction)
        dismiss()
    }
}

// MARK: - Data Scenarios for Testing
extension TransactionsTableViewPreviews {
    /// Various data scenarios for comprehensive testing
    static var testScenarios: some View {
        TabView {
            // Empty state
            TransactionsTableView(transactions: [])
                .tabItem { Label("Empty", systemImage: "tray") }
            
            // Single category
            TransactionsTableView(
                transactions: TransactionsTableView.demoTransactions.filter { $0.category == .housing }
            )
            .tabItem { Label("Housing Only", systemImage: "house") }
            
            // Large dataset
            TransactionsTableView(transactions: generateLargeDataset())
                .tabItem { Label("Large Dataset", systemImage: "chart.bar") }
            
            // Mixed statuses
            TransactionsTableView(transactions: generateMixedStatusData())
                .tabItem { Label("Mixed Status", systemImage: "clock") }
        }
        .theme(VibrantTheme())
    }
    
    private static func generateLargeDataset() -> [TransactionRow] {
        var transactions: [TransactionRow] = []
        let categories = TransactionCategory.allCases
        let statuses = TransactionStatus.allCases
        
        for i in 0..<100 {
            let category = categories.randomElement() ?? .other
            let status = statuses.randomElement() ?? .due
            let amount = Double.random(in: 10...1000)
            let daysOffset = Int.random(in: -30...30)
            let date = Calendar.current.date(byAdding: .day, value: daysOffset, to: Date()) ?? Date()
            
            transactions.append(TransactionRow(
                category: category,
                subCategory: "Item \(i + 1)",
                amount: amount,
                billDueDate: date,
                status: status,
                description: "Sample transaction \(i + 1)",
                payee: "Vendor \(i + 1)"
            ))
        }
        
        return transactions
    }
    
    private static func generateMixedStatusData() -> [TransactionRow] {
        let baseTransactions = TransactionsTableView.demoTransactions
        var mixed: [TransactionRow] = []
        
        for (index, transaction) in baseTransactions.enumerated() {
            let newStatus: TransactionStatus
            switch index % 3 {
            case 0: newStatus = .paid
            case 1: newStatus = .due
            default: newStatus = .late
            }
            
            mixed.append(TransactionRow(
                category: transaction.category,
                subCategory: transaction.subCategory,
                amount: transaction.amount,
                billDueDate: transaction.billDueDate,
                status: newStatus,
                description: transaction.description,
                payee: transaction.payee
            ))
        }
        
        return mixed
    }
}

// MARK: - Preview Provider
#Preview("Transactions Table - Full Demo") {
    TransactionsTableViewPreviews()
}

#Preview("Transactions Table - Vibrant Theme") {
    NavigationView {
        TransactionsTableView.demo()
            .navigationTitle("Transactions")
    }
    .theme(VibrantTheme())
}

#Preview("Transactions Table - Neutral Theme") {
    NavigationView {
        TransactionsTableView.demo()
            .navigationTitle("Transactions")
    }
    .theme(NeutralTheme())
}

#Preview("Status Badges") {
    VStack(spacing: 16) {
        Text("Status Badge Variations")
            .font(.title)
        
        VStack(spacing: 8) {
            StatusBadge(status: .paid)
            StatusBadge(status: .due)  
            StatusBadge(status: .late)
        }
        
        HStack(spacing: 16) {
            StatusBadge(status: .paid)
            StatusBadge(status: .due)
            StatusBadge(status: .late)
        }
    }
    .theme(VibrantTheme())
    .padding()
}

#Preview("Category Sidebar") {
    CategorySidebar(
        selectedCategory: .constant(.housing),
        transactionCounts: [
            .housing: 15,
            .utilities: 8, 
            .food: 25,
            .transportation: 12,
            .entertainment: 6,
            .other: 3
        ]
    )
    .theme(VibrantTheme())
}

#Preview("Test Scenarios") {
    TransactionsTableViewPreviews.testScenarios
}