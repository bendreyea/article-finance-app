# IncomeExpenseChart Component Guide

## Overview

`IncomeExpenseChart` is a fully-themed Swift Charts component that visualizes income vs expenses over time. It features smoothed lines, area fills, automatic legend, and intelligent axis formatting—perfect for financial dashboards.

## Features

✅ **Swift Charts Integration** - Native macOS charting with smooth performance  
✅ **Dual Series** - Income (green) and Expenses (red) with distinct styling  
✅ **Smoothed Lines** - Catmull-Rom interpolation for elegant curves  
✅ **Area Fills** - 20% opacity fills from theme colors  
✅ **Automatic Legend** - Interactive legend with icons  
✅ **Currency Y-Axis** - Formatted as "$5K", "$10K", etc.  
✅ **Day-of-Month X-Axis** - Shows day numbers (1-31)  
✅ **Fully Themed** - Zero hardcoded colors, all from theme  
✅ **Demo Data** - Realistic generators for previews and testing  
✅ **ChartCard Wrapper** - Integrated with card styling  

## Basic Usage

```swift
let incomeData: [(Date, Double)] = [
    (date1, 5000),
    (date2, 5500),
    (date3, 300),
    // ...
]

let expenseData: [(Date, Double)] = [
    (date1, 3000),
    (date2, 3200),
    (date3, 150),
    // ...
]

IncomeExpenseChart(
    incomeData: incomeData,
    expenseData: expenseData
)
```

## Full API

```swift
IncomeExpenseChart(
    incomeData: [(Date, Double)],     // Income data points
    expenseData: [(Date, Double)],    // Expense data points
    title: String? = "Income vs Expenses",
    subtitle: String? = nil,
    height: CGFloat = 250
)
```

## Parameters

### incomeData: [(Date, Double)]
Array of tuples containing date and income amount.
- **Date**: Any valid Date object
- **Double**: Income amount in dollars (e.g., 5000.00)
- **Example**: `[(Date(), 5000), (yesterday, 4500)]`

### expenseData: [(Date, Double)]
Array of tuples containing date and expense amount.
- **Date**: Any valid Date object
- **Double**: Expense amount in dollars (e.g., 3000.00)
- **Example**: `[(Date(), 3000), (yesterday, 2800)]`

### title: String? (Optional)
Chart title displayed in the header.
- **Default**: `"Income vs Expenses"`
- **Example**: `"Monthly Cash Flow"`, `"Q4 Performance"`

### subtitle: String? (Optional)
Subtitle text for additional context.
- **Default**: `nil` (no subtitle)
- **Example**: `"Last 30 Days"`, `"October 2025"`

### height: CGFloat (Default: 250)
The height of the chart area in points.
- **Compact**: 180-200pt
- **Standard**: 250pt (default)
- **Tall**: 300-350pt

## Chart Features

### Smoothed Lines
Uses `.interpolationMethod(.catmullRom)` for smooth, natural-looking curves instead of straight segments.

### Area Fills
Each series has a filled area under the line at 20% opacity:
- **Income**: `theme.colors.success.opacity(0.2)` (light green)
- **Expenses**: `theme.colors.error.opacity(0.2)` (light red)

### Point Marks
Each data point is marked with a small circle (40pt symbol size) for clarity.

### Legend
Automatic legend at the top with:
- Icons (↑ for income, ↓ for expenses)
- Series names
- Color indicators
- Interactive (tap to toggle visibility)

### Axis Formatting

#### Y-Axis (Currency)
- Formats values as currency with K suffix
- Examples: `$5K`, `$10K`, `$15K`
- Positioned on the leading (left) edge
- Grid lines with subtle borders

#### X-Axis (Day of Month)
- Shows day numbers: `1`, `5`, `10`, `15`, etc.
- Automatic tick placement
- Grid lines for reference

## Demo Data Generators

### generateDemoData()
Creates random demo data for testing:

```swift
let (income, expenses) = IncomeExpenseChart.generateDemoData(days: 30)

IncomeExpenseChart(
    incomeData: income,
    expenseData: expenses
)
```

**Features**:
- Random daily variations
- Income spikes on 1st and 15th (paydays)
- Realistic expense patterns

### generateMonthlyDemoData()
Creates realistic monthly financial data:

```swift
let demoData = IncomeExpenseChart.generateMonthlyDemoData()

IncomeExpenseChart(
    incomeData: demoData.income,
    expenseData: demoData.expenses
)
```

**Features**:
- Paycheck deposits on 1st and 15th
- Rent payment on 1st
- Bill payments on 5th and 20th
- Weekend spending spikes
- Side income on weekends
- Realistic daily expenses

## Common Use Cases

### 1. Dashboard Overview
```swift
let demoData = IncomeExpenseChart.generateMonthlyDemoData()

IncomeExpenseChart(
    incomeData: demoData.income,
    expenseData: demoData.expenses,
    title: "Income vs Expenses",
    subtitle: "Last 30 Days"
)
```

### 2. With Real Data
```swift
// Fetch from your data model
let incomeTransactions = transactions.filter { $0.type == .income }
let expenseTransactions = transactions.filter { $0.type == .expense }

let incomeData = incomeTransactions.map { ($0.date, $0.amount) }
let expenseData = expenseTransactions.map { ($0.date, $0.amount) }

IncomeExpenseChart(
    incomeData: incomeData,
    expenseData: expenseData,
    title: "Monthly Overview",
    subtitle: DateFormatter.monthYear.string(from: Date())
)
```

### 3. Compact Dashboard Card
```swift
IncomeExpenseChart(
    incomeData: incomeData,
    expenseData: expenseData,
    title: "Cash Flow",
    height: 180
)
```

### 4. Tall Detail View
```swift
IncomeExpenseChart(
    incomeData: incomeData,
    expenseData: expenseData,
    title: "Detailed Cash Flow Analysis",
    subtitle: "Daily breakdown with trends",
    height: 350
)
```

### 5. Without Title
```swift
IncomeExpenseChart(
    incomeData: incomeData,
    expenseData: expenseData,
    title: nil,  // No title
    subtitle: nil
)
```

## ChartCard Component

The chart uses `ChartCard` which extends `Card` with chart-specific features:

### ChartCard Features
- **Optional Header**: Title and subtitle
- **Legend Note**: Helpful hint for interacting with legend
- **Chart Padding**: Optimized spacing for charts
- **Consistent Styling**: Inherits Card elevation and theming

### ChartCard Usage
```swift
ChartCard(
    title: "Custom Chart",
    subtitle: "Additional context",
    showLegend: true
) {
    // Your custom chart content
}
```

## Integration with Dashboard

### Full Dashboard Example
```swift
VStack(spacing: 24) {
    // Header
    HStack {
        Text("Financial Dashboard")
            .font(theme.typography.displaySmall)
        Spacer()
    }
    
    // Chart
    let demoData = IncomeExpenseChart.generateMonthlyDemoData()
    
    IncomeExpenseChart(
        incomeData: demoData.income,
        expenseData: demoData.expenses,
        title: "Income vs Expenses",
        subtitle: "Last 30 Days"
    )
    
    // Summary Cards
    HStack(spacing: 16) {
        StatCard(title: "Total Income", value: "$8,450")
        StatCard(title: "Total Expenses", value: "$4,230")
        StatCard(title: "Net Savings", value: "$4,220")
    }
}
```

### With Other Components
```swift
VStack(spacing: 24) {
    // Net worth gauge
    DonutGauge(
        value: 156789.50,
        max: 200000,
        title: "Net Worth",
        size: .large
    )
    
    // Cash flow chart
    IncomeExpenseChart(
        incomeData: incomeData,
        expenseData: expenseData
    )
    
    // Transaction list
    // ...
}
```

## Theme Integration

### Colors Used
All colors come from the theme:
- **Income Series**: `theme.colors.success` (green)
- **Expense Series**: `theme.colors.error` (red)
- **Area Fills**: 20% opacity of series colors
- **Background**: `theme.colors.surface`
- **Grid Lines**: `theme.colors.borderSubtle`
- **Axis Labels**: `theme.colors.onSurfaceSecondary`
- **Legend Text**: `theme.colors.onSurface`

### Fonts Used
- **Title**: `theme.typography.headingMedium`
- **Subtitle**: `theme.typography.bodyMedium`
- **Legend**: `theme.typography.labelMedium`
- **Axis Labels**: `theme.typography.caption`
- **Legend Hint**: `theme.typography.caption`

### Works with Both Themes
- **Vibrant Theme**: Dark background, vivid colors, high contrast
- **Neutral Theme**: Light background, subtle colors, professional

## Data Preparation

### From SwiftData Models
```swift
@Query private var transactions: [Transaction]

var incomeData: [(Date, Double)] {
    transactions
        .filter { $0.category == .income }
        .map { ($0.date, $0.amount) }
}

var expenseData: [(Date, Double)] {
    transactions
        .filter { $0.category == .expense }
        .map { ($0.date, $0.amount) }
}
```

### Filtering by Date Range
```swift
let startDate = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
let endDate = Date()

let filteredIncome = incomeData.filter { date, _ in
    date >= startDate && date <= endDate
}

let filteredExpenses = expenseData.filter { date, _ in
    date >= startDate && date <= endDate
}
```

### Grouping by Day
```swift
func groupByDay(_ data: [(Date, Double)]) -> [(Date, Double)] {
    let calendar = Calendar.current
    let grouped = Dictionary(grouping: data) { date, _ in
        calendar.startOfDay(for: date)
    }
    
    return grouped.map { date, transactions in
        let total = transactions.reduce(0) { $0 + $1.1 }
        return (date, total)
    }.sorted { $0.0 < $1.0 }
}

let dailyIncome = groupByDay(rawIncomeData)
let dailyExpenses = groupByDay(rawExpenseData)
```

## Best Practices

### ✅ DO
- Use demo data for previews and development
- Group data by day for daily charts
- Provide meaningful titles and subtitles
- Use appropriate height for context
- Sort data by date before passing to chart
- Handle empty data gracefully

### ❌ DON'T
- Don't pass unsorted data
- Don't use extremely tall heights (> 400pt)
- Don't update data too frequently (causes re-rendering)
- Don't hardcode colors or formatting
- Don't show too many data points (> 90 days becomes cluttered)

## Performance Considerations

### Optimal Data Points
- **Ideal**: 7-30 data points per series
- **Maximum**: 90 data points (3 months daily)
- **Too Many**: > 100 points becomes cluttered

### Data Aggregation
For longer periods, aggregate data:
```swift
// Instead of daily for 6 months (180 points)
// Use weekly aggregation (24 points)
let weeklyIncome = aggregateByWeek(incomeData)
let weeklyExpenses = aggregateByWeek(expenseData)
```

## Accessibility

### Chart Accessibility
Swift Charts automatically provides:
- VoiceOver descriptions
- Audio graphs (macOS)
- Data table representation

### Custom Accessibility
```swift
IncomeExpenseChart(...)
    .accessibilityLabel("Income versus expense chart showing 30 days of financial data")
    .accessibilityHint("Shows income trend in green and expense trend in red")
```

## Customization

### Custom Height
```swift
IncomeExpenseChart(..., height: 300)
```

### Custom Title
```swift
IncomeExpenseChart(
    ...,
    title: "Q4 Cash Flow",
    subtitle: "October - December 2025"
)
```

### No Header
```swift
IncomeExpenseChart(
    ...,
    title: nil,
    subtitle: nil
)
```

## Troubleshooting

### Chart Not Showing
- Verify data is not empty
- Check date ranges are valid
- Ensure amounts are > 0

### Lines Look Jagged
- Data is already smoothed with `.catmullRom`
- Add more data points between existing ones
- Check for extreme value jumps

### Overlapping Labels
- Reduce data points
- Increase chart height
- Use data aggregation

### Colors Don't Match Theme
- Verify theme is injected via `ThemeProvider`
- Check `@Environment(\.theme)` is present
- Ensure no hardcoded colors in custom code

## Examples in Context

### Income & Expenses View
```swift
struct IncomeExpensesView: View {
    @Environment(\.theme) private var theme
    @Query private var transactions: [Transaction]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Chart
                IncomeExpenseChart(
                    incomeData: incomeTransactions,
                    expenseData: expenseTransactions,
                    title: "Income vs Expenses",
                    subtitle: "Last 30 Days"
                )
                
                // Category breakdown
                // Transaction list
                // etc.
            }
            .padding()
        }
    }
}
```

### Detail Modal
```swift
.sheet(isPresented: $showingDetail) {
    VStack(spacing: 20) {
        Text("Detailed Analysis")
            .font(theme.typography.displaySmall)
        
        IncomeExpenseChart(
            incomeData: detailedIncomeData,
            expenseData: detailedExpenseData,
            height: 350
        )
        
        // Additional details
    }
    .padding()
}
```

---

**Component**: IncomeExpenseChart + ChartCard  
**Files**: 
- `DesignSystem/Components/IncomeExpenseChart.swift`
- `DesignSystem/Components/ChartCard.swift`  
**Dependencies**: Swift Charts, AppTheme  
**Platform**: macOS 14+  
**Framework**: SwiftUI + Charts
