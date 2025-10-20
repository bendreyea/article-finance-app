import Foundation

// MARK: - Date Range

/// Time range options for financial data filtering
public enum DateRange: String, CaseIterable, Identifiable {
    case week = "7D"
    case month = "30D"
    case quarter = "90D"
    case year = "1Y"
    case all = "All"
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .week: return "This Week"
        case .month: return "This Month"
        case .quarter: return "This Quarter"
        case .year: return "This Year"
        case .all: return "All Time"
        }
    }
    
    public var days: Int? {
        switch self {
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        case .year: return 365
        case .all: return nil
        }
    }
    
    public var dateInterval: DateInterval? {
        guard let days = days else { return nil }
        let end = Date()
        let start = Calendar.current.date(byAdding: .day, value: -days, to: end)!
        return DateInterval(start: start, end: end)
    }
}

// MARK: - Navigation Destination

/// Navigation destinations in the app
public enum NavigationDestination: String, CaseIterable, Identifiable {
    case dashboard
    case incomeExpenses
    case assetsGoals
    
    public var id: String { rawValue }
    
    public var displayName: String {
        switch self {
        case .dashboard: return "Dashboard"
        case .incomeExpenses: return "Income & Expenses"
        case .assetsGoals: return "Assets & Goals"
        }
    }
    
    public var icon: String {
        switch self {
        case .dashboard: return "chart.pie.fill"
        case .incomeExpenses: return "dollarsign.circle.fill"
        case .assetsGoals: return "target"
        }
    }
    
    public var supportsSearch: Bool {
        switch self {
        case .dashboard: return false
        case .incomeExpenses: return true
        case .assetsGoals: return true
        }
    }
}
