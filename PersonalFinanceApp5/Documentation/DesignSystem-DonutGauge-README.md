# DonutGauge Component

A reusable circular gauge component for displaying financial metrics with style and accessibility.

## 📊 Overview

The DonutGauge component displays a value as a percentage of maximum using a beautiful circular ring with gradient colors. Perfect for showing net worth, budget progress, savings goals, and other financial metrics.

## ✨ Features

- **Stroked Ring Design** - Clean donut shape with rounded line caps
- **Gradient Effect** - Smooth gradient from `primary` to `primaryAlt` theme colors
- **Currency Formatting** - Automatic currency display with proper formatting
- **Percentage Display** - Shows completion percentage in center
- **Configurable Sizes** - Small (120pt), Medium (180pt), Large (240pt), or custom
- **Accessibility First** - Full VoiceOver support with descriptive labels
- **Theme-Driven** - Zero hardcoded colors, reads from `@Environment(\.theme)`
- **Smooth Animation** - Progress changes animate smoothly

## 🚀 Quick Start

### Basic Usage

```swift
DonutGauge(
    value: 45678.90,
    max: 100000,
    title: "Net Worth",
    subtitle: "Total Assets",
    size: .large
)
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `value` | `Double` | ✅ | Current value to display |
| `max` | `Double` | ✅ | Maximum value (100% mark) |
| `title` | `String` | ✅ | Main label below gauge |
| `subtitle` | `String?` | ❌ | Optional secondary label |
| `size` | `GaugeSize` | ❌ | Size preset (default: `.medium`) |

### Size Options

```swift
.small      // 120pt diameter
.medium     // 180pt diameter (default)
.large      // 240pt diameter
.custom(200)  // Custom diameter in points
```

## 💡 Usage Examples

### 1. Net Worth Display

```swift
DonutGauge(
    value: 156789.50,
    max: 250000,
    title: "Net Worth",
    subtitle: "Goal: $250K by Dec 2026",
    size: .large
)
```

### 2. Budget Tracker

```swift
Card(padding: .lg, shadow: .md) {
    DonutGauge(
        value: 3450.00,
        max: 5000,
        title: "Monthly Budget",
        subtitle: "Remaining",
        size: .medium
    )
}
```

### 3. Multiple Gauges Dashboard

```swift
HStack(spacing: theme.spacing.xl) {
    DonutGauge(
        value: 12500,
        max: 15000,
        title: "Emergency Fund",
        size: .small
    )
    
    DonutGauge(
        value: 45000,
        max: 50000,
        title: "Retirement",
        size: .small
    )
    
    DonutGauge(
        value: 8500,
        max: 10000,
        title: "Savings Goal",
        size: .small
    )
}
```

### 4. With Animation

```swift
@State private var value: Double = 0

var body: some View {
    DonutGauge(
        value: value,
        max: 100000,
        title: "Savings Goal",
        size: .large
    )
    .onAppear {
        withAnimation(.easeInOut(duration: 1.5)) {
            value = 45678.90
        }
    }
}
```

### 5. Inside Card Component

```swift
Card(padding: .xl, shadow: .lg, cornerRadius: .lg) {
    VStack(spacing: theme.spacing.lg) {
        DonutGauge(
            value: 156789.50,
            max: 250000,
            title: "Net Worth",
            subtitle: "Goal: $250K",
            size: .large
        )
        
        // Additional content below gauge
        HStack {
            statItem("Assets", "$189K")
            statItem("Liabilities", "$32K")
            statItem("Growth", "+12.5%")
        }
    }
}
```

## 🎨 Design Specifications

### Proportions (Relative to Diameter)

- **Stroke Width**: 12% of diameter
- **Value Font**: 15% of diameter (bold, rounded)
- **Percentage Font**: 9% of diameter (medium)
- **Title Font**: 8% of diameter (semibold)
- **Subtitle Font**: 6% of diameter (regular)

### Colors from Theme

- **Background Ring**: `theme.colors.backgroundSecondary`
- **Progress Gradient**: `theme.colors.primary` → `theme.colors.primaryAlt`
- **Value Text**: `theme.colors.textPrimary`
- **Percentage**: `theme.colors.textSecondary`
- **Title**: `theme.colors.textPrimary`
- **Subtitle**: `theme.colors.textSecondary`

### Animation

- **Duration**: 0.8 seconds
- **Curve**: easeInOut
- **Property**: Progress percentage (0 to 1)

## ♿ Accessibility

### VoiceOver Support

The DonutGauge provides comprehensive VoiceOver support:

**Accessibility Label**: 
- Combines title and subtitle
- Example: "Net Worth, Total Assets"

**Accessibility Value**:
- Formatted currency value
- Percentage of maximum
- Maximum value
- Example: "$45,678.90, 46 percent of $100,000"

**Accessibility Traits**:
- `.updatesFrequently` - Indicates value may change

### Example VoiceOver Output

```
"Net Worth, Total Assets. 
$45,678.90, 46 percent of $100,000"
```

## 🎯 Best Practices

### 1. Choose Appropriate Size

```swift
// Dashboard main metric
.large      // Use for primary KPIs

// Card content
.medium     // Use for secondary metrics

// Compact displays or grids
.small      // Use for tertiary metrics or lists
```

### 2. Provide Context with Subtitle

```swift
// Good - Clear context
DonutGauge(
    value: 45000,
    max: 50000,
    title: "Retirement",
    subtitle: "Annual contribution"
)

// Better - Even more context
DonutGauge(
    value: 45000,
    max: 50000,
    title: "401(k) Progress",
    subtitle: "Goal: $50K by Dec 31"
)
```

### 3. Use Meaningful Maximum Values

```swift
// Good - Round numbers
max: 100000  // $100K goal
max: 5000    // $5K budget

// Avoid - Arbitrary or changing values
max: userInputValue  // May confuse users if it changes
```

### 4. Combine with Supporting Information

```swift
VStack(spacing: theme.spacing.lg) {
    DonutGauge(
        value: 3450,
        max: 5000,
        title: "Budget Status",
        size: .large
    )
    
    // Add context
    HStack {
        Label("Spent: $1,550", systemImage: "arrow.down")
        Label("Remaining: $3,450", systemImage: "arrow.up")
    }
}
```

## 🔍 Common Patterns

### 1. Financial Dashboard

```swift
HStack(alignment: .top, spacing: theme.spacing.xl) {
    // Main gauge
    DonutGauge(
        value: netWorth,
        max: netWorthGoal,
        title: "Net Worth",
        subtitle: "Progress to Goal",
        size: .large
    )
    
    // Secondary metrics
    VStack(spacing: theme.spacing.md) {
        DonutGauge(
            value: emergency,
            max: emergencyGoal,
            title: "Emergency Fund",
            size: .medium
        )
        DonutGauge(
            value: retirement,
            max: retirementGoal,
            title: "Retirement",
            size: .medium
        )
    }
}
```

### 2. Budget Tracking

```swift
Card(padding: .lg, shadow: .md) {
    VStack(spacing: theme.spacing.md) {
        DonutGauge(
            value: budgetRemaining,
            max: budgetTotal,
            title: "Monthly Budget",
            subtitle: "\(daysRemaining) days left",
            size: .medium
        )
        
        ForEach(categories) { category in
            BudgetCategoryRow(category: category)
        }
    }
}
```

### 3. Goal Progress Tracker

```swift
VStack(alignment: .leading, spacing: theme.spacing.lg) {
    Text("Financial Goals")
        .font(theme.typography.titleLarge.font)
    
    LazyVGrid(columns: [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ], spacing: theme.spacing.lg) {
        ForEach(goals) { goal in
            DonutGauge(
                value: goal.current,
                max: goal.target,
                title: goal.name,
                subtitle: goal.deadline,
                size: .small
            )
        }
    }
}
```

## 🧪 Testing with Previews

Run these previews in Xcode to see DonutGauge in action:

1. **DonutGaugePreview.swift** - Comprehensive showcase
   - `#Preview("Showcase - Vibrant")` - Full feature demo
   - `#Preview("Showcase - Neutral")` - Neutral theme version
   - `#Preview("Theme Comparison")` - Side-by-side themes
   - `#Preview("Animated Demo")` - Interactive animation
   - `#Preview("Single Gauge")` - Simple example

2. **DonutGauge.swift** - Basic previews
   - `#Preview("DonutGauge - Vibrant Theme")` - Size comparison
   - `#Preview("DonutGauge - Neutral Theme")` - Neutral version

## 📱 Platform Support

- **macOS 14+** (Sonoma or later)
- **SwiftUI** native implementation
- **VoiceOver** fully supported
- **Dynamic Type** font scaling supported

## 🎨 Theme Integration

The DonutGauge automatically adapts to your theme:

### VibrantTheme
- Gradient: Electric Blue (#4078FF) → Light Blue (#6699FF)
- Bold, prominent visual style
- Higher contrast

### NeutralTheme
- Gradient: Slate Blue (#64779E) → Light Slate (#8094B8)
- Subtle, professional appearance
- Softer contrast

### Custom Themes
Simply implement `AppTheme` protocol and DonutGauge will use your colors!

## 💡 Tips & Tricks

1. **Responsive Sizing**: Use `.custom()` for responsive layouts
2. **Empty State**: Handle zero values gracefully (shows 0%)
3. **Over 100%**: Values > max are capped at 100%
4. **Currency Format**: Automatically uses $X,XXX.XX format
5. **Animation**: Changes to `value` animate automatically

## 🚫 What NOT to Do

❌ Don't hardcode colors
```swift
// BAD
.foregroundColor(.blue)
```

✅ Always use theme
```swift
// GOOD
.foregroundColor(theme.colors.primary)
```

❌ Don't use for non-percentage data
```swift
// BAD - Not a progress metric
DonutGauge(value: stockPrice, max: ???)
```

✅ Use for progress toward goals
```swift
// GOOD - Clear goal/progress relationship
DonutGauge(value: saved, max: goalAmount)
```

## 📚 Related Components

- **Card** - Container for DonutGauge
- **MetricCard** - Quick metric display
- **StatusBadge** - Show status indicators

---

**Component**: DonutGauge  
**Version**: 1.0.0  
**Platform**: macOS 14+ (SwiftUI)  
**Accessibility**: Full VoiceOver support  
**Theme**: Environment-driven, no hardcoded values
