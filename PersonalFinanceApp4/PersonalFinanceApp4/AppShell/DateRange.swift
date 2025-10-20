//
//  DateRange.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import Foundation

/// Represents a time range for filtering financial data
enum DateRange: String, CaseIterable, Identifiable {
    case week = "Week"
    case month = "Month"
    case quarter = "Quarter"
    case year = "Year"
    case allTime = "All Time"
    
    var id: String { rawValue }
    
    /// Display title
    var title: String {
        rawValue
    }
    
    /// Calculate the start and end dates for this range
    func dateInterval(relativeTo date: Date = Date()) -> DateInterval {
        let calendar = Calendar.current
        let endDate = date
        
        let startDate: Date
        switch self {
        case .week:
            // Last 7 days
            startDate = calendar.date(byAdding: .day, value: -7, to: endDate) ?? endDate
            
        case .month:
            // Last 30 days
            startDate = calendar.date(byAdding: .day, value: -30, to: endDate) ?? endDate
            
        case .quarter:
            // Last 90 days
            startDate = calendar.date(byAdding: .day, value: -90, to: endDate) ?? endDate
            
        case .year:
            // Last 365 days
            startDate = calendar.date(byAdding: .day, value: -365, to: endDate) ?? endDate
            
        case .allTime:
            // Last 5 years (arbitrary far date)
            startDate = calendar.date(byAdding: .year, value: -5, to: endDate) ?? endDate
        }
        
        return DateInterval(start: startDate, end: endDate)
    }
    
    /// Number of days in this range
    var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        case .year: return 365
        case .allTime: return 1825 // 5 years
        }
    }
    
    /// Short label for compact display
    var shortLabel: String {
        switch self {
        case .week: return "7D"
        case .month: return "30D"
        case .quarter: return "90D"
        case .year: return "1Y"
        case .allTime: return "All"
        }
    }
}

/// Filter model that combines date range with search query
struct DataFilter {
    var dateRange: DateRange
    var searchQuery: String
    
    init(dateRange: DateRange = .month, searchQuery: String = "") {
        self.dateRange = dateRange
        self.searchQuery = searchQuery
    }
    
    /// Check if a date falls within the selected range
    func contains(date: Date) -> Bool {
        let interval = dateRange.dateInterval()
        return interval.contains(date)
    }
    
    /// Check if a string matches the search query
    func matches(text: String) -> Bool {
        guard !searchQuery.isEmpty else { return true }
        return text.localizedCaseInsensitiveContains(searchQuery)
    }
    
    /// Check if filter has any active criteria
    var isActive: Bool {
        dateRange != .allTime || !searchQuery.isEmpty
    }
}
