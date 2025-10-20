# GoalsListView Component Guide

## Overview

`GoalsListView` is a comprehensive financial goals management component featuring inline editing, progress tracking with `ProgressBar`, status badges, and full CRUD operations. Perfect for tracking financial objectives like emergency funds, vacation savings, home purchases, and debt payoff.

## Components Package

This implementation includes **3 interconnected components**:

1. **GoalModels** - Data structures and demo generators
2. **ProgressBar** - Reusable progress bar component
3. **GoalsListView** - Goals list with inline editing

## Features

✅ **Inline Editing** - Edit goals directly in the list  
✅ **Progress Bars** - Visual progress with ProgressBar component  
✅ **Status Badges** - Color-coded status indicators  
✅ **Category Icons** - SF Symbols for goal types  
✅ **Currency Formatting** - Proper $ display  
✅ **Progress Calculation** - Automatic percentage  
✅ **Deadline Tracking** - Shows days/date remaining  
✅ **Add/Edit/Delete** - Full CRUD operations  
✅ **Empty State** - Helpful placeholder when no goals  
✅ **Smart Status** - Auto-calculated based on progress  
✅ **Fully Themed** - Zero hardcoded colors or fonts  
✅ **Demo Data** - Realistic goal generator  

## Basic Usage

```swift
@State private var goals = Goal.generateDemoData()

GoalsListView(
    goals: $goals,
    title: "My Financial Goals",
    subtitle: "Track your progress"
)
```

## Full API

```swift
GoalsListView(
    goals: Binding<[Goal]>,
    title: String = "Financial Goals",
    subtitle: String? = nil,
    onAddGoal: (() -> Void)? = nil,
    onDeleteGoal: ((Goal) -> Void)? = nil
)
```

## Parameters

### goals: Binding<[Goal]>
Binding to array of goals for two-way updates.

**Goal Structure**:
```swift
Goal(
    id: UUID = UUID(),
    name: String,                    // "Emergency Fund", "New Car"
    category: GoalCategory,          // .emergency, .car, etc.
    targetAmount: Double,            // Goal amount: 10000
    currentAmount: Double = 0,       // Current progress: 6500
    deadline: Date? = nil,           // Optional deadline
    notes: String? = nil,            // Optional notes
    createdAt: Date = Date(),
    updatedAt: Date = Date()
)
```

### title: String (Default: "Financial Goals")
Main heading for the list.

### subtitle: String? (Default: nil)
Optional subtitle for context.

### onAddGoal: (() -> Void)? (Default: nil)
Optional callback when Add button is tapped.
- If `nil`: Creates default goal and opens edit form
- If provided: Calls your custom handler

### onDeleteGoal: ((Goal) -> Void)? (Default: nil)
Optional callback for delete action.
- If `nil`: Delete button is hidden
- If provided: Shows delete button and calls handler

## Data Models

### GoalCategory Enum
```swift
enum GoalCategory: String, CaseIterable {
    case emergency = "Emergency Fund"
    case vacation = "Vacation"
    case home = "Home Purchase"
    case car = "Car"
    case education = "Education"
    case retirement = "Retirement"
    case debt = "Debt Payoff"
    case investment = "Investment"
    case wedding = "Wedding"
    case business = "Business"
    case other = "Other"
}
```

Each category has:
- SF Symbol icon
- Human-readable name
- Themed color support

### GoalStatus Enum
```swift
enum GoalStatus: String, CaseIterable {
    case notStarted = "Not Started"     // No progress yet
    case inProgress = "In Progress"     // Behind schedule
    case onTrack = "On Track"           // Meeting expectations
    case atRisk = "At Risk"             // Deadline passed or far behind
    case completed = "Completed"        // Goal reached!
}
```

Status is **automatically calculated** based on:
- Current vs target amount
- Deadline (if set)
- Time elapsed since creation
- Expected vs actual progress

### Goal Computed Properties
```swift
// Progress as 0.0 to 1.0
var progress: Double

// Progress as 0 to 100
var progressPercentage: Double

// Amount still needed
var remainingAmount: Double

// Whether goal is complete
var isCompleted: Bool

// Auto-calculated status
var status: GoalStatus

// Days until deadline (if set)
var daysRemaining: Int?

// Formatted deadline string
var deadlineString: String?
```

## Goal List Features

### Goal Row Display
Each goal shows:
- **Category Icon**: Colored icon in rounded square
- **Goal Name**: Bold, prominent title
- **Status Badge**: Color-coded status indicator
- **Category**: Goal category name
- **Deadline**: Optional deadline date
- **Progress Values**: "Current of Target" amounts
- **Progress Bar**: Visual progress with percentage
- **Edit Button**: Opens inline edit form
- **Delete Button**: (if onDeleteGoal provided)

### Status Badge Colors
- **Not Started**: Neutral (gray)
- **In Progress**: Info (blue)
- **On Track**: Success (green)
- **At Risk**: Warning (orange)
- **Completed**: Success (green)

### Progress Bar Colors
Automatically matches status:
- **Not Started**: Secondary (gray)
- **In Progress**: Info (blue)
- **On Track**: Success (green)
- **At Risk**: Warning (orange)
- **Completed**: Success (green)

## Inline Editing

### Edit Form Fields
When pencil icon is tapped, shows:
1. **Goal Name**: Text field
2. **Current Amount**: Currency field
3. **Target Amount**: Currency field
4. **Cancel Button**: Discards changes
5. **Save Changes Button**: Saves and closes

### Edit Form Features
- ✅ Inline display (no modal/sheet)
- ✅ Two-way binding to goal
- ✅ Currency formatting in fields
- ✅ Auto-updates `updatedAt` timestamp
- ✅ Themed styling
- ✅ Keyboard shortcuts

### Edit Behavior
```swift
// Tapping edit button
editingGoalId = goal.id  // Opens form

// Saving changes
goal.updatedAt = Date()  // Updates timestamp
editingGoalId = nil      // Closes form

// Canceling
editingGoalId = nil      // Just closes form
```

## Adding Goals

### Default Add Behavior
If `onAddGoal` is `nil`:
```swift
// Creates new goal
let newGoal = Goal(
    name: "New Goal",
    category: .other,
    targetAmount: 1000,
    currentAmount: 0
)
goals.append(newGoal)
editingGoalId = newGoal.id  // Opens edit form immediately
```

### Custom Add Behavior
```swift
GoalsListView(
    goals: $goals,
    onAddGoal: {
        // Your custom logic
        showAddSheet = true
    }
)
```

## Deleting Goals

### Enable Delete
Provide `onDeleteGoal` callback:
```swift
GoalsListView(
    goals: $goals,
    onDeleteGoal: { goal in
        goals.removeAll { $0.id == goal.id }
    }
)
```

### Without Delete
Omit callback to hide delete buttons:
```swift
GoalsListView(
    goals: $goals
)
// No delete button shown
```

## ProgressBar Component

### Standalone Usage
```swift
ProgressBar(
    progress: 0.65,                    // 0.0 to 1.0
    size: .medium,                     // .small, .medium, .large
    showPercentage: true,              // Show "65%" label
    color: .success,                   // .primary, .success, .warning, etc.
    animated: true                     // Animate on appear/change
)
```

### Size Variants
- **Small**: 6pt height, compact
- **Medium**: 10pt height (default)
- **Large**: 14pt height, prominent

### Color Options
```swift
enum ProgressBarColor {
    case primary      // Theme primary color
    case success      // Green
    case warning      // Orange
    case error        // Red
    case info         // Blue
    case secondary    // Gray
    case custom(Color)  // Your color
}
```

### Features
- Rounded bar with theme radius
- Animated progress fill
- Optional percentage label
- Fully themed colors
- Smooth transitions

## Demo Data Generation

### Generate Demo Goals
```swift
let goals = Goal.generateDemoData(count: 8)
```

Generates realistic goals:
- **Emergency Fund**: $10k target, 65% complete
- **Vacation**: $5k target, 56% complete
- **Home Down Payment**: $60k target, 37% complete
- **New Car**: $15k target, 57% complete
- **Education**: $25k target, 48% complete
- **Retirement**: $1M target, 12.5% complete (long-term)
- **Debt Payoff**: $8k target, 65% complete
- **Wedding**: $20k target, 22% complete

Each with:
- Realistic deadlines
- Appropriate progress amounts
- Created/updated timestamps
- Optional notes

## Common Use Cases

### 1. Basic Goals List
```swift
struct GoalsView: View {
    @State private var goals = Goal.generateDemoData()
    
    var body: some View {
        GoalsListView(
            goals: $goals,
            title: "My Goals"
        )
    }
}
```

### 2. With Delete Action
```swift
struct ManageGoalsView: View {
    @State private var goals = Goal.generateDemoData()
    
    var body: some View {
        GoalsListView(
            goals: $goals,
            title: "Manage Goals",
            subtitle: "\(goals.count) active goals",
            onDeleteGoal: { goal in
                withAnimation {
                    goals.removeAll { $0.id == goal.id }
                }
            }
        )
    }
}
```

### 3. With Custom Add Sheet
```swift
struct GoalsView: View {
    @State private var goals = Goal.generateDemoData()
    @State private var showAddSheet = false
    
    var body: some View {
        GoalsListView(
            goals: $goals,
            title: "Financial Goals",
            onAddGoal: {
                showAddSheet = true
            }
        )
        .sheet(isPresented: $showAddSheet) {
            AddGoalSheet(goals: $goals)
        }
    }
}
```

### 4. Filtered Goals
```swift
struct FilteredGoalsView: View {
    @State private var allGoals = Goal.generateDemoData()
    @State private var selectedCategory: GoalCategory? = nil
    
    var filteredGoals: Binding<[Goal]> {
        Binding(
            get: {
                if let category = selectedCategory {
                    return allGoals.filter { $0.category == category }
                }
                return allGoals
            },
            set: { newValue in
                // Update logic if needed
            }
        )
    }
    
    var body: some View {
        VStack {
            // Category picker
            Picker("Category", selection: $selectedCategory) {
                Text("All").tag(nil as GoalCategory?)
                ForEach(GoalCategory.allCases) { category in
                    Text(category.rawValue).tag(category as GoalCategory?)
                }
            }
            
            GoalsListView(
                goals: filteredGoals,
                title: "Goals"
            )
        }
    }
}
```

### 5. With SwiftData
```swift
@Model
class GoalEntity {
    var name: String
    var categoryName: String
    var targetAmount: Double
    var currentAmount: Double
    var deadline: Date?
    var notes: String?
    var createdAt: Date
    var updatedAt: Date
    
    func toGoal() -> Goal {
        Goal(
            name: name,
            category: GoalCategory(rawValue: categoryName) ?? .other,
            targetAmount: targetAmount,
            currentAmount: currentAmount,
            deadline: deadline,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}

struct PersistentGoalsView: View {
    @Query private var goalEntities: [GoalEntity]
    @Environment(\.modelContext) private var modelContext
    
    var goals: [Goal] {
        goalEntities.map { $0.toGoal() }
    }
    
    var body: some View {
        GoalsListView(
            goals: Binding(
                get: { goals },
                set: { newGoals in
                    // Update SwiftData entities
                    updateGoalEntities(newGoals)
                }
            ),
            title: "My Goals",
            onDeleteGoal: { goal in
                if let entity = goalEntities.first(where: { $0.name == goal.name }) {
                    modelContext.delete(entity)
                }
            }
        )
    }
    
    func updateGoalEntities(_ goals: [Goal]) {
        // Sync changes to SwiftData
        for goal in goals {
            if let entity = goalEntities.first(where: { $0.name == goal.name }) {
                entity.currentAmount = goal.currentAmount
                entity.targetAmount = goal.targetAmount
                entity.updatedAt = goal.updatedAt
            }
        }
    }
}
```

### 6. In Dashboard Card
```swift
struct DashboardView: View {
    @State private var goals = Goal.generateDemoData()
    
    var body: some View {
        VStack(spacing: 24) {
            // Other dashboard components...
            
            GoalsListView(
                goals: $goals,
                title: "Financial Goals",
                subtitle: "Active goals"
            )
            .frame(height: 500)
        }
    }
}
```

## Theme Integration

### Colors Used
- **Primary**: Icon backgrounds, buttons
- **Success**: On track status, completed goals
- **Warning**: At risk status
- **Info**: In progress status
- **Error**: Delete button
- **OnSurface**: Primary text
- **OnSurfaceSecondary**: Secondary text
- **OnSurfaceTertiary**: Tertiary text
- **Surface**: Goal row background
- **SurfaceVariant**: Edit form inputs
- **BorderSubtle**: Row borders

### Fonts Used
- **Heading Medium**: List title
- **Body Large**: Goal names
- **Body Medium**: Amounts, subtitle
- **Body Small**: Category, deadline
- **Label Large**: Edit form section titles
- **Label Medium**: Buttons
- **Label Small**: Status badges, category tags

### Spacing Used
- **xxxs-xxxl**: All spacing from theme
- **md**: Row padding
- **lg**: Section spacing
- **sm**: Component spacing
- **xs**: Icon spacing

## Auto-Status Calculation

### Status Logic
```swift
// Completed
if currentAmount >= targetAmount { return .completed }

// Not Started
if currentAmount == 0 { return .notStarted }

// No deadline
if deadline == nil { return .inProgress }

// Deadline passed
if Date() > deadline { return .atRisk }

// Compare to expected progress
let expectedProgress = timeElapsed / totalTime
if progress >= expectedProgress * 0.9 { return .onTrack }
if progress >= expectedProgress * 0.5 { return .inProgress }
return .atRisk
```

### Examples
**Goal**: $10,000 emergency fund, 6-month deadline

| Current | Time | Status |
|---------|------|--------|
| $0 | 0 months | Not Started |
| $2,000 | 1 month | On Track (20% in 17%) |
| $3,000 | 3 months | In Progress (30% vs 50% expected) |
| $5,000 | 3 months | On Track (50% in 50%) |
| $6,000 | 7 months | At Risk (deadline passed) |
| $10,000 | Any | Completed |

## Best Practices

### ✅ DO
- Use bindings for two-way updates
- Provide delete handler for user control
- Set realistic target amounts
- Include deadlines for motivation
- Update `updatedAt` after edits
- Use demo data for testing
- Show appropriate status badges
- Make progress visually clear

### ❌ DON'T
- Don't use unbound state
- Don't skip currency formatting
- Don't hide progress information
- Don't use very long goal names
- Don't forget to handle empty state
- Don't show too many goals at once (paginate)
- Don't skip status badges

## Accessibility

### VoiceOver Support
- Goal names are announced
- Progress percentages are spoken
- Status badges are readable
- Buttons are labeled
- Edit form fields have labels

### Enhanced Accessibility
```swift
GoalsListView(...)
    .accessibilityLabel("Financial goals list")
    .accessibilityHint("Shows \(goals.count) goals with progress tracking")
```

## Performance Considerations

### Optimal Goal Count
- **Ideal**: 5-10 goals
- **Good**: 10-20 goals
- **Paginate**: > 20 goals

### Inline Editing
- Only one goal editable at a time
- Edit form is lightweight
- Changes update immediately

## Complete Example

### Full Featured Implementation
```swift
struct GoalsManagementView: View {
    @Environment(\.theme) private var theme
    @State private var goals = Goal.generateDemoData()
    @State private var showAddSheet = false
    @State private var showDeleteConfirm = false
    @State private var goalToDelete: Goal?
    
    var completedGoals: Int {
        goals.filter { $0.isCompleted }.count
    }
    
    var totalProgress: Double {
        let total = goals.reduce(0.0) { $0 + $1.targetAmount }
        let current = goals.reduce(0.0) { $0 + $1.currentAmount }
        return total > 0 ? current / total : 0
    }
    
    var body: some View {
        VStack(spacing: theme.spacing.lg) {
            // Header Stats
            HStack(spacing: theme.spacing.xl) {
                statCard(
                    title: "Active Goals",
                    value: "\(goals.count)",
                    icon: "target"
                )
                
                statCard(
                    title: "Completed",
                    value: "\(completedGoals)",
                    icon: "checkmark.circle"
                )
                
                statCard(
                    title: "Overall Progress",
                    value: "\(Int(totalProgress * 100))%",
                    icon: "chart.line.uptrend.xyaxis"
                )
            }
            .padding()
            
            // Goals List
            GoalsListView(
                goals: $goals,
                title: "My Financial Goals",
                subtitle: "Stay on track with your objectives",
                onAddGoal: {
                    showAddSheet = true
                },
                onDeleteGoal: { goal in
                    goalToDelete = goal
                    showDeleteConfirm = true
                }
            )
        }
        .sheet(isPresented: $showAddSheet) {
            AddGoalView(goals: $goals)
        }
        .alert("Delete Goal?", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                if let goal = goalToDelete {
                    withAnimation {
                        goals.removeAll { $0.id == goal.id }
                    }
                }
            }
        } message: {
            if let goal = goalToDelete {
                Text("Are you sure you want to delete '\(goal.name)'?")
            }
        }
    }
    
    func statCard(title: String, value: String, icon: String) -> some View {
        Card(elevation: .low, padding: .medium) {
            VStack(spacing: theme.spacing.sm) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(theme.colors.primary)
                
                Text(value)
                    .font(theme.typography.headingLarge)
                    .foregroundColor(theme.colors.onSurface)
                
                Text(title)
                    .font(theme.typography.labelSmall)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
```

---

**Components**: GoalsListView + ProgressBar + GoalModels  
**Files**: 
- `DesignSystem/Components/GoalsListView.swift`
- `DesignSystem/Components/ProgressBar.swift`
- `DesignSystem/Components/GoalModels.swift`  
**Dependencies**: AppTheme  
**Platform**: macOS 14+  
**Framework**: SwiftUI
