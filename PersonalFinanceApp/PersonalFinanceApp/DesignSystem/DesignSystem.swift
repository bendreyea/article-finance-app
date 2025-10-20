import SwiftUI

// MARK: - Design System Module
// This file serves as the main entry point for the DesignSystem module.
// All types are already available when importing this file since they're in the same module.

/// DesignSystem namespace for organizing design system utilities
public enum DesignSystem {
    
    /// Available themes in the design system
    public enum Themes {
        public static let vibrant = VibrantTheme()
        public static let neutral = NeutralTheme()
        
        public static var all: [AppTheme] {
            [vibrant, neutral]
        }
    }
    
    /// Design system version
    public static let version = "1.0.0"
    
    /// Usage examples and documentation
    public enum Examples {
        
        /// Example of creating a themed view
        public static func themedView() -> some View {
            ThemeProvider(theme: Themes.vibrant) {
                VStack {
                    Text("Themed Content")
                        .cardTitle()
                    
                    Card {
                        Text("This card uses the theme from environment")
                            .cardBody()
                    }
                }
            }
        }
        
        /// Example of switching themes dynamically
        public static func dynamicThemeExample() -> some View {
            struct DynamicThemeView: View {
                @State private var themeManager = ThemeManager(theme: Themes.vibrant)
                
                var body: some View {
                    ThemeProvider(theme: themeManager.currentTheme) {
                        VStack {
                            Text("Dynamic Theme Example")
                                .cardTitle()
                            
                            Button("Switch Theme") {
                                themeManager.setTheme(
                                    themeManager.currentTheme.name == "Vibrant" 
                                        ? Themes.neutral 
                                        : Themes.vibrant
                                )
                            }
                        }
                    }
                }
            }
            
            return DynamicThemeView()
        }
    }
}

// MARK: - Extension Documentation

/**
 # DesignSystem Usage Guide
 
 ## Basic Setup
 
 1. Wrap your app content with ThemeProvider:
 ```swift
 ThemeProvider(theme: VibrantTheme()) {
     ContentView()
 }
 ```
 
 2. Access theme in any child view:
 ```swift
 struct MyView: View {
     @Environment(\.theme) private var theme
     
     var body: some View {
         Text("Hello")
             .foregroundColor(theme.colors.textPrimary)
             .font(theme.typography.bodyFont)
     }
 }
 ```
 
 ## Using Components
 
 ### Cards
 ```swift
 // Default card
 Card {
     Text("Content").cardTitle()
 }
 
 // Styled cards
 Card.outlined { /* content */ }
 Card.filled { /* content */ }
 Card.elevated { /* content */ }
 ```
 
 ### DonutGauge
 ```swift
 // Basic usage
 DonutGauge(
     value: 75000,
     maxValue: 100000,
     title: "Net Worth",
     subtitle: "+12.5% this month"
 )
 
 // Convenience constructors
 DonutGauge.netWorth(current: 75000, target: 100000)
 DonutGauge.savingsGoal(saved: 45000, goal: 50000)
 DonutGauge.budget(spent: 2800, budget: 3500)
 
 // Different sizes
 DonutGauge(..., size: .small)
 DonutGauge(..., size: .medium)  // default
 DonutGauge(..., size: .large)
 DonutGauge(..., size: .custom(diameter: 200, strokeWidth: 14))
 ```
 
 ### IncomeExpenseChart
 ```swift
 // Basic usage with data arrays
 IncomeExpenseChart(
     incomeData: [(Date(), 1000), (Date().addingTimeInterval(86400), 1200)],
     expenseData: [(Date(), 800), (Date().addingTimeInterval(86400), 900)]
 )
 
 // Inside a ChartCard
 ChartCard(title: "Financial Overview", subtitle: "Last 30 days") {
     IncomeExpenseChart(incomeData: income, expenseData: expenses)
 }
 
 // Demo version with sample data
 IncomeExpenseChart.demo()
 IncomeExpenseChart.demoCard(title: "Monthly Report")
 
 // Compact version without legend
 IncomeExpenseChart(..., showLegend: false)
 ```
 
 ### TransactionsTableView
 ```swift
 // Basic usage with data array
 TransactionsTableView(
     transactions: transactionData,
     onRowDoubleClick: { transaction in
         // Handle edit action
         print("Edit: \(transaction.subCategory)")
     }
 )
 
 // Demo version with sample data
 TransactionsTableView.demo { transaction in
     // Handle row double-click
 }
 
 // Individual components
 StatusBadge(status: .paid)    // .due, .late
 CategorySidebar(selectedCategory: $selectedCategory)
 ```
 
 ### AssetsPieCard
 ```swift
 // Basic usage with asset data
 AssetsPieCard(
     assets: assetAllocations,
     title: "Investment Portfolio",
     subtitle: "Asset allocation breakdown"
 )
 
 // Demo version with sample data
 AssetsPieCard.demo(title: "Portfolio Overview")
 
 // Compact version without legend
 AssetsPieCard(..., showLegend: false)
 
 // Custom assets
 let assets = [
     AssetAllocation(name: "S&P 500", value: 125000, category: .stocks),
     AssetAllocation(name: "Bonds", value: 45000, category: .bonds)
 ]
 ```
 
 ### GoalsListView
 ```swift
 // Basic usage with goals binding
 GoalsListView(
     goals: $financialGoals,
     onGoalUpdate: { updatedGoal in
         // Handle goal update
     },
     onGoalDelete: { deletedGoal in
         // Handle goal deletion
     }
 )
 
 // Individual components
 ProgressBar(progress: 0.75, showPercentage: true)
 StatusBadge(status: .paid)
 ```
 
 ### Text Styling
 ```swift
 Text("Title").cardTitle()
 Text("Body text").cardBody()
 Text("Small text").cardCaption()
 ```
 
 ## Creating Custom Components
 
 Always read from @Environment(\.theme):
 ```swift
 struct CustomComponent: View {
     @Environment(\.theme) private var theme
     
     var body: some View {
         Rectangle()
             .fill(theme.colors.primary)
             .cornerRadius(theme.radius.md)
     }
 }
 ```
 
 ## Available Themes
 - VibrantTheme: Energetic colors for engaging interfaces
 - NeutralTheme: Professional, subdued color palette
 
 ## Extending the System
 
 Create new themes by conforming to AppTheme:
 ```swift
 struct MyCustomTheme: AppTheme {
     let name = "Custom"
     let isDark = false
     let colors = ColorTokens(...)
     // ... implement other required properties
 }
 ```
 */