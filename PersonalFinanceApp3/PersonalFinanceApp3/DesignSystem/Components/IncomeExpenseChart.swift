import SwiftUI
import Charts

/// Data point for income/expense chart
public struct ChartDataPoint: Identifiable {
    public let id = UUID()
    public let date: Date
    public let amount: Double
    
    public init(date: Date, amount: Double) {
        self.date = date
        self.amount = amount
    }
}

/// Income and expense line chart with area fills
public struct IncomeExpenseChart: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    private let income: [ChartDataPoint]
    private let expenses: [ChartDataPoint]
    private let showLegend: Bool
    
    // MARK: - Computed Properties
    
    private var maxValue: Double {
        let incomeMax = income.map(\.amount).max() ?? 0
        let expenseMax = expenses.map(\.amount).max() ?? 0
        return max(incomeMax, expenseMax)
    }
    
    private var minDate: Date {
        let allDates = income.map(\.date) + expenses.map(\.date)
        return allDates.min() ?? Date()
    }
    
    private var maxDate: Date {
        let allDates = income.map(\.date) + expenses.map(\.date)
        return allDates.max() ?? Date()
    }
    
    // MARK: - Initialization
    
    /// Creates an income and expense chart
    /// - Parameters:
    ///   - income: Array of income data points (date, amount)
    ///   - expenses: Array of expense data points (date, amount)
    ///   - showLegend: Whether to show the legend (default: true)
    public init(
        income: [(Date, Double)],
        expenses: [(Date, Double)],
        showLegend: Bool = true
    ) {
        self.income = income.map { ChartDataPoint(date: $0.0, amount: $0.1) }
        self.expenses = expenses.map { ChartDataPoint(date: $0.0, amount: $0.1) }
        self.showLegend = showLegend
    }
    
    // MARK: - Body
    
    public var body: some View {
        Chart {
            // Income Series
            ForEach(income) { dataPoint in
                LineMark(
                    x: .value("Date", dataPoint.date, unit: .day),
                    y: .value("Amount", dataPoint.amount)
                )
                .foregroundStyle(theme.colors.success)
                .interpolationMethod(.catmullRom)
                .symbol(Circle().strokeBorder(lineWidth: 2))
                .symbolSize(40)
                
                AreaMark(
                    x: .value("Date", dataPoint.date, unit: .day),
                    y: .value("Amount", dataPoint.amount)
                )
                .foregroundStyle(
                    theme.colors.success.opacity(0.2)
                )
                .interpolationMethod(.catmullRom)
            }
            .foregroundStyle(by: .value("Type", "Income"))
            
            // Expense Series
            ForEach(expenses) { dataPoint in
                LineMark(
                    x: .value("Date", dataPoint.date, unit: .day),
                    y: .value("Amount", dataPoint.amount)
                )
                .foregroundStyle(theme.colors.error)
                .interpolationMethod(.catmullRom)
                .symbol(Circle().strokeBorder(lineWidth: 2))
                .symbolSize(40)
                
                AreaMark(
                    x: .value("Date", dataPoint.date, unit: .day),
                    y: .value("Amount", dataPoint.amount)
                )
                .foregroundStyle(
                    theme.colors.error.opacity(0.2)
                )
                .interpolationMethod(.catmullRom)
            }
            .foregroundStyle(by: .value("Type", "Expenses"))
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 5)) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(dayOfMonth(date))
                            .font(theme.typography.labelSmall)
                            .foregroundColor(theme.colors.textTertiary)
                    }
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(theme.colors.borderSubtle)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                if let amount = value.as(Double.self) {
                    AxisValueLabel {
                        Text(formatCurrency(amount))
                            .font(theme.typography.labelSmall)
                            .foregroundColor(theme.colors.textTertiary)
                    }
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(theme.colors.borderSubtle)
                }
            }
        }
        .chartLegend(showLegend ? .visible : .hidden)
        .chartForegroundStyleScale([
            "Income": theme.colors.success,
            "Expenses": theme.colors.error
        ])
        .frame(minHeight: 250)
    }
    
    // MARK: - Helper Methods
    
    private func dayOfMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        
        // Shorten large numbers
        if amount >= 1000 {
            formatter.maximumFractionDigits = 1
            if amount >= 1_000_000 {
                return formatter.string(from: NSNumber(value: amount / 1_000_000))?.appending("M") ?? "$0"
            } else {
                return formatter.string(from: NSNumber(value: amount / 1000))?.appending("K") ?? "$0"
            }
        }
        
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// MARK: - Chart Card Wrapper

/// Card component specifically designed for charts
public struct ChartCard<Content: View>: View {
    @Environment(\.theme) private var theme
    
    private let title: String
    private let subtitle: String?
    private let content: Content
    private let style: CardStyle
    
    /// Creates a chart card
    /// - Parameters:
    ///   - title: Card title
    ///   - subtitle: Optional subtitle
    ///   - style: Card visual style (default: .elevated)
    ///   - content: Chart content
    public init(
        title: String,
        subtitle: String? = nil,
        style: CardStyle = .elevated,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.style = style
        self.content = content()
    }
    
    public var body: some View {
        Card(style: style, padding: .large) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Header
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text(title)
                        .font(theme.typography.headingMedium)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(theme.typography.bodySmall)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                }
                
                // Chart Content
                content
            }
        }
    }
}

// MARK: - Demo Data Generator

/// Generates demo data for chart previews
public struct ChartDemoData {
    public static func generateMonthlyData(
        baseIncome: Double = 5000,
        baseExpense: Double = 3000,
        variance: Double = 1000
    ) -> (income: [(Date, Double)], expenses: [(Date, Double)]) {
        let calendar = Calendar.current
        let today = Date()
        
        var income: [(Date, Double)] = []
        var expenses: [(Date, Double)] = []
        
        // Generate 30 days of data
        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: -29 + dayOffset, to: today) else {
                continue
            }
            
            // Create natural-looking fluctuation
            let dayOfMonth = Double(calendar.component(.day, from: date))
            let incomeVariation = sin(dayOfMonth / 5) * variance + Double.random(in: -200...200)
            let expenseVariation = cos(dayOfMonth / 4) * (variance * 0.8) + Double.random(in: -150...150)
            
            let incomeAmount = baseIncome + incomeVariation
            let expenseAmount = baseExpense + expenseVariation
            
            income.append((date, max(0, incomeAmount)))
            expenses.append((date, max(0, expenseAmount)))
        }
        
        return (income, expenses)
    }
    
    public static func generateWeeklyData() -> (income: [(Date, Double)], expenses: [(Date, Double)]) {
        let calendar = Calendar.current
        let today = Date()
        
        var income: [(Date, Double)] = []
        var expenses: [(Date, Double)] = []
        
        let incomeAmounts: [Double] = [0, 0, 0, 0, 4500, 0, 200]
        let expenseAmounts: [Double] = [45, 120, 80, 95, 150, 300, 85]
        
        for dayOffset in 0..<7 {
            guard let date = calendar.date(byAdding: .day, value: -6 + dayOffset, to: today) else {
                continue
            }
            
            income.append((date, incomeAmounts[dayOffset]))
            expenses.append((date, expenseAmounts[dayOffset]))
        }
        
        return (income, expenses)
    }
}

// MARK: - Previews

#Preview("Income & Expense Chart - Vibrant") {
    let data = ChartDemoData.generateMonthlyData()
    
    return ChartCard(
        title: "Income & Expenses",
        subtitle: "Last 30 Days"
    ) {
        IncomeExpenseChart(
            income: data.income,
            expenses: data.expenses
        )
    }
    .themed(VibrantTheme())
    .frame(width: 700, height: 400)
    .padding()
}

#Preview("Income & Expense Chart - Neutral") {
    let data = ChartDemoData.generateMonthlyData()
    
    return ChartCard(
        title: "Income & Expenses",
        subtitle: "Last 30 Days"
    ) {
        IncomeExpenseChart(
            income: data.income,
            expenses: data.expenses
        )
    }
    .themed(NeutralTheme())
    .frame(width: 700, height: 400)
    .padding()
}

#Preview("Side-by-Side Themes") {
    let data = ChartDemoData.generateMonthlyData()
    
    return HStack(spacing: 40) {
        ChartCard(
            title: "Income & Expenses",
            subtitle: "Vibrant Theme"
        ) {
            IncomeExpenseChart(
                income: data.income,
                expenses: data.expenses
            )
        }
        .themed(VibrantTheme())
        
        ChartCard(
            title: "Income & Expenses",
            subtitle: "Neutral Theme"
        ) {
            IncomeExpenseChart(
                income: data.income,
                expenses: data.expenses
            )
        }
        .themed(NeutralTheme())
    }
    .padding(40)
    .frame(width: 1600, height: 500)
}

#Preview("Weekly Data - Vibrant") {
    let data = ChartDemoData.generateWeeklyData()
    
    return ChartCard(
        title: "Weekly Overview",
        subtitle: "Last 7 Days"
    ) {
        IncomeExpenseChart(
            income: data.income,
            expenses: data.expenses
        )
    }
    .themed(VibrantTheme())
    .frame(width: 700, height: 400)
    .padding()
}

#Preview("Multiple Chart Styles") {
    let data = ChartDemoData.generateMonthlyData()
    
    return ScrollView {
        VStack(spacing: 30) {
            ChartCard(
                title: "Elevated Style",
                subtitle: "With shadow",
                style: .elevated
            ) {
                IncomeExpenseChart(
                    income: data.income,
                    expenses: data.expenses
                )
            }
            
            ChartCard(
                title: "Outlined Style",
                subtitle: "With border",
                style: .outlined
            ) {
                IncomeExpenseChart(
                    income: data.income,
                    expenses: data.expenses
                )
            }
            
            ChartCard(
                title: "Flat Style",
                subtitle: "Minimal shadow",
                style: .flat
            ) {
                IncomeExpenseChart(
                    income: data.income,
                    expenses: data.expenses
                )
            }
        }
        .padding(40)
    }
    .themed(VibrantTheme())
    .frame(width: 800, height: 1400)
}

#Preview("Finance Dashboard with Charts") {
    FinanceDashboardWithCharts()
        .themed(VibrantTheme())
        .frame(width: 1200, height: 800)
}

// MARK: - Example Dashboard

struct FinanceDashboardWithCharts: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        Text("Financial Dashboard")
                            .font(theme.typography.displaySmall)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("Track your income and expenses over time")
                            .font(theme.typography.bodyMedium)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    
                    Spacer()
                }
                
                // Main Chart
                let monthlyData = ChartDemoData.generateMonthlyData(
                    baseIncome: 6000,
                    baseExpense: 3500,
                    variance: 1200
                )
                
                ChartCard(
                    title: "Monthly Overview",
                    subtitle: "Last 30 Days",
                    style: .elevated
                ) {
                    IncomeExpenseChart(
                        income: monthlyData.income,
                        expenses: monthlyData.expenses
                    )
                }
                
                // Stats Grid
                HStack(spacing: theme.spacing.lg) {
                    statCard(
                        title: "Total Income",
                        value: "$18,450",
                        trend: "+12.3%",
                        isPositive: true
                    )
                    
                    statCard(
                        title: "Total Expenses",
                        value: "$9,280",
                        trend: "-5.2%",
                        isPositive: true
                    )
                    
                    statCard(
                        title: "Net Savings",
                        value: "$9,170",
                        trend: "+24.1%",
                        isPositive: true
                    )
                }
                
                // Weekly Comparison
                let weeklyData = ChartDemoData.generateWeeklyData()
                
                HStack(spacing: theme.spacing.lg) {
                    ChartCard(
                        title: "This Week",
                        subtitle: "Daily Breakdown",
                        style: .outlined
                    ) {
                        IncomeExpenseChart(
                            income: weeklyData.income,
                            expenses: weeklyData.expenses,
                            showLegend: false
                        )
                    }
                    
                    Card(style: .elevated) {
                        VStack(spacing: theme.spacing.xl) {
                            DonutGauge(
                                value: 9170,
                                max: 15000,
                                title: "Savings Goal",
                                subtitle: "61% of monthly target",
                                size: .large
                            )
                        }
                    }
                }
            }
            .padding(theme.spacing.xxl)
        }
        .background(theme.colors.background)
    }
    
    private func statCard(title: String, value: String, trend: String, isPositive: Bool) -> some View {
        Card(style: .flat, padding: .medium) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(title)
                    .font(theme.typography.labelMedium)
                    .foregroundColor(theme.colors.textSecondary)
                
                Text(value)
                    .font(theme.typography.headingLarge)
                    .foregroundColor(theme.colors.textPrimary)
                
                HStack(spacing: theme.spacing.xs) {
                    Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                        .font(theme.typography.labelSmall)
                    Text(trend)
                        .font(theme.typography.labelMedium)
                }
                .foregroundColor(isPositive ? theme.colors.success : theme.colors.error)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
