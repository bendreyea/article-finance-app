# 🚀 Quick Reference Card

## Keyboard Shortcuts
```
Cmd+R           Build and run
Cmd+Shift+1     Switch to Vibrant Theme
Cmd+Shift+2     Switch to Neutral Theme
Cmd+Option+P    Show Canvas/Previews
```

## Theme Usage Pattern
```swift
// 1. Import and inject theme in environment
@Environment(\.theme) private var theme

// 2. Use theme tokens exclusively
.foregroundColor(theme.colors.textPrimary)
.padding(theme.spacing.lg)
.font(theme.typography.bodyMedium)
.cornerRadius(theme.radius.md)
.shadow(color: theme.shadow.md.color, radius: theme.shadow.md.radius)
```

## Component Quick Start

### DonutGauge
```swift
DonutGauge(
    value: 45280,
    max: 100000,
    title: "Net Worth",
    subtitle: "45% of goal",
    size: .large
)
```

### IncomeExpenseChart
```swift
let data = ChartDemoData.generateMonthlyData()
IncomeExpenseChart(
    income: data.income,
    expenses: data.expenses
)
```

### Card
```swift
Card(style: .elevated, padding: .large) {
    VStack {
        Text("Title")
        Text("Content")
    }
}
```

### TransactionsTableView
```swift
TransactionsTableView(
    transactions: TransactionRow.generateDemoData()
) { transaction in
    // Handle edit
}
```

### AssetsPieCard
```swift
AssetsPieCard(
    assets: AssetItem.generateDemoData(),
    showLegend: true
)
```

### GoalsListView
```swift
GoalsListView(
    goals: GoalItem.generateDemoData()
) { updatedGoal in
    // Handle update
}
```

## Token Quick Reference

### Colors
```swift
theme.colors.background          // Page background
theme.colors.surface             // Card background
theme.colors.textPrimary         // Main text
theme.colors.textSecondary       // Secondary text
theme.colors.textTertiary        // Tertiary text
theme.colors.accentPrimary       // Primary brand color
theme.colors.accentSecondary     // Secondary accent
theme.colors.success             // Green (positive)
theme.colors.warning             // Yellow/orange
theme.colors.error               // Red (negative)
theme.colors.info                // Blue (informational)
theme.colors.border              // Borders, dividers
theme.colors.chartPrimary        // [Color] array for charts
```

### Spacing
```swift
theme.spacing.xxs    // 2pt
theme.spacing.xs     // 4pt
theme.spacing.sm     // 8pt
theme.spacing.md     // 12pt
theme.spacing.lg     // 16pt
theme.spacing.xl     // 24pt
theme.spacing.xxl    // 32pt
theme.spacing.xxxl   // 48pt
```

### Typography
```swift
theme.typography.displayLarge     // 48pt bold
theme.typography.displayMedium    // 36pt bold
theme.typography.displaySmall     // 28pt semibold
theme.typography.headingLarge     // 24pt semibold
theme.typography.headingMedium    // 20pt semibold
theme.typography.headingSmall     // 16pt semibold
theme.typography.bodyLarge        // 16pt regular
theme.typography.bodyMedium       // 14pt regular
theme.typography.bodySmall        // 12pt regular
theme.typography.labelLarge       // 14pt medium
theme.typography.labelMedium      // 12pt medium
theme.typography.labelSmall       // 10pt medium
theme.typography.monoMedium       // 14pt monospace
```

### Radius
```swift
theme.radius.none    // 0pt
theme.radius.sm      // 4-6pt
theme.radius.md      // 8-10pt
theme.radius.lg      // 12-14pt
theme.radius.xl      // 16-18pt
theme.radius.full    // 9999pt (pill)
```

### Shadows
```swift
theme.shadow.none    // No shadow
theme.shadow.sm      // Subtle elevation
theme.shadow.md      // Medium elevation
theme.shadow.lg      // Large elevation
theme.shadow.xl      // Extra large elevation
```

## File Locations

```
DesignSystem/
├── Tokens/
│   ├── AppTheme.swift
│   ├── ColorTokens.swift
│   ├── SpacingTokens.swift
│   ├── RadiusTokens.swift
│   ├── TypographyTokens.swift
│   └── ShadowTokens.swift
├── Themes/
│   ├── VibrantTheme.swift
│   └── NeutralTheme.swift
├── Components/
│   ├── Card.swift
│   ├── DonutGauge.swift
│   ├── IncomeExpenseChart.swift
│   ├── TransactionsTableView.swift
│   └── AssetsPieAndGoals.swift
├── ThemeProvider.swift
└── AppShell.swift
```

## Navigation Routes

```swift
AppRoute.dashboard          // Main overview
AppRoute.incomeExpenses     // Transaction management
AppRoute.assetsGoals        // Assets and goals
```

## Data Models

```swift
// Transactions
TransactionRow(subCategory, category, amount, billDueDate, status, description)

// Assets
AssetItem(name, category, amount)

// Goals
GoalItem(name, targetAmount, currentAmount, deadline, category)

// Chart data
ChartDataPoint(date, amount)
```

## Best Practices

✅ **DO**
- Use `@Environment(\.theme)` in all views
- Use theme tokens exclusively
- Test with both themes
- Add SwiftUI previews
- Include accessibility labels

❌ **DON'T**
- Hardcode colors: `.foregroundColor(.blue)`
- Hardcode spacing: `.padding(16)`
- Hardcode fonts: `.font(.system(size: 14))`
- Skip previews
- Forget accessibility

## Preview Template

```swift
#Preview("Component - Vibrant") {
    MyComponent()
        .themed(VibrantTheme())
        .frame(width: 600, height: 400)
        .padding()
}

#Preview("Component - Neutral") {
    MyComponent()
        .themed(NeutralTheme())
        .frame(width: 600, height: 400)
        .padding()
}

#Preview("Side-by-Side") {
    HStack(spacing: 40) {
        MyComponent().themed(VibrantTheme())
        MyComponent().themed(NeutralTheme())
    }
    .padding(40)
    .frame(width: 1400, height: 500)
}
```

## Common Patterns

### View with Theme
```swift
struct MyView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.lg) {
            // Content
        }
        .padding(theme.spacing.xl)
        .background(theme.colors.background)
    }
}
```

### Themed Button
```swift
Button(action: {}) {
    Label("Action", systemImage: "plus")
        .font(theme.typography.labelMedium)
}
.buttonStyle(.plain)
.foregroundColor(theme.colors.accentPrimary)
```

### Themed TextField
```swift
HStack {
    Image(systemName: "magnifyingglass")
        .foregroundColor(theme.colors.textTertiary)
    
    TextField("Search", text: $text)
        .textFieldStyle(.plain)
        .font(theme.typography.bodyMedium)
}
.padding(theme.spacing.md)
.background(theme.colors.backgroundSecondary)
.cornerRadius(theme.radius.md)
```

---

**Print this for quick reference while coding!** 📋
