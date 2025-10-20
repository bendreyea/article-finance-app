import SwiftUI
import Charts

// MARK: - Asset Data Model

/// Asset data point for pie chart
public struct AssetItem: Identifiable, Hashable {
    public let id: UUID
    public let name: String
    public let category: AssetCategory
    public let amount: Double
    
    public init(
        id: UUID = UUID(),
        name: String,
        category: AssetCategory,
        amount: Double
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.amount = amount
    }
}

/// Asset category
public enum AssetCategory: String, CaseIterable, Identifiable {
    case cash = "Cash"
    case investments = "Investments"
    case realEstate = "Real Estate"
    case retirement = "Retirement"
    case vehicles = "Vehicles"
    case other = "Other"
    
    public var id: String { rawValue }
}

// MARK: - Assets Pie Card

/// Pie chart card showing asset distribution
public struct AssetsPieCard: View {
    @Environment(\.theme) private var theme
    
    private let assets: [AssetItem]
    private let showLegend: Bool
    
    private var totalAssets: Double {
        assets.reduce(0) { $0 + $1.amount }
    }
    
    private var assetsByCategory: [(category: String, amount: Double, color: Color)] {
        let grouped = Dictionary(grouping: assets, by: \.category)
        return grouped.map { category, items in
            let total = items.reduce(0) { $0 + $1.amount }
            let index = AssetCategory.allCases.firstIndex(of: category) ?? 0
            let color = theme.colors.chartPrimary[index % theme.colors.chartPrimary.count]
            return (category.rawValue, total, color)
        }
        .sorted { $0.amount > $1.amount }
    }
    
    /// Creates an assets pie card
    /// - Parameters:
    ///   - assets: Array of asset items
    ///   - showLegend: Whether to show the legend (default: true)
    public init(assets: [AssetItem], showLegend: Bool = true) {
        self.assets = assets
        self.showLegend = showLegend
    }
    
    public var body: some View {
        Card(style: .elevated, padding: .large) {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                // Header
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text("Assets Distribution")
                        .font(theme.typography.headingMedium)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Total: \(formatCurrency(totalAssets))")
                        .font(theme.typography.bodyMedium)
                        .foregroundColor(theme.colors.textSecondary)
                }
                
                HStack(alignment: .top, spacing: theme.spacing.xxl) {
                    // Pie Chart with Center Total
                    ZStack {
                        Chart(assetsByCategory, id: \.category) { item in
                            SectorMark(
                                angle: .value("Amount", item.amount),
                                innerRadius: .ratio(0.618),
                                angularInset: 2
                            )
                            .foregroundStyle(item.color)
                            .cornerRadius(4)
                        }
                        .chartLegend(.hidden)
                        .frame(width: 280, height: 280)
                        
                        // Center Total
                        VStack(spacing: theme.spacing.xs) {
                            Text(formatCurrency(totalAssets))
                                .font(theme.typography.displaySmall)
                                .fontWeight(.bold)
                                .foregroundColor(theme.colors.textPrimary)
                            
                            Text("Total Assets")
                                .font(theme.typography.labelMedium)
                                .foregroundColor(theme.colors.textSecondary)
                        }
                    }
                    
                    // External Legend
                    if showLegend {
                        VStack(alignment: .leading, spacing: theme.spacing.md) {
                            ForEach(assetsByCategory, id: \.category) { item in
                                LegendItem(
                                    color: item.color,
                                    label: item.category,
                                    amount: item.amount,
                                    percentage: (item.amount / totalAssets) * 100
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        
        if amount >= 1_000_000 {
            return formatter.string(from: NSNumber(value: amount / 1_000_000))?.appending("M") ?? "$0"
        } else if amount >= 1000 {
            return formatter.string(from: NSNumber(value: amount / 1000))?.appending("K") ?? "$0"
        }
        
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// MARK: - Legend Item

struct LegendItem: View {
    @Environment(\.theme) private var theme
    
    let color: Color
    let label: String
    let amount: Double
    let percentage: Double
    
    var body: some View {
        HStack(spacing: theme.spacing.md) {
            // Color indicator
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .fill(color)
                .frame(width: 16, height: 16)
            
            // Label and amount
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(label)
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.textPrimary)
                
                HStack(spacing: theme.spacing.xs) {
                    Text(formatCurrency(amount))
                        .font(theme.typography.labelMedium)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Text("•")
                        .foregroundColor(theme.colors.textTertiary)
                    
                    Text(String(format: "%.1f%%", percentage))
                        .font(theme.typography.labelMedium)
                        .foregroundColor(theme.colors.textTertiary)
                }
            }
            
            Spacer()
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        
        if amount >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: amount / 1_000_000))?.appending("M") ?? "$0"
        } else if amount >= 1000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: amount / 1000))?.appending("K") ?? "$0"
        }
        
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
}

// MARK: - Goal Data Model

/// Goal data model
public struct GoalItem: Identifiable, Hashable {
    public let id: UUID
    public var name: String
    public var targetAmount: Double
    public var currentAmount: Double
    public var deadline: Date?
    public var category: GoalCategory
    
    public var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
    
    public var isCompleted: Bool {
        currentAmount >= targetAmount
    }
    
    public init(
        id: UUID = UUID(),
        name: String,
        targetAmount: Double,
        currentAmount: Double,
        deadline: Date? = nil,
        category: GoalCategory
    ) {
        self.id = id
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
        self.category = category
    }
}

/// Goal category
public enum GoalCategory: String, CaseIterable, Identifiable {
    case savings = "Savings"
    case investment = "Investment"
    case debtPayoff = "Debt Payoff"
    case purchase = "Purchase"
    case emergency = "Emergency Fund"
    case other = "Other"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .savings: return "banknote"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .debtPayoff: return "creditcard"
        case .purchase: return "cart"
        case .emergency: return "shield.checkered"
        case .other: return "flag"
        }
    }
}

// MARK: - Goals List View

/// List view of financial goals with progress bars and inline editing
public struct GoalsListView: View {
    @Environment(\.theme) private var theme
    
    @State private var goals: [GoalItem]
    @State private var editingGoalId: UUID?
    @State private var editingAmount: String = ""
    
    private let onGoalUpdate: ((GoalItem) -> Void)?
    
    /// Creates a goals list view
    /// - Parameters:
    ///   - goals: Array of goal items
    ///   - onGoalUpdate: Optional callback when a goal is updated
    public init(
        goals: [GoalItem],
        onGoalUpdate: ((GoalItem) -> Void)? = nil
    ) {
        _goals = State(initialValue: goals)
        self.onGoalUpdate = onGoalUpdate
    }
    
    public var body: some View {
        Card(style: .elevated, padding: .large) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: theme.spacing.xs) {
                        Text("Financial Goals")
                            .font(theme.typography.headingMedium)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("\(completedGoalsCount) of \(goals.count) completed")
                            .font(theme.typography.bodySmall)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    
                    Spacer()
                    
                    Button(action: {}) {
                        Label("Add Goal", systemImage: "plus")
                            .font(theme.typography.labelMedium)
                    }
                    .buttonStyle(.plain)
                    .foregroundColor(theme.colors.accentPrimary)
                }
                
                Divider()
                    .background(theme.colors.border)
                
                // Goals List
                ScrollView {
                    VStack(spacing: theme.spacing.lg) {
                        ForEach($goals) { $goal in
                            GoalRow(
                                goal: goal,
                                isEditing: editingGoalId == goal.id,
                                editingAmount: $editingAmount,
                                onEdit: {
                                    startEditing(goal: goal)
                                },
                                onSave: {
                                    saveEdit(goal: &goal)
                                },
                                onCancel: {
                                    cancelEdit()
                                }
                            )
                        }
                    }
                }
            }
        }
    }
    
    private var completedGoalsCount: Int {
        goals.filter(\.isCompleted).count
    }
    
    private func startEditing(goal: GoalItem) {
        editingGoalId = goal.id
        editingAmount = String(format: "%.0f", goal.currentAmount)
    }
    
    private func saveEdit(goal: inout GoalItem) {
        if let amount = Double(editingAmount) {
            goal.currentAmount = amount
            onGoalUpdate?(goal)
        }
        editingGoalId = nil
        editingAmount = ""
    }
    
    private func cancelEdit() {
        editingGoalId = nil
        editingAmount = ""
    }
}

// MARK: - Goal Row

struct GoalRow: View {
    @Environment(\.theme) private var theme
    
    let goal: GoalItem
    let isEditing: Bool
    @Binding var editingAmount: String
    let onEdit: () -> Void
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            // Header row
            HStack(spacing: theme.spacing.md) {
                // Icon
                Circle()
                    .fill(progressColor.opacity(0.15))
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: goal.category.icon)
                            .foregroundColor(progressColor)
                            .font(.system(size: 18))
                    )
                
                // Goal info
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    HStack {
                        Text(goal.name)
                            .font(theme.typography.bodyLarge)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        if goal.isCompleted {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(theme.colors.success)
                                .font(theme.typography.bodyMedium)
                        }
                    }
                    
                    HStack(spacing: theme.spacing.xs) {
                        Text(goal.category.rawValue)
                            .font(theme.typography.labelSmall)
                            .foregroundColor(theme.colors.textTertiary)
                        
                        if let deadline = goal.deadline {
                            Text("•")
                                .foregroundColor(theme.colors.textTertiary)
                            Text("Due \(formatDeadline(deadline))")
                                .font(theme.typography.labelSmall)
                                .foregroundColor(theme.colors.textTertiary)
                        }
                    }
                }
                
                Spacer()
                
                // Amount display or editor
                if isEditing {
                    HStack(spacing: theme.spacing.sm) {
                        TextField("Amount", text: $editingAmount)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 100)
                            .font(theme.typography.bodyMedium)
                        
                        Button(action: onSave) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(theme.colors.success)
                        }
                        .buttonStyle(.plain)
                        
                        Button(action: onCancel) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(theme.colors.textTertiary)
                        }
                        .buttonStyle(.plain)
                    }
                } else {
                    VStack(alignment: .trailing, spacing: theme.spacing.xxs) {
                        Text(formatCurrency(goal.currentAmount))
                            .font(theme.typography.bodyLarge)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("of \(formatCurrency(goal.targetAmount))")
                            .font(theme.typography.labelSmall)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    .onTapGesture {
                        onEdit()
                    }
                }
            }
            
            // Progress bar
            ProgressBar(
                progress: goal.progress,
                color: progressColor,
                showPercentage: true
            )
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surface)
        .cornerRadius(theme.radius.lg)
        .overlay(
            RoundedRectangle(cornerRadius: theme.radius.lg)
                .stroke(theme.colors.borderSubtle, lineWidth: 1)
        )
    }
    
    private var progressColor: Color {
        if goal.isCompleted {
            return theme.colors.success
        } else if goal.progress >= 0.75 {
            return theme.colors.info
        } else if goal.progress >= 0.5 {
            return theme.colors.accentPrimary
        } else if goal.progress >= 0.25 {
            return theme.colors.warning
        } else {
            return theme.colors.error
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: amount)) ?? "$0"
    }
    
    private func formatDeadline(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

// MARK: - Progress Bar

struct ProgressBar: View {
    @Environment(\.theme) private var theme
    
    let progress: Double
    let color: Color
    let showPercentage: Bool
    
    init(progress: Double, color: Color, showPercentage: Bool = false) {
        self.progress = progress
        self.color = color
        self.showPercentage = showPercentage
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: theme.radius.full)
                        .fill(theme.colors.backgroundTertiary)
                        .frame(height: 8)
                    
                    // Progress
                    RoundedRectangle(cornerRadius: theme.radius.full)
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: 8)
                        .animation(.spring(response: 0.6, dampingFraction: 0.8), value: progress)
                }
            }
            .frame(height: 8)
            
            if showPercentage {
                Text(String(format: "%.0f%% Complete", progress * 100))
                    .font(theme.typography.labelSmall)
                    .foregroundColor(theme.colors.textTertiary)
            }
        }
    }
}

// MARK: - Demo Data

extension AssetItem {
    static func generateDemoData() -> [AssetItem] {
        [
            AssetItem(name: "Savings Account", category: .cash, amount: 15000),
            AssetItem(name: "Checking Account", category: .cash, amount: 5000),
            AssetItem(name: "Stocks", category: .investments, amount: 45000),
            AssetItem(name: "Bonds", category: .investments, amount: 20000),
            AssetItem(name: "Primary Residence", category: .realEstate, amount: 350000),
            AssetItem(name: "401(k)", category: .retirement, amount: 125000),
            AssetItem(name: "IRA", category: .retirement, amount: 75000),
            AssetItem(name: "Car", category: .vehicles, amount: 25000),
            AssetItem(name: "Motorcycle", category: .vehicles, amount: 8000),
        ]
    }
}

extension GoalItem {
    static func generateDemoData() -> [GoalItem] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            GoalItem(
                name: "Emergency Fund",
                targetAmount: 10000,
                currentAmount: 7500,
                deadline: calendar.date(byAdding: .month, value: 6, to: today),
                category: .emergency
            ),
            GoalItem(
                name: "New Car Down Payment",
                targetAmount: 15000,
                currentAmount: 12000,
                deadline: calendar.date(byAdding: .month, value: 8, to: today),
                category: .purchase
            ),
            GoalItem(
                name: "Vacation Fund",
                targetAmount: 5000,
                currentAmount: 5000,
                deadline: calendar.date(byAdding: .month, value: 2, to: today),
                category: .savings
            ),
            GoalItem(
                name: "Pay Off Credit Card",
                targetAmount: 8000,
                currentAmount: 4500,
                deadline: calendar.date(byAdding: .month, value: 12, to: today),
                category: .debtPayoff
            ),
            GoalItem(
                name: "Investment Portfolio",
                targetAmount: 50000,
                currentAmount: 18000,
                deadline: calendar.date(byAdding: .year, value: 2, to: today),
                category: .investment
            ),
            GoalItem(
                name: "Home Renovation",
                targetAmount: 25000,
                currentAmount: 3500,
                deadline: calendar.date(byAdding: .year, value: 1, to: today),
                category: .purchase
            ),
        ]
    }
}

// MARK: - Previews

#Preview("Assets Pie Card - Vibrant") {
    AssetsPieCard(assets: AssetItem.generateDemoData())
        .themed(VibrantTheme())
        .frame(width: 700, height: 450)
        .padding()
}

#Preview("Assets Pie Card - Neutral") {
    AssetsPieCard(assets: AssetItem.generateDemoData())
        .themed(NeutralTheme())
        .frame(width: 700, height: 450)
        .padding()
}

#Preview("Goals List - Vibrant") {
    GoalsListView(goals: GoalItem.generateDemoData()) { goal in
        print("Updated goal: \(goal.name) to \(goal.currentAmount)")
    }
    .themed(VibrantTheme())
    .frame(width: 600, height: 700)
    .padding()
}

#Preview("Goals List - Neutral") {
    GoalsListView(goals: GoalItem.generateDemoData())
        .themed(NeutralTheme())
        .frame(width: 600, height: 700)
        .padding()
}

#Preview("Side-by-Side Themes") {
    HStack(spacing: 40) {
        VStack(spacing: 30) {
            AssetsPieCard(assets: AssetItem.generateDemoData())
            GoalsListView(goals: GoalItem.generateDemoData())
        }
        .themed(VibrantTheme())
        
        VStack(spacing: 30) {
            AssetsPieCard(assets: AssetItem.generateDemoData())
            GoalsListView(goals: GoalItem.generateDemoData())
        }
        .themed(NeutralTheme())
    }
    .padding(40)
    .frame(width: 1600, height: 1200)
}

#Preview("Combined Dashboard") {
    AssetsDashboard()
        .themed(VibrantTheme())
        .frame(width: 1200, height: 900)
}

// MARK: - Example Dashboard

struct AssetsDashboard: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        Text("Assets & Goals")
                            .font(theme.typography.displaySmall)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("Track your wealth and financial objectives")
                            .font(theme.typography.bodyMedium)
                            .foregroundColor(theme.colors.textSecondary)
                    }
                    
                    Spacer()
                }
                
                // Assets and Goals
                HStack(alignment: .top, spacing: theme.spacing.xl) {
                    AssetsPieCard(assets: AssetItem.generateDemoData())
                        .frame(maxWidth: .infinity)
                    
                    GoalsListView(goals: GoalItem.generateDemoData())
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(theme.spacing.xxl)
        }
        .background(theme.colors.background)
    }
}
