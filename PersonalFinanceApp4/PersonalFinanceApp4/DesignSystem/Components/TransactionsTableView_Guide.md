# TransactionsTableView Component Guide

## Overview

`TransactionsTableView` is a comprehensive, fully-themed table component for displaying and managing financial transactions. It features sortable columns, search, category filtering, status badges, and interactive row actions—perfect for transaction management in financial applications.

## Components Package

This implementation includes **4 interconnected components**:

1. **TransactionModels** - Data structures and demo generators
2. **StatusBadge** - Colored status indicators
3. **CategorySidebar** - Category filter sidebar
4. **TransactionsTableView** - Main table with all features

## Features

✅ **SwiftUI Table** - Native macOS Table with column support  
✅ **Sortable Columns** - Click headers to sort by any column  
✅ **Search** - Real-time search across subcategory, category, notes  
✅ **Category Filter** - Sidebar with category selection  
✅ **Status Badges** - Color-coded Paid/Due/Late indicators  
✅ **Currency Formatting** - Proper $ formatting with decimals  
✅ **Date Formatting** - Medium date style (e.g., "Oct 17, 2025")  
✅ **Row Selection** - Single/multiple row selection  
✅ **Double-Click Action** - Callback for editing transactions  
✅ **Category Counts** - Live counts in sidebar badges  
✅ **Fully Themed** - Zero hardcoded colors or fonts  
✅ **Demo Data** - Realistic transaction generator  

## Basic Usage

```swift
TransactionsTableView(
    transactions: transactions,
    onRowDoubleClick: { transaction in
        // Handle edit action
        showEditSheet(for: transaction)
    }
)
```

## Full API

```swift
TransactionsTableView(
    transactions: [TransactionRow],           // Transaction data
    onRowDoubleClick: ((TransactionRow) -> Void)? = nil,
    showSidebar: Bool = true
)
```

## Parameters

### transactions: [TransactionRow]
Array of transactions to display.

**TransactionRow Structure**:
```swift
TransactionRow(
    id: UUID = UUID(),
    category: TransactionCategory,     // Housing, Utilities, etc.
    subcategory: String,               // "Rent", "Electricity", etc.
    amount: Double,                    // 1200.00
    dueDate: Date,                     // Bill due date
    status: TransactionStatus,         // .paid, .due, .late
    notes: String? = nil               // Optional notes
)
```

### onRowDoubleClick: ((TransactionRow) -> Void)?
Optional callback triggered when user double-clicks a row.
- Use for editing transactions
- Receives the clicked transaction as parameter
- Example: Show edit sheet, navigate to detail view

### showSidebar: Bool (Default: true)
Whether to show the category filter sidebar.
- `true`: Shows sidebar with categories (default)
- `false`: Table only, no sidebar

## Table Columns

### 1. Category (Not Sortable)
- Shows category icon + name
- Icon from `TransactionCategory.icon`
- Color: `theme.colors.primary`

### 2. Subcategory (Sortable)
- Transaction subcategory name
- Examples: "Rent", "Electricity", "Netflix"
- Sortable alphabetically

### 3. Amount (Sortable)
- Currency formatted: "$1,200.00"
- Income shown in green (`theme.colors.success`)
- Expenses in default color
- Sortable numerically

### 4. Due Date (Sortable)
- Medium date format: "Oct 17, 2025"
- Sortable chronologically
- Default sort (ascending)

### 5. Status (Sortable)
- Colored badge with icon
- **Paid**: Green badge with checkmark
- **Due**: Yellow/orange badge with clock
- **Late**: Red badge with warning triangle
- Sortable by priority (Late > Due > Paid)

### 6. Notes (Not Sortable)
- Optional transaction notes
- Shows "—" if empty
- Truncated to 1 line

## Transaction Status

### TransactionStatus Enum
```swift
enum TransactionStatus: String {
    case paid = "Paid"     // Green - Completed
    case due = "Due"       // Orange - Upcoming
    case late = "Late"     // Red - Overdue
}
```

### Status Colors
- **Paid**: `theme.colors.success` (green)
- **Due**: `theme.colors.warning` (orange/yellow)
- **Late**: `theme.colors.error` (red)

## Transaction Categories

### Available Categories
```swift
enum TransactionCategory {
    case housing          // 🏠 House
    case utilities        // ⚡ Bolt
    case groceries        // 🛒 Cart
    case transportation   // 🚗 Car
    case entertainment    // 📺 TV
    case healthcare       // ⚕️ Medical Cross
    case shopping         // 🛍️ Bag
    case dining           // 🍴 Fork & Knife
    case income           // 💰 Dollar Circle
    case other            // ⋯ Ellipsis
}
```

Each category has:
- Icon (SF Symbol)
- Localized name
- Color coding in sidebar

## Features Deep Dive

### 1. Search Functionality
**What it searches**:
- Subcategory name
- Category name
- Notes field

**How it works**:
- Real-time as you type
- Case-insensitive
- Partial matching
- Shows result count in toolbar

### 2. Sorting
**Sortable columns**:
- Subcategory (alphabetical)
- Amount (numerical)
- Due Date (chronological)
- Status (priority: Late → Due → Paid)

**How to sort**:
- Click column header to sort ascending
- Click again to sort descending
- Default: Due Date ascending

**State Management**:
```swift
@State private var sortOrder = [
    KeyPathComparator(\TransactionRow.dueDate, order: .forward)
]
```

### 3. Category Filtering
**Sidebar features**:
- All Categories (shows all)
- Individual category filters
- Transaction counts per category
- Clear selection button in header
- Visual highlight for selected category

**Interaction**:
- Click category to filter
- Click "All Categories" to show all
- Click X in header to clear filter

### 4. Toolbar
**Components**:
- Search field with clear button
- Results count display
- Clear Filters button (when filters active)

### 5. Row Actions
**Double-click**:
```swift
TransactionsTableView(
    transactions: transactions,
    onRowDoubleClick: { transaction in
        selectedTransaction = transaction
        showEditSheet = true
    }
)
```

**Selection**:
- Single selection supported
- State maintained in `@State private var selection`
- Can be extended for bulk actions

## Demo Data Generation

### Simple Generation
```swift
let transactions = TransactionRow.generateDemoData(count: 25)
```

### Features of Demo Data
- Realistic amounts per category
- Paydays on 1st and 15th (higher amounts)
- Bill due dates throughout month
- Automatic status calculation based on due date
- Random notes on some transactions
- Balanced category distribution

### Categories in Demo Data
Each category has realistic amounts:
- **Housing**: $1,200-$2,500 (rent/mortgage)
- **Utilities**: $50-$200 (electricity, water, internet)
- **Groceries**: $30-$150 (shopping trips)
- **Transportation**: $40-$400 (gas, payments)
- **Entertainment**: $10-$100 (subscriptions, movies)
- **Healthcare**: $50-$500 (insurance, prescriptions)
- **Shopping**: $20-$300 (general purchases)
- **Dining**: $15-$80 (restaurants, delivery)
- **Income**: $500-$5,000 (paychecks, freelance)
- **Other**: $10-$200 (miscellaneous)

## Common Use Cases

### 1. Basic Transaction Table
```swift
struct TransactionsView: View {
    @Query private var transactions: [Transaction]
    
    var body: some View {
        TransactionsTableView(
            transactions: transactions.map { convertToRow($0) }
        )
    }
}
```

### 2. With Edit Action
```swift
struct ManageTransactionsView: View {
    @State private var transactions = TransactionRow.generateDemoData(count: 25)
    @State private var showEditSheet = false
    @State private var selectedTransaction: TransactionRow?
    
    var body: some View {
        TransactionsTableView(
            transactions: transactions,
            onRowDoubleClick: { transaction in
                selectedTransaction = transaction
                showEditSheet = true
            }
        )
        .sheet(isPresented: $showEditSheet) {
            if let transaction = selectedTransaction {
                EditTransactionView(transaction: transaction)
            }
        }
    }
}
```

### 3. Without Sidebar
```swift
TransactionsTableView(
    transactions: filteredTransactions,
    showSidebar: false
)
```

### 4. In a Card
```swift
Card(elevation: .medium, padding: .none) {
    TransactionsTableView(
        transactions: recentTransactions,
        onRowDoubleClick: handleEdit
    )
    .frame(height: 500)
}
```

### 5. With Custom Filtering
```swift
struct FilteredTransactionsView: View {
    let allTransactions: [TransactionRow]
    let startDate: Date
    let endDate: Date
    
    var filteredByDate: [TransactionRow] {
        allTransactions.filter { transaction in
            transaction.dueDate >= startDate && transaction.dueDate <= endDate
        }
    }
    
    var body: some View {
        TransactionsTableView(
            transactions: filteredByDate
        )
    }
}
```

## StatusBadge Component

### Standalone Usage
```swift
StatusBadge(status: .paid)
StatusBadge(status: .due, size: .small)
StatusBadge(status: .late, size: .large)
```

### Badge Sizes
- **Small**: Compact badge for tables
- **Medium**: Standard size (default)
- **Large**: Prominent display

### Features
- Icon + text
- Colored background (15% opacity)
- Rounded corners from theme
- Fully themed colors

## CategorySidebar Component

### Standalone Usage
```swift
CategorySidebar(
    selectedCategory: $selectedCategory,
    categoryCounts: ["Housing": 5, "Utilities": 8],
    showCounts: true
)
```

### Features
- All Categories option
- Individual category rows
- Transaction count badges
- Clear selection button
- Visual selection highlight
- Scrollable list

## Theme Integration

### Colors Used
All colors from theme tokens:
- **Primary**: Category icons, selection highlight
- **Success**: Income amounts, Paid status
- **Warning**: Due status
- **Error**: Late status
- **Backgrounds**: Surface, backgroundElevated
- **Text**: onSurface hierarchy

### Fonts Used
- **Heading Small**: Sidebar header
- **Body Medium**: Table cells, sidebar items
- **Body Small**: Results count, notes
- **Label Small**: Count badges
- **Label Medium**: Toolbar buttons

### Both Themes Work Perfectly
- **Vibrant**: Dark mode with vivid colors
- **Neutral**: Light mode with subtle tones

## Best Practices

### ✅ DO
- Use demo data for development and testing
- Implement double-click for editing
- Show sidebar for better UX
- Keep transaction counts updated
- Format currency and dates consistently
- Handle empty states gracefully

### ❌ DON'T
- Don't show thousands of rows (paginate instead)
- Don't update data too frequently
- Don't hardcode colors or fonts
- Don't skip the onRowDoubleClick handler
- Don't show sidebar if space is limited

## Performance Considerations

### Optimal Row Count
- **Ideal**: 10-50 rows
- **Good**: 50-100 rows
- **Paginate**: > 100 rows

### Filtering Performance
- Search and category filters are efficient
- Sorting uses native Table performance
- Real-time updates work well for moderate datasets

## Integration with SwiftData

### Convert from SwiftData Model
```swift
extension Transaction {
    func toTransactionRow() -> TransactionRow {
        TransactionRow(
            id: self.id,
            category: TransactionCategory(rawValue: self.categoryName) ?? .other,
            subcategory: self.subcategory,
            amount: self.amount,
            dueDate: self.dueDate,
            status: TransactionStatus(rawValue: self.statusName) ?? .due,
            notes: self.notes
        )
    }
}

// Usage
@Query private var transactions: [Transaction]

var transactionRows: [TransactionRow] {
    transactions.map { $0.toTransactionRow() }
}
```

## Keyboard Shortcuts

### Built-in Table Shortcuts
- **↑/↓**: Navigate rows
- **⌘A**: Select all
- **Space**: Toggle selection
- **Enter**: Can trigger custom action

### Custom Shortcuts
```swift
.onKeyPress(.return) {
    if let selectedId = selection.first {
        // Handle enter key
    }
    return .handled
}
```

## Accessibility

### VoiceOver Support
- Table rows are accessible
- Column headers are labeled
- Status badges have semantic labels
- Search field has placeholder
- Counts are announced

### Additional Accessibility
```swift
TransactionsTableView(...)
    .accessibilityLabel("Transactions table")
    .accessibilityHint("Double-click rows to edit")
```

## Customization Examples

### Custom Column Widths
Already configured with:
- `min`: Minimum width
- `ideal`: Preferred width
- `max`: Maximum width

### Hide Sidebar Programmatically
```swift
@State private var showSidebar = true

TransactionsTableView(
    transactions: transactions,
    showSidebar: showSidebar
)
```

### Custom Search Scope
Extend filtering logic in computed property:
```swift
private var filteredTransactions: [TransactionRow] {
    var filtered = transactions
    
    // Add custom filters
    if onlyLate {
        filtered = filtered.filter { $0.status == .late }
    }
    
    // ... existing filters
}
```

## Troubleshooting

### Table Not Showing Data
- Verify `transactions` array is not empty
- Check if filters are too restrictive
- Ensure data model matches `TransactionRow`

### Sorting Not Working
- Verify column uses `value: \.property` syntax
- Check property is Comparable
- Ensure `sortOrder` state is bound

### Double-Click Not Firing
- Verify `onRowDoubleClick` is provided
- Check selection state is updating
- Ensure row is actually selected

### Sidebar Counts Wrong
- Update `categoryCounts` when data changes
- Verify category mapping is correct
- Check filtering logic

## Complete Example

### Full Feature Implementation
```swift
struct TransactionManagementView: View {
    @Environment(\.theme) private var theme
    @State private var transactions = TransactionRow.generateDemoData(count: 30)
    @State private var showEditSheet = false
    @State private var selectedTransaction: TransactionRow?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            header
            
            Divider()
            
            // Table
            TransactionsTableView(
                transactions: transactions,
                onRowDoubleClick: { transaction in
                    selectedTransaction = transaction
                    showEditSheet = true
                }
            )
        }
        .sheet(isPresented: $showEditSheet) {
            editSheet
        }
    }
    
    private var header: some View {
        HStack {
            Text("Transactions")
                .font(theme.typography.displaySmall)
            
            Spacer()
            
            Button("Add Transaction") {
                // Add new transaction
            }
            .font(theme.typography.labelLarge)
            .foregroundColor(theme.colors.onPrimary)
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.sm)
            .background(theme.colors.primary)
            .cornerRadius(theme.radius.button)
        }
        .padding()
    }
    
    @ViewBuilder
    private var editSheet: some View {
        if let transaction = selectedTransaction {
            VStack(spacing: 20) {
                Text("Edit Transaction")
                    .font(theme.typography.headingLarge)
                
                // Edit form here
                
                HStack {
                    Button("Cancel") {
                        showEditSheet = false
                    }
                    
                    Button("Save") {
                        // Save changes
                        showEditSheet = false
                    }
                }
            }
            .padding()
        }
    }
}
```

---

**Components**: TransactionsTableView + StatusBadge + CategorySidebar + TransactionModels  
**Files**: 
- `DesignSystem/Components/TransactionsTableView.swift`
- `DesignSystem/Components/StatusBadge.swift`
- `DesignSystem/Components/CategorySidebar.swift`
- `DesignSystem/Components/TransactionModels.swift`  
**Dependencies**: SwiftUI Table, AppTheme  
**Platform**: macOS 14+  
**Framework**: SwiftUI
