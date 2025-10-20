# PersonalFinanceApp3 - Complete Application Guide

A modern macOS personal finance application built with SwiftUI featuring comprehensive financial management, beautiful visualizations, and a fully theme-driven design system.

## 🎯 Application Overview

### Core Features
- **Dashboard**: Net worth tracking, income/expense trends, quick stats
- **Income & Expenses**: Transaction management with sorting, filtering, and search
- **Assets & Goals**: Asset distribution pie chart and goal tracking with progress bars

### Architecture Highlights
- **MVVM Pattern** with NavigationSplitView routing
- **Theme-Driven Design**: Zero hardcoded values, 100% environment-based theming
- **Component Library**: Reusable, composable UI components
- **Mock Data Services**: Production-ready data layer structure

## 🚀 Quick Start

### Running the Application

1. **Open in Xcode**:
   ```bash
   open PersonalFinanceApp3.xcodeproj
   ```

2. **Build and Run**:
   - Select a target macOS version (14+)
   - Press `Cmd+R` to build and run
   - Default window size: 1400×900

3. **Theme Switching**:
   - `Cmd+Shift+1`: Switch to Vibrant Theme
   - `Cmd+Shift+2`: Switch to Neutral Theme

## 📁 Project Structure

```
PersonalFinanceApp3/
├── PersonalFinanceApp3/
│   ├── PersonalFinanceApp3App.swift  # App entry point with theme injection
│   └── ContentView.swift             # Legacy view (not used)
│
├── DesignSystem/                      # Self-contained design system
│   ├── Tokens/                        # Design tokens
│   │   ├── AppTheme.swift            # Theme protocol
│   │   ├── ColorTokens.swift         # Color system
│   │   ├── SpacingTokens.swift       # Spacing scale
│   │   ├── RadiusTokens.swift        # Border radius
│   │   ├── TypographyTokens.swift    # Type system
│   │   └── ShadowTokens.swift        # Shadow elevations
│   │
│   ├── Themes/                        # Concrete theme implementations
│   │   ├── VibrantTheme.swift        # Bold, colorful theme
│   │   └── NeutralTheme.swift        # Subtle, refined theme
│   │
│   ├── Components/                    # Reusable UI components
│   │   ├── Card.swift                # Card container component
│   │   ├── DonutGauge.swift          # Circular progress gauge
│   │   ├── IncomeExpenseChart.swift  # Line chart with areas
│   │   ├── TransactionsTableView.swift # Sortable table with sidebar
│   │   ├── AssetsPieAndGoals.swift   # Pie chart and goals list
│   │   ├── CardPreview.swift         # Preview examples
│   │   └── FinanceDashboardExample.swift # Dashboard demo
│   │
│   ├── ThemeProvider.swift            # Environment injection
│   ├── AppShell.swift                 # Main app shell & routing
│   └── README.md                      # Design system docs
│
└── BuildPrompts/                      # Feature specifications
    ├── Global theme & tokens(1).md
    ├── Donut gauge component(2).md
    ├── Line chart card(3).md
    ├── Transactions table(4).md
    ├── Assets pie + goals(5).md
    └── App shell & routing(6).md
```

## 🎨 Design System

### Themes

#### VibrantTheme
- **Colors**: Bold blues, purples, high contrast
- **Shadows**: Strong elevation (0.12-0.18 opacity)
- **Radius**: Larger corners (6-18pt)
- **Feel**: Modern, energetic, engaging

#### NeutralTheme
- **Colors**: Muted slate-blues, refined palette
- **Shadows**: Subtle elevation (0.04-0.10 opacity)
- **Radius**: Conservative corners (4-16pt)
- **Feel**: Professional, elegant, calm

### Token System

```swift
@Environment(\.theme) private var theme

// Colors
theme.colors.accentPrimary       // Primary brand color
theme.colors.success             // Green for positive states
theme.colors.textPrimary         // Primary text color
theme.colors.chartPrimary        // Chart color palette

// Spacing
theme.spacing.sm    // 8pt
theme.spacing.md    // 12pt
theme.spacing.lg    // 16pt
theme.spacing.xl    // 24pt

// Typography
theme.typography.headingLarge    // 24pt semibold
theme.typography.bodyMedium      // 14pt regular
theme.typography.labelSmall      // 10pt medium

// Radius & Shadow
theme.radius.lg                  // 12-14pt
theme.shadow.md                  // Medium elevation
```

## 🧩 Components

### 1. DonutGauge
Circular progress gauge with center value display.

```swift
DonutGauge(
    value: 45280,
    max: 100000,
    title: "Net Worth",
    subtitle: "45% of goal",
    size: .large
)
```

**Features**:
- 4 size variants (small, medium, large, extraLarge)
- Gradient ring (accentPrimary → accentSecondary)
- Currency-formatted center value
- Full accessibility support

### 2. IncomeExpenseChart
Dual-line chart with area fills using Swift Charts.

```swift
IncomeExpenseChart(
    income: [(date1, 5000), (date2, 5200)],
    expenses: [(date1, 3000), (date2, 2800)],
    showLegend: true
)
```

**Features**:
- Smooth Catmull-Rom interpolation
- 20% opacity area fills
- Currency-formatted Y-axis
- Day-of-month X-axis
- Automatic legend

### 3. TransactionsTableView
Sortable table with category sidebar and search.

```swift
TransactionsTableView(
    transactions: transactionData
) { transaction in
    // Handle double-click to edit
}
```

**Features**:
- 4 sortable columns (SubCategory, Amount, Due Date, Status)
- Colored status badges (Paid, Due, Late)
- Category filtering sidebar
- Real-time search
- Double-click to edit

### 4. AssetsPieCard
Pie chart with center total and external legend.

```swift
AssetsPieCard(
    assets: assetData,
    showLegend: true
)
```

**Features**:
- Swift Charts SectorMark
- Golden ratio donut (0.618 inner radius)
- Center total display
- Percentage-based legend
- Auto-colored segments

### 5. GoalsListView
Goal tracking with progress bars and inline editing.

```swift
GoalsListView(goals: goalData) { updatedGoal in
    // Handle goal update
}
```

**Features**:
- Color-coded progress bars
- Inline amount editing
- Completion badges
- Deadline tracking
- Category icons

### 6. Card
Universal container component with multiple styles.

```swift
Card(style: .elevated, padding: .large) {
    // Content
}
```

**Styles**: elevated, flat, outlined, subtle  
**Padding**: none, small, medium, large, extraLarge

## 🗺️ Navigation & Routing

### App Shell Structure

```
AppShell (NavigationSplitView)
├── Sidebar
│   ├── App Header
│   ├── Navigation List
│   │   ├── Dashboard
│   │   ├── Income & Expenses
│   │   └── Assets & Goals
│   └── User Footer
│
└── Detail View
    ├── Toolbar
    │   ├── Date Range Picker (Week/Month/Quarter/Year/All)
    │   └── Search Field (context-aware placeholder)
    └── Content View (routed based on selection)
```

### Routes

- **Dashboard**: Overview with gauges, charts, and stats
- **Income & Expenses**: Transaction table with category filtering
- **Assets & Goals**: Pie chart and goal tracking

## 📊 Data Services

### MockDataService

Observable object providing demo data:

```swift
class MockDataService: ObservableObject {
    @Published var netWorth: Double
    @Published var transactions: [TransactionRow]
    @Published var assets: [AssetItem]
    @Published var goals: [GoalItem]
    // ... more properties
    
    func updateGoal(_ goal: GoalItem) { /* ... */ }
}
```

**Demo Data Included**:
- 30 days of income/expense chart data
- 16 realistic transactions across 8 categories
- 9 asset items totaling $668K
- 6 financial goals with varied progress

## 🎯 Key Features

### Dashboard View
- Net worth donut gauge ($668K / $1M goal)
- Available balance, income, expenses cards
- 30-day income/expense trend chart
- Quick stats: Total income, expenses, net savings

### Income & Expenses View
- Full-featured transaction table
- Category sidebar with counts
- Search across subcategory and description
- Sortable columns
- Status badges (Paid/Due/Late)

### Assets & Goals View
- Summary cards (total assets, goals progress)
- Asset distribution pie chart
- Goals list with progress bars
- Inline editing for goal amounts
- Completion tracking

## 🎨 Theming

### How It Works

1. **Root Level**: Theme injected at app entry point
   ```swift
   AppShell().themed(VibrantTheme())
   ```

2. **Component Level**: Access via environment
   ```swift
   @Environment(\.theme) private var theme
   ```

3. **Usage**: Never hardcode values
   ```swift
   .foregroundColor(theme.colors.textPrimary)
   .padding(theme.spacing.lg)
   .font(theme.typography.bodyMedium)
   ```

### Creating Custom Themes

```swift
struct MyCustomTheme: AppTheme {
    let name = "Custom"
    let colors = ColorTokens(/* ... */)
    let spacing = SpacingTokens()
    let radius = RadiusTokens(/* custom values */)
    let typography = TypographyTokens()
    let shadow = ShadowTokens()
}
```

## 🔧 Development

### Adding a New View

1. Create view file in appropriate location
2. Inject theme: `@Environment(\.theme) private var theme`
3. Use theme tokens exclusively
4. Add to routing in `AppShell.swift`
5. Create SwiftUI previews with both themes

### Adding a New Component

1. Create in `DesignSystem/Components/`
2. Use only theme tokens for styling
3. Make it reusable and configurable
4. Add comprehensive previews
5. Document in component file

### Best Practices

- ✅ Always use `@Environment(\.theme)`
- ✅ Never hardcode colors, spacing, fonts
- ✅ Test with both themes
- ✅ Add accessibility labels
- ✅ Create side-by-side previews
- ❌ Don't use `.foregroundColor(.blue)`
- ❌ Don't use `.padding(16)`
- ❌ Don't use `.font(.system(size: 14))`

## 📱 Keyboard Shortcuts

- `Cmd+Shift+1` - Switch to Vibrant Theme
- `Cmd+Shift+2` - Switch to Neutral Theme

## 🎬 Previews

Every component includes multiple preview configurations:
- Single theme views
- Side-by-side theme comparisons
- Different size/state variations
- Complete dashboard examples

To view previews in Xcode:
1. Open any component file
2. Use the Canvas (Cmd+Option+Return)
3. Select preview from dropdown

## 📈 Future Enhancements

Potential additions:
- [ ] Data persistence (SwiftData)
- [ ] CSV/OFX/QIF import
- [ ] Budget tracking
- [ ] Recurring transactions
- [ ] Multi-account support
- [ ] Investment tracking
- [ ] Reports and analytics
- [ ] Export functionality
- [ ] Cloud sync
- [ ] Dark mode support

## 🤝 Contributing

When adding features:
1. Follow the theme-driven architecture
2. Use existing components where possible
3. Create reusable components for common patterns
4. Add comprehensive previews
5. Document complex logic
6. Test with both themes

## 📄 License

Part of the PersonalFinanceApp3 project.

---

**Built with**: SwiftUI, Swift Charts, macOS 14+  
**Architecture**: MVVM with environment-driven theming  
**Design**: Comprehensive design system with two complete themes
