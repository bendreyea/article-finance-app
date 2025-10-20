import SwiftUI

// MARK: - Goal Data Model
public struct GoalItem: Identifiable {
    public let id: UUID
    public var name: String
    public var currentAmount: Double
    public var targetAmount: Double
    public var deadline: Date
    public var category: String
    
    public var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
    
    public var progressPercentage: Double {
        progress * 100
    }
    
    public init(
        id: UUID = UUID(),
        name: String,
        currentAmount: Double,
        targetAmount: Double,
        deadline: Date,
        category: String
    ) {
        self.id = id
        self.name = name
        self.currentAmount = currentAmount
        self.targetAmount = targetAmount
        self.deadline = deadline
        self.category = category
    }
}

// MARK: - Goals List View
public struct GoalsListView: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    @Binding private var goals: [GoalItem]
    private let title: String
    private let subtitle: String?
    
    // MARK: - State
    @State private var editingGoalId: UUID?
    @State private var editAmount: String = ""
    
    // MARK: - Initializer
    public init(
        goals: Binding<[GoalItem]>,
        title: String = "Financial Goals",
        subtitle: String? = nil
    ) {
        self._goals = goals
        self.title = title
        self.subtitle = subtitle
    }
    
    // MARK: - Body
    public var body: some View {
        Card {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
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
                
                // Goals List
                if goals.isEmpty {
                    EmptyGoalsView()
                } else {
                    VStack(spacing: theme.spacing.md) {
                        ForEach(goals) { goal in
                            GoalProgressItem(
                                goal: goal,
                                isEditing: editingGoalId == goal.id,
                                editAmount: $editAmount,
                                onEdit: {
                                    startEditing(goal)
                                },
                                onSave: {
                                    saveEdit(for: goal)
                                },
                                onCancel: {
                                    cancelEdit()
                                }
                            )
                            
                            if goal.id != goals.last?.id {
                                Divider()
                                    .background(theme.colors.borderSubtle)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func startEditing(_ goal: GoalItem) {
        editingGoalId = goal.id
        editAmount = String(format: "%.0f", goal.currentAmount)
    }
    
    private func saveEdit(for goal: GoalItem) {
        guard let index = goals.firstIndex(where: { $0.id == goal.id }),
              let newAmount = Double(editAmount) else {
            cancelEdit()
            return
        }
        
        goals[index].currentAmount = max(0, min(newAmount, goal.targetAmount))
        cancelEdit()
    }
    
    private func cancelEdit() {
        editingGoalId = nil
        editAmount = ""
    }
}

// MARK: - Goal Progress Item
private struct GoalProgressItem: View {
    @Environment(\.theme) private var theme
    
    let goal: GoalItem
    let isEditing: Bool
    @Binding var editAmount: String
    let onEdit: () -> Void
    let onSave: () -> Void
    let onCancel: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            // Header Row
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(goal.name)
                        .font(theme.typography.subheadline)
                        .fontWeight(theme.typography.semibold)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text(goal.category)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.textSecondary)
                }
                
                Spacer()
                
                // Deadline
                VStack(alignment: .trailing, spacing: 2) {
                    Text(formatDate(goal.deadline))
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    if daysRemaining(until: goal.deadline) >= 0 {
                        Text("\(daysRemaining(until: goal.deadline)) days left")
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.info)
                    } else {
                        Text("Overdue")
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.error)
                    }
                }
            }
            
            // Progress Bar
            ProgressBar(progress: goal.progress)
            
            // Amount Row with Edit
            HStack {
                if isEditing {
                    // Edit Mode
                    HStack(spacing: theme.spacing.sm) {
                        TextField("Amount", text: $editAmount)
                            .textFieldStyle(.plain)
                            .font(theme.typography.body)
                            .foregroundColor(theme.colors.textPrimary)
                            .padding(theme.spacing.xs)
                            .background(theme.colors.backgroundTertiary)
                            .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))
                            .overlay(
                                RoundedRectangle(cornerRadius: theme.radius.sm)
                                    .stroke(theme.colors.border, lineWidth: 1)
                            )
                            .frame(width: 100)
                        
                        Button("Save") {
                            onSave()
                        }
                        .buttonStyle(CompactButtonStyle(style: .primary))
                        
                        Button("Cancel") {
                            onCancel()
                        }
                        .buttonStyle(CompactButtonStyle(style: .secondary))
                    }
                } else {
                    // Display Mode
                    HStack(spacing: theme.spacing.xs) {
                        Text(formatCurrency(goal.currentAmount))
                            .font(theme.typography.body)
                            .fontWeight(theme.typography.semibold)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text("of")
                            .font(theme.typography.body)
                            .foregroundColor(theme.colors.textSecondary)
                        
                        Text(formatCurrency(goal.targetAmount))
                            .font(theme.typography.body)
                            .foregroundColor(theme.colors.textSecondary)
                        
                        Text("•")
                            .font(theme.typography.body)
                            .foregroundColor(theme.colors.textTertiary)
                        
                        Text(String(format: "%.0f%%", goal.progressPercentage))
                            .font(theme.typography.body)
                            .fontWeight(theme.typography.medium)
                            .foregroundColor(progressColor)
                    }
                    
                    Spacer()
                    
                    Button(action: onEdit) {
                        Image(systemName: "pencil.circle.fill")
                            .font(theme.typography.title3)
                            .foregroundColor(theme.colors.interactive)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(theme.spacing.sm)
        .background(isEditing ? theme.colors.backgroundTertiary.opacity(0.5) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: theme.radius.md))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
    }
    
    private var progressColor: Color {
        if goal.progress >= 1.0 {
            return theme.colors.success
        } else if goal.progress >= 0.75 {
            return theme.colors.info
        } else if goal.progress >= 0.5 {
            return theme.colors.warning
        } else {
            return theme.colors.textSecondary
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "$0"
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    private func daysRemaining(until date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: date)
        return components.day ?? 0
    }
    
    private var accessibilityLabel: String {
        "\(goal.name). \(goal.category). Progress: \(formatCurrency(goal.currentAmount)) of \(formatCurrency(goal.targetAmount)), \(String(format: "%.0f%%", goal.progressPercentage)). Deadline: \(formatDate(goal.deadline))"
    }
}

// MARK: - Progress Bar Component
public struct ProgressBar: View {
    @Environment(\.theme) private var theme
    
    let progress: Double
    
    public init(progress: Double) {
        self.progress = progress
    }
    
    public var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                // Background
                RoundedRectangle(cornerRadius: theme.radius.sm)
                    .fill(theme.colors.border)
                    .frame(height: 8)
                
                // Progress Fill
                RoundedRectangle(cornerRadius: theme.radius.sm)
                    .fill(
                        LinearGradient(
                            colors: [progressColor, progressColor.opacity(0.8)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * progress, height: 8)
                    .animation(.easeInOut(duration: 0.3), value: progress)
            }
        }
        .frame(height: 8)
    }
    
    private var progressColor: Color {
        if progress >= 1.0 {
            return theme.colors.success
        } else if progress >= 0.75 {
            return theme.colors.info
        } else if progress >= 0.5 {
            return theme.colors.warning
        } else {
            return theme.colors.brandPrimary
        }
    }
}

// MARK: - Compact Button Style
private struct CompactButtonStyle: ButtonStyle {
    @Environment(\.theme) private var theme
    
    enum Style {
        case primary
        case secondary
    }
    
    let style: Style
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(theme.typography.caption)
            .fontWeight(theme.typography.medium)
            .foregroundColor(foregroundColor)
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: theme.radius.sm))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return theme.colors.brandPrimary
        case .secondary:
            return theme.colors.border
        }
    }
    
    private var foregroundColor: Color {
        switch style {
        case .primary:
            return theme.colors.textInverse
        case .secondary:
            return theme.colors.textPrimary
        }
    }
}

// MARK: - Empty Goals View
private struct EmptyGoalsView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            Image(systemName: "target")
                .font(.system(size: 48))
                .foregroundColor(theme.colors.textTertiary)
            
            Text("No Goals Yet")
                .font(theme.typography.subheadline)
                .fontWeight(theme.typography.medium)
                .foregroundColor(theme.colors.textSecondary)
            
            Text("Add financial goals to track your progress")
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.textTertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(theme.spacing.xxl)
    }
}

// MARK: - Demo Data
public struct GoalDemoData {
    public static func generateGoals() -> [GoalItem] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            GoalItem(
                name: "Emergency Fund",
                currentAmount: 8500,
                targetAmount: 15000,
                deadline: calendar.date(byAdding: .month, value: 6, to: today)!,
                category: "Savings"
            ),
            GoalItem(
                name: "Down Payment for House",
                currentAmount: 42000,
                targetAmount: 80000,
                deadline: calendar.date(byAdding: .year, value: 2, to: today)!,
                category: "Real Estate"
            ),
            GoalItem(
                name: "New Car",
                currentAmount: 12500,
                targetAmount: 35000,
                deadline: calendar.date(byAdding: .month, value: 18, to: today)!,
                category: "Vehicle"
            ),
            GoalItem(
                name: "Vacation Fund",
                currentAmount: 3200,
                targetAmount: 8000,
                deadline: calendar.date(byAdding: .month, value: 8, to: today)!,
                category: "Travel"
            ),
            GoalItem(
                name: "Retirement Contribution",
                currentAmount: 95000,
                targetAmount: 100000,
                deadline: calendar.date(byAdding: .month, value: 3, to: today)!,
                category: "Retirement"
            ),
        ]
    }
}

// MARK: - Preview Provider
#Preview("Goals List - Vibrant Theme") {
    @Previewable @State var goals = GoalDemoData.generateGoals()
    let vibrantTheme = VibrantTheme()
    
    VStack(spacing: 24) {
        GoalsListView(
            goals: $goals,
            title: "Financial Goals",
            subtitle: "Track your progress"
        )
    }
    .padding(24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(vibrantTheme.colors.backgroundPrimary)
    .theme(vibrantTheme)
}

#Preview("Goals List - Neutral Theme") {
    @Previewable @State var goals = GoalDemoData.generateGoals()
    let neutralTheme = NeutralTheme()
    
    VStack(spacing: 24) {
        GoalsListView(
            goals: $goals,
            title: "Financial Goals",
            subtitle: "2025 Targets"
        )
    }
    .padding(24)
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(neutralTheme.colors.backgroundPrimary)
    .theme(neutralTheme)
}

#Preview("Progress Bar Variations") {
    VStack(spacing: 16) {
        VStack(alignment: .leading, spacing: 4) {
            Text("25% Progress")
                .font(.caption)
            ProgressBar(progress: 0.25)
        }
        
        VStack(alignment: .leading, spacing: 4) {
            Text("50% Progress")
                .font(.caption)
            ProgressBar(progress: 0.50)
        }
        
        VStack(alignment: .leading, spacing: 4) {
            Text("75% Progress")
                .font(.caption)
            ProgressBar(progress: 0.75)
        }
        
        VStack(alignment: .leading, spacing: 4) {
            Text("100% Progress")
                .font(.caption)
            ProgressBar(progress: 1.0)
        }
    }
    .padding(24)
    .theme(VibrantTheme())
}

#Preview("Empty Goals State") {
    @Previewable @State var goals: [GoalItem] = []
    
    GoalsListView(
        goals: $goals,
        title: "Financial Goals",
        subtitle: "Start tracking your goals"
    )
    .padding(24)
    .frame(width: 400, height: 300)
    .theme(NeutralTheme())
}
