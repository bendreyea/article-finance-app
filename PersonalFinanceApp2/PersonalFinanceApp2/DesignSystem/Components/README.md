# Assets & Goals Components

This document describes the AssetsPieCard and GoalsListView components created for the Personal Finance App.

## 📊 AssetsPieCard

### Features
- **Swift Charts SectorMark**: Pie chart with donut-style display (60% inner radius)
- **Center Total**: Shows total asset value in the center of the donut
- **External Legend**: Category breakdown with values and percentages
- **Theme Integration**: Uses chart palette from theme colors
- **Accessibility**: Full VoiceOver support with detailed breakdown

### Usage
```swift
AssetsPieCard(
    assets: [
        AssetItem(name: "Savings", value: 25000, category: "Cash"),
        AssetItem(name: "S&P 500", value: 45000, category: "Investments"),
        // ... more assets
    ],
    title: "Assets Breakdown",
    subtitle: "Total portfolio value"
)
```

### Chart Palette
The component uses a 8-color palette from theme:
1. brandPrimary
2. brandSecondary
3. success
4. info
5. warning
6. brandTertiary
7. Purple accent
8. Teal accent

### Components Included
- `AssetItem`: Data model (name, value, category)
- `AssetsPieCard`: Main card with pie chart
- `AssetLegendItem`: Individual legend row
- `AssetDemoData`: Realistic demo data generator

---

## 🎯 GoalsListView

### Features
- **Progress Bars**: Color-coded based on completion (0-50%: blue, 50-75%: orange, 75-100%: cyan, 100%: green)
- **Inline Edit**: Click pencil icon to edit current amount
- **Smart Formatting**: Currency formatting with K/M notation
- **Days Remaining**: Shows countdown to deadline
- **Empty State**: Friendly message when no goals exist
- **Accessibility**: Full VoiceOver support

### Usage
```swift
@State var goals = GoalDemoData.generateGoals()

GoalsListView(
    goals: $goals,
    title: "Financial Goals",
    subtitle: "Track your progress"
)
```

### Inline Editing
1. Click the pencil icon on any goal
2. Edit the current amount in the text field
3. Click "Save" to update or "Cancel" to discard
4. Amount is validated (0 to target max)

### Components Included
- `GoalItem`: Data model (name, current/target amounts, deadline, category)
- `GoalsListView`: Main list view with edit capability
- `GoalProgressItem`: Individual goal row with progress bar
- `ProgressBar`: Reusable progress bar with color gradient
- `CompactButtonStyle`: Small buttons for edit actions
- `EmptyGoalsView`: Empty state display
- `GoalDemoData`: Realistic demo data generator

---

## 🎨 Theming

Both components are fully themed:
- ✅ Zero hardcoded colors
- ✅ Use `@Environment(\.theme)` for all styling
- ✅ Spacing from theme.spacing tokens
- ✅ Typography from theme.typography tokens
- ✅ Colors from theme.colors tokens
- ✅ Radius from theme.radius tokens

---

## 📱 Preview Coverage

### AssetsPieCard Previews
1. Vibrant Theme - Full portfolio + Liquid assets
2. Neutral Theme - Full portfolio

### GoalsListView Previews
1. Vibrant Theme - All goals with edit capability
2. Neutral Theme - All goals
3. Progress Bar Variations - 25%, 50%, 75%, 100%
4. Empty State - No goals message

---

## 🔧 Technical Details

### AssetsPieCard
- **Chart Type**: SectorMark with inner/outer radius
- **Grouping**: Automatic category aggregation
- **Sorting**: By value (highest to lowest)
- **Angular Inset**: 1.5pt spacing between sectors
- **Corner Radius**: 4pt rounded sectors

### GoalsListView
- **State Management**: Binding to goal array for real-time updates
- **Edit State**: UUID-based editing with temporary state
- **Progress Calculation**: Auto-computed from current/target
- **Date Formatting**: Medium style dates
- **Validation**: Clamps edit values between 0 and target

---

## 📦 Files Created

```
PersonalFinanceApp2/DesignSystem/Components/
├── AssetsPieCard.swift       # Pie chart with legend
└── GoalsListView.swift       # Goals list with progress bars
```

Both components are production-ready and follow the app's design system architecture!
