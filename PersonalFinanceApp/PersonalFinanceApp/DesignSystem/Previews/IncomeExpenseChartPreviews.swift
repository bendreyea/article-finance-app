import SwiftUI
import Charts

/// Comprehensive previews for IncomeExpenseChart component
struct IncomeExpenseChartPreviews: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Header
                Text("IncomeExpenseChart Component")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Side-by-side theme comparison
                HStack(alignment: .top, spacing: 24) {
                    VStack {
                        Text("Vibrant Theme")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                        
                        IncomeExpenseChartShowcase()
                            .theme(VibrantTheme())
                    }
                    
                    VStack {
                        Text("Neutral Theme")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 8)
                        
                        IncomeExpenseChartShowcase()
                            .theme(NeutralTheme())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

/// Individual theme showcase for IncomeExpenseChart components
private struct IncomeExpenseChartShowcase: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.lg) {
            // Standard Chart Card
            standardChartSection
            
            // Compact Chart (no legend)
            compactChartSection
            
            // Custom Data Examples
            customDataSection
        }
        .padding(theme.spacing.md)
        .background(theme.colors.background)
        .cornerRadius(theme.radius.xl)
    }
    
    // MARK: - Standard Chart Card
    private var standardChartSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Standard Chart Card")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            IncomeExpenseChart.demoCard(
                title: "Monthly Overview",
                subtitle: "Income vs Expenses - Last 30 days"
            )
        }
    }
    
    // MARK: - Compact Chart (No Legend)
    private var compactChartSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Compact Version")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            ChartCard(title: "Quick View") {
                IncomeExpenseChart(
                    incomeData: IncomeExpenseChart.demoData.income,
                    expenseData: IncomeExpenseChart.demoData.expenses,
                    showLegend: false
                )
            }
        }
    }
    
    // MARK: - Custom Data Examples
    private var customDataSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Custom Data Scenarios")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: theme.spacing.md) {
                // High income scenario
                ChartCard(title: "High Income Period", subtitle: "Growing business") {
                    IncomeExpenseChart(
                        incomeData: generateHighIncomeData(),
                        expenseData: generateModerateExpenseData(),
                        showLegend: false,
                        animationDelay: 0.2
                    )
                }
                
                // Expense control scenario
                ChartCard(title: "Expense Control", subtitle: "Budget optimization") {
                    IncomeExpenseChart(
                        incomeData: generateStableIncomeData(),
                        expenseData: generateLowExpenseData(),
                        showLegend: false,
                        animationDelay: 0.4
                    )
                }
                
                // Break-even scenario
                ChartCard(title: "Break-Even", subtitle: "Balanced period") {
                    IncomeExpenseChart(
                        incomeData: generateBalancedIncomeData(),
                        expenseData: generateBalancedExpenseData(),
                        showLegend: false,
                        animationDelay: 0.6
                    )
                }
                
                // Challenging period
                ChartCard(title: "Challenging Month", subtitle: "Recovery needed") {
                    IncomeExpenseChart(
                        incomeData: generateLowIncomeData(),
                        expenseData: generateHighExpenseData(),
                        showLegend: false,
                        animationDelay: 0.8
                    )
                }
            }
        }
    }
    
    // MARK: - Data Generation Functions
    
    private func generateHighIncomeData() -> [(Date, Double)] {
        generateDateRange().enumerated().map { index, date in
            let baseAmount = 400.0
            let growth = Double(index) * 15.0
            let variation = Double.random(in: -50...100)
            return (date, baseAmount + growth + variation)
        }
    }
    
    private func generateStableIncomeData() -> [(Date, Double)] {
        generateDateRange().map { date in
            let baseAmount = 300.0
            let variation = Double.random(in: -30...50)
            return (date, baseAmount + variation)
        }
    }
    
    private func generateBalancedIncomeData() -> [(Date, Double)] {
        generateDateRange().map { date in
            let baseAmount = 250.0
            let variation = Double.random(in: -40...60)
            return (date, baseAmount + variation)
        }
    }
    
    private func generateLowIncomeData() -> [(Date, Double)] {
        generateDateRange().map { date in
            let baseAmount = 150.0
            let variation = Double.random(in: -30...40)
            return (date, max(50, baseAmount + variation))
        }
    }
    
    private func generateModerateExpenseData() -> [(Date, Double)] {
        generateDateRange().map { date in
            let baseAmount = 180.0
            let variation = Double.random(in: -40...60)
            return (date, baseAmount + variation)
        }
    }
    
    private func generateLowExpenseData() -> [(Date, Double)] {
        generateDateRange().enumerated().map { index, date in
            let baseAmount = 120.0
            let reduction = Double(index) * -2.0 // Decreasing expenses over time
            let variation = Double.random(in: -20...30)
            return (date, max(80, baseAmount + reduction + variation))
        }
    }
    
    private func generateBalancedExpenseData() -> [(Date, Double)] {
        generateDateRange().map { date in
            let baseAmount = 240.0
            let variation = Double.random(in: -50...70)
            return (date, baseAmount + variation)
        }
    }
    
    private func generateHighExpenseData() -> [(Date, Double)] {
        generateDateRange().map { date in
            let baseAmount = 280.0
            let variation = Double.random(in: -40...100)
            return (date, baseAmount + variation)
        }
    }
    
    private func generateDateRange() -> [Date] {
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -19, to: today) ?? today
        
        return (0..<20).compactMap { dayOffset in
            calendar.date(byAdding: .day, value: dayOffset, to: startDate)
        }
    }
}

// MARK: - Interactive Demo
private struct InteractiveChartDemo: View {
    @Environment(\.theme) private var theme
    @State private var selectedPeriod: Period = .month
    @State private var showAnimation = true
    
    enum Period: String, CaseIterable {
        case week = "7 Days"
        case month = "30 Days"
        case quarter = "90 Days"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            Text("Interactive Demo")
                .font(theme.typography.title3Font)
                .foregroundColor(theme.colors.textPrimary)
            
            // Controls
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Time Period")
                    .font(theme.typography.calloutFont)
                    .foregroundColor(theme.colors.textPrimary)
                
                Picker("Period", selection: $selectedPeriod) {
                    ForEach(Period.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                Toggle("Enable Animation", isOn: $showAnimation)
                    .font(theme.typography.calloutFont)
            }
            
            // Chart
            ChartCard(
                title: "Interactive Chart",
                subtitle: selectedPeriod.rawValue
            ) {
                IncomeExpenseChart(
                    incomeData: generateDataForPeriod(selectedPeriod).income,
                    expenseData: generateDataForPeriod(selectedPeriod).expenses,
                    animationDelay: showAnimation ? 0.3 : 0.0
                )
            }
        }
    }
    
    private func generateDataForPeriod(_ period: Period) -> (income: [(Date, Double)], expenses: [(Date, Double)]) {
        let days: Int
        switch period {
        case .week: days = 7
        case .month: days = 30
        case .quarter: days = 90
        }
        
        let calendar = Calendar.current
        let today = Date()
        let startDate = calendar.date(byAdding: .day, value: -days + 1, to: today) ?? today
        
        var incomeData: [(Date, Double)] = []
        var expenseData: [(Date, Double)] = []
        
        for dayOffset in 0..<days {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) else { continue }
            
            let income = 200 + Double.random(in: -50...150)
            let expenses = 150 + Double.random(in: -30...80)
            
            incomeData.append((date, income))
            expenseData.append((date, expenses))
        }
        
        return (incomeData, expenseData)
    }
}

// MARK: - Preview Provider
#Preview("IncomeExpenseChart Comparison") {
    IncomeExpenseChartPreviews()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}

#Preview("Vibrant Theme Only") {
    IncomeExpenseChartShowcase()
        .theme(VibrantTheme())
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}

#Preview("Neutral Theme Only") {
    IncomeExpenseChartShowcase()
        .theme(NeutralTheme())
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}

#Preview("Interactive Demo") {
    InteractiveChartDemo()
        .theme(VibrantTheme())
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.windowBackgroundColor))
}

#Preview("Chart Card Only") {
    VStack(spacing: 24) {
        Text("Chart Card Examples")
            .font(.title)
            .fontWeight(.bold)
        
        IncomeExpenseChart.demoCard()
            .theme(VibrantTheme())
        
        ChartCard(title: "Custom Chart", subtitle: "Last week") {
            IncomeExpenseChart(
                incomeData: [(Date(), 1000), (Date().addingTimeInterval(86400), 1200)],
                expenseData: [(Date(), 800), (Date().addingTimeInterval(86400), 900)],
                showLegend: false
            )
        }
        .theme(NeutralTheme())
    }
    .padding()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color(NSColor.windowBackgroundColor))
}