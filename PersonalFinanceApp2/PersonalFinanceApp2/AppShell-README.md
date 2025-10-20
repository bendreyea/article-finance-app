# AppShell Architecture

The AppShell provides the main navigation structure and routing for the Personal Finance App with environment-driven theming and mocked data services.

## 🏗️ Architecture Overview

```
App Entry (PersonalFinanceApp2App.swift)
    └── ThemeProvider (injects theme into environment)
        └── AppShell (NavigationSplitView)
            ├── Sidebar (Navigation)
            └── Detail View
                ├── Top Toolbar (DateRange + Search)
                └── Content (Dashboard | Income & Expenses | Assets & Goals)
```

## 📱 Components

### **1. NavigationSplitView Structure**

**Sidebar** (200-250pt width):
- Dashboard
- Income & Expenses
- Assets & Goals

**Detail View**:
- Top Toolbar with DateRange picker and SearchField
- Scrollable content area
- Section-specific views

### **2. Navigation Sections**

```swift
enum NavigationSection {
    case dashboard
    case incomeExpenses
    case assetsGoals
}
```

Each section has:
- Icon (SF Symbol)
- Raw value (display name)
- Unique routing identifier

### **3. Top Toolbar**

**DateRange Segmented Control**:
- Week (7 days)
- Month (30 days)
- Quarter (90 days)
- Year (365 days)

**SearchField**:
- Context-aware placeholder
- Clear button when not empty
- Bound to current screen
- Filters content in real-time

### **4. Theme Injection**

Theme is injected at the root via `ThemeProvider`:

```swift
AppShell()
    .theme(NeutralTheme()) // or VibrantTheme()
```

All child components access theme via:
```swift
@Environment(\.theme) private var theme
```

## 📊 Section Details

### **Dashboard**
Components:
- Net Worth DonutGauge (large)
- 3 StatCards (Balance, Income, Expenses)
- IncomeExpenseChart
- Quick stats grid (Recent Transactions, Upcoming Bills)

Features:
- Dynamic data based on selected date range
- Real-time updates from MockDataService
- Responsive grid layout

### **Income & Expenses**
Components:
- IncomeExpenseChart (trend over time)
- TransactionsTableView (sortable, searchable)

Features:
- Date range filtering
- Search by category/subcategory
- Double-click to edit transactions
- Full table with all features (sort, filter, select)

### **Assets & Goals**
Components:
- AssetsPieCard (portfolio breakdown)
- GoalsListView (progress tracking)

Features:
- Search by asset name/category
- Inline goal editing
- Real-time progress updates
- Portfolio visualization

## 🔧 MockDataService

Comprehensive data service providing:

### **Financial Data**
- `incomeData(for:)` - Income time series
- `expenseData(for:)` - Expense time series
- `totalIncome(for:)` - Aggregated income
- `totalExpenses(for:)` - Aggregated expenses
- `netCashFlow(for:)` - Income minus expenses
- `savingsRate(for:)` - Percentage saved

### **Transactions**
- `transactions(for:)` - Filtered by date range
- `searchTransactions(_:)` - Text search
- `recentTransactionsCount` - Last 7 days
- `upcomingBillsCount` - Next 14 days

### **Assets & Goals**
- `assets` - Portfolio items
- `goals` - Financial goals with binding
- `searchAssets(_:)` - Text search
- `searchGoals(_:)` - Text search
- `updateGoal(_:)` - Update goal progress

### **Account Data**
- `accounts` - Account summaries
- `categoryBreakdown(for:)` - Expense by category
- `budgetCategories(for:)` - Budget vs actual

### **Statistics**
- `netWorth` - Total portfolio value
- `availableBalance` - Liquid funds
- `monthlyAverage(for:)` - Average spending

## 🎨 Theming

The app supports two themes:

**NeutralTheme** (Default):
- Light, professional appearance
- Subtle shadows and borders
- Classic blue brand colors

**VibrantTheme**:
- Dark, energetic appearance
- Pronounced shadows
- Neon cyan/purple/pink accents

Switch themes via:
1. App menu: Theme → Neutral/Vibrant
2. Programmatically: Update `currentTheme` state

## 🔍 Search Implementation

Search is context-aware:

**Dashboard**: General search (not filtered - for future use)
**Income & Expenses**: Filters transactions by category/subcategory
**Assets & Goals**: Filters assets and goals by name/category

Search is debounced and case-insensitive.

## 📏 Layout Specifications

**Sidebar**:
- Min: 200pt
- Ideal: 220pt
- Max: 250pt

**Window**:
- Min: 1000×700pt
- Default: 1400×900pt

**Content Padding**: 32pt (theme.spacing.xxl)

**Toolbar Height**: ~60pt (with padding)

## 🚀 Usage

### Basic Setup

```swift
@main
struct PersonalFinanceApp2App: App {
    @State private var currentTheme: AppTheme = NeutralTheme()
    
    var body: some Scene {
        WindowGroup {
            AppShell()
                .theme(currentTheme)
        }
    }
}
```

### Accessing Data Service

Components receive the data service via parameters:

```swift
DashboardView(
    dataService: dataService,
    dateRange: dateRange,
    searchText: searchText
)
```

The service is a `@StateObject` in `AppShell` and passed as `@ObservedObject` to child views.

## 📦 Files Created

```
PersonalFinanceApp2/
├── AppShell.swift                      # Main shell with navigation
├── Services/
│   └── MockDataService.swift          # Mocked data provider
└── PersonalFinanceApp2App.swift       # App entry with theme injection
```

## 🎯 Key Features

✅ NavigationSplitView with 3 sections
✅ Top toolbar with DateRange picker
✅ Context-aware SearchField
✅ Theme injection at root
✅ Comprehensive MockDataService
✅ Real-time data filtering
✅ Responsive layout
✅ Sidebar toggle support
✅ Window size constraints
✅ Menu commands for theme switching

## 🔄 Data Flow

1. User selects date range → Triggers data refresh
2. User types in search → Filters current view
3. User clicks sidebar item → Changes section
4. Data service updates → UI reflects changes
5. Theme changes → Entire app re-renders with new tokens

The app is fully functional with mocked data and ready for production implementation!
