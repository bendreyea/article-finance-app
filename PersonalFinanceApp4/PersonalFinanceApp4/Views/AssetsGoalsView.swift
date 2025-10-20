//
//  AssetsGoalsView.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// Assets and Goals view with pie chart and goals list
struct AssetsGoalsView: View {
    @Environment(\.theme) private var theme
    let dataService: MockDataService
    let filter: DataFilter
    
    @State private var filteredAssets: [AssetItem] = []
    @State private var filteredGoals: [Goal] = []
    @State private var goalsBinding: [Goal] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                // Assets section
                assetsSection
                
                // Goals section
                goalsSection
            }
            .padding(theme.spacing.xl)
        }
        .onAppear {
            updateFilteredData()
        }
        .onChange(of: filter.searchQuery) { _, _ in
            updateFilteredData()
        }
        .onChange(of: dataService.goals) { _, _ in
            updateFilteredData()
        }
    }
    
    // MARK: - Assets Section
    
    private var assetsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            // Header
            HStack {
                Text("Asset Allocation")
                    .font(theme.typography.headingMedium)
                    .foregroundColor(theme.colors.onSurface)
                
                Spacer()
                
                Text("\(filteredAssets.count) assets")
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
            }
            .padding(.horizontal, theme.spacing.md)
            
            // Pie Chart
            AssetsPieCard(
                assetData: AssetCategoryData.aggregate(from: filteredAssets),
                title: "Total Assets",
                subtitle: "By Category"
            )
        }
    }
    
    // MARK: - Goals Section
    
    private var goalsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            // Header
            HStack {
                Text("Financial Goals")
                    .font(theme.typography.headingMedium)
                    .foregroundColor(theme.colors.onSurface)
                
                Spacer()
                
                Text("\(filteredGoals.count) goals")
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
            }
            .padding(.horizontal, theme.spacing.md)
            
            // Goals List
            GoalsListView(
                goals: $goalsBinding,
                title: "Your Goals",
                subtitle: "Track your financial objectives",
                onAddGoal: {
                    let newGoal = Goal(
                        name: "New Goal",
                        category: .other,
                        targetAmount: 1000,
                        currentAmount: 0
                    )
                    dataService.addGoal(newGoal)
                },
                onDeleteGoal: { goal in
                    dataService.deleteGoal(goal)
                }
            )
            .frame(minHeight: 600)
            .onChange(of: goalsBinding) { _, newGoals in
                // Sync changes back to data service
                for goal in newGoals {
                    dataService.updateGoal(goal)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func updateFilteredData() {
        filteredAssets = dataService.filteredAssets(filter: filter)
        filteredGoals = dataService.filteredGoals(filter: filter)
        goalsBinding = filteredGoals
    }
}

#Preview("AssetsGoalsView - Vibrant Theme") {
    ThemeProvider(theme: VibrantTheme()) {
        AssetsGoalsView(
            dataService: MockDataService(),
            filter: DataFilter()
        )
    }
    .frame(width: 1200, height: 1200)
}

#Preview("AssetsGoalsView - Neutral Theme") {
    ThemeProvider(theme: NeutralTheme()) {
        AssetsGoalsView(
            dataService: MockDataService(),
            filter: DataFilter()
        )
    }
    .frame(width: 1200, height: 1200)
}
