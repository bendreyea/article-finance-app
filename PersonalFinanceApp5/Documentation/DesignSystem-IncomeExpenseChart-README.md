# IncomeExpenseChart Component

A Swift Charts-based line chart for visualizing income and expenses over time with smooth animations and theme integration.

## 📊 Overview

The IncomeExpenseChart displays dual time-series data (income and expenses) using Swift Charts with smoothed lines, area fills, and automatic legends. Perfect for financial dashboards and expense tracking.

## ✨ Features

- **Dual Series** - Income (green) and Expenses (red) on same chart
- **Smoothed Lines** - Catmull-Rom interpolation for smooth curves
- **Area Fills** - 20% opacity fills below lines
- **Currency Y-Axis** - Automatic currency formatting with K notation
- **Day-of-Month X-Axis** - Shows day numbers (1-31)
- **Automatic Legend** - Built-in series identification
- **Theme-Driven** - Colors from `@Environment(\.theme)`
- **ChartCard Wrapper** - Card with title, subtitle, and metadata
- **Demo Data Generator** - Ready-to-use sample data

## 🚀 Quick Start

### Basic Usage

```swift
let income = [
    (Date(), 5200.0),
    (Date().addingTimeInterval(86400), 5400.0),
    (Date().addingTimeInterval(172800), 4800.0)
]

let expenses = [
    (Date(), 3200.0),
    (Date().addingTimeInterval(86400), 3450.0),
    (Date().addingTimeInterval(172800), 3100.0)
]

IncomeExpenseChart(
    income: income,
    expenses: expenses
)
```

### With ChartCard

```swift
ChartCard(
    title: "Income vs Expenses",
    subtitle: "Last 30 days",
    metadata: [
        ChartCard.MetadataItem(
            label: "Total Income",
            value: "$156,000",
            color: theme.colors.success
        ),
        ChartCard.MetadataItem(
            label: "Total Expenses",
            value: "$102,000",
            color: theme.colors.error
        ),
        ChartCard.MetadataItem(
            label: "Net",
            value: "+$54,000",
            color: theme.colors.success
        )
    ]
) {
    IncomeExpenseChart(
        income: income,
        expenses: expenses
    )
}
```

### Using Demo Data

```swift
// Generate 30 days of sample data
let data = ChartDemoData.currentMonthData()

IncomeExpenseChart(
    income: data.income,
    expenses: data.expenses
)

// Or custom days
let income = ChartDemoData.generateIncomeData(days: 14)
let expenses = ChartDemoData.generateExpenseData(days: 14)
```

## 📐 Components

### IncomeExpenseChart

The main chart component.

**Parameters**:
- `income: [(Date, Double)]` - Array of income data points
- `expenses: [(Date, Double)]` - Array of expense data points
- `showLegend: Bool` - Show/hide legend (default: `true`)

### ChartCard

A card wrapper for charts with metadata.

**Parameters**:
- `title: String` - Main card title
- `subtitle: String?` - Optional subtitle
- `metadata: [MetadataItem]` - Array of metadata items
- `content: () -> Content` - Chart content

**MetadataItem**:
```swift
ChartCard.MetadataItem(
    label: String,       // Label text
    value: String,       // Value text
    color: Color?        // Optional color (nil = textPrimary)
)
```

### ChartDemoData

Static demo data generator.

**Methods**:
- `generateIncomeData(days: Int) -> [(Date, Double)]`
- `generateExpenseData(days: Int) -> [(Date, Double)]`
- `currentMonthData() -> (income: [(Date, Double)], expenses: [(Date, Double)])`

## 💡 Usage Examples

### 1. Monthly Overview Dashboard

```swift
let data = ChartDemoData.currentMonthData()
let totalIncome = data.income.reduce(0) { $0 + $1.1 }
let totalExpenses = data.expenses.reduce(0) { $0 + $1.1 }
let net = totalIncome - totalExpenses

ChartCard(
    title: "Monthly Financial Overview",
    subtitle: "October 2025",
    metadata: [
        ChartCard.MetadataItem(
            label: "Income",
            value: formatCurrency(totalIncome),
            color: theme.colors.success
        ),
        ChartCard.MetadataItem(
            label: "Expenses",
            value: formatCurrency(totalExpenses),
            color: theme.colors.error
        ),
        ChartCard.MetadataItem(
            label: "Net Savings",
            value: formatCurrency(net),
            color: net >= 0 ? theme.colors.success : theme.colors.error
        )
    ]
) {
    IncomeExpenseChart(
        income: data.income,
        expenses: data.expenses
    )
}
```

### 2. Weekly Trend Comparison

```swift
HStack(spacing: theme.spacing.md) {
    ChartCard(title: "Last 7 Days") {
        let data = ChartDemoData.generateIncomeData(days: 7)
        IncomeExpenseChart(
            income: data,
            expenses: ChartDemoData.generateExpenseData(days: 7)
        )
    }
    
    ChartCard(title: "Last 14 Days") {
        let data = ChartDemoData.generateIncomeData(days: 14)
        IncomeExpenseChart(
            income: data,
            expenses: ChartDemoData.generateExpenseData(days: 14)
        )
    }
}
```

### 3. Real Data Integration

```swift
struct FinancialData {
    let transactions: [Transaction]
    
    func chartData() -> (income: [(Date, Double)], expenses: [(Date, Double)]) {
        let grouped = Dictionary(grouping: transactions) { 
            Calendar.current.startOfDay(for: $0.date)
        }
        
        let income = grouped.map { date, trans in
            let total = trans.filter { $0.type == .income }.reduce(0) { $0 + $1.amount }
            return (date, total)
        }.sorted { $0.0 < $1.0 }
        
        let expenses = grouped.map { date, trans in
            let total = trans.filter { $0.type == .expense }.reduce(0) { $0 + $1.amount }
            return (date, total)
        }.sorted { $0.0 < $1.0 }
        
        return (income, expenses)
    }
}

let data = financialData.chartData()
IncomeExpenseChart(income: data.income, expenses: data.expenses)
```

### 4. Animated Data Updates

```swift
@State private var data = ChartDemoData.currentMonthData()

var body: some View {
    VStack {
        IncomeExpenseChart(
            income: data.income,
            expenses: data.expenses
        )
        
        Button("Refresh Data") {
            withAnimation {
                data = ChartDemoData.currentMonthData()
            }
        }
    }
}
```

## 🎨 Design Specifications

### Chart Dimensions
- **Height**: 280pt (fixed)
- **Width**: Adaptive (fills available space)

### Line Styling
- **Stroke**: Theme color (success for income, error for expenses)
- **Interpolation**: Catmull-Rom (smooth curves)
- **Symbol**: 6pt circle at data points

### Area Fill
- **Opacity**: 20% (0.2)
- **Color**: Same as line color
- **Interpolation**: Matches line curve

### Axis Formatting

**Y-Axis (Currency)**:
- Format: `$X,XXX` or `$X.XK` (for thousands)
- Position: Leading (left side)
- Grid: 0.5pt subtle lines
- Labels: Small tertiary text

**X-Axis (Days)**:
- Format: Day of month (1-31)
- Position: Bottom
- Grid: 0.5pt subtle lines
- Labels: Small tertiary text

### Colors from Theme

**Income Series**:
- Line: `theme.colors.success`
- Fill: `theme.colors.success.opacity(0.2)`
- Symbol: `theme.colors.success`

**Expense Series**:
- Line: `theme.colors.error`
- Fill: `theme.colors.error.opacity(0.2)`
- Symbol: `theme.colors.error`

**Chart Elements**:
- Grid lines: `theme.colors.borderSubtle`
- Labels: `theme.colors.textSecondary`
- Background: Transparent (inherits from card)

## 📊 Demo Data

### Data Generation

The `ChartDemoData` generator creates realistic financial data:

**Income Generation**:
- Base: $5,200/day
- Variation: ±$500-800
- Weekend bonus: $0-200 (weekdays only)
- Always non-negative

**Expense Generation**:
- Base: $3,400/day
- Variation: ±$600-700
- Weekend spike: $100-400 (weekends)
- Always non-negative

### Custom Time Periods

```swift
// 7 days
let week = (
    income: ChartDemoData.generateIncomeData(days: 7),
    expenses: ChartDemoData.generateExpenseData(days: 7)
)

// 30 days (default)
let month = ChartDemoData.currentMonthData()

// 90 days
let quarter = (
    income: ChartDemoData.generateIncomeData(days: 90),
    expenses: ChartDemoData.generateExpenseData(days: 90)
)
```

## 🎯 Best Practices

### 1. Data Preparation

```swift
// Ensure dates are sorted
let sortedIncome = income.sorted { $0.0 < $1.0 }
let sortedExpenses = expenses.sorted { $0.0 < $1.0 }

// Filter out invalid data
let validIncome = income.filter { $0.1 >= 0 }
```

### 2. Time Range Selection

```swift
// Good - Reasonable time ranges
.generateIncomeData(days: 7)    // Week
.generateIncomeData(days: 30)   // Month
.generateIncomeData(days: 90)   // Quarter

// Avoid - Too many data points
.generateIncomeData(days: 365)  // Too dense for daily view
```

### 3. Metadata Calculation

```swift
let totalIncome = income.reduce(0) { $0 + $1.1 }
let totalExpenses = expenses.reduce(0) { $0 + $1.1 }
let net = totalIncome - totalExpenses
let avgIncome = totalIncome / Double(income.count)

// Use in metadata
ChartCard.MetadataItem(
    label: "Average",
    value: formatCurrency(avgIncome),
    color: theme.colors.textPrimary
)
```

### 4. Empty State Handling

```swift
if income.isEmpty || expenses.isEmpty {
    EmptyState(
        icon: "chart.line.uptrend.xyaxis",
        title: "No Data Available",
        description: "Start tracking your income and expenses",
        actionTitle: "Add Transaction",
        action: { /* ... */ }
    )
} else {
    IncomeExpenseChart(income: income, expenses: expenses)
}
```

## 🔍 Common Patterns

### 1. Dashboard Main Chart

```swift
VStack(spacing: theme.spacing.lg) {
    ChartCard(
        title: "Income vs Expenses",
        subtitle: "Monthly trend",
        metadata: calculateMetadata()
    ) {
        IncomeExpenseChart(income: income, expenses: expenses)
    }
    
    // Supporting metrics below
    HStack {
        MetricCard(title: "Avg Income", value: "$5,200")
        MetricCard(title: "Avg Expense", value: "$3,450")
        MetricCard(title: "Savings Rate", value: "34%")
    }
}
```

### 2. Comparison View

```swift
HStack(alignment: .top, spacing: theme.spacing.xl) {
    ChartCard(title: "This Month") {
        IncomeExpenseChart(
            income: currentMonthIncome,
            expenses: currentMonthExpenses
        )
    }
    
    ChartCard(title: "Last Month") {
        IncomeExpenseChart(
            income: lastMonthIncome,
            expenses: lastMonthExpenses
        )
    }
}
```

### 3. Detailed Analysis

```swift
VStack(alignment: .leading, spacing: theme.spacing.xl) {
    // Main chart
    ChartCard(title: "Annual Overview", subtitle: "2025") {
        IncomeExpenseChart(income: yearIncome, expenses: yearExpenses)
    }
    
    // Quarterly breakdown
    Text("Quarterly Breakdown")
        .font(theme.typography.titleLarge.font)
    
    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
        ForEach(quarters) { quarter in
            ChartCard(title: quarter.name) {
                IncomeExpenseChart(
                    income: quarter.income,
                    expenses: quarter.expenses
                )
            }
        }
    }
}
```

## 🧪 Testing with Previews

Run these previews in Xcode:

1. **IncomeExpenseChartPreview.swift**
   - `#Preview("Showcase - Vibrant")` - Full feature demo
   - `#Preview("Theme Comparison")` - Side-by-side themes
   - `#Preview("Interactive Demo")` - Adjustable time periods
   - `#Preview("Simple Chart Card")` - Basic example

2. **IncomeExpenseChart.swift**
   - `#Preview("IncomeExpenseChart - Vibrant")` - Basic chart
   - `#Preview("ChartCard - Vibrant")` - Card with metadata

## 📱 Platform Support

- **macOS 14+** (Sonoma or later)
- **Swift Charts** framework required
- **SwiftUI** native implementation

## 🎨 Theme Integration

### VibrantTheme
- Income: Vibrant Green (#34C759)
- Expenses: Bold Red (#FF453A)
- High contrast, energetic

### NeutralTheme
- Income: Muted Green (#47A66B)
- Expenses: Muted Red (#D9544F)
- Subtle, professional

### Custom Themes
Uses `theme.colors.success` and `theme.colors.error` automatically!

## 💡 Tips & Tricks

1. **Performance**: Limit to ~100 data points for smooth scrolling
2. **Data Density**: Use appropriate time ranges (7-90 days ideal)
3. **Responsiveness**: Chart adapts to container width
4. **Animation**: Data changes animate smoothly via Swift Charts
5. **Accessibility**: Built-in VoiceOver support from Swift Charts

## 🚫 What NOT to Do

❌ Don't use for non-time-series data
```swift
// BAD - Not time-based
IncomeExpenseChart(income: categoryData, ...)
```

✅ Use for time-series data
```swift
// GOOD - Time-based financial data
IncomeExpenseChart(income: dailyIncome, expenses: dailyExpenses)
```

❌ Don't hardcode colors
```swift
// BAD
.foregroundStyle(.green)
```

✅ Use theme colors
```swift
// GOOD
.foregroundStyle(theme.colors.success)
```

## 📚 Related Components

- **DonutGauge** - Circular progress indicator
- **Card** - Basic container component
- **MetricCard** - Quick stat display

---

**Component**: IncomeExpenseChart + ChartCard  
**Version**: 1.0.0  
**Platform**: macOS 14+ (SwiftUI + Swift Charts)  
**Theme**: Environment-driven, no hardcoded values  
**Demo Data**: Included with realistic variation
