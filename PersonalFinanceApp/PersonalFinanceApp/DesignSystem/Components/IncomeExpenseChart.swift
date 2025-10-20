import SwiftUI
import Charts

/// A data model representing a financial data point with date and amount
public struct FinancialDataPoint: Identifiable {
    public let id = UUID()
    public let date: Date
    public let amount: Double
    
    public init(date: Date, amount: Double) {
        self.date = date
        self.amount = amount
    }
}

/// An income and expense chart component using Swift Charts with theme integration
public struct IncomeExpenseChart: View {
    @Environment(\.theme) private var theme
    
    private let incomeData: [FinancialDataPoint]
    private let expenseData: [FinancialDataPoint]
    private let showLegend: Bool
    private let animationDelay: Double
    
    /// Creates an IncomeExpenseChart with the specified data
    /// - Parameters:
    ///   - incomeData: Array of tuples containing (Date, Double) for income data
    ///   - expenseData: Array of tuples containing (Date, Double) for expense data
    ///   - showLegend: Whether to display the chart legend
    ///   - animationDelay: Delay before chart animation starts
    public init(
        incomeData: [(Date, Double)],
        expenseData: [(Date, Double)],
        showLegend: Bool = true,
        animationDelay: Double = 0.0
    ) {
        self.incomeData = incomeData.map { FinancialDataPoint(date: $0.0, amount: $0.1) }
        self.expenseData = expenseData.map { FinancialDataPoint(date: $0.0, amount: $0.1) }
        self.showLegend = showLegend
        self.animationDelay = animationDelay
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            // Chart title and summary
            chartHeader
            
            // Main chart
            chartView
                .frame(height: 200)
            
            // Legend (if enabled)
            if showLegend {
                chartLegend
            }
        }
    }
    
    // MARK: - Chart Header
    private var chartHeader: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            HStack {
                Text("Income vs Expenses")
                    .cardTitle()
                
                Spacer()
                
                // Net difference indicator
                netDifferenceView
            }
            
            Text("Daily comparison over time")
                .cardCaption()
        }
    }
    
    // MARK: - Net Difference View
    private var netDifferenceView: some View {
        let totalIncome = incomeData.reduce(0) { $0 + $1.amount }
        let totalExpenses = expenseData.reduce(0) { $0 + $1.amount }
        let netDifference = totalIncome - totalExpenses
        let isPositive = netDifference >= 0
        
        return HStack(spacing: theme.spacing.xs) {
            Image(systemName: isPositive ? "arrow.up.circle.fill" : "arrow.down.circle.fill")
                .foregroundColor(isPositive ? theme.colors.success : theme.colors.error)
                .font(.caption)
            
            Text(formatCurrency(netDifference))
                .font(theme.typography.font(size: theme.typography.callout, weight: theme.typography.semibold))
                .foregroundColor(isPositive ? theme.colors.success : theme.colors.error)
        }
    }
    
    // MARK: - Chart View
    private var chartView: some View {
        Chart {
            // Income series with area fill and line
            ForEach(incomeData) { dataPoint in
                AreaMark(
                    x: .value("Day", dayOfMonth(from: dataPoint.date)),
                    y: .value("Income", dataPoint.amount)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            theme.colors.success.opacity(0.2),
                            theme.colors.success.opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom) // Smooth curves
                
                LineMark(
                    x: .value("Day", dayOfMonth(from: dataPoint.date)),
                    y: .value("Income", dataPoint.amount)
                )
                .foregroundStyle(theme.colors.success)
                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))
                .interpolationMethod(.catmullRom)
                .symbol(Circle().strokeBorder(lineWidth: 2))
                .symbolSize(30)
            }
            .opacity(0.8)
            
            // Expense series with area fill and line
            ForEach(expenseData) { dataPoint in
                AreaMark(
                    x: .value("Day", dayOfMonth(from: dataPoint.date)),
                    y: .value("Expenses", dataPoint.amount)
                )
                .foregroundStyle(
                    LinearGradient(
                        colors: [
                            theme.colors.error.opacity(0.2),
                            theme.colors.error.opacity(0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .interpolationMethod(.catmullRom)
                
                LineMark(
                    x: .value("Day", dayOfMonth(from: dataPoint.date)),
                    y: .value("Expenses", dataPoint.amount)
                )
                .foregroundStyle(theme.colors.error)
                .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round))
                .interpolationMethod(.catmullRom)
                .symbol(Circle().strokeBorder(lineWidth: 2))
                .symbolSize(30)
            }
            .opacity(0.8)
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .day, count: 2)) { _ in
                AxisValueLabel()
                    .font(theme.typography.captionFont)
                    .foregroundStyle(theme.colors.textSecondary)
                AxisGridLine()
                    .foregroundStyle(theme.colors.border.opacity(0.3))
            }
        }
        .chartYAxis {
            AxisMarks { value in
                AxisValueLabel {
                    if let amount = value.as(Double.self) {
                        Text(formatCurrencyShort(amount))
                            .font(theme.typography.captionFont)
                            .foregroundStyle(theme.colors.textSecondary)
                    }
                }
                AxisGridLine()
                    .foregroundStyle(theme.colors.border.opacity(0.3))
            }
        }
        .chartBackground { _ in
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .fill(theme.colors.surface.opacity(0.5))
        }
        .chartPlotStyle { plotContent in
            plotContent
                .background(theme.colors.surface.opacity(0.1))
                .cornerRadius(theme.radius.sm)
        }
        .animation(.easeInOut(duration: 1.0).delay(animationDelay), value: incomeData.count)
        .animation(.easeInOut(duration: 1.0).delay(animationDelay), value: expenseData.count)
    }
    
    // MARK: - Chart Legend
    private var chartLegend: some View {
        HStack(spacing: theme.spacing.lg) {
            // Income legend item
            legendItem(
                color: theme.colors.success,
                label: "Income",
                amount: incomeData.reduce(0) { $0 + $1.amount }
            )
            
            // Expense legend item  
            legendItem(
                color: theme.colors.error,
                label: "Expenses",
                amount: expenseData.reduce(0) { $0 + $1.amount }
            )
            
            Spacer()
        }
    }
    
    private func legendItem(color: Color, label: String, amount: Double) -> some View {
        HStack(spacing: theme.spacing.xs) {
            Circle()
                .fill(color)
                .frame(width: 12, height: 12)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(label)
                    .font(theme.typography.captionFont)
                    .foregroundColor(theme.colors.textSecondary)
                
                Text(formatCurrency(amount))
                    .font(theme.typography.font(size: theme.typography.footnote, weight: theme.typography.semibold))
                    .foregroundColor(theme.colors.textPrimary)
            }
        }
    }
    
    // MARK: - Helper Functions
    
    private func dayOfMonth(from date: Date) -> Int {
        Calendar.current.component(.day, from: date)
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
    
    private func formatCurrencyShort(_ amount: Double) -> String {
        if abs(amount) >= 1000 {
            return formatCurrency(amount / 1000) + "K"
        } else {
            return formatCurrency(amount)
        }
    }
}

// MARK: - ChartCard Wrapper
/// A card wrapper specifically designed for charts with appropriate padding and styling
public struct ChartCard<Content: View>: View {
    @Environment(\.theme) private var theme
    
    private let content: Content
    private let title: String?
    private let subtitle: String?
    
    /// Creates a ChartCard with optional title and subtitle
    /// - Parameters:
    ///   - title: Optional card title
    ///   - subtitle: Optional card subtitle
    ///   - content: The chart content to display
    public init(
        title: String? = nil,
        subtitle: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    public var body: some View {
        Card(elevation: .medium) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                // Optional header
                if let title = title {
                    VStack(alignment: .leading, spacing: theme.spacing.xs) {
                        Text(title)
                            .cardTitle()
                        
                        if let subtitle = subtitle {
                            Text(subtitle)
                                .cardCaption()
                        }
                    }
                }
                
                // Chart content
                content
            }
        }
    }
}

// MARK: - Demo Data and Convenience Initializers
extension IncomeExpenseChart {
    /// Sample data for previews and demos
    public static var demoData: (income: [(Date, Double)], expenses: [(Date, Double)]) {
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -29, to: today) ?? today
        
        var incomeData: [(Date, Double)] = []
        var expenseData: [(Date, Double)] = []
        
        // Generate 30 days of demo data
        for dayOffset in 0..<30 {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) else { continue }
            
            // Generate realistic income data (higher on weekdays, some weekends off)
            let isWeekend = calendar.isDateInWeekend(date)
            let incomeBase: Double = isWeekend ? 50 : 250
            let incomeVariation = Double.random(in: -50...100)
            let income = max(0, incomeBase + incomeVariation)
            
            // Generate realistic expense data (varies throughout month)
            let expenseBase: Double = 120
            let expenseVariation = Double.random(in: -40...80)
            let expenses = max(20, expenseBase + expenseVariation)
            
            if income > 0 {
                incomeData.append((date, income))
            }
            expenseData.append((date, expenses))
        }
        
        return (incomeData, expenseData)
    }
    
    /// Creates an IncomeExpenseChart with demo data
    public static func demo(animationDelay: Double = 0.0) -> IncomeExpenseChart {
        let data = demoData
        return IncomeExpenseChart(
            incomeData: data.income,
            expenseData: data.expenses,
            animationDelay: animationDelay
        )
    }
    
    /// Creates an IncomeExpenseChart inside a ChartCard with demo data
    public static func demoCard(
        title: String = "Financial Overview",
        subtitle: String = "Last 30 days",
        animationDelay: Double = 0.0
    ) -> some View {
        ChartCard(title: title, subtitle: subtitle) {
            IncomeExpenseChart.demo(animationDelay: animationDelay)
        }
    }
}