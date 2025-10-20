//
//  IncomeExpenseChart.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI
import Charts

/// A data point for the income/expense chart
public struct FinanceDataPoint: Identifiable {
    public let id = UUID()
    public let date: Date
    public let amount: Double
    public let category: FinanceCategory
    
    public init(date: Date, amount: Double, category: FinanceCategory) {
        self.date = date
        self.amount = amount
        self.category = category
    }
}

/// Categories for financial data
public enum FinanceCategory: String, CaseIterable {
    case income = "Income"
    case expenses = "Expenses"
    
    /// Color from theme for this category
    func color(theme: AppTheme) -> Color {
        switch self {
        case .income: return theme.colors.success
        case .expenses: return theme.colors.error
        }
    }
    
    /// SF Symbol icon for this category
    var icon: String {
        switch self {
        case .income: return "arrow.up.circle.fill"
        case .expenses: return "arrow.down.circle.fill"
        }
    }
}

/// A chart component displaying income vs expenses over time using Swift Charts.
/// Shows two series with smoothed lines, area fills, and automatic legend.
///
/// Example usage:
/// ```swift
/// IncomeExpenseChart(
///     incomeData: [(date1, 5000), (date2, 5500), ...],
///     expenseData: [(date1, 3000), (date2, 3200), ...]
/// )
/// ```
public struct IncomeExpenseChart: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    private let incomeData: [(Date, Double)]
    private let expenseData: [(Date, Double)]
    private let title: String?
    private let subtitle: String?
    private let height: CGFloat
    
    // MARK: - Computed Properties
    
    /// Combined data points for the chart
    private var dataPoints: [FinanceDataPoint] {
        var points: [FinanceDataPoint] = []
        
        // Add income data points
        for (date, amount) in incomeData {
            points.append(FinanceDataPoint(date: date, amount: amount, category: .income))
        }
        
        // Add expense data points
        for (date, amount) in expenseData {
            points.append(FinanceDataPoint(date: date, amount: amount, category: .expenses))
        }
        
        return points.sorted { $0.date < $1.date }
    }
    
    /// Maximum value for Y-axis scaling
    private var maxValue: Double {
        let allAmounts = dataPoints.map { $0.amount }
        return allAmounts.max() ?? 0
    }
    
    /// Minimum value for Y-axis
    private var minValue: Double {
        0
    }
    
    /// Date range for the chart
    private var dateRange: ClosedRange<Date> {
        let allDates = dataPoints.map { $0.date }
        let minDate = allDates.min() ?? Date()
        let maxDate = allDates.max() ?? Date()
        return minDate...maxDate
    }
    
    // MARK: - Initialization
    
    public init(
        incomeData: [(Date, Double)],
        expenseData: [(Date, Double)],
        title: String? = "Income vs Expenses",
        subtitle: String? = nil,
        height: CGFloat = 250
    ) {
        self.incomeData = incomeData
        self.expenseData = expenseData
        self.title = title
        self.subtitle = subtitle
        self.height = height
    }
    
    // MARK: - Body
    
    public var body: some View {
        ChartCard(
            title: title,
            subtitle: subtitle,
            showLegend: true
        ) {
            chart
                .frame(height: height)
        }
    }
    
    // MARK: - Chart
    
    private var chart: some View {
        Chart(dataPoints) { dataPoint in
            // Area fill (20% opacity)
            AreaMark(
                x: .value("Date", dataPoint.date),
                y: .value("Amount", dataPoint.amount)
            )
            .foregroundStyle(
                dataPoint.category.color(theme: theme).opacity(0.2)
            )
            .interpolationMethod(.catmullRom) // Smoothed line
            
            // Line mark
            LineMark(
                x: .value("Date", dataPoint.date),
                y: .value("Amount", dataPoint.amount)
            )
            .foregroundStyle(dataPoint.category.color(theme: theme))
            .lineStyle(StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round))
            .interpolationMethod(.catmullRom) // Smoothed line
            
            // Point marks for data points
            PointMark(
                x: .value("Date", dataPoint.date),
                y: .value("Amount", dataPoint.amount)
            )
            .foregroundStyle(dataPoint.category.color(theme: theme))
            .symbol(.circle)
            .symbolSize(40)
        }
        .chartForegroundStyleScale([
            FinanceCategory.income.rawValue: FinanceCategory.income.color(theme: theme),
            FinanceCategory.expenses.rawValue: FinanceCategory.expenses.color(theme: theme)
        ])
        .chartLegend(position: .top, alignment: .leading) {
            HStack(spacing: theme.spacing.lg) {
                ForEach(FinanceCategory.allCases, id: \.self) { category in
                    HStack(spacing: theme.spacing.xs) {
                        Image(systemName: category.icon)
                            .font(.system(size: theme.spacing.iconSizeSmall))
                            .foregroundColor(category.color(theme: theme))
                        
                        Text(category.rawValue)
                            .font(theme.typography.labelMedium)
                            .foregroundColor(theme.colors.onSurface)
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(dayOfMonth(from: date))
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.onSurfaceSecondary)
                    }
                    AxisGridLine()
                        .foregroundStyle(theme.colors.borderSubtle)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading, values: .automatic) { value in
                if let amount = value.as(Double.self) {
                    AxisValueLabel {
                        Text(formatCurrency(amount))
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.onSurfaceSecondary)
                    }
                    AxisGridLine()
                        .foregroundStyle(theme.colors.borderSubtle)
                }
            }
        }
        .chartPlotStyle { plotArea in
            plotArea
                .background(theme.colors.surface)
                .cornerRadius(theme.radius.sm)
        }
    }
    
    // MARK: - Formatting Helpers
    
    /// Format a date as day of month (e.g., "15")
    private func dayOfMonth(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    /// Format amount as currency
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        
        // Use K for thousands
        if amount >= 1000 {
            let thousands = amount / 1000
            return "$\(Int(thousands))K"
        }
        
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// MARK: - Demo Data Generator

extension IncomeExpenseChart {
    /// Generate demo data for previews and testing
    public static func generateDemoData(days: Int = 30) -> (income: [(Date, Double)], expenses: [(Date, Double)]) {
        let calendar = Calendar.current
        let today = Date()
        
        var incomeData: [(Date, Double)] = []
        var expenseData: [(Date, Double)] = []
        
        for day in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: -day, to: today) else { continue }
            
            // Generate income data (higher on certain days like 1st and 15th)
            let dayOfMonth = calendar.component(.day, from: date)
            let baseIncome: Double = dayOfMonth == 1 || dayOfMonth == 15 ? 5000 : 200
            let incomeVariation = Double.random(in: 0.8...1.2)
            let income = baseIncome * incomeVariation
            
            // Generate expense data (varies throughout month)
            let baseExpense: Double = 150
            let expenseVariation = Double.random(in: 0.5...2.0)
            let expense = baseExpense * expenseVariation
            
            incomeData.append((date, income))
            expenseData.append((date, expense))
        }
        
        return (
            income: incomeData.sorted { $0.0 < $1.0 },
            expenses: expenseData.sorted { $0.0 < $1.0 }
        )
    }
    
    /// Generate realistic monthly demo data
    public static func generateMonthlyDemoData() -> (income: [(Date, Double)], expenses: [(Date, Double)]) {
        let calendar = Calendar.current
        let today = Date()
        
        var incomeData: [(Date, Double)] = []
        var expenseData: [(Date, Double)] = []
        
        // Generate 30 days of data
        for day in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -day, to: today) else { continue }
            let dayOfMonth = calendar.component(.day, from: date)
            
            // Income spikes on paydays (1st and 15th)
            var dailyIncome: Double = 0
            if dayOfMonth == 1 {
                dailyIncome = 4500 + Double.random(in: -200...200) // First paycheck
            } else if dayOfMonth == 15 {
                dailyIncome = 4200 + Double.random(in: -200...200) // Second paycheck
            } else if dayOfMonth % 7 == 0 {
                dailyIncome = 300 + Double.random(in: -50...100) // Side income
            } else {
                dailyIncome = Double.random(in: 0...150) // Misc income
            }
            
            // Expenses vary by day type
            var dailyExpenses: Double = 0
            if dayOfMonth == 1 {
                dailyExpenses = 1200 + Double.random(in: -100...100) // Rent day
            } else if dayOfMonth == 5 || dayOfMonth == 20 {
                dailyExpenses = 400 + Double.random(in: -50...150) // Bill payment days
            } else if dayOfMonth % 7 == 6 {
                dailyExpenses = 250 + Double.random(in: -50...100) // Weekend spending
            } else {
                dailyExpenses = 120 + Double.random(in: -30...80) // Daily expenses
            }
            
            incomeData.append((date, dailyIncome))
            expenseData.append((date, dailyExpenses))
        }
        
        return (
            income: incomeData.sorted { $0.0 < $1.0 },
            expenses: expenseData.sorted { $0.0 < $1.0 }
        )
    }
}

// MARK: - Previews

#Preview("IncomeExpenseChart - Vibrant Theme") {
    ThemeProvider(theme: VibrantTheme()) {
        ScrollView {
            VStack(spacing: 24) {
                Text("Income vs Expense Chart")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)
                
                let demoData = IncomeExpenseChart.generateMonthlyDemoData()
                
                IncomeExpenseChart(
                    incomeData: demoData.income,
                    expenseData: demoData.expenses,
                    title: "Income vs Expenses",
                    subtitle: "Last 30 Days"
                )
            }
            .padding()
        }
    }
    .frame(width: 700, height: 500)
}

#Preview("IncomeExpenseChart - Neutral Theme") {
    ThemeProvider(theme: NeutralTheme()) {
        ScrollView {
            VStack(spacing: 24) {
                Text("Income vs Expense Chart")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)
                
                let demoData = IncomeExpenseChart.generateMonthlyDemoData()
                
                IncomeExpenseChart(
                    incomeData: demoData.income,
                    expenseData: demoData.expenses,
                    title: "Income vs Expenses",
                    subtitle: "Last 30 Days"
                )
            }
            .padding()
        }
    }
    .frame(width: 700, height: 500)
}

#Preview("IncomeExpenseChart - Side by Side") {
    HStack(spacing: 0) {
        // Vibrant Theme
        ThemeProvider(theme: VibrantTheme()) {
            VStack(spacing: 16) {
                Text("Vibrant Theme")
                    .font(.system(size: 18, weight: .semibold))
                
                let demoData = IncomeExpenseChart.generateMonthlyDemoData()
                
                IncomeExpenseChart(
                    incomeData: demoData.income,
                    expenseData: demoData.expenses,
                    title: "Income vs Expenses",
                    subtitle: "Last 30 Days",
                    height: 220
                )
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        Divider()
        
        // Neutral Theme
        ThemeProvider(theme: NeutralTheme()) {
            VStack(spacing: 16) {
                Text("Neutral Theme")
                    .font(.system(size: 18, weight: .semibold))
                
                let demoData = IncomeExpenseChart.generateMonthlyDemoData()
                
                IncomeExpenseChart(
                    incomeData: demoData.income,
                    expenseData: demoData.expenses,
                    title: "Income vs Expenses",
                    subtitle: "Last 30 Days",
                    height: 220
                )
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    .frame(width: 1200, height: 450)
}

#Preview("IncomeExpenseChart - Heights") {
    ThemeProvider(theme: VibrantTheme()) {
        ScrollView {
            VStack(spacing: 32) {
                Text("Different Heights")
                    .font(.system(size: 24, weight: .bold))
                
                let demoData = IncomeExpenseChart.generateMonthlyDemoData()
                
                VStack(spacing: 24) {
                    // Compact
                    IncomeExpenseChart(
                        incomeData: demoData.income,
                        expenseData: demoData.expenses,
                        title: "Compact Height (180pt)",
                        height: 180
                    )
                    
                    // Standard
                    IncomeExpenseChart(
                        incomeData: demoData.income,
                        expenseData: demoData.expenses,
                        title: "Standard Height (250pt)",
                        height: 250
                    )
                    
                    // Tall
                    IncomeExpenseChart(
                        incomeData: demoData.income,
                        expenseData: demoData.expenses,
                        title: "Tall Height (350pt)",
                        height: 350
                    )
                }
            }
            .padding()
        }
    }
    .frame(width: 700, height: 1100)
}

#Preview("IncomeExpenseChart - Dashboard Context") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 24) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Financial Dashboard")
                        .font(.system(size: 28, weight: .bold))
                    Text("October 2025")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Chart
            let demoData = IncomeExpenseChart.generateMonthlyDemoData()
            
            IncomeExpenseChart(
                incomeData: demoData.income,
                expenseData: demoData.expenses,
                title: "Income vs Expenses",
                subtitle: "Daily transactions - Last 30 days"
            )
            .padding(.horizontal)
            
            // Stats summary
            HStack(spacing: 16) {
                Card(elevation: .low, padding: .compact) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Income")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$8,450")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Card(elevation: .low, padding: .compact) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Total Expenses")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$4,230")
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Card(elevation: .low, padding: .compact) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Net Savings")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("$4,220")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.horizontal)
            
            Spacer()
        }
    }
    .frame(width: 800, height: 650)
}
