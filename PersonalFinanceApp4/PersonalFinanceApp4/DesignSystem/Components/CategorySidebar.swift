//
//  CategorySidebar.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// A sidebar component for filtering transactions by category.
/// Displays a list of categories with icons and transaction counts.
///
/// Example usage:
/// ```swift
/// CategorySidebar(
///     selectedCategory: $selectedCategory,
///     categoryCounts: ["Housing": 5, "Utilities": 3]
/// )
/// ```
public struct CategorySidebar: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    @Binding private var selectedCategory: TransactionCategory?
    private let categoryCounts: [TransactionCategory: Int]
    private let showCounts: Bool
    
    // MARK: - Initialization
    
    public init(
        selectedCategory: Binding<TransactionCategory?>,
        categoryCounts: [TransactionCategory: Int] = [:],
        showCounts: Bool = true
    ) {
        self._selectedCategory = selectedCategory
        self.categoryCounts = categoryCounts
        self.showCounts = showCounts
    }
    
    // MARK: - Body
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            sidebarHeader
            
            Divider()
                .padding(.vertical, theme.spacing.xs)
            
            // All Categories option
            allCategoriesRow
            
            Divider()
                .padding(.vertical, theme.spacing.xs)
            
            // Category list
            ScrollView {
                VStack(spacing: theme.spacing.xxs) {
                    ForEach(TransactionCategory.allCases) { category in
                        categoryRow(category)
                    }
                }
            }
        }
        .padding(theme.spacing.md)
        .frame(minWidth: 200, idealWidth: 220, maxWidth: 250)
        .background(theme.colors.backgroundElevated)
    }
    
    // MARK: - Subviews
    
    private var sidebarHeader: some View {
        HStack {
            Text("Categories")
                .font(theme.typography.headingSmall)
                .foregroundColor(theme.colors.onBackground)
            
            Spacer()
            
            if selectedCategory != nil {
                Button(action: clearSelection) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: theme.spacing.iconSizeSmall))
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.bottom, theme.spacing.xs)
    }
    
    private var allCategoriesRow: some View {
        categoryRowContent(
            icon: "square.grid.2x2.fill",
            title: "All Categories",
            count: totalCount,
            isSelected: selectedCategory == nil,
            action: clearSelection
        )
    }
    
    private func categoryRow(_ category: TransactionCategory) -> some View {
        categoryRowContent(
            icon: category.icon,
            title: category.rawValue,
            count: categoryCounts[category] ?? 0,
            isSelected: selectedCategory == category,
            action: { selectedCategory = category }
        )
    }
    
    private func categoryRowContent(
        icon: String,
        title: String,
        count: Int,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: theme.spacing.sm) {
                // Icon
                Image(systemName: icon)
                    .font(.system(size: theme.spacing.iconSize))
                    .foregroundColor(isSelected ? theme.colors.primary : theme.colors.onSurfaceSecondary)
                    .frame(width: theme.spacing.iconSizeLarge, alignment: .center)
                
                // Title
                Text(title)
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(isSelected ? theme.colors.onSurface : theme.colors.onSurfaceSecondary)
                    .fontWeight(isSelected ? theme.typography.weightSemibold : theme.typography.weightRegular)
                
                Spacer()
                
                // Count badge
                if showCounts && count > 0 {
                    Text("\(count)")
                        .font(theme.typography.labelSmall)
                        .foregroundColor(isSelected ? theme.colors.primary : theme.colors.onSurfaceTertiary)
                        .padding(.horizontal, theme.spacing.xs)
                        .padding(.vertical, theme.spacing.xxs)
                        .background(
                            (isSelected ? theme.colors.primary : theme.colors.onSurfaceTertiary)
                                .opacity(0.15)
                        )
                        .cornerRadius(theme.radius.chip)
                }
            }
            .padding(.vertical, theme.spacing.xs)
            .padding(.horizontal, theme.spacing.sm)
            .background(
                isSelected ? theme.colors.primary.opacity(0.1) : Color.clear
            )
            .cornerRadius(theme.radius.sm)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Helpers
    
    private var totalCount: Int {
        categoryCounts.values.reduce(0, +)
    }
    
    private func clearSelection() {
        selectedCategory = nil
    }
}

// MARK: - Previews

#Preview("CategorySidebar - Basic") {
    ThemeProvider(theme: VibrantTheme()) {
        CategorySidebar(
            selectedCategory: .constant(nil),
            categoryCounts: [
                .housing: 5,
                .utilities: 8,
                .groceries: 12,
                .transportation: 6,
                .entertainment: 4,
                .healthcare: 2,
                .shopping: 9,
                .dining: 15,
                .income: 3,
                .other: 7
            ]
        )
    }
    .frame(width: 250, height: 600)
}

#Preview("CategorySidebar - With Selection") {
    ThemeProvider(theme: VibrantTheme()) {
        CategorySidebar(
            selectedCategory: .constant(.groceries),
            categoryCounts: [
                .housing: 5,
                .utilities: 8,
                .groceries: 12,
                .transportation: 6
            ]
        )
    }
    .frame(width: 250, height: 600)
}

#Preview("CategorySidebar - Themes") {
    HStack(spacing: 0) {
        ThemeProvider(theme: VibrantTheme()) {
            VStack {
                Text("Vibrant")
                    .font(.system(size: 16, weight: .semibold))
                    .padding()
                
                CategorySidebar(
                    selectedCategory: .constant(.groceries),
                    categoryCounts: [
                        .housing: 5,
                        .groceries: 12,
                        .utilities: 8
                    ]
                )
            }
        }
        
        Divider()
        
        ThemeProvider(theme: NeutralTheme()) {
            VStack {
                Text("Neutral")
                    .font(.system(size: 16, weight: .semibold))
                    .padding()
                
                CategorySidebar(
                    selectedCategory: .constant(.groceries),
                    categoryCounts: [
                        .housing: 5,
                        .groceries: 12,
                        .utilities: 8
                    ]
                )
            }
        }
    }
    .frame(width: 550, height: 600)
}
