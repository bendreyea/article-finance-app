import SwiftUI
import Charts

/// A data point for the income/expense chart
public struct ChartDataPoint: Identifiable {
    public let id = UUID()
    public let date: Date
    public let value: Double
    
    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
    }
}

/// A line chart displaying income and expenses over time using Swift Charts
///
/// Features:
/// - Dual series (income and expenses)
/// - Smoothed line interpolation
/// - Area fill with 20% opacity
/// - Automatic legend
/// - Currency-formatted Y axis
/// - Day-of-month X axis
/// - Theme-driven colors (no hardcoded values)
///
/// Usage:
/// ```swift
/// IncomeExpenseChart(
///     income: [(date1, 5200), (date2, 5400), ...],
///     expenses: [(date1, 3200), (date2, 3450), ...]
/// )
/// ```
public struct IncomeExpenseChart: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    private let incomeData: [ChartDataPoint]
    private let expenseData: [ChartDataPoint]
    private let showLegend: Bool
    
    // MARK: - Initialization
    
    public init(
        income: [(Date, Double)],
        expenses: [(Date, Double)],
        showLegend: Bool = true
    ) {
        self.incomeData = income.map { ChartDataPoint(date: $0.0, value: $0.1) }
        self.expenseData = expenses.map { ChartDataPoint(date: $0.0, value: $0.1) }
        self.showLegend = showLegend
    }
    
    // MARK: - Body
    
    public var body: some View {
        Chart {
            // Income Series
            ForEach(incomeData) { point in
                LineMark(
                    x: .value("Day", point.date, unit: .day),
                    y: .value("Amount", point.value)
                )
                .foregroundStyle(theme.colors.success)
                .interpolationMethod(.catmullRom)
                
                AreaMark(
                    x: .value("Day", point.date, unit: .day),
                    y: .value("Amount", point.value)
                )
                .foregroundStyle(theme.colors.success.opacity(0.2))
                .interpolationMethod(.catmullRom)
            }
            .symbol {
                Circle()
                    .fill(theme.colors.success)
                    .frame(width: 6, height: 6)
            }
            .accessibilityLabel("Income")
            
            // Expense Series
            ForEach(expenseData) { point in
                LineMark(
                    x: .value("Day", point.date, unit: .day),
                    y: .value("Amount", point.value)
                )
                .foregroundStyle(theme.colors.error)
                .interpolationMethod(.catmullRom)
                
                AreaMark(
                    x: .value("Day", point.date, unit: .day),
                    y: .value("Amount", point.value)
                )
                .foregroundStyle(theme.colors.error.opacity(0.2))
                .interpolationMethod(.catmullRom)
            }
            .symbol {
                Circle()
                    .fill(theme.colors.error)
                    .frame(width: 6, height: 6)
            }
            .accessibilityLabel("Expenses")
        }
        .chartXAxis {
            AxisMarks(values: .automatic) { value in
                if let date = value.as(Date.self) {
                    AxisValueLabel {
                        Text(dayOfMonth(date))
                            .font(theme.typography.labelSmall.font)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(theme.colors.borderSubtle)
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                if let amount = value.as(Double.self) {
                    AxisValueLabel {
                        Text(formatCurrency(amount))
                            .font(theme.typography.labelSmall.font)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                        .foregroundStyle(theme.colors.borderSubtle)
                }
            }
        }
        .chartLegend(showLegend ? .visible : .hidden)
        .chartForegroundStyleScale([
            "Income": theme.colors.success,
            "Expenses": theme.colors.error
        ])
        .frame(height: 280)
    }
    
    // MARK: - Formatting Helpers
    
    private func dayOfMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: date)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        
        // Use K notation for thousands
        if abs(value) >= 1000 {
            let thousands = value / 1000
            return "$\(String(format: "%.1f", thousands))K"
        }
        
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

// MARK: - Chart Card Wrapper

/// A card component specifically designed to contain charts with title, subtitle, and metadata
public struct ChartCard<Content: View>: View {
    @Environment(\.theme) private var theme
    
    private let title: String
    private let subtitle: String?
    private let content: Content
    private let metadata: [MetadataItem]
    
    public struct MetadataItem {
        public let label: String
        public let value: String
        public let color: Color?
        
        public init(label: String, value: String, color: Color? = nil) {
            self.label = label
            self.value = value
            self.color = color
        }
    }
    
    public init(
        title: String,
        subtitle: String? = nil,
        metadata: [MetadataItem] = [],
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.subtitle = subtitle
        self.metadata = metadata
        self.content = content()
    }
    
    public var body: some View {
        Card(padding: .lg, shadow: .md, cornerRadius: .lg) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                // Header
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text(title)
                        .font(theme.typography.titleLarge.font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(theme.typography.bodySmall.font)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                }
                
                // Metadata (if provided)
                if !metadata.isEmpty {
                    HStack(spacing: theme.spacing.lg) {
                        ForEach(metadata.indices, id: \.self) { index in
                            metadataView(metadata[index])
                            
                            if index < metadata.count - 1 {
                                Rectangle()
                                    .fill(theme.colors.borderSubtle)
                                    .frame(width: 1)
                            }
                        }
                    }
                    .padding(.vertical, theme.spacing.xs)
                }
                
                // Chart Content
                content
            }
        }
    }
    
    private func metadataView(_ item: MetadataItem) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.xxs) {
            Text(item.label)
                .font(theme.typography.labelSmall.font)
                .foregroundColor(theme.colors.textTertiary)
            
            Text(item.value)
                .font(theme.typography.titleSmall.font)
                .foregroundColor(item.color ?? theme.colors.textPrimary)
        }
    }
}

// MARK: - Demo Data Generator

/// Generates sample data for previews and testing
public struct ChartDemoData {
    public static func generateIncomeData(days: Int = 30) -> [(Date, Double)] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<days).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -days + dayOffset + 1, to: today)!
            
            // Simulate income with some variation
            let baseIncome = 5200.0
            let variation = Double.random(in: -500...800)
            let weekendBonus = calendar.isDateInWeekend(date) ? 0 : Double.random(in: 0...200)
            let value = baseIncome + variation + weekendBonus
            
            return (date, max(0, value))
        }
    }
    
    public static func generateExpenseData(days: Int = 30) -> [(Date, Double)] {
        let calendar = Calendar.current
        let today = Date()
        
        return (0..<days).map { dayOffset in
            let date = calendar.date(byAdding: .day, value: -days + dayOffset + 1, to: today)!
            
            // Simulate expenses with some variation
            let baseExpense = 3400.0
            let variation = Double.random(in: -600...700)
            let weekendSpike = calendar.isDateInWeekend(date) ? Double.random(in: 100...400) : 0
            let value = baseExpense + variation + weekendSpike
            
            return (date, max(0, value))
        }
    }
    
    public static func currentMonthData() -> (income: [(Date, Double)], expenses: [(Date, Double)]) {
        let income = generateIncomeData(days: 30)
        let expenses = generateExpenseData(days: 30)
        return (income, expenses)
    }
}

// MARK: - Basic Preview

#Preview("IncomeExpenseChart - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        let data = ChartDemoData.currentMonthData()
        
        VStack(spacing: 20) {
            IncomeExpenseChart(
                income: data.income,
                expenses: data.expenses
            )
            .padding()
        }
        .background(Color(white: 0.95))
    }
    .frame(width: 800, height: 400)
}

#Preview("ChartCard - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        let data = ChartDemoData.currentMonthData()
        
        ChartCard(
            title: "Income vs Expenses",
            subtitle: "Last 30 days",
            metadata: [
                ChartCard.MetadataItem(
                    label: "Total Income",
                    value: "$156,000",
                    color: VibrantTheme().colors.success
                ),
                ChartCard.MetadataItem(
                    label: "Total Expenses",
                    value: "$102,000",
                    color: VibrantTheme().colors.error
                ),
                ChartCard.MetadataItem(
                    label: "Net",
                    value: "+$54,000",
                    color: VibrantTheme().colors.success
                )
            ]
        ) {
            IncomeExpenseChart(
                income: data.income,
                expenses: data.expenses
            )
        }
        .frame(width: 700)
        .padding(40)
    }
    .background(Color(white: 0.95))
}
