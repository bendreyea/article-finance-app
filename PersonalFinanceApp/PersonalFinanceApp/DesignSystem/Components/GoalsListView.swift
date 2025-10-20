import SwiftUI

/// A data model representing a financial goal
public struct FinancialGoal: Identifiable, Hashable {
    public let id = UUID()
    public var name: String
    public var targetAmount: Double
    public var currentAmount: Double
    public var targetDate: Date
    public var category: GoalCategory
    public var isCompleted: Bool
    
    public init(
        name: String,
        targetAmount: Double,
        currentAmount: Double = 0,
        targetDate: Date,
        category: GoalCategory = .savings
    ) {
        self.name = name
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.targetDate = targetDate
        self.category = category
        self.isCompleted = currentAmount >= targetAmount
    }
    
    /// Progress as a percentage (0.0 to 1.0)
    public var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
    
    /// Days remaining until target date
    public var daysRemaining: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: targetDate).day ?? 0
    }
}

/// Goal categories for organization
public enum GoalCategory: String, CaseIterable, Identifiable {
    case savings = "Savings"
    case debt = "Debt Payoff"
    case investment = "Investment"
    case emergency = "Emergency Fund"
    case purchase = "Major Purchase"
    case retirement = "Retirement"
    case education = "Education"
    case travel = "Travel"
    case other = "Other"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .savings: return "banknote.fill"
        case .debt: return "creditcard.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .emergency: return "shield.fill"
        case .purchase: return "cart.fill"
        case .retirement: return "figure.walk"
        case .education: return "graduationcap.fill"
        case .travel: return "airplane"
        case .other: return "target"
        }
    }
    
    public var color: Color {
        switch self {
        case .savings: return .green
        case .debt: return .red
        case .investment: return .blue
        case .emergency: return .orange
        case .purchase: return .purple
        case .retirement: return .indigo
        case .education: return .cyan
        case .travel: return .mint
        case .other: return .gray
        }
    }
}

/// A themed progress bar component for goals
public struct ProgressBar: View {
    @Environment(\.theme) private var theme
    
    private let progress: Double
    private let height: CGFloat
    private let backgroundColor: Color?
    private let foregroundColor: Color?
    private let showPercentage: Bool
    
    public init(
        progress: Double,
        height: CGFloat = 8,
        backgroundColor: Color? = nil,
        foregroundColor: Color? = nil,
        showPercentage: Bool = false
    ) {
        self.progress = max(0, min(progress, 1.0))
        self.height = height
        self.backgroundColor = backgroundColor
        self.foregroundColor = foregroundColor
        self.showPercentage = showPercentage
    }
    
    public var body: some View {
        HStack(spacing: theme.spacing.sm) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(backgroundColor ?? theme.colors.border.opacity(0.3))
                    
                    // Progress fill
                    RoundedRectangle(cornerRadius: height / 2)
                        .fill(foregroundColor ?? theme.colors.primary)
                        .frame(width: geometry.size.width * progress)
                        .animation(.easeInOut(duration: 0.5), value: progress)
                }
            }
            .frame(height: height)
            
            // Optional percentage text
            if showPercentage {
                Text(formatPercentage(progress))
                    .font(theme.typography.captionFont)
                    .foregroundColor(theme.colors.textSecondary)
                    .frame(width: 35, alignment: .trailing)
            }
        }
    }
    
    private func formatPercentage(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? "0%"
    }
}

/// Goals list view with inline editing capabilities
public struct GoalsListView: View {
    @Environment(\.theme) private var theme
    
    @Binding private var goals: [FinancialGoal]
    private let onGoalUpdate: ((FinancialGoal) -> Void)?
    private let onGoalDelete: ((FinancialGoal) -> Void)?
    
    @State private var editingGoalId: UUID? = nil
    @State private var showingAddGoal = false
    
    public init(
        goals: Binding<[FinancialGoal]>,
        onGoalUpdate: ((FinancialGoal) -> Void)? = nil,
        onGoalDelete: ((FinancialGoal) -> Void)? = nil
    ) {
        self._goals = goals
        self.onGoalUpdate = onGoalUpdate
        self.onGoalDelete = onGoalDelete
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            // Header with add button
            headerView
            
            if goals.isEmpty {
                emptyStateView
            } else {
                // Goals list
                LazyVStack(spacing: theme.spacing.sm) {
                    ForEach(sortedGoals) { goal in
                        goalRow(for: goal)
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddGoal) {
            AddGoalSheet { newGoal in
                goals.append(newGoal)
            }
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                Text("Financial Goals")
                    .font(theme.typography.title3Font)
                    .foregroundColor(theme.colors.textPrimary)
                
                Text("\(goals.count) active goals")
                    .font(theme.typography.captionFont)
                    .foregroundColor(theme.colors.textSecondary)
            }
            
            Spacer()
            
            Button(action: { showingAddGoal = true }) {
                HStack(spacing: theme.spacing.xs) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Goal")
                }
                .font(theme.typography.calloutFont)
                .foregroundColor(theme.colors.primary)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack(spacing: theme.spacing.md) {
            Image(systemName: "target")
                .font(.system(size: 48))
                .foregroundColor(theme.colors.textTertiary)
            
            Text("No Goals Yet")
                .font(theme.typography.headlineFont)
                .foregroundColor(theme.colors.textPrimary)
            
            Text("Set your first financial goal to start tracking your progress")
                .font(theme.typography.bodyFont)
                .foregroundColor(theme.colors.textSecondary)
                .multilineTextAlignment(.center)
            
            Button("Add Your First Goal") {
                showingAddGoal = true
            }
            .font(theme.typography.calloutFont)
            .foregroundColor(theme.colors.onPrimary)
            .padding(.horizontal, theme.spacing.lg)
            .padding(.vertical, theme.spacing.sm)
            .background(theme.colors.primary)
            .cornerRadius(theme.radius.button)
        }
        .padding(theme.spacing.xl)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: - Goal Row
    private func goalRow(for goal: FinancialGoal) -> some View {
        Card(style: .outlined, elevation: .subtle) {
            VStack(spacing: theme.spacing.md) {
                if editingGoalId == goal.id {
                    // Inline edit mode
                    InlineGoalEditor(
                        goal: goal,
                        onSave: { updatedGoal in
                            if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                                goals[index] = updatedGoal
                                onGoalUpdate?(updatedGoal)
                            }
                            editingGoalId = nil
                        },
                        onCancel: {
                            editingGoalId = nil
                        }
                    )
                } else {
                    // Display mode
                    goalDisplayContent(for: goal)
                }
            }
        }
    }
    
    // MARK: - Goal Display Content
    private func goalDisplayContent(for goal: FinancialGoal) -> some View {
        VStack(spacing: theme.spacing.sm) {
            // Header row
            HStack {
                // Category icon and name
                HStack(spacing: theme.spacing.sm) {
                    Image(systemName: goal.category.icon)
                        .foregroundColor(goal.category.color)
                        .frame(width: 16)
                    
                    Text(goal.name)
                        .font(theme.typography.headlineFont)
                        .foregroundColor(theme.colors.textPrimary)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // Action buttons
                HStack(spacing: theme.spacing.xs) {
                    Button("Edit") {
                        editingGoalId = goal.id
                    }
                    .font(theme.typography.captionFont)
                    .foregroundColor(theme.colors.primary)
                    
                    Button("Delete") {
                        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
                            let goalToDelete = goals.remove(at: index)
                            onGoalDelete?(goalToDelete)
                        }
                    }
                    .font(theme.typography.captionFont)
                    .foregroundColor(theme.colors.error)
                }
            }
            
            // Progress section
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                HStack {
                    Text("Progress")
                        .font(theme.typography.calloutFont)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Spacer()
                    
                    Text("\(formatCurrency(goal.currentAmount)) / \(formatCurrency(goal.targetAmount))")
                        .font(theme.typography.calloutFont)
                        .fontWeight(theme.typography.medium)
                        .foregroundColor(theme.colors.textPrimary)
                }
                
                ProgressBar(
                    progress: goal.progress,
                    height: 12,
                    foregroundColor: progressColor(for: goal),
                    showPercentage: true
                )
            }
            
            // Footer info
            HStack {
                // Category
                HStack(spacing: theme.spacing.xs) {
                    Circle()
                        .fill(goal.category.color)
                        .frame(width: 8, height: 8)
                    Text(goal.category.rawValue)
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                }
                
                Spacer()
                
                // Due date info
                HStack(spacing: theme.spacing.xs) {
                    Image(systemName: "calendar")
                        .font(.caption)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Text(dueDateText(for: goal))
                        .font(theme.typography.captionFont)
                        .foregroundColor(dueDateColor(for: goal))
                }
            }
        }
    }
    
    // MARK: - Computed Properties
    
    private var sortedGoals: [FinancialGoal] {
        goals.sorted { goal1, goal2 in
            // Completed goals go to bottom
            if goal1.isCompleted != goal2.isCompleted {
                return !goal1.isCompleted
            }
            // Then sort by target date (closest first)
            return goal1.targetDate < goal2.targetDate
        }
    }
    
    // MARK: - Helper Functions
    
    private func progressColor(for goal: FinancialGoal) -> Color {
        if goal.isCompleted {
            return theme.colors.success
        } else if goal.progress >= 0.8 {
            return theme.colors.success
        } else if goal.progress >= 0.5 {
            return theme.colors.warning
        } else {
            return theme.colors.primary
        }
    }
    
    private func dueDateText(for goal: FinancialGoal) -> String {
        let days = goal.daysRemaining
        if days < 0 {
            return "Overdue by \(abs(days)) days"
        } else if days == 0 {
            return "Due today"
        } else if days == 1 {
            return "Due tomorrow"
        } else if days <= 30 {
            return "Due in \(days) days"
        } else {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return "Due \(formatter.string(from: goal.targetDate))"
        }
    }
    
    private func dueDateColor(for goal: FinancialGoal) -> Color {
        let days = goal.daysRemaining
        if days < 0 {
            return theme.colors.error
        } else if days <= 7 {
            return theme.colors.warning
        } else {
            return theme.colors.textSecondary
        }
    }
    
    private func formatCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        
        if abs(amount) >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            return formatter.string(from: NSNumber(value: amount / 1_000_000)) ?? "$0M"
        } else if abs(amount) >= 1_000 {
            return formatter.string(from: NSNumber(value: amount / 1_000)) ?? "$0K"
        } else {
            formatter.maximumFractionDigits = 2
            return formatter.string(from: NSNumber(value: amount)) ?? "$0"
        }
    }
}

// MARK: - Inline Goal Editor
private struct InlineGoalEditor: View {
    @Environment(\.theme) private var theme
    
    let goal: FinancialGoal
    let onSave: (FinancialGoal) -> Void
    let onCancel: () -> Void
    
    @State private var editedName: String
    @State private var editedTargetAmount: String
    @State private var editedCurrentAmount: String
    @State private var editedTargetDate: Date
    @State private var editedCategory: GoalCategory
    
    init(goal: FinancialGoal, onSave: @escaping (FinancialGoal) -> Void, onCancel: @escaping () -> Void) {
        self.goal = goal
        self.onSave = onSave
        self.onCancel = onCancel
        
        self._editedName = State(initialValue: goal.name)
        self._editedTargetAmount = State(initialValue: String(Int(goal.targetAmount)))
        self._editedCurrentAmount = State(initialValue: String(Int(goal.currentAmount)))
        self._editedTargetDate = State(initialValue: goal.targetDate)
        self._editedCategory = State(initialValue: goal.category)
    }
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            // Name field
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                Text("Goal Name")
                    .font(theme.typography.calloutFont)
                    .foregroundColor(theme.colors.textPrimary)
                TextField("Enter goal name", text: $editedName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            // Amount fields
            HStack(spacing: theme.spacing.md) {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text("Target Amount")
                        .font(theme.typography.calloutFont)
                        .foregroundColor(theme.colors.textPrimary)
                    TextField("0", text: $editedTargetAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text("Current Amount")
                        .font(theme.typography.calloutFont)
                        .foregroundColor(theme.colors.textPrimary)
                    TextField("0", text: $editedCurrentAmount)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            
            // Category and date
            HStack(spacing: theme.spacing.md) {
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text("Category")
                        .font(theme.typography.calloutFont)
                        .foregroundColor(theme.colors.textPrimary)
                    Picker("Category", selection: $editedCategory) {
                        ForEach(GoalCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.icon)
                                .tag(category)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                
                VStack(alignment: .leading, spacing: theme.spacing.xs) {
                    Text("Target Date")
                        .font(theme.typography.calloutFont)
                        .foregroundColor(theme.colors.textPrimary)
                    DatePicker("", selection: $editedTargetDate, displayedComponents: .date)
                        .labelsHidden()
                }
            }
            
            // Action buttons
            HStack(spacing: theme.spacing.md) {
                Button("Cancel") {
                    onCancel()
                }
                .font(theme.typography.calloutFont)
                .foregroundColor(theme.colors.textSecondary)
                .padding(.horizontal, theme.spacing.lg)
                .padding(.vertical, theme.spacing.sm)
                .background(theme.colors.border.opacity(0.2))
                .cornerRadius(theme.radius.button)
                
                Spacer()
                
                Button("Save") {
                    saveGoal()
                }
                .font(theme.typography.calloutFont)
                .foregroundColor(theme.colors.onPrimary)
                .padding(.horizontal, theme.spacing.lg)
                .padding(.vertical, theme.spacing.sm)
                .background(theme.colors.primary)
                .cornerRadius(theme.radius.button)
                .disabled(!isFormValid)
            }
        }
    }
    
    private var isFormValid: Bool {
        !editedName.isEmpty && 
        Double(editedTargetAmount) != nil && 
        Double(editedCurrentAmount) != nil
    }
    
    private func saveGoal() {
        guard let targetAmount = Double(editedTargetAmount),
              let currentAmount = Double(editedCurrentAmount) else { return }
        
        var updatedGoal = goal
        updatedGoal.name = editedName
        updatedGoal.targetAmount = targetAmount
        updatedGoal.currentAmount = currentAmount
        updatedGoal.targetDate = editedTargetDate
        updatedGoal.category = editedCategory
        updatedGoal.isCompleted = currentAmount >= targetAmount
        
        onSave(updatedGoal)
    }
}

// MARK: - Add Goal Sheet
private struct AddGoalSheet: View {
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    
    let onAdd: (FinancialGoal) -> Void
    
    @State private var name = ""
    @State private var targetAmount = ""
    @State private var currentAmount = "0"
    @State private var targetDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()
    @State private var category: GoalCategory = .savings
    
    var body: some View {
        NavigationView {
            Form {
                Section("Goal Details") {
                    TextField("Goal Name", text: $name)
                    
                    Picker("Category", selection: $category) {
                        ForEach(GoalCategory.allCases) { cat in
                            Label(cat.rawValue, systemImage: cat.icon)
                                .tag(cat)
                        }
                    }
                }
                
                Section("Amounts") {
                    TextField("Target Amount", text: $targetAmount)
                    
                    TextField("Current Amount", text: $currentAmount)
                }
                
                Section("Timeline") {
                    DatePicker("Target Date", selection: $targetDate, in: Date()..., displayedComponents: .date)
                }
            }
            .navigationTitle("Add Goal")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        addGoal()
                    }
                    .disabled(!isFormValid)
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !name.isEmpty && 
        !targetAmount.isEmpty && 
        Double(targetAmount) != nil && 
        Double(currentAmount) != nil
    }
    
    private func addGoal() {
        guard let target = Double(targetAmount),
              let current = Double(currentAmount) else { return }
        
        let goal = FinancialGoal(
            name: name,
            targetAmount: target,
            currentAmount: current,
            targetDate: targetDate,
            category: category
        )
        
        onAdd(goal)
        dismiss()
    }
}

// MARK: - Demo Data
extension GoalsListView {
    /// Sample goals for previews and demos
    public static var demoGoals: [FinancialGoal] {
        let calendar = Calendar.current
        let today = Date()
        
        return [
            FinancialGoal(
                name: "Emergency Fund",
                targetAmount: 10000,
                currentAmount: 7500,
                targetDate: calendar.date(byAdding: .month, value: 6, to: today) ?? today,
                category: .emergency
            ),
            FinancialGoal(
                name: "New Car Down Payment",
                targetAmount: 15000,
                currentAmount: 8200,
                targetDate: calendar.date(byAdding: .month, value: 8, to: today) ?? today,
                category: .purchase
            ),
            FinancialGoal(
                name: "Pay Off Credit Card",
                targetAmount: 5000,
                currentAmount: 3100,
                targetDate: calendar.date(byAdding: .month, value: 4, to: today) ?? today,
                category: .debt
            ),
            FinancialGoal(
                name: "Vacation to Europe",
                targetAmount: 8000,
                currentAmount: 2400,
                targetDate: calendar.date(byAdding: .month, value: 12, to: today) ?? today,
                category: .travel
            ),
            FinancialGoal(
                name: "Investment Portfolio",
                targetAmount: 50000,
                currentAmount: 22000,
                targetDate: calendar.date(byAdding: .year, value: 2, to: today) ?? today,
                category: .investment
            )
        ]
    }
}