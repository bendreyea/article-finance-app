import SwiftUI

// MARK: - Goal Item Model

/// Data model for a financial goal
public struct GoalItem: Identifiable, Hashable {
    public let id: UUID
    public var name: String
    public var targetAmount: Double
    public var currentAmount: Double
    public var targetDate: Date
    public var category: String
    public var priority: GoalPriority
    public var notes: String?
    
    public init(
        id: UUID = UUID(),
        name: String,
        targetAmount: Double,
        currentAmount: Double,
        targetDate: Date,
        category: String,
        priority: GoalPriority = .medium,
        notes: String? = nil
    ) {
        self.id = id
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.targetDate = targetDate
        self.category = category
        self.priority = priority
        self.notes = notes
    }
    
    public var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
    
    public var isCompleted: Bool {
        currentAmount >= targetAmount
    }
    
    public var remainingAmount: Double {
        max(targetAmount - currentAmount, 0)
    }
}

// MARK: - Goal Priority

/// Priority levels for goals
public enum GoalPriority: String, CaseIterable, Codable {
    case high
    case medium
    case low
    
    public var displayName: String {
        rawValue.capitalized
    }
}

// MARK: - Progress Bar

/// A reusable progress bar component
public struct ProgressBar: View {
    @Environment(\.theme) private var theme
    
    let progress: Double
    let height: CGFloat
    let showPercentage: Bool
    
    public init(
        progress: Double,
        height: CGFloat = 8,
        showPercentage: Bool = false
    ) {
        self.progress = min(max(progress, 0), 1)
        self.height = height
        self.showPercentage = showPercentage
    }
    
    public var body: some View {
        HStack(spacing: theme.spacing.sm) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(theme.colors.backgroundTertiary)
                        .frame(height: height)
                    
                    // Progress Fill
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(progressGradient)
                        .frame(
                            width: geometry.size.width * progress,
                            height: height
                        )
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: height)
            
            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(theme.typography.labelSmall.font)
                    .foregroundColor(theme.colors.textSecondary)
                    .monospacedDigit()
                    .frame(width: 40, alignment: .trailing)
            }
        }
    }
    
    private var progressGradient: LinearGradient {
        let color = progressColor
        return LinearGradient(
            colors: [color, color.opacity(0.8)],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private var progressColor: Color {
        if progress >= 1.0 {
            return theme.colors.success
        } else if progress >= 0.75 {
            return theme.colors.primary
        } else if progress >= 0.5 {
            return theme.colors.info
        } else if progress >= 0.25 {
            return theme.colors.warning
        } else {
            return theme.colors.error
        }
    }
}

// MARK: - Goals List View

/// A list view displaying financial goals with inline editing
public struct GoalsListView: View {
    @Environment(\.theme) private var theme
    
    // Data
    @Binding var goals: [GoalItem]
    let onGoalUpdate: (GoalItem) -> Void
    let onGoalDelete: (GoalItem) -> Void
    
    // State
    @State private var editingGoalId: UUID?
    @State private var editName: String = ""
    @State private var editCurrentAmount: String = ""
    @State private var sortOrder: SortOrder = .priority
    
    public init(
        goals: Binding<[GoalItem]>,
        onGoalUpdate: @escaping (GoalItem) -> Void = { _ in },
        onGoalDelete: @escaping (GoalItem) -> Void = { _ in }
    ) {
        self._goals = goals
        self.onGoalUpdate = onGoalUpdate
        self.onGoalDelete = onGoalDelete
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(spacing: 0) {
            // Header
            header
            
            Divider()
                .background(theme.colors.border)
            
            // Goals List
            ScrollView {
                VStack(spacing: theme.spacing.md) {
                    ForEach(sortedGoals) { goal in
                        goalCard(goal)
                    }
                    
                    if goals.isEmpty {
                        emptyState
                    }
                }
                .padding(theme.spacing.lg)
            }
        }
        .background(theme.colors.background)
    }
    
    // MARK: - Header
    
    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text("Financial Goals")
                    .font(theme.typography.titleLarge.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                Text("\(goals.count) goals • \(completedCount) completed")
                    .font(theme.typography.labelMedium.font)
                    .foregroundColor(theme.colors.textSecondary)
            }
            
            Spacer()
            
            // Sort Menu
            Menu {
                Button("Priority") { sortOrder = .priority }
                Button("Progress") { sortOrder = .progress }
                Button("Target Date") { sortOrder = .date }
                Button("Amount") { sortOrder = .amount }
            } label: {
                HStack(spacing: theme.spacing.xs) {
                    Text("Sort: \(sortOrder.displayName)")
                        .font(theme.typography.bodySmall.font)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(theme.colors.textTertiary)
                }
                .padding(.horizontal, theme.spacing.sm)
                .padding(.vertical, theme.spacing.xs)
                .background(theme.colors.backgroundSecondary)
                .cornerRadius(theme.radius.sm)
            }
            .buttonStyle(.plain)
        }
        .padding(theme.spacing.lg)
        .background(theme.colors.surface)
    }
    
    // MARK: - Goal Card
    
    private func goalCard(_ goal: GoalItem) -> some View {
        Card(shadow: .sm) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                // Top Row - Name and Priority
                HStack(alignment: .top) {
                    if editingGoalId == goal.id {
                        // Editing Mode
                        TextField("Goal name", text: $editName)
                            .textFieldStyle(.plain)
                            .font(theme.typography.titleMedium.font)
                            .foregroundColor(theme.colors.textPrimary)
                    } else {
                        // Display Mode
                        HStack(spacing: theme.spacing.sm) {
                            if goal.isCompleted {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(theme.colors.success)
                            }
                            
                            Text(goal.name)
                                .font(theme.typography.titleMedium.font)
                                .foregroundColor(theme.colors.textPrimary)
                        }
                    }
                    
                    Spacer()
                    
                    priorityBadge(goal.priority)
                }
                
                // Progress Bar
                ProgressBar(
                    progress: goal.progress,
                    height: 10,
                    showPercentage: true
                )
                
                // Amount Info
                HStack {
                    VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                        Text("Current")
                            .font(theme.typography.labelSmall.font)
                            .foregroundColor(theme.colors.textTertiary)
                        
                        if editingGoalId == goal.id {
                            HStack(spacing: theme.spacing.xs) {
                                Text("$")
                                    .font(theme.typography.bodyMedium.font)
                                    .foregroundColor(theme.colors.textSecondary)
                                
                                TextField("0", text: $editCurrentAmount)
                                    .textFieldStyle(.plain)
                                    .font(theme.typography.bodyMedium.font)
                                    .foregroundColor(theme.colors.textPrimary)
                                    .frame(width: 80)
                            }
                        } else {
                            Text(formatCurrency(goal.currentAmount))
                                .font(theme.typography.bodyMedium.font)
                                .foregroundColor(theme.colors.textPrimary)
                                .monospacedDigit()
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: theme.spacing.xxs) {
                        Text("Target")
                            .font(theme.typography.labelSmall.font)
                            .foregroundColor(theme.colors.textTertiary)
                        
                        Text(formatCurrency(goal.targetAmount))
                            .font(theme.typography.bodyMedium.font)
                            .foregroundColor(theme.colors.textPrimary)
                            .monospacedDigit()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: theme.spacing.xxs) {
                        Text("Remaining")
                            .font(theme.typography.labelSmall.font)
                            .foregroundColor(theme.colors.textTertiary)
                        
                        Text(formatCurrency(goal.remainingAmount))
                            .font(theme.typography.bodyMedium.font)
                            .foregroundColor(theme.colors.primary)
                            .monospacedDigit()
                    }
                }
                
                // Bottom Row - Category, Date, Actions
                HStack {
                    HStack(spacing: theme.spacing.sm) {
                        Image(systemName: iconForCategory(goal.category))
                            .font(.system(size: 12))
                            .foregroundColor(theme.colors.textTertiary)
                        
                        Text(goal.category)
                            .font(theme.typography.labelMedium.font)
                            .foregroundColor(theme.colors.textSecondary)
                        
                        Text("•")
                            .foregroundColor(theme.colors.textTertiary)
                        
                        Text(formatDate(goal.targetDate))
                            .font(theme.typography.labelMedium.font)
                            .foregroundColor(theme.colors.textSecondary)
                        
                        if daysUntilTarget(goal.targetDate) >= 0 {
                            Text("(\(daysUntilTarget(goal.targetDate)) days)")
                                .font(theme.typography.labelSmall.font)
                                .foregroundColor(theme.colors.textTertiary)
                        }
                    }
                    
                    Spacer()
                    
                    // Action Buttons
                    HStack(spacing: theme.spacing.xs) {
                        if editingGoalId == goal.id {
                            // Save Button
                            Button(action: { saveGoal(goal) }) {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(theme.colors.success)
                            }
                            .buttonStyle(.plain)
                            
                            // Cancel Button
                            Button(action: { cancelEdit() }) {
                                Image(systemName: "xmark")
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundColor(theme.colors.error)
                            }
                            .buttonStyle(.plain)
                        } else {
                            // Edit Button
                            Button(action: { startEditing(goal) }) {
                                Image(systemName: "pencil")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(theme.colors.textSecondary)
                            }
                            .buttonStyle(.plain)
                            
                            // Delete Button
                            Button(action: { deleteGoal(goal) }) {
                                Image(systemName: "trash")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(theme.colors.error)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(theme.spacing.lg)
        }
    }
    
    // MARK: - Priority Badge
    
    private func priorityBadge(_ priority: GoalPriority) -> some View {
        HStack(spacing: theme.spacing.xxs) {
            Circle()
                .fill(priorityColor(priority))
                .frame(width: 6, height: 6)
            
            Text(priority.displayName)
                .font(theme.typography.labelSmall.font)
                .foregroundColor(priorityColor(priority))
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.vertical, theme.spacing.xxs)
        .background(priorityColor(priority).opacity(0.1))
        .cornerRadius(theme.radius.sm)
    }
    
    private func priorityColor(_ priority: GoalPriority) -> Color {
        switch priority {
        case .high: return theme.colors.error
        case .medium: return theme.colors.warning
        case .low: return theme.colors.info
        }
    }
    
    // MARK: - Empty State
    
    private var emptyState: some View {
        VStack(spacing: theme.spacing.md) {
            Image(systemName: "target")
                .font(.system(size: 48))
                .foregroundColor(theme.colors.textTertiary)
            
            Text("No Goals Yet")
                .font(theme.typography.titleMedium.font)
                .foregroundColor(theme.colors.textPrimary)
            
            Text("Create your first financial goal to start tracking your progress")
                .font(theme.typography.bodyMedium.font)
                .foregroundColor(theme.colors.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
        }
        .padding(theme.spacing.xxl)
    }
    
    // MARK: - Computed Properties
    
    private var sortedGoals: [GoalItem] {
        switch sortOrder {
        case .priority:
            return goals.sorted { lhs, rhs in
                if lhs.priority == rhs.priority {
                    return lhs.progress < rhs.progress
                }
                return priorityValue(lhs.priority) > priorityValue(rhs.priority)
            }
        case .progress:
            return goals.sorted { $0.progress < $1.progress }
        case .date:
            return goals.sorted { $0.targetDate < $1.targetDate }
        case .amount:
            return goals.sorted { $0.targetAmount > $1.targetAmount }
        }
    }
    
    private var completedCount: Int {
        goals.filter { $0.isCompleted }.count
    }
    
    // MARK: - Actions
    
    private func startEditing(_ goal: GoalItem) {
        editingGoalId = goal.id
        editName = goal.name
        editCurrentAmount = String(format: "%.0f", goal.currentAmount)
    }
    
    private func cancelEdit() {
        editingGoalId = nil
        editName = ""
        editCurrentAmount = ""
    }
    
    private func saveGoal(_ goal: GoalItem) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }) else { return }
        
        var updatedGoal = goal
        updatedGoal.name = editName.isEmpty ? goal.name : editName
        
        if let amount = Double(editCurrentAmount) {
            updatedGoal.currentAmount = amount
        }
        
        goals[index] = updatedGoal
        onGoalUpdate(updatedGoal)
        cancelEdit()
    }
    
    private func deleteGoal(_ goal: GoalItem) {
        goals.removeAll { $0.id == goal.id }
        onGoalDelete(goal)
    }
    
    // MARK: - Helpers
    
    private func priorityValue(_ priority: GoalPriority) -> Int {
        switch priority {
        case .high: return 3
        case .medium: return 2
        case .low: return 1
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        if value >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value / 1_000_000))?.replacingOccurrences(of: ".0", with: "") ?? "$0" + "M"
        } else if value >= 1_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: value / 1_000))?.replacingOccurrences(of: ".0", with: "") ?? "$0" + "K"
        } else {
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: value)) ?? "$0"
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func daysUntilTarget(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: date)
        return components.day ?? 0
    }
    
    private func iconForCategory(_ category: String) -> String {
        switch category.lowercased() {
        case "emergency fund": return "shield.fill"
        case "retirement": return "chart.line.uptrend.xyaxis"
        case "vacation": return "airplane"
        case "home": return "house.fill"
        case "education": return "graduationcap.fill"
        case "car": return "car.fill"
        case "investment": return "chart.bar.fill"
        default: return "target"
        }
    }
}

// MARK: - Sort Order

enum SortOrder {
    case priority
    case progress
    case date
    case amount
    
    var displayName: String {
        switch self {
        case .priority: return "Priority"
        case .progress: return "Progress"
        case .date: return "Date"
        case .amount: return "Amount"
        }
    }
}

// MARK: - Goal Demo Data Generator

/// Generates sample goal data for previews and testing
public struct GoalDemoData {
    public static func generateGoals() -> [GoalItem] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            GoalItem(
                name: "Emergency Fund",
                targetAmount: 10_000,
                currentAmount: 7_500,
                targetDate: calendar.date(byAdding: .month, value: 6, to: today)!,
                category: "Emergency Fund",
                priority: .high,
                notes: "6 months of expenses"
            ),
            GoalItem(
                name: "Dream Vacation to Japan",
                targetAmount: 8_000,
                currentAmount: 3_200,
                targetDate: calendar.date(byAdding: .year, value: 1, to: today)!,
                category: "Vacation",
                priority: .medium,
                notes: "2 weeks in Tokyo and Kyoto"
            ),
            GoalItem(
                name: "Down Payment",
                targetAmount: 50_000,
                currentAmount: 22_000,
                targetDate: calendar.date(byAdding: .year, value: 2, to: today)!,
                category: "Home",
                priority: .high,
                notes: "20% down payment for house"
            ),
            GoalItem(
                name: "New Car",
                targetAmount: 15_000,
                currentAmount: 14_800,
                targetDate: calendar.date(byAdding: .month, value: 3, to: today)!,
                category: "Car",
                priority: .medium,
                notes: "Replace current vehicle"
            ),
            GoalItem(
                name: "Master's Degree",
                targetAmount: 30_000,
                currentAmount: 5_000,
                targetDate: calendar.date(byAdding: .year, value: 3, to: today)!,
                category: "Education",
                priority: .low,
                notes: "Part-time MBA program"
            ),
            GoalItem(
                name: "Retirement Boost",
                targetAmount: 100_000,
                currentAmount: 15_000,
                targetDate: calendar.date(byAdding: .year, value: 5, to: today)!,
                category: "Retirement",
                priority: .high,
                notes: "Additional retirement savings"
            )
        ]
    }
}

// MARK: - Preview

#Preview("Goals List - Vibrant") {
    @Previewable @State var goals = GoalDemoData.generateGoals()
    
    ThemeProvider(theme: VibrantTheme()) {
        GoalsListView(
            goals: $goals,
            onGoalUpdate: { goal in
                print("Updated: \(goal.name)")
            },
            onGoalDelete: { goal in
                print("Deleted: \(goal.name)")
            }
        )
        .frame(width: 800, height: 900)
    }
}

#Preview("Progress Bar Showcase") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 24) {
            ForEach([0.0, 0.25, 0.5, 0.75, 0.95, 1.0], id: \.self) { progress in
                ProgressBar(progress: progress, height: 10, showPercentage: true)
            }
        }
        .padding(32)
        .background(VibrantTheme().colors.background)
    }
}
