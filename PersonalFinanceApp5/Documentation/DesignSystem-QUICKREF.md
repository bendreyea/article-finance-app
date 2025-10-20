# AppShell Quick Reference

## 🎯 What is AppShell?

A complete macOS app shell with:
- ✅ NavigationSplitView (sidebar + detail)
- ✅ Top toolbar with DateRange picker & SearchField
- ✅ Three main screens (Dashboard, Income & Expenses, Assets & Goals)
- ✅ Mocked data services with full CRUD
- ✅ Theme injection via ThemeProvider
- ✅ Context-aware search
- ✅ Real-time metrics

## 📁 Files (1,549 lines total)

### Core Files

**AppShell.swift** (73 lines)
- Main entry point
- NavigationSplitView setup
- Route switching logic
- Theme injection at root

**NavigationTypes.swift** (76 lines)
- `DateRange` enum (7D, 30D, 90D, 1Y, All)
- `NavigationDestination` enum (Dashboard, Income & Expenses, Assets & Goals)
- Display names and icons

**MockDataService.swift** (179 lines)
- `AppState` class (navigation, search, theme state)
- `MockDataService` class (CRUD for transactions, assets, goals)
- Simulated network delay
- Computed metrics (totalAssets, netCashFlow, etc.)

### UI Components

**AppToolbar.swift** (341 lines)
- `DateRangeControl` - Segmented control
- `SearchField` - Context-aware search input
- `AppToolbar` - Top toolbar combining controls
- `AppSidebar` - Navigation sidebar with footer stats

**ScreenViews.swift** (352 lines)
- `DashboardView` - Metrics grid, charts, recent activity
- `IncomeExpensesView` - Transactions table with search
- `AssetsGoalsView` - Assets pie chart + goals list

### Documentation

**README.md** (528 lines)
- Architecture overview
- Component documentation
- State management guide
- Integration examples
- Performance notes

## 🚀 Quick Start

### 1. Use in App

```swift
// PersonalFinanceApp5App.swift
@main
struct PersonalFinanceApp5App: App {
    var body: some Scene {
        WindowGroup {
            AppShell()
        }
        .windowStyle(.hiddenTitleBar)
        .defaultSize(width: 1400, height: 900)
    }
}
```

### 2. Access State in Views

```swift
struct MyView: View {
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        // Access data
        Text("Assets: \(appState.dataService.totalAssets)")
        
        // Access state
        Text("Range: \(appState.dateRange.displayName)")
        Text("Search: \(appState.searchText)")
    }
}
```

### 3. Navigate Programmatically

```swift
// From any view with @EnvironmentObject
appState.navigate(to: .incomeExpenses)
```

### 4. Filter Data by Date Range

```swift
var filteredData: [Transaction] {
    guard let interval = appState.dateRange.dateInterval else {
        return allTransactions
    }
    return allTransactions.filter { interval.contains($0.date) }
}
```

### 5. Implement Search

```swift
var searchResults: [Goal] {
    guard !appState.searchText.isEmpty else {
        return appState.dataService.goals
    }
    return appState.dataService.goals.filter { goal in
        goal.name.localizedCaseInsensitiveContains(appState.searchText)
    }
}
```

## 🎨 UI Structure

```
┌─────────────────────────────────────────────────────────┐
│ AppShell (ThemeProvider Root)                          │
├─────────────────────────────────────────────────────────┤
│ ┌────────────┬──────────────────────────────────────┐  │
│ │  Sidebar   │  Toolbar                              │  │
│ │            │  [7D][30D][90D][1Y][All]  🔍Search  🔄│  │
│ │ Finance    ├──────────────────────────────────────┤  │
│ │   App      │                                       │  │
│ │            │  Detail View (Based on Selection)    │  │
│ │ ● Dashboard│                                       │  │
│ │   Income   │  - DashboardView (metrics + charts)  │  │
│ │   Assets   │  - IncomeExpensesView (table)        │  │
│ │            │  - AssetsGoalsView (pie + goals)     │  │
│ │            │                                       │  │
│ │            │                                       │  │
│ │────────────│                                       │  │
│ │ Net Worth  │                                       │  │
│ │  $651K     │                                       │  │
│ │ Cash Flow  │                                       │  │
│ │  +$2.4K    │                                       │  │
│ │ Goals 2/6  │                                       │  │
│ └────────────┴──────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────┘
```

## 📊 Data Flow

```
User Action
    ↓
AppState (@Published properties change)
    ↓
SwiftUI automatic updates
    ↓
UI reflects new state
```

**Example:**
```
1. User clicks "30D" button
2. DateRangeControl updates appState.dateRange = .month
3. DashboardView recomputes filteredData
4. Charts update automatically
```

## 🎯 Key Features

### Navigation
- **Sidebar**: 3 destinations with icons and indicators
- **Footer Stats**: Real-time metrics in sidebar
- **Active Indicator**: Blue dot shows selected screen

### Toolbar
- **DateRange**: 5 preset options with smooth animation
- **Search**: Context-aware (enabled/disabled per screen)
- **Refresh**: Manual data reload with loading state
- **Theme Selector**: Switch between Vibrant/Neutral

### Screens

**Dashboard:**
- 4 metric cards (Assets, Income, Expenses, Cash Flow)
- DonutGauge for net worth
- IncomeExpenseChart
- Recent transactions (top 5)

**Income & Expenses:**
- Full TransactionsTableView
- Search integration
- Sortable columns
- Category sidebar

**Assets & Goals:**
- AssetsPieCard with interactive legend
- GoalsListView with inline editing
- Progress bars
- CRUD operations

### Data Service
- **Mock Data**: Auto-generated realistic data
- **CRUD**: Full create, read, update, delete
- **Computed Metrics**: totalAssets, netCashFlow, etc.
- **Loading States**: Simulated network delay
- **Timestamps**: "Updated 5m ago"

## 🔧 Customization

### Add a Screen

```swift
// 1. Add to NavigationDestination enum
case reports

// 2. Add icon and display name
var icon: String {
    case .reports: return "chart.bar.fill"
}

// 3. Create view
struct ReportsView: View { ... }

// 4. Add to AppShell routing
case .reports: ReportsView()
```

### Replace Mock Data

```swift
// Replace MockDataService with real data service
@MainActor
class RealDataService: ObservableObject {
    @Published var transactions: [TransactionRow] = []
    
    init() {
        loadFromDatabase()
    }
    
    func loadFromDatabase() {
        // CoreData, SwiftData, or API calls
    }
}

// Update AppState
class AppState: ObservableObject {
    let dataService: RealDataService // Changed from MockDataService
}
```

### Custom Metrics

```swift
// Add to MockDataService
public var customMetric: Double {
    // Your calculation
    transactions.filter { $0.category == "Savings" }
        .reduce(0) { $0 + $1.amount }
}

// Display in sidebar footer
statRow(
    label: "Savings",
    value: formatCurrency(appState.dataService.customMetric)
)
```

## 🐛 Debugging

### Check State

```swift
// Add to any view
Text("Destination: \(appState.selectedDestination.displayName)")
Text("Range: \(appState.dateRange.displayName)")
Text("Search: '\(appState.searchText)'")
Text("Theme: \(appState.selectedTheme.displayName)")
Text("Loading: \(appState.dataService.isLoading ? "Yes" : "No")")
```

### Print Data Counts

```swift
// In DashboardView
.onAppear {
    print("Transactions: \(appState.dataService.transactions.count)")
    print("Assets: \(appState.dataService.assets.count)")
    print("Goals: \(appState.dataService.goals.count)")
}
```

## 📦 Dependencies

- **DesignSystem/Theme**: AppTheme, ThemeProvider, VibrantTheme, NeutralTheme
- **DesignSystem/Components**: Card, DonutGauge, IncomeExpenseChart, TransactionsTableView, AssetsPieCard, GoalsListView
- **DesignSystem/Components (Demo Data)**: TransactionDemoData, AssetDemoData, GoalDemoData, ChartDemoData

## 🎓 Learning Path

1. **Start here**: AppShell.swift (73 lines - see the big picture)
2. **Understand types**: NavigationTypes.swift (76 lines - DateRange & NavigationDestination)
3. **Study state**: MockDataService.swift (179 lines - AppState & data management)
4. **Explore UI**: AppToolbar.swift (341 lines - toolbar & sidebar components)
5. **See screens**: ScreenViews.swift (352 lines - three main views)
6. **Deep dive**: README.md (528 lines - complete guide)

## 🎯 Pro Tips

1. **Theme Switching**: Theme selector in toolbar switches between Vibrant/Neutral
2. **Search Toggle**: Search automatically disables on Dashboard (no filtering needed)
3. **Footer Stats**: Sidebar footer shows live metrics that update automatically
4. **Date Filtering**: Use `dateRange.dateInterval` to filter time-series data
5. **Navigation Reset**: Search clears automatically when navigating
6. **Loading State**: Refresh button disables during isLoading
7. **Computed Properties**: Data service provides pre-calculated metrics (totalAssets, etc.)
8. **Time Ago**: Footer shows "5m ago" / "2h ago" timestamps

## 📝 Common Tasks

### Filter by Date Range
```swift
let interval = appState.dateRange.dateInterval
let filtered = data.filter { interval?.contains($0.date) ?? true }
```

### Navigate Programmatically
```swift
appState.navigate(to: .assetsGoals)
```

### Access Metrics
```swift
appState.dataService.totalAssets
appState.dataService.netCashFlow
appState.dataService.completedGoals
```

### Update Data
```swift
appState.dataService.updateGoal(modifiedGoal)
appState.dataService.addTransaction(newTransaction)
appState.dataService.deleteAsset(asset)
```

### Check Search State
```swift
if appState.hasActiveSearch {
    // Show filtered results
}
```

## 🚀 Ready to Use!

The AppShell is fully wired and ready. Just import it in your main app file and run!

**Total: 1,549 lines of production-ready app infrastructure** 🎉
