//
//  NavigationDestination.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// Represents the main navigation destinations in the app
enum NavigationDestination: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case incomeExpenses = "Income & Expenses"
    case assetsGoals = "Assets & Goals"
    
    var id: String { rawValue }
    
    /// SF Symbol icon for this destination
    var icon: String {
        switch self {
        case .dashboard:
            return "chart.pie.fill"
        case .incomeExpenses:
            return "dollarsign.circle.fill"
        case .assetsGoals:
            return "target"
        }
    }
    
    /// Display title
    var title: String {
        rawValue
    }
    
    /// Subtitle/description
    var subtitle: String {
        switch self {
        case .dashboard:
            return "Overview and insights"
        case .incomeExpenses:
            return "Track income and expenses"
        case .assetsGoals:
            return "Manage assets and goals"
        }
    }
}
