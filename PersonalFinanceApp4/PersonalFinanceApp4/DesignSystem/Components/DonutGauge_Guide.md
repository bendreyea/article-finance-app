# DonutGauge Component Guide

## Overview

`DonutGauge` is a fully-themed, accessible circular progress indicator that displays financial values with a beautiful gradient ring. Perfect for showing net worth, savings goals, budget progress, or any financial metric.

## Features

✅ **Fully Themed** - Zero hardcoded values, reads all styling from `@Environment(\.theme)`  
✅ **Gradient Ring** - Smooth gradient from `primary` to `primaryVariant` with rounded caps  
✅ **Currency Formatting** - Automatic currency display with intelligent decimal handling  
✅ **Accessibility** - Full VoiceOver support with descriptive labels  
✅ **Size Variants** - Small, Medium, Large, or Custom sizes  
✅ **Optional Elements** - Subtitle and percentage display  
✅ **Smooth Animation** - 1-second ease-in-out animation on value changes  
✅ **Edge Case Handling** - Properly handles 0%, 100%, and over-max values  

## Basic Usage

```swift
DonutGauge(
    value: 156789.50,
    max: 200000,
    title: "Net Worth"
)
```

## Full API

```swift
DonutGauge(
    value: Double,              // Current value (e.g., 156789.50)
    max: Double,                // Maximum value (e.g., 200000)
    title: String,              // Main label (e.g., "Net Worth")
    subtitle: String? = nil,    // Optional secondary label
    size: GaugeSize = .medium,  // Size variant
    showPercentage: Bool = false // Show percentage below value
)
```

## Parameters

### value: Double
The current value to display. Will be formatted as currency.
- Example: `156789.50` → `"$156,790"`
- Auto-formats decimals (shows cents only for values < $1,000)

### max: Double
The maximum value representing 100% completion.
- Example: `200000` → Full circle at $200,000
- Values over max are capped at 100%

### title: String
The main label displayed below the value.
- Example: `"Net Worth"`, `"Savings Goal"`, `"Monthly Budget"`
- Multiline supported (max 2 lines)

### subtitle: String? (Optional)
An optional secondary label for additional context.
- Example: `"Total Assets"`, `"Q4 Target"`, `"Retirement Fund"`
- Single line only

### size: GaugeSize (Default: .medium)
The size variant for the gauge:
- `.small` - 120pt diameter, 8pt stroke
- `.medium` - 200pt diameter, 12pt stroke (default)
- `.large` - 280pt diameter, 16pt stroke
- `.custom(diameter: 300, strokeWidth: 20)` - Custom dimensions

### showPercentage: Bool (Default: false)
Whether to display the percentage value.
- `true` - Shows percentage between value and title
- `false` - Hides percentage display

## Size Variants

### Small (120pt)
```swift
DonutGauge(
    value: 75000,
    max: 100000,
    title: "Savings",
    size: .small
)
```
**Use cases**: Dashboards with multiple gauges, compact layouts, sidebar widgets

### Medium (200pt) - Default
```swift
DonutGauge(
    value: 156789.50,
    max: 200000,
    title: "Net Worth",
    subtitle: "Total Assets",
    size: .medium
)
```
**Use cases**: Main dashboard cards, primary metrics, featured indicators

### Large (280pt)
```swift
DonutGauge(
    value: 350000,
    max: 500000,
    title: "Net Worth",
    subtitle: "Investment Portfolio",
    size: .large,
    showPercentage: true
)
```
**Use cases**: Hero sections, detail views, full-screen displays

### Custom Size
```swift
DonutGauge(
    value: 100000,
    max: 150000,
    title: "Custom",
    size: .custom(diameter: 250, strokeWidth: 15)
)
```
**Use cases**: Special layouts requiring specific dimensions

## Common Use Cases

### 1. Net Worth Display
```swift
DonutGauge(
    value: 156789.50,
    max: 200000,
    title: "Net Worth",
    subtitle: "Total Assets",
    size: .large,
    showPercentage: true
)
```

### 2. Savings Goal Progress
```swift
DonutGauge(
    value: 8750,
    max: 10000,
    title: "Emergency Fund",
    subtitle: "Target: $10,000",
    size: .medium
)
```

### 3. Monthly Budget Usage
```swift
DonutGauge(
    value: 3250,
    max: 4000,
    title: "Budget Used",
    subtitle: "This Month",
    size: .medium,
    showPercentage: true
)
```

### 4. Investment Goal
```swift
DonutGauge(
    value: 450000,
    max: 500000,
    title: "Retirement Goal",
    subtitle: "401(k) + IRA",
    size: .large
)
```

### 5. Multiple Small Gauges
```swift
HStack(spacing: 16) {
    DonutGauge(
        value: 5000,
        max: 10000,
        title: "Q1",
        size: .small
    )
    
    DonutGauge(
        value: 7500,
        max: 10000,
        title: "Q2",
        size: .small
    )
    
    DonutGauge(
        value: 6200,
        max: 10000,
        title: "Q3",
        size: .small
    )
}
```

## In Card Components

```swift
Card(elevation: .medium) {
    VStack(alignment: .leading, spacing: 20) {
        // Header
        HStack {
            Text("Financial Overview")
                .font(theme.typography.headingMedium)
            
            Spacer()
            
            Image(systemName: "chart.pie.fill")
                .foregroundColor(theme.colors.primary)
        }
        
        // Gauge
        DonutGauge(
            value: 156789.50,
            max: 200000,
            title: "Net Worth",
            subtitle: "Total Assets",
            size: .large,
            showPercentage: true
        )
        .frame(maxWidth: .infinity, alignment: .center)
        
        // Footer stats
        Divider()
        
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Target")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
                Text("$200,000")
                    .font(theme.typography.labelLarge)
                    .foregroundColor(theme.colors.onSurface)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("Remaining")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
                Text("$43,210")
                    .font(theme.typography.labelLarge)
                    .foregroundColor(theme.colors.success)
            }
        }
    }
}
```

## Styling Details

### Gradient
The ring uses an `AngularGradient` with three color stops:
1. `theme.colors.primary` (start)
2. `theme.colors.primaryVariant` (middle)
3. `theme.colors.primary` (end)

This creates a smooth, continuous gradient around the circle.

### Colors
All colors come from the theme:
- **Progress ring**: Primary gradient
- **Background ring**: `surfaceVariant`
- **Value text**: `onBackground`
- **Title**: `onSurfaceSecondary`
- **Subtitle**: `onSurfaceTertiary`
- **Percentage**: `onSurfaceSecondary`

### Fonts
All fonts scale with size variant:
- **Value**: `displaySmall` (medium), `displayLarge` (large)
- **Title**: `labelMedium` (medium), `labelLarge` (large)
- **Subtitle**: `caption`
- **Percentage**: `bodyMedium`

### Animation
- **Duration**: 1.0 seconds
- **Curve**: `easeInOut`
- **Property**: Ring percentage (trim value)

## Accessibility

### VoiceOver Support
The component provides comprehensive accessibility:

```swift
.accessibilityElement(children: .ignore)
.accessibilityLabel(accessibilityLabel)
.accessibilityValue(formattedPercentage)
.accessibilityHint("Circular progress indicator")
```

### Accessibility Label
Combines all information:
- "Net Worth: $156,790 of $200,000, Total Assets, 78.4% complete"

### VoiceOver Reads
1. **Label**: Full description with value, max, subtitle
2. **Value**: Current percentage
3. **Hint**: "Circular progress indicator"

### Testing Accessibility
1. Enable VoiceOver: System Settings → Accessibility → VoiceOver
2. Navigate to the gauge
3. Verify all information is read clearly
4. Test with different values and configurations

## Edge Cases

### Zero Value (0%)
```swift
DonutGauge(value: 0, max: 100000, title: "Starting Out")
// Shows: $0, empty ring (background only)
```

### Full Value (100%)
```swift
DonutGauge(value: 100000, max: 100000, title: "Goal Reached!")
// Shows: $100,000, complete ring
```

### Over Max (>100%)
```swift
DonutGauge(value: 125000, max: 100000, title: "Exceeded Goal")
// Shows: $125,000, complete ring (capped at 100%)
```

### Very Small Value
```swift
DonutGauge(value: 50.75, max: 10000, title: "Just Started")
// Shows: $50.75 (with decimals), tiny progress
```

### Very Large Value
```swift
DonutGauge(value: 9876543.21, max: 10000000, title: "High Value")
// Shows: $9,876,543 (no decimals), 98.8% progress
```

## Theme Compatibility

### Vibrant Theme
- Deep dark background
- Bold purple → violet gradient
- High contrast text
- Dramatic appearance

### Neutral Theme
- Light background
- Refined slate blue gradient
- Subtle, professional
- Clean appearance

Both themes work perfectly without any code changes!

## Performance

- **Lightweight**: Struct-based, no heavy computations
- **Efficient**: SwiftUI automatically optimizes
- **Animated**: Smooth 60fps animation
- **Responsive**: Instant updates on value changes

## Best Practices

### ✅ DO
- Use for financial metrics and progress indicators
- Combine with Card for elevation and grouping
- Show percentage for clarity when needed
- Use appropriate size for context
- Provide meaningful titles and subtitles

### ❌ DON'T
- Don't use for non-numeric data
- Don't make the gauge too small (< 100pt diameter)
- Don't update value too frequently (causes constant animation)
- Don't hardcode colors or fonts

## Integration Examples

### Dashboard Grid
```swift
LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 24) {
    Card {
        DonutGauge(value: 156789, max: 200000, title: "Net Worth", size: .medium)
    }
    
    Card {
        DonutGauge(value: 8450, max: 10000, title: "Income", size: .medium)
    }
    
    Card {
        DonutGauge(value: 4230, max: 5000, title: "Expenses", size: .medium)
    }
    
    Card {
        DonutGauge(value: 75000, max: 100000, title: "Savings", size: .medium)
    }
}
```

### Asset Detail View
```swift
VStack(spacing: 32) {
    DonutGauge(
        value: assetValue,
        max: assetGoal,
        title: asset.name,
        subtitle: asset.category,
        size: .large,
        showPercentage: true
    )
    
    // Additional details below
}
```

### Goal Tracker
```swift
ScrollView {
    VStack(spacing: 24) {
        ForEach(goals) { goal in
            Card {
                HStack(spacing: 20) {
                    DonutGauge(
                        value: goal.current,
                        max: goal.target,
                        title: goal.name,
                        size: .small
                    )
                    
                    VStack(alignment: .leading) {
                        // Goal details
                    }
                }
            }
        }
    }
}
```

## Previews

The component includes 6 comprehensive previews:

1. **Sizes** - Small, Medium, Large comparison
2. **Progress Levels** - 15%, 50%, 95% examples
3. **With Percentage** - Percentage display enabled
4. **Side-by-Side Themes** - Vibrant vs Neutral
5. **In Card** - Real-world card usage
6. **Edge Cases** - 0%, 100%, over-max scenarios

View them in Xcode Canvas or run the app to see live examples!

---

**Component**: DonutGauge  
**File**: `DesignSystem/Components/DonutGauge.swift`  
**Dependencies**: AppTheme, ColorTokens, TypographyTokens  
**Platform**: macOS 14+  
**Framework**: SwiftUI
