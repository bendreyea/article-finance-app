import SwiftUI

/// Comprehensive previews for AssetsPieCard and GoalsListView components
struct AssetsAndGoalsPreviews: View {
    var body: some View {
        TabView {
            // Assets Pie Card tab
            assetsPieCardTab
                .tabItem {
                    Label("Assets Pie", systemImage: "chart.pie")
                }
            
            // Goals List tab
            goalsListTab
                .tabItem {
                    Label("Goals List", systemImage: "target")
                }
            
            // Theme comparison tab
            themeComparisonTab
                .tabItem {
                    Label("Themes", systemImage: "paintbrush")
                }
            
            // Combined dashboard tab
            combinedDashboardTab
                .tabItem {
                    Label("Dashboard", systemImage: "rectangle.grid.2x2")
                }
        }
    }
    
    // MARK: - Assets Pie Card Tab
    private var assetsPieCardTab: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("AssetsPieCard Variations")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                VStack(spacing: 24) {
                    // Full card with legend
                    AssetsPieCard.demo(
                        title: "Investment Portfolio",
                        subtitle: "Total allocation across asset classes"
                    )
                    
                    // Compact version without legend
                    AssetsPieCard(
                        assets: AssetsPieCard.demoAssets.prefix(5).map { $0 },
                        title: "Top 5 Holdings",
                        subtitle: "Primary investments",
                        showLegend: false
                    )
                    
                    // Small allocation example
                    AssetsPieCard(
                        assets: [
                            AssetAllocation(name: "Stocks", value: 60000, category: .stocks),
                            AssetAllocation(name: "Bonds", value: 25000, category: .bonds),
                            AssetAllocation(name: "Cash", value: 15000, category: .cash)
                        ],
                        title: "Simple Portfolio",
                        subtitle: "3-fund strategy"
                    )
                }
                .padding(.horizontal)
            }
        }
        .theme(VibrantTheme())
    }
    
    // MARK: - Goals List Tab
    private var goalsListTab: some View {
        NavigationView {
            GoalsListViewDemo()
                .navigationTitle("Financial Goals")
        }
        .theme(VibrantTheme())
    }
    
    // MARK: - Theme Comparison Tab
    private var themeComparisonTab: some View {
        ScrollView {
            VStack(spacing: 32) {
                Text("Theme Comparisons")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                // Assets Pie Card theme comparison
                VStack(spacing: 16) {
                    Text("AssetsPieCard Themes")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("Vibrant")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            AssetsPieCardShowcase()
                                .theme(VibrantTheme())
                        }
                        
                        VStack {
                            Text("Neutral")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            AssetsPieCardShowcase()
                                .theme(NeutralTheme())
                        }
                    }
                }
                
                Divider()
                    .padding(.vertical)
                
                // Goals List theme comparison
                VStack(spacing: 16) {
                    Text("GoalsListView Themes")
                        .font(.headline)
                    
                    HStack(spacing: 20) {
                        VStack {
                            Text("Vibrant")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            GoalsListShowcase()
                                .theme(VibrantTheme())
                        }
                        
                        VStack {
                            Text("Neutral")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            GoalsListShowcase()
                                .theme(NeutralTheme())
                        }
                    }
                }
            }
            .padding()
        }
    }
    
    // MARK: - Combined Dashboard Tab
    private var combinedDashboardTab: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Assets and Goals side by side
                    HStack(alignment: .top, spacing: 20) {
                        // Assets pie chart
                        AssetsPieCard.demo(
                            title: "Asset Allocation",
                            showLegend: false
                        )
                        .frame(maxWidth: .infinity)
                        
                        // Goals summary
                        Card {
                            GoalsListViewDemo(compact: true)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    
                    // Full goals list
                    GoalsListViewDemo()
                }
                .padding()
            }
            .navigationTitle("Assets & Goals Dashboard")
        }
        .theme(VibrantTheme())
    }
}

// MARK: - Showcase Components
private struct AssetsPieCardShowcase: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            // Mini pie chart
            AssetsPieCard(
                assets: [
                    AssetAllocation(name: "Stocks", value: 50000, category: .stocks),
                    AssetAllocation(name: "Bonds", value: 25000, category: .bonds),
                    AssetAllocation(name: "Cash", value: 10000, category: .cash),
                    AssetAllocation(name: "Real Estate", value: 15000, category: .realEstate)
                ],
                title: "Sample Portfolio",
                showLegend: false
            )
            
            // Color palette showcase
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text("Chart Palette")
                    .font(theme.typography.calloutFont)
                    .foregroundColor(theme.colors.textPrimary)
                
                HStack(spacing: theme.spacing.xs) {
                    ForEach(0..<min(6, theme.colors.chartPalette.count), id: \.self) { index in
                        Circle()
                            .fill(theme.colors.chartPalette[index])
                            .frame(width: 20, height: 20)
                    }
                }
            }
        }
        .padding(theme.spacing.md)
        .background(theme.colors.background)
        .cornerRadius(theme.radius.xl)
    }
}

private struct GoalsListShowcase: View {
    @Environment(\.theme) private var theme
    @State private var sampleGoals = [
        FinancialGoal(
            name: "Emergency Fund",
            targetAmount: 10000,
            currentAmount: 7500,
            targetDate: Calendar.current.date(byAdding: .month, value: 6, to: Date()) ?? Date(),
            category: .emergency
        ),
        FinancialGoal(
            name: "Vacation Savings",
            targetAmount: 5000,
            currentAmount: 2000,
            targetDate: Calendar.current.date(byAdding: .month, value: 8, to: Date()) ?? Date(),
            category: .travel
        )
    ]
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            // Progress bars showcase
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text("Progress Bars")
                    .font(theme.typography.calloutFont)
                    .foregroundColor(theme.colors.textPrimary)
                
                VStack(spacing: theme.spacing.xs) {
                    ProgressBar(progress: 0.75, showPercentage: true)
                    ProgressBar(progress: 0.40, foregroundColor: theme.colors.warning, showPercentage: true)
                    ProgressBar(progress: 0.20, foregroundColor: theme.colors.error, showPercentage: true)
                }
            }
            
            // Mini goals list
            GoalsListView(goals: $sampleGoals)
                .frame(height: 200)
        }
        .padding(theme.spacing.md)
        .background(theme.colors.background)
        .cornerRadius(theme.radius.xl)
    }
}

// MARK: - Interactive Goals Demo
private struct GoalsListViewDemo: View {
    @State private var goals = GoalsListView.demoGoals
    let compact: Bool
    
    init(compact: Bool = false) {
        self.compact = compact
    }
    
    var body: some View {
        GoalsListView(
            goals: $goals,
            onGoalUpdate: { updatedGoal in
                print("Goal updated: \(updatedGoal.name)")
            },
            onGoalDelete: { deletedGoal in
                print("Goal deleted: \(deletedGoal.name)")
            }
        )
        .frame(maxHeight: compact ? 300 : nil)
    }
}

// MARK: - Individual Component Previews
struct ProgressBarPreviews: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: 24) {
            Text("ProgressBar Component")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Different Progress Levels")
                        .font(.headline)
                    
                    ProgressBar(progress: 1.0, showPercentage: true)  // Complete
                    ProgressBar(progress: 0.8, showPercentage: true)  // Almost there
                    ProgressBar(progress: 0.5, showPercentage: true)  // Half way
                    ProgressBar(progress: 0.2, showPercentage: true)  // Getting started
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Different Colors")
                        .font(.headline)
                    
                    ProgressBar(progress: 0.7, foregroundColor: theme.colors.success, showPercentage: true)
                    ProgressBar(progress: 0.7, foregroundColor: theme.colors.warning, showPercentage: true)
                    ProgressBar(progress: 0.7, foregroundColor: theme.colors.error, showPercentage: true)
                    ProgressBar(progress: 0.7, foregroundColor: theme.colors.info, showPercentage: true)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Different Heights")
                        .font(.headline)
                    
                    ProgressBar(progress: 0.6, height: 4)
                    ProgressBar(progress: 0.6, height: 8)
                    ProgressBar(progress: 0.6, height: 16)
                    ProgressBar(progress: 0.6, height: 24)
                }
            }
        }
        .padding()
    }
}

// MARK: - Preview Provider
#Preview("Assets & Goals - Complete") {
    AssetsAndGoalsPreviews()
}

#Preview("AssetsPieCard - Vibrant Theme") {
    VStack(spacing: 20) {
        AssetsPieCard.demo()
        
        AssetsPieCard(
            assets: AssetsPieCard.demoAssets.prefix(4).map { $0 },
            title: "Simplified View",
            showLegend: false
        )
    }
    .theme(VibrantTheme())
    .padding()
}

#Preview("AssetsPieCard - Neutral Theme") {
    AssetsPieCard.demo(
        title: "Investment Portfolio",
        subtitle: "Diversified allocation"
    )
    .theme(NeutralTheme())
    .padding()
}

#Preview("GoalsListView - Interactive") {
    NavigationView {
        GoalsListViewDemo()
            .navigationTitle("My Goals")
    }
    .theme(VibrantTheme())
}

#Preview("ProgressBar Variations") {
    ProgressBarPreviews()
        .theme(VibrantTheme())
}

#Preview("Empty Goals State") {
    GoalsListView(goals: .constant([]))
        .theme(VibrantTheme())
        .padding()
}

#Preview("Chart Color Palette") {
    VStack(spacing: 16) {
        Text("Chart Color Palettes")
            .font(.title)
            .fontWeight(.bold)
        
        VStack(spacing: 12) {
            Text("Vibrant Theme")
                .font(.headline)
            HStack(spacing: 8) {
                ForEach(0..<VibrantTheme().colors.chartPalette.count, id: \.self) { index in
                    Circle()
                        .fill(VibrantTheme().colors.chartPalette[index])
                        .frame(width: 30, height: 30)
                }
            }
            
            Text("Neutral Theme")
                .font(.headline)
            HStack(spacing: 8) {
                ForEach(0..<NeutralTheme().colors.chartPalette.count, id: \.self) { index in
                    Circle()
                        .fill(NeutralTheme().colors.chartPalette[index])
                        .frame(width: 30, height: 30)
                }
            }
        }
    }
    .padding()
}