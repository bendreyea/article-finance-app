# AssetsPieCard Component Guide

## Overview

`AssetsPieCard` is a sophisticated pie chart component built with Swift Charts' `SectorMark`, designed for visualizing asset allocation by category. It features a center total display, external legend with detailed breakdowns, and uses the theme's chart palette for consistent, beautiful data visualization.

## Components Package

This implementation includes **2 interconnected components**:

1. **AssetModels** - Data structures and demo generators
2. **AssetsPieCard** - Pie chart visualization with legend

## Features

✅ **Swift Charts SectorMark** - Native pie/donut chart rendering  
✅ **Center Total Display** - Shows total assets in the center  
✅ **External Legend** - Detailed category breakdown with icons  
✅ **Chart Palette** - Uses `theme.colors.chartPalette` for colors  
✅ **Currency Formatting** - Proper $ formatting  
✅ **Percentage Display** - Shows each category's percentage  
✅ **Category Icons** - SF Symbols for visual identification  
✅ **Donut/Pie Toggle** - Show center total or full pie  
✅ **Responsive Layout** - Chart + legend side-by-side  
✅ **Fully Themed** - Zero hardcoded colors or fonts  
✅ **Demo Data** - Realistic asset generator  

## Basic Usage

```swift
AssetsPieCard(
    assetData: AssetCategoryData.generateDemoData(),
    title: "Asset Allocation",
    subtitle: "By Category"
)
```

## Full API

```swift
AssetsPieCard(
    assetData: [AssetCategoryData],
    title: String = "Asset Allocation",
    subtitle: String? = nil,
    showLegend: Bool = true,
    showCenterTotal: Bool = true
)
```

## Parameters

### assetData: [AssetCategoryData]
Array of aggregated asset data by category.

**AssetCategoryData Structure**:
```swift
AssetCategoryData(
    category: AssetCategory,      // .checking, .savings, etc.
    totalValue: Double,            // Total $ for this category
    itemCount: Int                 // Number of items in category
)
```

**Available Categories**:
- `checking` - Checking accounts
- `savings` - Savings accounts
- `investments` - Investment accounts
- `retirement` - Retirement accounts (401k, IRA)
- `realEstate` - Real estate holdings
- `crypto` - Cryptocurrency
- `other` - Other assets

### title: String (Default: "Asset Allocation")
Main heading for the card.

### subtitle: String? (Default: nil)
Optional subtitle for additional context.

### showLegend: Bool (Default: true)
Whether to show the external legend.
- `true`: Shows chart + legend side-by-side (default)
- `false`: Chart only, full width

### showCenterTotal: Bool (Default: true)
Whether to show total in the center (donut style).
- `true`: Donut chart with center total (default)
- `false`: Full pie chart

## Data Models

### AssetCategory Enum
```swift
enum AssetCategory: String, CaseIterable {
    case checking = "Checking"
    case savings = "Savings"
    case investments = "Investments"
    case retirement = "Retirement"
    case realEstate = "Real Estate"
    case crypto = "Crypto"
    case other = "Other"
}
```

Each category has:
- Icon (SF Symbol)
- Color from chart palette
- Human-readable name

### AssetItem Model
```swift
AssetItem(
    id: UUID = UUID(),
    category: AssetCategory,
    name: String,                    // "Primary Checking", "401(k)", etc.
    value: Double,                   // Current value
    institutionName: String?,        // "Chase Bank", "Fidelity", etc.
    lastUpdated: Date = Date()
)
```

Individual asset items that get aggregated into `AssetCategoryData`.

### AssetCategoryData Model
```swift
AssetCategoryData(
    id: UUID = UUID(),
    category: AssetCategory,
    totalValue: Double,              // Sum of all items in category
    itemCount: Int                   // Number of items
)

// Helper method
func percentage(of total: Double) -> Double
```

Aggregated data for pie chart display.

## Chart Features

### Pie Chart (SectorMark)
- **Inner Radius**: 60% (donut) or 0% (full pie)
- **Angular Inset**: 2pt spacing between slices
- **Corner Radius**: 4pt rounded slice corners
- **Colors**: From `theme.colors.chartPalette`
- **Height**: 280pt

### Center Total Display
When `showCenterTotal = true`:
- Label: "Total Assets"
- Value: Currency formatted total
- Font: `theme.typography.headingLarge`
- Color: `theme.colors.onSurface`

### Legend Display
Shows for each category:
- **Color Indicator**: 12pt circle
- **Category Icon**: SF Symbol (20pt)
- **Category Name**: With icon
- **Dollar Amount**: Currency formatted
- **Percentage**: Of total assets
- **Scrollable**: For many categories

## Demo Data Generation

### Generate Demo Assets
```swift
let assets = AssetItem.generateDemoData(count: 15)
```

Generates realistic asset items:
- **Checking**: 1-2 accounts ($2.5k-$15k)
- **Savings**: 1-3 accounts ($3k-$35k)
- **Investments**: 2-4 accounts ($15k-$95k)
- **Retirement**: 1-2 accounts ($25k-$250k)
- **Real Estate**: 0-2 properties ($150k-$750k)
- **Crypto**: 0-2 holdings ($3k-$35k)
- **Other**: 0-1 items ($5k-$25k)

### Generate Aggregated Data
```swift
// Option 1: From demo assets
let aggregatedData = AssetCategoryData.generateDemoData()

// Option 2: From your own assets
let assets: [AssetItem] = loadMyAssets()
let aggregatedData = AssetCategoryData.aggregate(from: assets)
```

## Common Use Cases

### 1. Basic Asset Pie Chart
```swift
struct DashboardView: View {
    let assetData: [AssetCategoryData]
    
    var body: some View {
        AssetsPieCard(
            assetData: assetData,
            title: "Total Net Worth",
            subtitle: "All Accounts"
        )
    }
}
```

### 2. Without Legend (Compact)
```swift
AssetsPieCard(
    assetData: assetData,
    title: "Asset Distribution",
    showLegend: false
)
.frame(width: 400)
```

### 3. Full Pie (No Center Total)
```swift
AssetsPieCard(
    assetData: assetData,
    title: "Asset Allocation",
    showCenterTotal: false
)
```

### 4. In a Dashboard Grid
```swift
HStack(spacing: 24) {
    AssetsPieCard(
        assetData: liquidAssets,
        title: "Liquid Assets",
        showLegend: false
    )
    
    AssetsPieCard(
        assetData: investmentAssets,
        title: "Investments",
        showLegend: false
    )
}
```

### 5. With Live Data
```swift
struct AssetsView: View {
    @Query private var assets: [Asset]
    
    var assetData: [AssetCategoryData] {
        let items = assets.map { asset in
            AssetItem(
                category: asset.category,
                name: asset.name,
                value: asset.currentValue,
                institutionName: asset.institution
            )
        }
        return AssetCategoryData.aggregate(from: items)
    }
    
    var body: some View {
        AssetsPieCard(
            assetData: assetData,
            title: "My Assets",
            subtitle: "Updated \(Date().formatted())"
        )
    }
}
```

### 6. Filter by Type
```swift
struct FilteredAssetsView: View {
    let allAssets: [AssetItem]
    let filterCategories: Set<AssetCategory>
    
    var filteredData: [AssetCategoryData] {
        let filtered = allAssets.filter { 
            filterCategories.contains($0.category) 
        }
        return AssetCategoryData.aggregate(from: filtered)
    }
    
    var body: some View {
        AssetsPieCard(
            assetData: filteredData,
            title: "Filtered View"
        )
    }
}
```

## Theme Integration

### Chart Palette Usage
Colors are automatically selected from `theme.colors.chartPalette`:
```swift
// Category 0 (Checking) → chartPalette[0]
// Category 1 (Savings) → chartPalette[1]
// Category 2 (Investments) → chartPalette[2]
// ... and so on, wrapping around if needed
```

### Colors Used
- **Pie Slices**: `theme.colors.chartPalette[index]`
- **Center Total Label**: `theme.colors.onSurfaceSecondary`
- **Center Total Value**: `theme.colors.onSurface`
- **Legend Category**: `theme.colors.onSurface`
- **Legend Values**: `theme.colors.onSurfaceSecondary`
- **Background**: `theme.colors.surface`

### Fonts Used
- **Title**: `theme.typography.headingMedium`
- **Subtitle**: `theme.typography.bodyMedium`
- **Center Label**: `theme.typography.labelMedium`
- **Center Value**: `theme.typography.headingLarge`
- **Legend Header**: `theme.typography.labelLarge`
- **Legend Items**: `theme.typography.bodySmall`
- **Legend Values**: `theme.typography.labelSmall`

### Both Themes Work Perfectly
- **Vibrant Theme**: Bold colors, high contrast, dramatic visualization
- **Neutral Theme**: Subtle colors, professional look, harmonious palette

## Chart Palette

### Vibrant Theme Palette
8 bold colors:
1. Purple `#7247F5`
2. Cyan `#1FC7E3`
3. Orange `#FFB333`
4. Green `#33D98F`
5. Red `#F24D59`
6. Blue `#4DA6FF`
7. Pink `#FF73B3`
8. Lime `#A6D94D`

### Neutral Theme Palette
8 professional colors:
1. Slate Blue `#5973A6`
2. Green `#47A66B`
3. Orange `#D99940`
4. Blue `#598CBF`
5. Red `#CC5959`
6. Taupe `#8C807A`
7. Purple `#9966B3`
8. Gold `#B3A659`

## Customization Examples

### Custom Layout Sizes
```swift
// Compact
AssetsPieCard(
    assetData: data,
    title: "Assets",
    showLegend: false
)
.frame(width: 350, height: 350)

// Wide
AssetsPieCard(
    assetData: data,
    title: "Asset Allocation"
)
.frame(width: 900)

// Tall
AssetsPieCard(
    assetData: data,
    title: "All Assets"
)
.frame(height: 600)
```

### Conditional Legend Display
```swift
struct ResponsiveAssetCard: View {
    let assetData: [AssetCategoryData]
    @State private var viewWidth: CGFloat = 0
    
    var body: some View {
        AssetsPieCard(
            assetData: assetData,
            title: "Assets",
            showLegend: viewWidth > 600
        )
        .background(
            GeometryReader { geo in
                Color.clear.onAppear {
                    viewWidth = geo.size.width
                }
            }
        )
    }
}
```

## Best Practices

### ✅ DO
- Use aggregated data (`AssetCategoryData`)
- Provide meaningful titles and subtitles
- Show legend for clarity (default)
- Use center total for emphasis (default)
- Keep category count reasonable (3-8 ideal)
- Format currency consistently
- Update data when assets change

### ❌ DON'T
- Don't pass raw `AssetItem` arrays
- Don't show too many categories (10+)
- Don't hide both legend and center total
- Don't hardcode colors
- Don't skip currency formatting
- Don't use in very small spaces (<300pt)

## Performance Considerations

### Optimal Category Count
- **Ideal**: 3-7 categories
- **Good**: 8-10 categories
- **Too Many**: > 10 categories (consider grouping)

### Data Updates
- Aggregation is efficient for < 1000 items
- Re-aggregate when source data changes
- Chart re-renders smoothly with new data

## Accessibility

### VoiceOver Support
- Chart is announced as "Chart"
- Legend items are readable
- Values are spoken with currency
- Percentages are announced

### Additional Accessibility
```swift
AssetsPieCard(...)
    .accessibilityLabel("Asset allocation pie chart")
    .accessibilityHint("Shows breakdown of \(assetData.count) asset categories")
```

## Integration Examples

### With SwiftData
```swift
@Model
class Asset {
    var name: String
    var categoryName: String
    var value: Double
    var institution: String?
    
    func toAssetItem() -> AssetItem {
        AssetItem(
            category: AssetCategory(rawValue: categoryName) ?? .other,
            name: name,
            value: value,
            institutionName: institution
        )
    }
}

struct AssetsView: View {
    @Query private var assets: [Asset]
    
    var aggregatedData: [AssetCategoryData] {
        let items = assets.map { $0.toAssetItem() }
        return AssetCategoryData.aggregate(from: items)
    }
    
    var body: some View {
        AssetsPieCard(
            assetData: aggregatedData,
            title: "Net Worth"
        )
    }
}
```

### With Combine/Observation
```swift
@Observable
class AssetManager {
    var assets: [AssetItem] = []
    
    var aggregatedData: [AssetCategoryData] {
        AssetCategoryData.aggregate(from: assets)
    }
    
    func fetchAssets() async {
        // Fetch from API/database
        assets = await loadAssets()
    }
}

struct DashboardView: View {
    @State private var manager = AssetManager()
    
    var body: some View {
        AssetsPieCard(
            assetData: manager.aggregatedData,
            title: "Total Assets"
        )
        .task {
            await manager.fetchAssets()
        }
    }
}
```

## Troubleshooting

### Chart Not Showing
- Verify `assetData` is not empty
- Check that all values are > 0
- Ensure data is properly aggregated

### Colors Wrong
- Check theme has `chartPalette` property
- Verify palette has enough colors
- Ensure theme is provided via `ThemeProvider`

### Legend Truncated
- Increase card width (needs ~700pt for legend)
- Use shorter category names
- Hide legend if space constrained

### Center Total Not Showing
- Verify `showCenterTotal = true`
- Check total value is > 0
- Ensure currency formatter is working

## Complete Example

### Full Feature Implementation
```swift
struct AssetsDashboard: View {
    @Environment(\.theme) private var theme
    @State private var assets: [AssetItem] = []
    @State private var isLoading = false
    
    var aggregatedData: [AssetCategoryData] {
        AssetCategoryData.aggregate(from: assets)
    }
    
    var totalAssets: Double {
        assets.reduce(0) { $0 + $1.value }
    }
    
    var body: some View {
        VStack(spacing: theme.spacing.lg) {
            // Header
            HStack {
                VStack(alignment: .leading) {
                    Text("Asset Overview")
                        .font(theme.typography.displaySmall)
                    Text("Last updated: \(Date().formatted())")
                        .font(theme.typography.bodySmall)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                }
                
                Spacer()
                
                Button("Refresh") {
                    Task { await loadAssets() }
                }
            }
            .padding()
            
            // Pie Chart
            if isLoading {
                ProgressView()
            } else {
                AssetsPieCard(
                    assetData: aggregatedData,
                    title: "Asset Allocation",
                    subtitle: "$\(Int(totalAssets).formatted()) Total"
                )
            }
        }
        .task {
            await loadAssets()
        }
    }
    
    func loadAssets() async {
        isLoading = true
        // Simulate API call
        try? await Task.sleep(for: .seconds(1))
        assets = AssetItem.generateDemoData()
        isLoading = false
    }
}
```

---

**Components**: AssetsPieCard + AssetModels  
**Files**: 
- `DesignSystem/Components/AssetsPieCard.swift`
- `DesignSystem/Components/AssetModels.swift`  
**Dependencies**: Swift Charts (SectorMark), AppTheme  
**Platform**: macOS 14+  
**Framework**: SwiftUI + Swift Charts
