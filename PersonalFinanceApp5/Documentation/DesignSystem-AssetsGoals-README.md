# Assets & Goals Components

Comprehensive financial visualization and goal tracking components for SwiftUI using Swift Charts.

## Components

### 1. AssetsPieCard

A sophisticated pie chart card displaying asset allocation with interactive selection and external legend.

#### Features

- **Swift Charts Integration**: Uses `SectorMark` for professional pie chart rendering
- **Interactive Selection**: Click segments to view detailed breakdown
- **Center Display**: Shows total value or selected asset details
- **External Legend**: Clickable legend with color indicators, values, and percentages
- **Theme Colors**: Uses `theme.colors.chartPalette` for consistent coloring
- **Smart Formatting**: K/M notation for large values
- **Donut Style**: Inner radius for modern appearance

#### Usage

```swift
@State private var assets = AssetDemoData.generateAssets()

AssetsPieCard(
    assets: assets,
    title: "Asset Allocation",
    showLegend: true
)
```

#### Data Model

```swift
struct AssetData: Identifiable {
    let id: UUID
    let name: String
    let value: Double
    let category: String
    let description: String?
}
```

#### Customization

```swift
// Without legend (compact view)
AssetsPieCard(
    assets: myAssets,
    title: "Liquid Assets",
    showLegend: false
)

// Custom assets
let assets = [
    AssetData(name: "401(k)", value: 125000, category: "Retirement"),
    AssetData(name: "Savings", value: 25000, category: "Cash"),
    AssetData(name: "Real Estate", value: 350000, category: "Property")
]
```

### 2. GoalsListView

A comprehensive goal tracking interface with inline editing, progress visualization, and sorting.

#### Features

- **Inline Editing**: Edit goal name and current amount directly in the list
- **Progress Bars**: Color-coded progress visualization (0-25% red, 25-50% orange, 50-75% blue, 75-100% green, 100% success)
- **Priority Badges**: High/Medium/Low priority with color coding
- **Smart Sorting**: Sort by priority, progress, date, or amount
- **Category Icons**: Visual category identification
- **Date Intelligence**: Relative date display ("In 5 days", "Today", etc.)
- **Completion States**: Visual indicators for completed goals
- **Empty State**: Helpful message when no goals exist
- **Summary Stats**: Header shows total and completed count

#### Usage

```swift
@State private var goals = GoalDemoData.generateGoals()

GoalsListView(
    goals: $goals,
    onGoalUpdate: { goal in
        print("Updated: \(goal.name)")
        saveToDatabase(goal)
    },
    onGoalDelete: { goal in
        print("Deleted: \(goal.name)")
        deleteFromDatabase(goal)
    }
)
```

#### Data Model

```swift
struct GoalItem: Identifiable {
    let id: UUID
    var name: String
    var targetAmount: Double
    var currentAmount: Double
    var targetDate: Date
    var category: String
    var priority: GoalPriority
    var notes: String?
    
    var progress: Double // Computed property
    var isCompleted: Bool // Computed property
    var remainingAmount: Double // Computed property
}

enum GoalPriority: String {
    case high, medium, low
}
```

#### Inline Editing

1. Click the pencil icon next to any goal
2. Edit the name and/or current amount
3. Click checkmark to save or X to cancel
4. Changes trigger `onGoalUpdate` callback

#### Sorting Options

- **Priority**: High → Medium → Low, then by progress
- **Progress**: Lowest to highest completion
- **Date**: Nearest to farthest target date
- **Amount**: Largest to smallest target

### 3. ProgressBar

A reusable progress bar component with color-coded states.

#### Features

- **Dynamic Coloring**: Automatically colors based on progress percentage
- **Smooth Animation**: Animated progress changes
- **Optional Percentage**: Show/hide percentage label
- **Customizable Height**: Adjust bar thickness
- **Gradient Fill**: Subtle gradient for visual depth

#### Usage

```swift
// Basic usage
ProgressBar(progress: 0.75)

// With customization
ProgressBar(
    progress: goal.progress,
    height: 10,
    showPercentage: true
)

// Standalone showcase
ForEach([0.0, 0.25, 0.5, 0.75, 1.0], id: \.self) { progress in
    ProgressBar(progress: progress, height: 8, showPercentage: true)
}
```

#### Color Logic

| Progress Range | Color |
|----------------|-------|
| 0% - 25% | Error (Red) |
| 25% - 50% | Warning (Orange) |
| 50% - 75% | Info (Blue) |
| 75% - 100% | Primary |
| 100%+ | Success (Green) |

## Demo Data Generators

### AssetDemoData

```swift
// Predefined realistic assets
let assets = AssetDemoData.generateAssets()
// Returns: 401(k), Roth IRA, Brokerage, Savings, Checking, Real Estate, Crypto

// Random assets
let randomAssets = AssetDemoData.generateRandomAssets(count: 5)
```

### GoalDemoData

```swift
// Predefined realistic goals
let goals = GoalDemoData.generateGoals()
// Returns: Emergency Fund, Vacation, Down Payment, New Car, Education, Retirement
```

## Integration Examples

### Dashboard Layout

```swift
VStack(spacing: 24) {
    // Assets section
    AssetsPieCard(assets: assets)
        .frame(height: 400)
    
    // Goals section
    GoalsListView(
        goals: $goals,
        onGoalUpdate: saveGoal,
        onGoalDelete: deleteGoal
    )
}
```

### Two-Column Layout

```swift
HStack(alignment: .top, spacing: 24) {
    // Left: Assets
    AssetsPieCard(assets: assets)
        .frame(maxWidth: .infinity)
    
    // Right: Goals
    GoalsListView(goals: $goals)
        .frame(maxWidth: .infinity)
}
```

### Sidebar Navigation

```swift
NavigationSplitView {
    List {
        NavigationLink("Dashboard") { DashboardView() }
        NavigationLink("Assets & Goals") { AssetsGoalsView() }
    }
} detail: {
    ScrollView {
        VStack(spacing: 24) {
            AssetsPieCard(assets: assets)
            GoalsListView(goals: $goals)
        }
        .padding()
    }
}
```

## Chart Palette

The components use `theme.colors.chartPalette` for consistent coloring:

```swift
// Example palette (5+ colors recommended)
let chartPalette = [
    Color(hex: "#4078FF"), // Blue
    Color(hex: "#10B981"), // Green
    Color(hex: "#F59E0B"), // Orange
    Color(hex: "#8B5CF6"), // Purple
    Color(hex: "#EF4444"), // Red
    Color(hex: "#06B6D4"), // Cyan
    Color(hex: "#EC4899")  // Pink
]
```

## Accessibility

Both components follow accessibility best practices:

- **Semantic Labels**: Proper text hierarchy
- **Color Independence**: Information not conveyed by color alone
- **Touch Targets**: Adequate button sizes (44pt minimum)
- **VoiceOver**: Descriptive labels for screen readers
- **Keyboard Navigation**: Full keyboard support

## Performance Notes

- **Large Asset Lists**: Pie charts work best with 3-10 segments
- **Goal Counts**: List handles 50+ goals efficiently with lazy rendering
- **Animation**: Progress changes are smoothly animated without blocking UI
- **Memory**: Demo data generators create lightweight mock data

## Theming

Both components respect your theme configuration:

```swift
// Vibrant Theme
ThemeProvider(theme: VibrantTheme()) {
    AssetsPieCard(assets: assets)
}

// Neutral Theme
ThemeProvider(theme: NeutralTheme()) {
    GoalsListView(goals: $goals)
}
```

## State Management

### Assets

Assets are typically read-only for display. If you need to modify:

```swift
@State private var assets: [AssetData] = []

// Reload from data source
func refreshAssets() {
    assets = dataService.fetchAssets()
}
```

### Goals

Goals support full CRUD operations:

```swift
@State private var goals: [GoalItem] = []

func saveGoal(_ goal: GoalItem) {
    if let index = goals.firstIndex(where: { $0.id == goal.id }) {
        goals[index] = goal
        dataService.update(goal)
    }
}

func deleteGoal(_ goal: GoalItem) {
    goals.removeAll { $0.id == goal.id }
    dataService.delete(goal)
}

func addGoal(_ goal: GoalItem) {
    goals.append(goal)
    dataService.create(goal)
}
```

## Best Practices

1. **Asset Categories**: Group similar assets for clearer visualization
2. **Goal Priorities**: Use high priority sparingly for important goals
3. **Target Dates**: Set realistic deadlines for better tracking
4. **Progress Updates**: Update goal progress regularly (weekly/monthly)
5. **Category Icons**: Customize icons to match your app's style
6. **Empty States**: Provide clear next steps when lists are empty
7. **Validation**: Validate amounts and dates before saving

## Requirements

- macOS 14+ (Sonoma)
- SwiftUI
- Swift Charts framework
- DesignSystem module (theme, tokens, Card component)

## Files

```
Components/
├── AssetsPieCard.swift (400+ lines)
│   ├── AssetData model
│   ├── AssetsPieCard view
│   ├── Chart angle selection extension
│   └── AssetDemoData generator
│
├── GoalsListView.swift (600+ lines)
│   ├── GoalItem model
│   ├── GoalPriority enum
│   ├── ProgressBar component
│   ├── GoalsListView with inline editing
│   ├── SortOrder enum
│   └── GoalDemoData generator
│
Previews/
└── AssetsGoalsPreview.swift (500+ lines)
    ├── Combined preview
    ├── Theme comparison
    ├── Dashboard integration
    ├── Interactive demo
    └── Individual component showcases
```

## License

Part of PersonalFinanceApp5 DesignSystem module.
