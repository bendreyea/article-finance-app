//
//  TransactionModels.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import Foundation

// MARK: - Transaction Status

/// Status of a transaction or bill
public enum TransactionStatus: String, CaseIterable, Codable {
    case paid = "Paid"
    case due = "Due"
    case late = "Late"
    
    /// Sort priority (Late > Due > Paid)
    var priority: Int {
        switch self {
        case .late: return 0
        case .due: return 1
        case .paid: return 2
        }
    }
}

// MARK: - Transaction Category

/// Transaction category for filtering
public enum TransactionCategory: String, CaseIterable, Codable, Identifiable {
    case housing = "Housing"
    case utilities = "Utilities"
    case groceries = "Groceries"
    case transportation = "Transportation"
    case entertainment = "Entertainment"
    case healthcare = "Healthcare"
    case shopping = "Shopping"
    case dining = "Dining"
    case income = "Income"
    case other = "Other"
    
    public var id: String { rawValue }
    
    /// SF Symbol icon for the category
    var icon: String {
        switch self {
        case .housing: return "house.fill"
        case .utilities: return "bolt.fill"
        case .groceries: return "cart.fill"
        case .transportation: return "car.fill"
        case .entertainment: return "tv.fill"
        case .healthcare: return "cross.case.fill"
        case .shopping: return "bag.fill"
        case .dining: return "fork.knife"
        case .income: return "dollarsign.circle.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }
}

// MARK: - Transaction Row

/// A transaction row for display in the table
public struct TransactionRow: Identifiable, Codable {
    public let id: UUID
    public let category: TransactionCategory
    public let subcategory: String
    public let amount: Double
    public let dueDate: Date
    public var status: TransactionStatus
    public let notes: String?
    
    public init(
        id: UUID = UUID(),
        category: TransactionCategory,
        subcategory: String,
        amount: Double,
        dueDate: Date,
        status: TransactionStatus,
        notes: String? = nil
    ) {
        self.id = id
        self.category = category
        self.subcategory = subcategory
        self.amount = amount
        self.dueDate = dueDate
        self.status = status
        self.notes = notes
    }
}

// MARK: - Demo Data Generator

extension TransactionRow {
    /// Generate demo transactions for previews and testing
    public static func generateDemoData(count: Int = 20) -> [TransactionRow] {
        let calendar = Calendar.current
        let today = Date()
        
        let subcategories: [TransactionCategory: [String]] = [
            .housing: ["Rent", "Mortgage", "Property Tax", "HOA Fees"],
            .utilities: ["Electricity", "Water", "Gas", "Internet", "Phone"],
            .groceries: ["Whole Foods", "Trader Joe's", "Costco", "Farmers Market"],
            .transportation: ["Gas", "Car Payment", "Insurance", "Parking"],
            .entertainment: ["Netflix", "Spotify", "Movies", "Concerts"],
            .healthcare: ["Insurance Premium", "Prescription", "Doctor Visit", "Dental"],
            .shopping: ["Amazon", "Target", "Clothing", "Electronics"],
            .dining: ["Restaurant", "Coffee Shop", "Fast Food", "Delivery"],
            .income: ["Salary", "Freelance", "Investment", "Bonus"],
            .other: ["Misc", "Gift", "Donation", "Subscription"]
        ]
        
        var transactions: [TransactionRow] = []
        
        for i in 0..<count {
            let category = TransactionCategory.allCases.randomElement()!
            let subcategoryOptions = subcategories[category] ?? ["General"]
            let subcategory = subcategoryOptions.randomElement()!
            
            // Generate amount based on category
            let amount: Double
            switch category {
            case .housing:
                amount = Double.random(in: 1200...2500)
            case .utilities:
                amount = Double.random(in: 50...200)
            case .groceries:
                amount = Double.random(in: 30...150)
            case .transportation:
                amount = Double.random(in: 40...400)
            case .entertainment:
                amount = Double.random(in: 10...100)
            case .healthcare:
                amount = Double.random(in: 50...500)
            case .shopping:
                amount = Double.random(in: 20...300)
            case .dining:
                amount = Double.random(in: 15...80)
            case .income:
                amount = Double.random(in: 500...5000)
            case .other:
                amount = Double.random(in: 10...200)
            }
            
            // Generate due date
            let daysOffset = Int.random(in: -15...15)
            let dueDate = calendar.date(byAdding: .day, value: daysOffset, to: today)!
            
            // Determine status based on due date
            let status: TransactionStatus
            let daysDiff = calendar.dateComponents([.day], from: dueDate, to: today).day ?? 0
            if daysDiff > 3 {
                status = .late
            } else if daysDiff > 0 || daysDiff == 0 {
                status = .due
            } else {
                status = Bool.random() ? .paid : .due
            }
            
            let notes = Bool.random() ? "Auto-pay enabled" : nil
            
            transactions.append(
                TransactionRow(
                    category: category,
                    subcategory: subcategory,
                    amount: amount,
                    dueDate: dueDate,
                    status: status,
                    notes: notes
                )
            )
        }
        
        return transactions
    }
}
