//
//  AssetModels.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import Foundation

/// Represents a category of assets for grouping in the pie chart
public enum AssetCategory: String, CaseIterable, Identifiable {
    case checking = "Checking"
    case savings = "Savings"
    case investments = "Investments"
    case retirement = "Retirement"
    case realEstate = "Real Estate"
    case crypto = "Crypto"
    case other = "Other"
    
    public var id: String { rawValue }
    
    /// SF Symbol icon for this asset category
    public var icon: String {
        switch self {
        case .checking: return "banknote"
        case .savings: return "dollarsign.circle"
        case .investments: return "chart.line.uptrend.xyaxis"
        case .retirement: return "building.columns"
        case .realEstate: return "house"
        case .crypto: return "bitcoinsign.circle"
        case .other: return "folder"
        }
    }
    
    /// Human-readable description
    public var description: String {
        rawValue
    }
}

/// Represents an individual asset item
public struct AssetItem: Identifiable {
    public let id: UUID
    public let category: AssetCategory
    public let name: String
    public let value: Double
    public let institutionName: String?
    public let lastUpdated: Date
    
    public init(
        id: UUID = UUID(),
        category: AssetCategory,
        name: String,
        value: Double,
        institutionName: String? = nil,
        lastUpdated: Date = Date()
    ) {
        self.id = id
        self.category = category
        self.name = name
        self.value = value
        self.institutionName = institutionName
        self.lastUpdated = lastUpdated
    }
}

/// Aggregated asset data by category for pie chart display
public struct AssetCategoryData: Identifiable {
    public let id: UUID
    public let category: AssetCategory
    public let totalValue: Double
    public let itemCount: Int
    
    public init(
        id: UUID = UUID(),
        category: AssetCategory,
        totalValue: Double,
        itemCount: Int
    ) {
        self.id = id
        self.category = category
        self.totalValue = totalValue
        self.itemCount = itemCount
    }
    
    /// Calculate percentage of total assets
    public func percentage(of total: Double) -> Double {
        guard total > 0 else { return 0 }
        return (totalValue / total) * 100
    }
}

// MARK: - Demo Data Generation

extension AssetItem {
    /// Generate realistic demo asset data for testing
    public static func generateDemoData(count: Int = 15) -> [AssetItem] {
        var assets: [AssetItem] = []
        let categories = AssetCategory.allCases
        
        // Checking accounts (1-2)
        assets.append(AssetItem(
            category: .checking,
            name: "Primary Checking",
            value: Double.random(in: 2500...8000),
            institutionName: "Chase Bank",
            lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...86400))
        ))
        
        if Bool.random() {
            assets.append(AssetItem(
                category: .checking,
                name: "Business Checking",
                value: Double.random(in: 5000...15000),
                institutionName: "Wells Fargo",
                lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...172800))
            ))
        }
        
        // Savings accounts (1-3)
        assets.append(AssetItem(
            category: .savings,
            name: "Emergency Fund",
            value: Double.random(in: 15000...35000),
            institutionName: "Ally Bank",
            lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...259200))
        ))
        
        assets.append(AssetItem(
            category: .savings,
            name: "High-Yield Savings",
            value: Double.random(in: 8000...25000),
            institutionName: "Marcus",
            lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...345600))
        ))
        
        if Bool.random() {
            assets.append(AssetItem(
                category: .savings,
                name: "Vacation Fund",
                value: Double.random(in: 3000...12000),
                institutionName: "Capital One",
                lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...432000))
            ))
        }
        
        // Investment accounts (2-4)
        assets.append(AssetItem(
            category: .investments,
            name: "Brokerage Account",
            value: Double.random(in: 25000...85000),
            institutionName: "Fidelity",
            lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...86400))
        ))
        
        assets.append(AssetItem(
            category: .investments,
            name: "Index Funds",
            value: Double.random(in: 30000...95000),
            institutionName: "Vanguard",
            lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...172800))
        ))
        
        if Bool.random() {
            assets.append(AssetItem(
                category: .investments,
                name: "Tech Stocks",
                value: Double.random(in: 15000...50000),
                institutionName: "Robinhood",
                lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...259200))
            ))
        }
        
        if assets.count < count {
            assets.append(AssetItem(
                category: .investments,
                name: "Dividend Portfolio",
                value: Double.random(in: 20000...60000),
                institutionName: "Charles Schwab",
                lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...345600))
            ))
        }
        
        // Retirement accounts (1-2)
        assets.append(AssetItem(
            category: .retirement,
            name: "401(k)",
            value: Double.random(in: 50000...250000),
            institutionName: "Fidelity",
            lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...432000))
        ))
        
        if Bool.random() {
            assets.append(AssetItem(
                category: .retirement,
                name: "Roth IRA",
                value: Double.random(in: 25000...95000),
                institutionName: "Vanguard",
                lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...518400))
            ))
        }
        
        // Real Estate (0-2)
        if Bool.random() {
            assets.append(AssetItem(
                category: .realEstate,
                name: "Primary Residence",
                value: Double.random(in: 250000...750000),
                institutionName: nil,
                lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...2592000))
            ))
        }
        
        if assets.count < count && Bool.random() {
            assets.append(AssetItem(
                category: .realEstate,
                name: "Rental Property",
                value: Double.random(in: 150000...450000),
                institutionName: nil,
                lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...2592000))
            ))
        }
        
        // Crypto (0-2)
        if Bool.random() {
            assets.append(AssetItem(
                category: .crypto,
                name: "Bitcoin",
                value: Double.random(in: 5000...35000),
                institutionName: "Coinbase",
                lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...43200))
            ))
        }
        
        if assets.count < count && Bool.random() {
            assets.append(AssetItem(
                category: .crypto,
                name: "Ethereum",
                value: Double.random(in: 3000...20000),
                institutionName: "Coinbase",
                lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...86400))
            ))
        }
        
        // Other assets (0-1)
        if assets.count < count && Bool.random() {
            assets.append(AssetItem(
                category: .other,
                name: "Precious Metals",
                value: Double.random(in: 5000...25000),
                institutionName: nil,
                lastUpdated: Date().addingTimeInterval(-Double.random(in: 0...604800))
            ))
        }
        
        return assets
    }
}

extension AssetCategoryData {
    /// Aggregate asset items by category
    public static func aggregate(from assets: [AssetItem]) -> [AssetCategoryData] {
        var categoryMap: [AssetCategory: (total: Double, count: Int)] = [:]
        
        // Aggregate values by category
        for asset in assets {
            let current = categoryMap[asset.category] ?? (total: 0, count: 0)
            categoryMap[asset.category] = (
                total: current.total + asset.value,
                count: current.count + 1
            )
        }
        
        // Convert to array and sort by value (descending)
        return categoryMap.map { category, data in
            AssetCategoryData(
                category: category,
                totalValue: data.total,
                itemCount: data.count
            )
        }
        .sorted { $0.totalValue > $1.totalValue }
    }
    
    /// Generate demo aggregated data
    public static func generateDemoData() -> [AssetCategoryData] {
        let assets = AssetItem.generateDemoData()
        return aggregate(from: assets)
    }
}
