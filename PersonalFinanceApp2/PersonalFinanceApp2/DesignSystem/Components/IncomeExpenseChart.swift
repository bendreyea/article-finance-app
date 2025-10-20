import SwiftUI
import Charts

/// A data point for income or expense tracking
public struct FinancialDataPoint: Identifiable {
    public let id = UUID()
    public let date: Date
    public let amount: Double
    
    public init(date: Date, amount: Double) {
        self.date = date
        self.amount = amount
    }
}

/// A chart card displaying income and expense trends over time
public struct IncomeExpenseChart: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    private let incomeData: [FinancialDataPoint]
    private let expenseData: [FinancialDataPoint]
    private let title: String
    private let subtitle: String?
    
    // MARK: - Initializer
    public init(
        income: [(Date, Double)],
        expenses: [(Date, Double)],
        title: String = "Income & Expenses",
        subtitle: String? = nil
    ) {
        self.incomeData = income.map { FinancialDataPoint(date: $0.0, amount: $0.1) }
        self.expenseData = expenses.map { FinancialDataPoint(date: $0.0, amount: $0.1) }
        self.title = title
        self.subtitle = subtitle
    }
    
    // MARK: - Computed Properties
    private var maxValue: Double {
        let incomeMax = incomeData.map { $0.amount }.max() ?? 0
        let expenseMax = expenseData.map { $0.amount }.max() ?? 0
        return max(incomeMax, expenseMax)
    }
    
    private var dateRange: ClosedRange<Date> {
        let allDates = incomeData.map { $0.date } + expenseData.map { $0.date }
        guard let minDate = allDates.min(),
              let maxDate = allDates.max() else {
            return Date()...Date()
        }
        return minDate...maxDate
    }
    
    // MARK: - Body
    public var body: some View {
        ChartCard(title: title, subtitle: subtitle) {
            Chart {
                // Income series
                ForEach(incomeData) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date, unit: .day),
                        y: .value("Amount", dataPoint.amount)
                    )
                    .foregroundStyle(theme.colors.success)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                    
                    AreaMark(
                        x: .value("Date", dataPoint.date, unit: .day),
                        y: .value("Amount", dataPoint.amount)
                    )
                    .foregroundStyle(theme.colors.success.opacity(0.2))
                    .interpolationMethod(.catmullRom)
                }
                .foregroundStyle(by: .value("Type", "Income"))
                
                // Expense series
                ForEach(expenseData) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date, unit: .day),
                        y: .value("Amount", dataPoint.amount)
                    )
                    .foregroundStyle(theme.colors.error)
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 2.5))
                    
                    AreaMark(
                        x: .value("Date", dataPoint.date, unit: .day),
                        y: .value("Amount", dataPoint.amount)
                    )
                    .foregroundStyle(theme.colors.error.opacity(0.2))
                    .interpolationMethod(.catmullRom)
                }
                .foregroundStyle(by: .value("Type", "Expenses"))
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day)) { value in
                    if let date = value.as(Date.self) {
                        AxisValueLabel {
                            Text(formatDayOfMonth(date))
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.textSecondary)
                        }
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(theme.colors.borderSubtle)
                        AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(theme.colors.border)
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    if let amount = value.as(Double.self) {
                        AxisValueLabel {
                            Text(formatCurrency(amount))
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.textSecondary)
                        }
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            .foregroundStyle(theme.colors.borderSubtle)
                    }
                }
            }
            .chartForegroundStyleScale([
                "Income": theme.colors.success,
                "Expenses": theme.colors.error
            ])
            .chartLegend(position: .top, alignment: .leading) {
                HStack(spacing: theme.spacing.lg) {
                    LegendItem(color: theme.colors.success, label: "Income")
                    LegendItem(color: theme.colors.error, label: "Expenses")
                }
            }
            .frame(height: 200)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilityLabel)
        }
    }
    
    // MARK: - Helper Methods
    private func formatDayOfMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        
        // Handle large numbers with K/M notation
        if abs(value) >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            return "$\(String(format: "%.1f", value / 1_000_000))M"
        } else if abs(value) >= 10_000 {
            return "$\(String(format: "%.0f", value / 1_000))K"
        } else {
            return formatter.string(from: NSNumber(value: value)) ?? "$0"
        }
    }
    
    private var accessibilityLabel: String {
        let totalIncome = incomeData.reduce(0) { $0 + $1.amount }
        let totalExpenses = expenseData.reduce(0) { $0 + $1.amount }
        return "\(title). Total income: \(formatCurrency(totalIncome)), Total expenses: \(formatCurrency(totalExpenses))"
    }
}

// MARK: - Legend Item Component
private struct LegendItem: View {
    @Environment(\.theme) private var theme
    let color: Color
    let label: String
    
    var body: some View {
        HStack(spacing: theme.spacing.xs) {
            Circle()
                .fill(color)
                .frame(width: 8, height: 8)
            
            Text(label)
                .font(theme.typography.caption)
                .fontWeight(theme.typography.medium)
                .foregroundColor(theme.colors.textPrimary)
        }
    }
}

// MARK: - Chart Card Wrapper
public struct ChartCard<Content: View>: View {
    @Environment(\.theme) private var theme
    
    private let title: String
    private let subtitle: String?
    private let content: Content
    
    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    public var body: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                // Header
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text(title)
                        .font(theme.typography.headline)
                        .fontWeight(theme.typography.semibold)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(theme.typography.footnote)
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
public struct FinancialDemoData {
    /// Generate demo income data for the current month
    public static func generateIncomeData(days: Int = 30) -> [(Date, Double)] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<days).map { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: -days + dayOffset + 1, to: today) else {
                return (today, 0)
            }
            
            // Simulate income pattern (higher on weekdays, peaks mid-month)
            let dayOfMonth = calendar.component(.day, from: date)
            let weekday = calendar.component(.weekday, from: date)
            
            var baseAmount = 2000.0
            
            // Weekend reduction
            if weekday == 1 || weekday == 7 {
                baseAmount *= 0.3
            }
            
            // Mid-month peak (payday effect)
            if dayOfMonth >= 10 && dayOfMonth <= 20 {
                baseAmount *= 1.8
            }
            
            // Add some randomness
            let randomFactor = Double.random(in: 0.7...1.3)
            let amount = baseAmount * randomFactor
            
            return (date, amount)
        }
    }
    
    /// Generate demo expense data for the current month
    public static func generateExpenseData(days: Int = 30) -> [(Date, Double)] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<days).map { dayOffset in
            guard let date = calendar.date(byAdding: .day, value: -days + dayOffset + 1, to: today) else {
                return (today, 0)
            }
            
            // Simulate expense pattern (higher on weekends, spikes for bills)
            let dayOfMonth = calendar.component(.day, from: date)
            let weekday = calendar.component(.weekday, from: date)
            
            var baseAmount = 1200.0
            
            // Weekend increase
            if weekday == 1 || weekday == 7 {
                baseAmount *= 1.5
            }
            
            // Bill payment spikes
            if dayOfMonth == 1 || dayOfMonth == 15 {
                baseAmount *= 2.5
            }
            
            // Add some randomness
            let randomFactor = Double.random(in: 0.8...1.4)
            let amount = baseAmount * randomFactor
            
            return (date, amount)
        }
    }
}

// MARK: - Preview Provider
#Preview("Income & Expense Chart - Vibrant Theme") {
    let vibrantTheme = VibrantTheme()
    
    VStack(spacing: 24) {
        IncomeExpenseChart(
            income: FinancialDemoData.generateIncomeData(),
            expenses: FinancialDemoData.generateExpenseData(),
            title: "Income & Expenses",
            subtitle: "Last 30 days"
        )
        
        IncomeExpenseChart(
            income: FinancialDemoData.generateIncomeData(days: 14),
            expenses: FinancialDemoData.generateExpenseData(days: 14),
            title: "Recent Activity",
            subtitle: "Last 2 weeks"
        )
    }
    .padding(24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(vibrantTheme.colors.backgroundPrimary)
    .theme(vibrantTheme)
}

#Preview("Income & Expense Chart - Neutral Theme") {
    let neutralTheme = NeutralTheme()
    
    ScrollView {
        VStack(spacing: 24) {
            IncomeExpenseChart(
                income: FinancialDemoData.generateIncomeData(),
                expenses: FinancialDemoData.generateExpenseData(),
                title: "Income & Expenses",
                subtitle: "Monthly overview"
            )
            
            HStack(spacing: 16) {
                IncomeExpenseChart(
                    income: FinancialDemoData.generateIncomeData(days: 7),
                    expenses: FinancialDemoData.generateExpenseData(days: 7),
                    title: "This Week"
                )
                
                IncomeExpenseChart(
                    income: FinancialDemoData.generateIncomeData(days: 7),
                    expenses: FinancialDemoData.generateExpenseData(days: 7),
                    title: "Last Week"
                )
            }
        }
        .padding(24)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(neutralTheme.colors.backgroundPrimary)
    .theme(neutralTheme)
}

#Preview("Chart Card Component") {
    let vibrantTheme = VibrantTheme()
    
    VStack(spacing: 24) {
        ChartCard(title: "Sample Chart", subtitle: "With custom content") {
            Rectangle()
                .fill(LinearGradient(
                    colors: [vibrantTheme.colors.brandPrimary, vibrantTheme.colors.brandSecondary],
                    startPoint: .leading,
                    endPoint: .trailing
                ))
                .frame(height: 150)
                .cornerRadius(8)
        }
    }
    .padding(24)
    .theme(vibrantTheme)
}
