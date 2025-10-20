import SwiftUI

// MARK: - Assets & Goals Preview

struct AssetsGoalsPreview: View {
    @State private var assets = AssetDemoData.generateAssets()
    @State private var goals = GoalDemoData.generateGoals()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Assets & Goals")
                            .font(.system(size: 28, weight: .bold))
                        
                        Text("Track your wealth and financial objectives")
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Net Worth")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                        
                        Text("$651,000")
                            .font(.system(size: 24, weight: .bold))
                            .monospacedDigit()
                    }
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                
                // Assets Pie Chart
                AssetsPieCard(assets: assets)
                    .padding(.horizontal, 24)
                
                // Goals List
                Card {
                    GoalsListView(
                        goals: $goals,
                        onGoalUpdate: { goal in
                            print("✅ Updated goal: \(goal.name)")
                        },
                        onGoalDelete: { goal in
                            print("🗑️ Deleted goal: \(goal.name)")
                        }
                    )
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 24)
            }
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
}

// MARK: - Side-by-Side Theme Comparison

struct AssetsGoalsThemeComparison: View {
    @State private var assets = AssetDemoData.generateAssets()
    @State private var goalsVibrant = GoalDemoData.generateGoals()
    @State private var goalsNeutral = GoalDemoData.generateGoals()
    
    var body: some View {
        HStack(spacing: 0) {
            // Vibrant Theme
            ThemeProvider(theme: VibrantTheme()) {
                VStack(spacing: 16) {
                    Text("Vibrant Theme")
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            AssetsPieCard(assets: assets)
                                .frame(height: 350)
                            
                            GoalsListView(
                                goals: $goalsVibrant,
                                onGoalUpdate: { _ in },
                                onGoalDelete: { _ in }
                            )
                            .frame(height: 600)
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(VibrantTheme().colors.background)
            }
            
            Divider()
            
            // Neutral Theme
            ThemeProvider(theme: NeutralTheme()) {
                VStack(spacing: 16) {
                    Text("Neutral Theme")
                        .font(.system(size: 20, weight: .bold))
                        .padding()
                    
                    ScrollView {
                        VStack(spacing: 16) {
                            AssetsPieCard(assets: assets)
                                .frame(height: 350)
                            
                            GoalsListView(
                                goals: $goalsNeutral,
                                onGoalUpdate: { _ in },
                                onGoalDelete: { _ in }
                            )
                            .frame(height: 600)
                        }
                        .padding()
                    }
                }
                .frame(maxWidth: .infinity)
                .background(NeutralTheme().colors.background)
            }
        }
    }
}

// MARK: - Dashboard Integration Example

struct AssetsDashboardExample: View {
    @State private var assets = AssetDemoData.generateAssets()
    @State private var goals = GoalDemoData.generateGoals()
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            List {
                NavigationLink("Dashboard") {
                    Text("Dashboard")
                }
                NavigationLink("Assets & Goals") {
                    assetsGoalsContent
                }
                NavigationLink("Transactions") {
                    Text("Transactions")
                }
            }
            .navigationTitle("Finance App")
        } detail: {
            assetsGoalsContent
        }
    }
    
    private var assetsGoalsContent: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Two Column Layout
                HStack(alignment: .top, spacing: 24) {
                    // Left: Assets
                    AssetsPieCard(
                        assets: assets,
                        title: "Asset Allocation"
                    )
                    .frame(maxWidth: .infinity)
                    
                    // Right: Quick Stats
                    VStack(spacing: 16) {
                        quickStatCard(
                            title: "Total Assets",
                            value: "$651K",
                            change: "+12.5%",
                            isPositive: true
                        )
                        
                        quickStatCard(
                            title: "Goals Progress",
                            value: "\(goalsCompleted)/\(goals.count)",
                            change: "67% avg",
                            isPositive: true
                        )
                        
                        quickStatCard(
                            title: "Monthly Savings",
                            value: "$2,450",
                            change: "+5.2%",
                            isPositive: true
                        )
                    }
                    .frame(maxWidth: 300)
                }
                
                // Goals Section
                GoalsListView(
                    goals: $goals,
                    onGoalUpdate: { _ in },
                    onGoalDelete: { _ in }
                )
            }
            .padding(24)
        }
    }
    
    private func quickStatCard(
        title: String,
        value: String,
        change: String,
        isPositive: Bool
    ) -> some View {
        Card(shadow: .sm) {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.system(size: 24, weight: .bold))
                    .monospacedDigit()
                
                HStack(spacing: 4) {
                    Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 10))
                    
                    Text(change)
                        .font(.system(size: 12))
                }
                .foregroundColor(isPositive ? .green : .red)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
    
    private var goalsCompleted: Int {
        goals.filter { $0.isCompleted }.count
    }
}

// MARK: - Interactive Demo

struct AssetsGoalsInteractiveDemo: View {
    @State private var assets = AssetDemoData.generateAssets()
    @State private var goals = GoalDemoData.generateGoals()
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Tab Bar
            HStack(spacing: 0) {
                tabButton("Assets", index: 0)
                tabButton("Goals", index: 1)
                tabButton("Combined", index: 2)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            
            Divider()
                .padding(.top, 16)
            
            // Content
            TabView(selection: $selectedTab) {
                // Assets Tab
                ScrollView {
                    VStack(spacing: 24) {
                        AssetsPieCard(assets: assets)
                        
                        assetBreakdown
                    }
                    .padding(24)
                }
                .tag(0)
                
                // Goals Tab
                GoalsListView(
                    goals: $goals,
                    onGoalUpdate: { goal in
                        print("Updated: \(goal.name) to $\(goal.currentAmount)")
                    },
                    onGoalDelete: { goal in
                        print("Deleted: \(goal.name)")
                    }
                )
                .tag(1)
                
                // Combined Tab
                ScrollView {
                    VStack(spacing: 24) {
                        HStack(alignment: .top, spacing: 24) {
                            AssetsPieCard(assets: assets, showLegend: false)
                                .frame(maxWidth: .infinity)
                            
                            Card {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Financial Overview")
                                        .font(.system(size: 18, weight: .semibold))
                                    
                                    Divider()
                                    
                                    overviewRow("Total Assets", value: "$651K")
                                    overviewRow("Active Goals", value: "\(goals.count)")
                                    overviewRow("Completed", value: "\(goalsCompleted)")
                                    overviewRow("Avg Progress", value: "\(Int(avgProgress * 100))%")
                                }
                                .padding()
                            }
                            .frame(maxWidth: 300)
                        }
                        
                        Card {
                            GoalsListView(
                                goals: $goals,
                                onGoalUpdate: { _ in },
                                onGoalDelete: { _ in }
                            )
                        }
                    }
                    .padding(24)
                }
                .tag(2)
            }
            .tabViewStyle(.automatic)
        }
    }
    
    private func tabButton(_ title: String, index: Int) -> some View {
        Button(action: { selectedTab = index }) {
            Text(title)
                .font(.system(size: 14, weight: selectedTab == index ? .semibold : .regular))
                .foregroundColor(selectedTab == index ? .primary : .secondary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    selectedTab == index
                        ? Color.accentColor.opacity(0.1)
                        : Color.clear
                )
                .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
    
    private var assetBreakdown: some View {
        Card {
            VStack(alignment: .leading, spacing: 16) {
                Text("Asset Breakdown")
                    .font(.system(size: 18, weight: .semibold))
                
                Divider()
                
                ForEach(assets) { asset in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(asset.name)
                                .font(.system(size: 14, weight: .medium))
                            
                            Text(asset.category)
                                .font(.system(size: 12))
                                .foregroundColor(.secondary)
                        }
                        
                        Spacer()
                        
                        Text("$\(formatValue(asset.value))")
                            .font(.system(size: 14, weight: .semibold))
                            .monospacedDigit()
                    }
                    .padding(.vertical, 8)
                    
                    if asset.id != assets.last?.id {
                        Divider()
                    }
                }
            }
            .padding()
        }
    }
    
    private func overviewRow(_ label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .font(.system(size: 14, weight: .semibold))
                .monospacedDigit()
        }
    }
    
    private func formatValue(_ value: Double) -> String {
        if value >= 1_000_000 {
            return String(format: "%.1fM", value / 1_000_000)
        } else if value >= 1_000 {
            return String(format: "%.0fK", value / 1_000)
        }
        return String(format: "%.0f", value)
    }
    
    private var goalsCompleted: Int {
        goals.filter { $0.isCompleted }.count
    }
    
    private var avgProgress: Double {
        guard !goals.isEmpty else { return 0 }
        return goals.reduce(0.0) { $0 + $1.progress } / Double(goals.count)
    }
}

// MARK: - Previews

#Preview("Assets & Goals - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        AssetsGoalsPreview()
            .frame(width: 1000, height: 1200)
    }
}

#Preview("Theme Comparison") {
    AssetsGoalsThemeComparison()
        .frame(width: 1600, height: 1200)
}

#Preview("Dashboard Integration") {
    ThemeProvider(theme: VibrantTheme()) {
        AssetsDashboardExample()
            .frame(width: 1400, height: 900)
    }
}

#Preview("Interactive Demo") {
    ThemeProvider(theme: VibrantTheme()) {
        AssetsGoalsInteractiveDemo()
            .frame(width: 1200, height: 900)
    }
}

#Preview("Assets Only - Neutral") {
    ThemeProvider(theme: NeutralTheme()) {
        VStack(spacing: 24) {
            AssetsPieCard(assets: AssetDemoData.generateAssets())
            
            HStack(spacing: 24) {
                AssetsPieCard(
                    assets: Array(AssetDemoData.generateAssets().prefix(3)),
                    title: "Liquid Assets",
                    showLegend: false
                )
                
                AssetsPieCard(
                    assets: Array(AssetDemoData.generateAssets().suffix(4)),
                    title: "Long-term",
                    showLegend: false
                )
            }
        }
        .padding(24)
        .frame(width: 1200)
        .background(NeutralTheme().colors.background)
    }
}

#Preview("Goals Only - Vibrant") {
    @Previewable @State var goals = GoalDemoData.generateGoals()
    
    ThemeProvider(theme: VibrantTheme()) {
        GoalsListView(
            goals: $goals,
            onGoalUpdate: { goal in
                print("✅ Goal updated: \(goal.name)")
            },
            onGoalDelete: { goal in
                print("🗑️ Goal deleted: \(goal.name)")
            }
        )
        .frame(width: 900, height: 1000)
    }
}
