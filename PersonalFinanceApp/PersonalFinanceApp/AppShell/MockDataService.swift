import SwiftUI
import Foundation

/// Mock data service providing sample financial data
@Observable
public class MockDataService {
    public static let shared = MockDataService()
    
    // MARK: - Overview Data
    public let netWorth: Double = 285000
    public let netWorthTarget: Double = 350000
    public let availableBalance: Double = 45250
    public let monthlyIncome: Double = 8500
    public let monthlyExpenses: Double = 6200
    
    private init() {}
    
    // MARK: - Transaction Data
    public func getTransactions(for dateRange: DateRange) -> [TransactionRow] {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -dateRange.days, to: endDate) ?? endDate
        
        return generateTransactions(from: startDate, to: endDate, count: dateRange.days * 2)
    }
    
    private func generateTransactions(from startDate: Date, to endDate: Date, count: Int) -> [TransactionRow] {
        var transactions: [TransactionRow] = []
        let calendar = Calendar.current
        
        for _ in 0..<count {
            let randomDayOffset = Int.random(in: 0...Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!)
            let transactionDate = calendar.date(byAdding: .day, value: randomDayOffset, to: startDate) ?? startDate
            
            let transaction = generateRandomTransaction(date: transactionDate)
            transactions.append(transaction)
        }
        
        return transactions.sorted { $0.billDueDate > $1.billDueDate }
    }
    
    private func generateRandomTransaction(date: Date) -> TransactionRow {
        let categories = TransactionCategory.allCases
        let category = categories.randomElement() ?? .other
        let statuses = TransactionStatus.allCases
        let status = statuses.randomElement() ?? .paid
        
        let (subCategory, payee, description, amount) = getTransactionDetails(for: category)
        
        return TransactionRow(
            category: category,
            subCategory: subCategory,
            amount: amount,
            billDueDate: date,
            status: status,
            description: description,
            payee: payee
        )
    }
    
    private func getTransactionDetails(for category: TransactionCategory) -> (String, String, String, Double) {
        switch category {
        case .housing:
            let options = [
                ("Rent", "Property Management LLC", "Monthly apartment rent", 2500.0),
                ("Utilities", "City Power & Light", "Electricity bill", Double.random(in: 80...200)),
                ("Internet", "FastNet ISP", "Monthly internet service", 79.99),
                ("Insurance", "Home Guard Insurance", "Renters insurance", 25.0)
            ]
            return options.randomElement() ?? options[0]
            
        case .transportation:
            let options = [
                ("Gas", "Shell Station", "Fuel purchase", Double.random(in: 40...80)),
                ("Car Payment", "Auto Finance Co", "Monthly car loan", 450.0),
                ("Insurance", "SafeDrive Insurance", "Auto insurance", 125.0),
                ("Maintenance", "Quick Lube", "Oil change", 65.0)
            ]
            return options.randomElement() ?? options[0]
            
        case .food:
            let options = [
                ("Groceries", "SuperMarket Plus", "Weekly grocery shopping", Double.random(in: 75...150)),
                ("Restaurant", "Italian Bistro", "Dinner with friends", Double.random(in: 45...120)),
                ("Coffee", "Corner Café", "Morning coffee", Double.random(in: 4...12)),
                ("Takeout", "Dragon Express", "Chinese food delivery", Double.random(in: 25...45))
            ]
            return options.randomElement() ?? options[0]
            
        case .utilities:
            let options = [
                ("Electricity", "City Power", "Monthly electric bill", Double.random(in: 85...165)),
                ("Water", "Municipal Water", "Water & sewer", Double.random(in: 35...75)),
                ("Gas", "Natural Gas Co", "Heating gas", Double.random(in: 45...125)),
                ("Trash", "Waste Management", "Garbage collection", 35.0)
            ]
            return options.randomElement() ?? options[0]
            
        case .healthcare:
            let options = [
                ("Insurance", "HealthCare Partners", "Monthly premium", 350.0),
                ("Dentist", "Smile Dental", "Regular cleaning", 125.0),
                ("Pharmacy", "Corner Pharmacy", "Prescription medication", Double.random(in: 15...85)),
                ("Doctor", "Family Medicine", "Check-up visit", 45.0)
            ]
            return options.randomElement() ?? options[0]
            
        case .entertainment:
            let options = [
                ("Streaming", "Netflix", "Monthly subscription", 15.99),
                ("Movies", "Cinema Complex", "Movie tickets", Double.random(in: 25...50)),
                ("Music", "Spotify Premium", "Music streaming", 9.99),
                ("Gaming", "Game Store", "Video game purchase", Double.random(in: 30...70))
            ]
            return options.randomElement() ?? options[0]
            
        case .shopping:
            let options = [
                ("Clothing", "Fashion Store", "New shirt", Double.random(in: 35...120)),
                ("Electronics", "Tech Mart", "Phone accessory", Double.random(in: 20...150)),
                ("Books", "Bookstore", "Novel purchase", Double.random(in: 12...25)),
                ("Home", "HomeGoods", "Kitchen utensils", Double.random(in: 25...75))
            ]
            return options.randomElement() ?? options[0]
            
        case .income:
            let options = [
                ("Salary", "Tech Company Inc", "Bi-weekly paycheck", -4500.0),
                ("Freelance", "Client Corp", "Consulting work", -Double.random(in: 800...2500)),
                ("Investment", "Brokerage", "Dividend payment", -Double.random(in: 150...500)),
                ("Side Gig", "Gig Platform", "Weekend earnings", -Double.random(in: 200...800))
            ]
            return options.randomElement() ?? options[0]
            
        case .savings:
            let options = [
                ("Emergency Fund", "High Yield Savings", "Monthly transfer", 500.0),
                ("Retirement", "401k Plan", "Contribution", 750.0),
                ("Investment", "Brokerage Account", "Stock purchase", Double.random(in: 300...1000)),
                ("Education", "529 Plan", "College savings", 200.0)
            ]
            return options.randomElement() ?? options[0]
            
        case .other:
            let options = [
                ("Gift", "Various", "Birthday gift", Double.random(in: 25...100)),
                ("Charity", "Local Charity", "Monthly donation", 50.0),
                ("Fees", "Bank", "Account maintenance", 12.0),
                ("Miscellaneous", "Various", "Random expense", Double.random(in: 15...75))
            ]
            return options.randomElement() ?? options[0]
        }
    }
    
    // MARK: - Income/Expense Chart Data
    public func getIncomeExpenseData(for dateRange: DateRange) -> (income: [(Date, Double)], expenses: [(Date, Double)]) {
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -dateRange.days, to: endDate) ?? endDate
        
        var incomeData: [(Date, Double)] = []
        var expenseData: [(Date, Double)] = []
        
        for dayOffset in 0..<dateRange.days {
            guard let date = calendar.date(byAdding: .day, value: dayOffset, to: startDate) else { continue }
            
            let isWeekend = calendar.isDateInWeekend(date)
            
            // Generate income (higher on weekdays for salary, some weekend gig work)
            let incomeBase: Double = isWeekend ? 50 : 280
            let incomeVariation = Double.random(in: -50...150)
            let income = max(0, incomeBase + incomeVariation)
            
            // Generate expenses (varies throughout week and month)
            let expenseBase: Double = isWeekend ? 180 : 150
            let expenseVariation = Double.random(in: -40...100)
            let expenses = max(20, expenseBase + expenseVariation)
            
            if income > 0 {
                incomeData.append((date, income))
            }
            expenseData.append((date, expenses))
        }
        
        return (incomeData, expenseData)
    }
    
    // MARK: - Asset Allocation Data
    public func getAssetAllocation() -> [AssetAllocation] {
        return AssetsPieCard.demoAssets
    }
    
    // MARK: - Financial Goals Data
    public func getFinancialGoals() -> [FinancialGoal] {
        return GoalsListView.demoGoals
    }
    
    // MARK: - Account Balances
    public func getAccountBalances() -> [AccountBalance] {
        return [
            AccountBalance(name: "Checking Account", balance: 15250, type: .checking),
            AccountBalance(name: "Savings Account", balance: 25000, type: .savings),
            AccountBalance(name: "Investment Account", balance: 125000, type: .investment),
            AccountBalance(name: "Retirement 401k", balance: 85000, type: .retirement)
        ]
    }
}

/// Account balance data model
public struct AccountBalance: Identifiable {
    public let id = UUID()
    public let name: String
    public let balance: Double
    public let type: AccountType
    
    public init(name: String, balance: Double, type: AccountType) {
        self.name = name
        self.balance = balance
        self.type = type
    }
}

/// Account types
public enum AccountType: String, CaseIterable {
    case checking = "Checking"
    case savings = "Savings" 
    case investment = "Investment"
    case retirement = "Retirement"
    
    var icon: String {
        switch self {
        case .checking: return "creditcard"
        case .savings: return "banknote"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .retirement: return "figure.walk"
        }
    }
    
    var color: Color {
        switch self {
        case .checking: return .blue
        case .savings: return .green
        case .investment: return .purple
        case .retirement: return .orange
        }
    }
}

/// Historical data point for trends
public struct HistoricalDataPoint: Identifiable {
    public let id = UUID()
    public let date: Date
    public let netWorth: Double
    public let cashFlow: Double
    
    public init(date: Date, netWorth: Double, cashFlow: Double) {
        self.date = date
        self.netWorth = netWorth
        self.cashFlow = cashFlow
    }
}

// MARK: - Mock Data Extensions
extension MockDataService {
    /// Get historical net worth data for trend analysis
    public func getNetWorthHistory(months: Int = 12) -> [HistoricalDataPoint] {
        let calendar = Calendar.current
        let endDate = Date()
        var dataPoints: [HistoricalDataPoint] = []
        
        for monthOffset in (0..<months).reversed() {
            guard let date = calendar.date(byAdding: .month, value: -monthOffset, to: endDate) else { continue }
            
            let baseNetWorth = 240000.0
            let growth = Double(months - monthOffset) * 3500.0
            let variation = Double.random(in: -5000...8000)
            let netWorth = baseNetWorth + growth + variation
            
            let cashFlow = Double.random(in: -2000...4000)
            
            dataPoints.append(HistoricalDataPoint(
                date: date,
                netWorth: netWorth,
                cashFlow: cashFlow
            ))
        }
        
        return dataPoints
    }
    
    /// Get spending by category for current month
    public func getSpendingByCategory() -> [CategorySpending] {
        return [
            CategorySpending(category: .housing, amount: 2800, budget: 3000),
            CategorySpending(category: .food, amount: 650, budget: 800),
            CategorySpending(category: .transportation, amount: 420, budget: 500),
            CategorySpending(category: .utilities, amount: 285, budget: 350),
            CategorySpending(category: .entertainment, amount: 180, budget: 200),
            CategorySpending(category: .healthcare, amount: 150, budget: 400),
            CategorySpending(category: .shopping, amount: 320, budget: 300),
            CategorySpending(category: .other, amount: 95, budget: 150)
        ]
    }
}

/// Category spending data model
public struct CategorySpending: Identifiable {
    public let id = UUID()
    public let category: TransactionCategory
    public let amount: Double
    public let budget: Double
    
    public init(category: TransactionCategory, amount: Double, budget: Double) {
        self.category = category
        self.amount = amount
        self.budget = budget
    }
    
    public var percentageUsed: Double {
        guard budget > 0 else { return 0 }
        return amount / budget
    }
    
    public var isOverBudget: Bool {
        return amount > budget
    }
}