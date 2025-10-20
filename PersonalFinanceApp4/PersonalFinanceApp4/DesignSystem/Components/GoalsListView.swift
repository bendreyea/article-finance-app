//
//  GoalsListView.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// A list view displaying financial goals with inline editing capability
public struct GoalsListView: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    @Binding public var goals: [Goal]
    public let title: String
    public let subtitle: String?
    public let onAddGoal: (() -> Void)?
    public let onDeleteGoal: ((Goal) -> Void)?
    
    @State private var editingGoalId: UUID?
    @State private var showAddSheet = false
    
    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        formatter.maximumFractionDigits = 0
        return formatter
    }()
    
    // MARK: - Initialization
    
    public init(
        goals: Binding<[Goal]>,
        title: String = "Financial Goals",
        subtitle: String? = nil,
        onAddGoal: (() -> Void)? = nil,
        onDeleteGoal: ((Goal) -> Void)? = nil
    ) {
        self._goals = goals
        self.title = title
        self.subtitle = subtitle
        self.onAddGoal = onAddGoal
        self.onDeleteGoal = onDeleteGoal
    }
    
    // MARK: - Body
    
    public var body: some View {
        Card(elevation: .medium, padding: .standard) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                // Header with add button
                headerView
                
                // Goals list
                if goals.isEmpty {
                    emptyStateView
                } else {
                    ScrollView {
                        VStack(spacing: theme.spacing.md) {
                            ForEach($goals) { $goal in
                                goalRowView(goal: $goal)
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Header View
    
    private var headerView: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(title)
                    .font(theme.typography.headingMedium)
                    .foregroundColor(theme.colors.onSurface)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(theme.typography.bodyMedium)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                }
            }
            
            Spacer()
            
            // Add button
            Button(action: {
                if let onAddGoal = onAddGoal {
                    onAddGoal()
                } else {
                    addNewGoal()
                }
            }) {
                HStack(spacing: theme.spacing.xs) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 14))
                    Text("Add Goal")
                        .font(theme.typography.labelMedium)
                }
                .foregroundColor(theme.colors.onPrimary)
                .padding(.horizontal, theme.spacing.md)
                .padding(.vertical, theme.spacing.sm)
                .background(theme.colors.primary)
                .cornerRadius(theme.radius.button)
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        VStack(spacing: theme.spacing.md) {
            Image(systemName: "target")
                .font(.system(size: 48))
                .foregroundColor(theme.colors.onSurfaceTertiary)
            
            Text("No Goals Yet")
                .font(theme.typography.headingSmall)
                .foregroundColor(theme.colors.onSurfaceSecondary)
            
            Text("Add your first financial goal to start tracking progress")
                .font(theme.typography.bodySmall)
                .foregroundColor(theme.colors.onSurfaceTertiary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, theme.spacing.xxxl)
    }
    
    // MARK: - Goal Row View
    
    private func goalRowView(goal: Binding<Goal>) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack(alignment: .center, spacing: theme.spacing.md) {
                // Icon
                Image(systemName: goal.wrappedValue.category.icon)
                    .font(.system(size: 20))
                    .foregroundColor(theme.colors.primary)
                    .frame(width: 32, height: 32)
                    .background(theme.colors.primary.opacity(0.1))
                    .cornerRadius(theme.radius.sm)
                
                // Goal info
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    HStack {
                        Text(goal.wrappedValue.name)
                            .font(theme.typography.bodyLarge)
                            .foregroundColor(theme.colors.onSurface)
                            .fontWeight(.semibold)
                        
                        // Status badge
                        statusBadge(for: goal.wrappedValue.status)
                    }
                    
                    HStack(spacing: theme.spacing.xs) {
                        Text(goal.wrappedValue.category.rawValue)
                            .font(theme.typography.labelSmall)
                            .foregroundColor(theme.colors.onSurfaceTertiary)
                        
                        if let deadlineString = goal.wrappedValue.deadlineString {
                            Text("•")
                                .font(theme.typography.labelSmall)
                                .foregroundColor(theme.colors.onSurfaceTertiary)
                            
                            Text(deadlineString)
                                .font(theme.typography.labelSmall)
                                .foregroundColor(theme.colors.onSurfaceTertiary)
                        }
                    }
                }
                
                Spacer()
                
                // Actions
                HStack(spacing: theme.spacing.sm) {
                    // Edit button
                    Button(action: {
                        editingGoalId = goal.id
                    }) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14))
                            .foregroundColor(theme.colors.onSurfaceSecondary)
                    }
                    .buttonStyle(.plain)
                    
                    // Delete button
                    if let onDeleteGoal = onDeleteGoal {
                        Button(action: {
                            onDeleteGoal(goal.wrappedValue)
                        }) {
                            Image(systemName: "trash")
                                .font(.system(size: 14))
                                .foregroundColor(theme.colors.error)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            
            // Progress info
            HStack(spacing: theme.spacing.sm) {
                Text(currencyFormatter.string(from: NSNumber(value: goal.wrappedValue.currentAmount)) ?? "$0")
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.onSurface)
                    .fontWeight(.medium)
                
                Text("of")
                    .font(theme.typography.bodySmall)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
                
                Text(currencyFormatter.string(from: NSNumber(value: goal.wrappedValue.targetAmount)) ?? "$0")
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
            }
            
            // Progress bar
            ProgressBar(
                progress: goal.wrappedValue.progress,
                size: .medium,
                showPercentage: true,
                color: progressColorForStatus(goal.wrappedValue.status)
            )
            
            // Inline edit form (if editing)
            if editingGoalId == goal.id {
                inlineEditView(goal: goal)
            }
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surface)
        .cornerRadius(theme.radius.card)
        .overlay(
            RoundedRectangle(cornerRadius: theme.radius.card)
                .stroke(theme.colors.borderSubtle, lineWidth: 1)
        )
    }
    
    // MARK: - Status Badge
    
    private func statusBadge(for status: GoalStatus) -> some View {
        Text(status.rawValue)
            .font(theme.typography.labelSmall)
            .foregroundColor(colorForStatus(status))
            .padding(.horizontal, theme.spacing.xs)
            .padding(.vertical, 2)
            .background(colorForStatus(status).opacity(0.15))
            .cornerRadius(theme.radius.xs)
    }
    
    // MARK: - Inline Edit View
    
    private func inlineEditView(goal: Binding<Goal>) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Divider()
                .padding(.vertical, theme.spacing.xs)
            
            Text("Edit Goal")
                .font(theme.typography.labelLarge)
                .foregroundColor(theme.colors.onSurface)
                .fontWeight(.semibold)
            
            // Name field
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text("Goal Name")
                    .font(theme.typography.labelSmall)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
                
                TextField("Enter goal name", text: goal.name)
                    .textFieldStyle(.plain)
                    .font(theme.typography.bodyMedium)
                    .padding(theme.spacing.sm)
                    .background(theme.colors.surfaceVariant)
                    .cornerRadius(theme.radius.input)
            }
            
            // Amount fields
            HStack(spacing: theme.spacing.md) {
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text("Current Amount")
                        .font(theme.typography.labelSmall)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                    
                    TextField("0", value: goal.currentAmount, format: .currency(code: "USD"))
                        .textFieldStyle(.plain)
                        .font(theme.typography.bodyMedium)
                        .padding(theme.spacing.sm)
                        .background(theme.colors.surfaceVariant)
                        .cornerRadius(theme.radius.input)
                }
                
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text("Target Amount")
                        .font(theme.typography.labelSmall)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                    
                    TextField("0", value: goal.targetAmount, format: .currency(code: "USD"))
                        .textFieldStyle(.plain)
                        .font(theme.typography.bodyMedium)
                        .padding(theme.spacing.sm)
                        .background(theme.colors.surfaceVariant)
                        .cornerRadius(theme.radius.input)
                }
            }
            
            // Action buttons
            HStack(spacing: theme.spacing.sm) {
                Button("Cancel") {
                    editingGoalId = nil
                }
                .font(theme.typography.labelMedium)
                .foregroundColor(theme.colors.onSurfaceSecondary)
                .padding(.horizontal, theme.spacing.md)
                .padding(.vertical, theme.spacing.sm)
                .background(theme.colors.surfaceVariant)
                .cornerRadius(theme.radius.button)
                .buttonStyle(.plain)
                
                Button("Save Changes") {
                    goal.wrappedValue.updatedAt = Date()
                    editingGoalId = nil
                }
                .font(theme.typography.labelMedium)
                .foregroundColor(theme.colors.onPrimary)
                .padding(.horizontal, theme.spacing.md)
                .padding(.vertical, theme.spacing.sm)
                .background(theme.colors.primary)
                .cornerRadius(theme.radius.button)
                .buttonStyle(.plain)
            }
        }
        .padding(.top, theme.spacing.sm)
    }
    
    // MARK: - Helper Methods
    
    private func colorForStatus(_ status: GoalStatus) -> Color {
        switch status.colorKey {
        case .success: return theme.colors.success
        case .warning: return theme.colors.warning
        case .info: return theme.colors.info
        case .neutral: return theme.colors.onSurfaceSecondary
        }
    }
    
    private func progressColorForStatus(_ status: GoalStatus) -> ProgressBarColor {
        switch status.colorKey {
        case .success: return .success
        case .warning: return .warning
        case .info: return .info
        case .neutral: return .secondary
        }
    }
    
    private func addNewGoal() {
        let newGoal = Goal(
            name: "New Goal",
            category: .other,
            targetAmount: 1000,
            currentAmount: 0
        )
        goals.append(newGoal)
        editingGoalId = newGoal.id
    }
}

// MARK: - Previews

#Preview("GoalsListView - Vibrant Theme") {
    ThemeProvider(theme: VibrantTheme()) {
        ScrollView {
            VStack(spacing: 24) {
                Text("Financial Goals")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)
                
                GoalsListView(
                    goals: .constant(Goal.generateDemoData()),
                    title: "My Goals",
                    subtitle: "Track your financial progress"
                )
                .frame(height: 600)
            }
            .padding()
        }
    }
    .frame(width: 800, height: 800)
}

#Preview("GoalsListView - Neutral Theme") {
    ThemeProvider(theme: NeutralTheme()) {
        ScrollView {
            VStack(spacing: 24) {
                Text("Financial Goals")
                    .font(.system(size: 24, weight: .bold))
                    .padding(.top)
                
                GoalsListView(
                    goals: .constant(Goal.generateDemoData()),
                    title: "My Goals",
                    subtitle: "Track your financial progress",
                    onDeleteGoal: { goal in
                        print("Delete goal: \(goal.name)")
                    }
                )
                .frame(height: 600)
            }
            .padding()
        }
    }
    .frame(width: 800, height: 800)
}

#Preview("GoalsListView - Empty State") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 24) {
            GoalsListView(
                goals: .constant([]),
                title: "Your Goals",
                subtitle: "Start tracking your financial objectives"
            )
            .frame(height: 400)
        }
        .padding()
    }
    .frame(width: 700, height: 500)
}

#Preview("GoalsListView - Few Goals") {
    ThemeProvider(theme: NeutralTheme()) {
        VStack(spacing: 24) {
            GoalsListView(
                goals: .constant(Array(Goal.generateDemoData().prefix(3))),
                title: "Active Goals"
            )
            .frame(height: 400)
        }
        .padding()
    }
    .frame(width: 700, height: 500)
}

#Preview("GoalsListView - With Delete Action") {
    struct DemoView: View {
        @Environment(\.theme) private var theme
        @State private var goals = Goal.generateDemoData()
        
        var body: some View {
            GoalsListView(
                goals: $goals,
                title: "Manage Goals",
                subtitle: "\(goals.count) active goals",
                onDeleteGoal: { goal in
                    goals.removeAll { $0.id == goal.id }
                }
            )
            .frame(height: 600)
        }
    }
    
    return ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 24) {
            Text("Goals with Delete")
                .font(.system(size: 24, weight: .bold))
                .padding(.top)
            
            DemoView()
        }
        .padding()
    }
    .frame(width: 800, height: 800)
}
