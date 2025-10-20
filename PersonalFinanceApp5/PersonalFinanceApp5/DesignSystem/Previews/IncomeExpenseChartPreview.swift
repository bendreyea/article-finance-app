import SwiftUI
import Charts

/// Comprehensive previews for IncomeExpenseChart and ChartCard components
struct IncomeExpenseChartShowcase: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xxl) {
                // Header
                VStack(spacing: theme.spacing.xs) {
                    Text("Income & Expense Chart")
                        .font(theme.typography.displaySmall.font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Swift Charts with smoothed lines and area fills")
                        .font(theme.typography.bodyMedium.font)
                        .foregroundColor(theme.colors.textSecondary)
                }
                .padding(.top, theme.spacing.xl)
                
                // Basic Chart
                basicChartSection
                
                // Chart Card with Metadata
                chartCardSection
                
                // Different Time Periods
                timePeriodSection
                
                // Dashboard Integration
                dashboardSection
            }
            .padding(theme.spacing.xl)
        }
        .background(theme.colors.background)
    }
    
    // MARK: - Basic Chart
    
    private var basicChartSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Basic Chart")
                .font(theme.typography.titleLarge.font)
                .foregroundColor(theme.colors.textPrimary)
            
            Card(padding: .lg, shadow: .md, cornerRadius: .lg) {
                let data = ChartDemoData.currentMonthData()
                IncomeExpenseChart(
                    income: data.income,
                    expenses: data.expenses
                )
            }
        }
    }
    
    // MARK: - Chart Card
    
    private var chartCardSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Chart Card with Metadata")
                .font(theme.typography.titleLarge.font)
                .foregroundColor(theme.colors.textPrimary)
            
            let data = ChartDemoData.currentMonthData()
            let totalIncome = data.income.reduce(0) { $0 + $1.1 }
            let totalExpenses = data.expenses.reduce(0) { $0 + $1.1 }
            let net = totalIncome - totalExpenses
            
            ChartCard(
                title: "Income vs Expenses",
                subtitle: "Last 30 days • October 2025",
                metadata: [
                    ChartCard.MetadataItem(
                        label: "Total Income",
                        value: formatCurrency(totalIncome),
                        color: theme.colors.success
                    ),
                    ChartCard.MetadataItem(
                        label: "Total Expenses",
                        value: formatCurrency(totalExpenses),
                        color: theme.colors.error
                    ),
                    ChartCard.MetadataItem(
                        label: "Net Savings",
                        value: formatCurrency(net),
                        color: net >= 0 ? theme.colors.success : theme.colors.error
                    )
                ]
            ) {
                IncomeExpenseChart(
                    income: data.income,
                    expenses: data.expenses
                )
            }
        }
    }
    
    // MARK: - Time Periods
    
    private var timePeriodSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Different Time Periods")
                .font(theme.typography.titleLarge.font)
                .foregroundColor(theme.colors.textPrimary)
            
            HStack(alignment: .top, spacing: theme.spacing.md) {
                // 7 days
                ChartCard(
                    title: "Last 7 Days",
                    subtitle: "Weekly trend"
                ) {
                    let data7 = (
                        income: ChartDemoData.generateIncomeData(days: 7),
                        expenses: ChartDemoData.generateExpenseData(days: 7)
                    )
                    IncomeExpenseChart(
                        income: data7.income,
                        expenses: data7.expenses
                    )
                }
                .frame(maxWidth: .infinity)
                
                // 14 days
                ChartCard(
                    title: "Last 14 Days",
                    subtitle: "Bi-weekly trend"
                ) {
                    let data14 = (
                        income: ChartDemoData.generateIncomeData(days: 14),
                        expenses: ChartDemoData.generateExpenseData(days: 14)
                    )
                    IncomeExpenseChart(
                        income: data14.income,
                        expenses: data14.expenses
                    )
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
    
    // MARK: - Dashboard
    
    private var dashboardSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Dashboard Integration")
                .font(theme.typography.titleLarge.font)
                .foregroundColor(theme.colors.textPrimary)
            
            HStack(alignment: .top, spacing: theme.spacing.md) {
                // Main Chart
                VStack(spacing: theme.spacing.md) {
                    let data = ChartDemoData.currentMonthData()
                    let totalIncome = data.income.reduce(0) { $0 + $1.1 }
                    let totalExpenses = data.expenses.reduce(0) { $0 + $1.1 }
                    let net = totalIncome - totalExpenses
                    let avgIncome = totalIncome / Double(data.income.count)
                    let avgExpense = totalExpenses / Double(data.expenses.count)
                    
                    ChartCard(
                        title: "Monthly Overview",
                        subtitle: "Income & Expenses Trend",
                        metadata: [
                            ChartCard.MetadataItem(
                                label: "Income",
                                value: formatCurrency(totalIncome),
                                color: theme.colors.success
                            ),
                            ChartCard.MetadataItem(
                                label: "Expenses",
                                value: formatCurrency(totalExpenses),
                                color: theme.colors.error
                            ),
                            ChartCard.MetadataItem(
                                label: "Net",
                                value: formatCurrency(net),
                                color: net >= 0 ? theme.colors.success : theme.colors.error
                            )
                        ]
                    ) {
                        IncomeExpenseChart(
                            income: data.income,
                            expenses: data.expenses
                        )
                    }
                    
                    // Summary Stats
                    HStack(spacing: theme.spacing.md) {
                        summaryCard(
                            title: "Avg Daily Income",
                            value: formatCurrency(avgIncome),
                            icon: "arrow.up.circle.fill",
                            color: theme.colors.success
                        )
                        
                        summaryCard(
                            title: "Avg Daily Expense",
                            value: formatCurrency(avgExpense),
                            icon: "arrow.down.circle.fill",
                            color: theme.colors.error
                        )
                        
                        summaryCard(
                            title: "Savings Rate",
                            value: "\(Int((net / totalIncome) * 100))%",
                            icon: "chart.line.uptrend.xyaxis",
                            color: theme.colors.primary
                        )
                    }
                }
                
                // Side Stats
                VStack(spacing: theme.spacing.md) {
                    Card(padding: .lg, shadow: .sm, cornerRadius: .md) {
                        VStack(alignment: .leading, spacing: theme.spacing.md) {
                            HStack {
                                Image(systemName: "calendar")
                                    .foregroundColor(theme.colors.primary)
                                Text("This Month")
                                    .font(theme.typography.titleMedium.font)
                                    .foregroundColor(theme.colors.textPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                                statRow(label: "Days Tracked", value: "30")
                                statRow(label: "Positive Days", value: "22")
                                statRow(label: "Best Day", value: "$1,850")
                                statRow(label: "Worst Day", value: "-$450")
                            }
                        }
                    }
                    
                    Card(padding: .lg, shadow: .sm, cornerRadius: .md) {
                        VStack(alignment: .leading, spacing: theme.spacing.md) {
                            HStack {
                                Image(systemName: "chart.bar.fill")
                                    .foregroundColor(theme.colors.primary)
                                Text("Trends")
                                    .font(theme.typography.titleMedium.font)
                                    .foregroundColor(theme.colors.textPrimary)
                            }
                            
                            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                                trendRow(
                                    label: "Income",
                                    value: "+8.5%",
                                    isPositive: true
                                )
                                trendRow(
                                    label: "Expenses",
                                    value: "-5.2%",
                                    isPositive: true
                                )
                                trendRow(
                                    label: "Net Savings",
                                    value: "+15.3%",
                                    isPositive: true
                                )
                            }
                        }
                    }
                }
                .frame(width: 280)
            }
        }
    }
    
    // MARK: - Helper Views
    
    private func summaryCard(title: String, value: String, icon: String, color: Color) -> some View {
        Card(padding: .md, shadow: .sm, cornerRadius: .md) {
            VStack(spacing: theme.spacing.xs) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(color)
                
                Text(value)
                    .font(theme.typography.titleMedium.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                Text(title)
                    .font(theme.typography.labelSmall.font)
                    .foregroundColor(theme.colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func statRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(theme.typography.bodySmall.font)
                .foregroundColor(theme.colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(theme.typography.bodyMedium.font)
                .foregroundColor(theme.colors.textPrimary)
        }
    }
    
    private func trendRow(label: String, value: String, isPositive: Bool) -> some View {
        HStack {
            Text(label)
                .font(theme.typography.bodySmall.font)
                .foregroundColor(theme.colors.textSecondary)
            
            Spacer()
            
            HStack(spacing: theme.spacing.xxs) {
                Image(systemName: isPositive ? "arrow.up" : "arrow.down")
                    .font(.system(size: 10, weight: .bold))
                Text(value)
                    .font(theme.typography.bodyMedium.font)
            }
            .foregroundColor(isPositive ? theme.colors.success : theme.colors.error)
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

// MARK: - Theme Comparison

struct IncomeExpenseChartComparison: View {
    var body: some View {
        HStack(spacing: 40) {
            // Vibrant Theme
            VStack(spacing: 20) {
                Text("Vibrant Theme")
                    .font(.system(size: 24, weight: .bold))
                
                ThemeProvider(theme: VibrantTheme()) {
                    comparisonContent
                }
            }
            
            // Neutral Theme
            VStack(spacing: 20) {
                Text("Neutral Theme")
                    .font(.system(size: 24, weight: .bold))
                
                ThemeProvider(theme: NeutralTheme()) {
                    comparisonContent
                }
            }
        }
        .padding(40)
        .background(Color(white: 0.95))
    }
    
    @ViewBuilder
    private var comparisonContent: some View {
        let data = ChartDemoData.currentMonthData()
        let totalIncome = data.income.reduce(0) { $0 + $1.1 }
        let totalExpenses = data.expenses.reduce(0) { $0 + $1.1 }
        let net = totalIncome - totalExpenses
        
        ChartCard(
            title: "Income vs Expenses",
            subtitle: "Last 30 days",
            metadata: [
                ChartCard.MetadataItem(
                    label: "Income",
                    value: formatCurrency(totalIncome),
                    color: nil
                ),
                ChartCard.MetadataItem(
                    label: "Expenses",
                    value: formatCurrency(totalExpenses),
                    color: nil
                ),
                ChartCard.MetadataItem(
                    label: "Net",
                    value: formatCurrency(net),
                    color: nil
                )
            ]
        ) {
            IncomeExpenseChart(
                income: data.income,
                expenses: data.expenses
            )
        }
        .frame(width: 550)
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
}

// MARK: - Interactive Demo

struct IncomeExpenseChartInteractive: View {
    @Environment(\.theme) private var theme
    @State private var days: Double = 30
    
    var body: some View {
        VStack(spacing: theme.spacing.xl) {
            Text("Interactive Chart Demo")
                .font(theme.typography.titleLarge.font)
                .foregroundColor(theme.colors.textPrimary)
            
            let data = (
                income: ChartDemoData.generateIncomeData(days: Int(days)),
                expenses: ChartDemoData.generateExpenseData(days: Int(days))
            )
            
            ChartCard(
                title: "Income vs Expenses",
                subtitle: "Last \(Int(days)) days"
            ) {
                IncomeExpenseChart(
                    income: data.income,
                    expenses: data.expenses
                )
            }
            .frame(width: 700)
            
            VStack(spacing: theme.spacing.md) {
                HStack {
                    Text("Time Period: \(Int(days)) days")
                        .font(theme.typography.bodyMedium.font)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Spacer()
                }
                
                Slider(value: $days, in: 7...90, step: 1)
                    .frame(width: 600)
                
                HStack(spacing: theme.spacing.md) {
                    Button("7 Days") { days = 7 }
                    Button("14 Days") { days = 14 }
                    Button("30 Days") { days = 30 }
                    Button("60 Days") { days = 60 }
                    Button("90 Days") { days = 90 }
                }
            }
            .padding(theme.spacing.lg)
        }
        .padding(theme.spacing.xxl)
        .background(theme.colors.background)
    }
}

// MARK: - Previews

#Preview("Showcase - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        IncomeExpenseChartShowcase()
    }
    .frame(width: 1400, height: 1600)
}

#Preview("Showcase - Neutral") {
    ThemeProvider(theme: NeutralTheme()) {
        IncomeExpenseChartShowcase()
    }
    .frame(width: 1400, height: 1600)
}

#Preview("Theme Comparison") {
    IncomeExpenseChartComparison()
        .frame(width: 1300, height: 600)
}

#Preview("Interactive Demo - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        IncomeExpenseChartInteractive()
    }
    .frame(width: 900, height: 700)
}

#Preview("Interactive Demo - Neutral") {
    ThemeProvider(theme: NeutralTheme()) {
        IncomeExpenseChartInteractive()
    }
    .frame(width: 900, height: 700)
}

#Preview("Simple Chart Card") {
    ThemeProvider(theme: VibrantTheme()) {
        let data = ChartDemoData.currentMonthData()
        
        ChartCard(
            title: "Income vs Expenses",
            subtitle: "October 2025"
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
