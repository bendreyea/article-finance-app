//
//  GoalModels.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import Foundation

/// Represents a financial goal category
public enum GoalCategory: String, CaseIterable, Identifiable {
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
    
    public var id: String { rawValue }
    
    /// SF Symbol icon for this goal category
    public var icon: String {
        switch self {
        case .emergency: return "cross.case"
        case .vacation: return "airplane"
        case .home: return "house"
        case .car: return "car"
        case .education: return "graduationcap"
        case .retirement: return "beach.umbrella"
        case .debt: return "creditcard"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .wedding: return "heart"
        case .business: return "briefcase"
        case .other: return "star"
        }
    }
}

/// Represents the status of a goal
public enum GoalStatus: String, CaseIterable {
    case notStarted = "Not Started"
    case inProgress = "In Progress"
    case onTrack = "On Track"
    case atRisk = "At Risk"
    case completed = "Completed"
    
    /// Color semantic for this status
    public var colorKey: GoalStatusColor {
        switch self {
        case .notStarted: return .neutral
        case .inProgress: return .info
        case .onTrack: return .success
        case .atRisk: return .warning
        case .completed: return .success
        }
    }
}

/// Color mapping for goal status
public enum GoalStatusColor {
    case success
    case warning
    case info
    case neutral
}

/// Represents a financial goal with progress tracking
public struct Goal: Identifiable, Equatable {
    public let id: UUID
    public var name: String
    public var category: GoalCategory
    public var targetAmount: Double
    public var currentAmount: Double
    public var deadline: Date?
    public var notes: String?
    public var createdAt: Date
    public var updatedAt: Date
    
    public init(
        id: UUID = UUID(),
        name: String,
        category: GoalCategory,
        targetAmount: Double,
        currentAmount: Double = 0,
        deadline: Date? = nil,
        notes: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.targetAmount = targetAmount
        self.currentAmount = currentAmount
        self.deadline = deadline
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    // MARK: - Computed Properties
    
    /// Progress as a percentage (0.0 to 1.0)
    public var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(currentAmount / targetAmount, 1.0)
    }
    
    /// Progress as a percentage (0 to 100)
    public var progressPercentage: Double {
        progress * 100
    }
    
    /// Amount remaining to reach goal
    public var remainingAmount: Double {
        max(targetAmount - currentAmount, 0)
    }
    
    /// Whether the goal is completed
    public var isCompleted: Bool {
        currentAmount >= targetAmount
    }
    
    /// Goal status based on progress and deadline
    public var status: GoalStatus {
        if isCompleted {
            return .completed
        }
        
        if currentAmount == 0 {
            return .notStarted
        }
        
        // Check if there's a deadline
        guard let deadline = deadline else {
            return currentAmount > 0 ? .inProgress : .notStarted
        }
        
        let now = Date()
        let timeRemaining = deadline.timeIntervalSince(now)
        let totalTime = deadline.timeIntervalSince(createdAt)
        let timeElapsed = now.timeIntervalSince(createdAt)
        
        // If deadline passed
        if timeRemaining < 0 {
            return .atRisk
        }
        
        // Calculate expected progress based on time
        let expectedProgress = totalTime > 0 ? timeElapsed / totalTime : 0
        
        // Compare actual progress to expected
        if progress >= expectedProgress * 0.9 { // Within 90% of expected
            return .onTrack
        } else if progress >= expectedProgress * 0.5 { // At least 50% of expected
            return .inProgress
        } else {
            return .atRisk
        }
    }
    
    /// Days remaining until deadline (nil if no deadline)
    public var daysRemaining: Int? {
        guard let deadline = deadline else { return nil }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: deadline)
        return components.day
    }
    
    /// Formatted deadline string
    public var deadlineString: String? {
        guard let deadline = deadline else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: deadline)
    }
}

// MARK: - Demo Data Generation

extension Goal {
    /// Generate realistic demo goal data for testing
    public static func generateDemoData(count: Int = 8) -> [Goal] {
        var goals: [Goal] = []
        
        // Emergency Fund
        goals.append(Goal(
            name: "Emergency Fund",
            category: .emergency,
            targetAmount: 10000,
            currentAmount: 6500,
            deadline: Calendar.current.date(byAdding: .month, value: 6, to: Date()),
            notes: "6 months of expenses",
            createdAt: Calendar.current.date(byAdding: .month, value: -4, to: Date())!,
            updatedAt: Date()
        ))
        
        // Vacation
        goals.append(Goal(
            name: "European Vacation",
            category: .vacation,
            targetAmount: 5000,
            currentAmount: 2800,
            deadline: Calendar.current.date(byAdding: .month, value: 8, to: Date()),
            notes: "2-week trip to Italy and France",
            createdAt: Calendar.current.date(byAdding: .month, value: -3, to: Date())!,
            updatedAt: Date()
        ))
        
        // Home Purchase
        goals.append(Goal(
            name: "House Down Payment",
            category: .home,
            targetAmount: 60000,
            currentAmount: 22000,
            deadline: Calendar.current.date(byAdding: .year, value: 2, to: Date()),
            notes: "20% down on $300k home",
            createdAt: Calendar.current.date(byAdding: .month, value: -8, to: Date())!,
            updatedAt: Date()
        ))
        
        // Car
        if goals.count < count {
            goals.append(Goal(
                name: "New Car",
                category: .car,
                targetAmount: 15000,
                currentAmount: 8500,
                deadline: Calendar.current.date(byAdding: .month, value: 10, to: Date()),
                notes: "Used reliable sedan",
                createdAt: Calendar.current.date(byAdding: .month, value: -5, to: Date())!,
                updatedAt: Date()
            ))
        }
        
        // Education
        if goals.count < count {
            goals.append(Goal(
                name: "Master's Degree",
                category: .education,
                targetAmount: 25000,
                currentAmount: 12000,
                deadline: Calendar.current.date(byAdding: .year, value: 1, to: Date()),
                notes: "Part-time program",
                createdAt: Calendar.current.date(byAdding: .month, value: -6, to: Date())!,
                updatedAt: Date()
            ))
        }
        
        // Retirement - long term
        if goals.count < count {
            goals.append(Goal(
                name: "Retirement Savings",
                category: .retirement,
                targetAmount: 1000000,
                currentAmount: 125000,
                deadline: Calendar.current.date(byAdding: .year, value: 20, to: Date()),
                notes: "Age 65 retirement goal",
                createdAt: Calendar.current.date(byAdding: .year, value: -3, to: Date())!,
                updatedAt: Date()
            ))
        }
        
        // Debt Payoff
        if goals.count < count {
            goals.append(Goal(
                name: "Credit Card Debt",
                category: .debt,
                targetAmount: 8000,
                currentAmount: 5200,
                deadline: Calendar.current.date(byAdding: .month, value: 4, to: Date()),
                notes: "High interest cards first",
                createdAt: Calendar.current.date(byAdding: .month, value: -7, to: Date())!,
                updatedAt: Date()
            ))
        }
        
        // Wedding
        if goals.count < count {
            goals.append(Goal(
                name: "Wedding Fund",
                category: .wedding,
                targetAmount: 20000,
                currentAmount: 4500,
                deadline: Calendar.current.date(byAdding: .year, value: 1, to: Date()),
                notes: "Small ceremony and reception",
                createdAt: Calendar.current.date(byAdding: .month, value: -2, to: Date())!,
                updatedAt: Date()
            ))
        }
        
        // Investment
        if goals.count < count {
            goals.append(Goal(
                name: "Investment Portfolio",
                category: .investment,
                targetAmount: 50000,
                currentAmount: 18000,
                deadline: Calendar.current.date(byAdding: .year, value: 3, to: Date()),
                notes: "Diversified index funds",
                createdAt: Calendar.current.date(byAdding: .year, value: -1, to: Date())!,
                updatedAt: Date()
            ))
        }
        
        // Business
        if goals.count < count {
            goals.append(Goal(
                name: "Start Business",
                category: .business,
                targetAmount: 30000,
                currentAmount: 3000,
                deadline: Calendar.current.date(byAdding: .year, value: 2, to: Date()),
                notes: "Initial capital for side business",
                createdAt: Calendar.current.date(byAdding: .month, value: -1, to: Date())!,
                updatedAt: Date()
            ))
        }
        
        return goals
    }
}
