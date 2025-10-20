//
//  ExampleIntegration.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//
//  This file demonstrates how to integrate the DesignSystem into your app.
//

import SwiftUI

// MARK: - App Integration Example

/// Example of how to integrate ThemeProvider at the app root.
/// Replace your app's entry point with this pattern.
struct ExampleAppIntegration: App {
    @State private var currentTheme: AppTheme = VibrantTheme()
    @State private var showingSettings = false
    
    var body: some Scene {
        WindowGroup {
            ThemeProvider(theme: currentTheme) {
                ExampleContentView(
                    currentTheme: $currentTheme,
                    showingSettings: $showingSettings
                )
            }
        }
        .commands {
            CommandMenu("Theme") {
                Button("Switch to Vibrant") {
                    currentTheme = VibrantTheme()
                }
                .keyboardShortcut("1", modifiers: .command)
                
                Button("Switch to Neutral") {
                    currentTheme = NeutralTheme()
                }
                .keyboardShortcut("2", modifiers: .command)
            }
        }
    }
}

// MARK: - Example Content View

struct ExampleContentView: View {
    @Environment(\.theme) private var theme
    @Binding var currentTheme: AppTheme
    @Binding var showingSettings: Bool
    
    var body: some View {
        NavigationSplitView {
            // Sidebar
            ExampleSidebar()
        } detail: {
            // Main content
            ExampleDashboard(
                currentTheme: $currentTheme,
                showingSettings: $showingSettings
            )
        }
    }
}

// MARK: - Example Sidebar

struct ExampleSidebar: View {
    @Environment(\.theme) private var theme
    @State private var selectedItem: SidebarItem? = .dashboard
    
    enum SidebarItem: String, CaseIterable {
        case dashboard = "Dashboard"
        case income = "Income & Expenses"
        case assets = "Assets & Goals"
        
        var icon: String {
            switch self {
            case .dashboard: return "chart.bar.fill"
            case .income: return "dollarsign.circle.fill"
            case .assets: return "briefcase.fill"
            }
        }
    }
    
    var body: some View {
        List(SidebarItem.allCases, id: \.self, selection: $selectedItem) { item in
            Label(item.rawValue, systemImage: item.icon)
                .font(theme.typography.bodyMedium)
        }
        .listStyle(.sidebar)
        .background(theme.colors.backgroundElevated)
    }
}

// MARK: - Example Dashboard

struct ExampleDashboard: View {
    @Environment(\.theme) private var theme
    @Binding var currentTheme: AppTheme
    @Binding var showingSettings: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.sectionSpacing) {
                // Header
                dashboardHeader
                
                // Stats Grid
                statsGrid
                
                // Charts Section
                chartsSection
                
                // Recent Transactions
                recentTransactionsSection
            }
            .padding(theme.spacing.lg)
        }
        .background(theme.colors.background)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                themeToggle
            }
        }
    }
    
    // MARK: - Header
    
    private var dashboardHeader: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            Text("Financial Dashboard")
                .font(theme.typography.displaySmall)
                .foregroundColor(theme.colors.onBackground)
            
            Text("October 17, 2025")
                .font(theme.typography.bodyMedium)
                .foregroundColor(theme.colors.onSurfaceSecondary)
        }
    }
    
    // MARK: - Stats Grid
    
    private var statsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: theme.spacing.md),
                GridItem(.flexible(), spacing: theme.spacing.md),
                GridItem(.flexible(), spacing: theme.spacing.md)
            ],
            spacing: theme.spacing.md
        ) {
            statCard(
                icon: "banknote.fill",
                title: "Net Worth",
                value: "$156,789",
                change: "+12.5%",
                isPositive: true
            )
            
            statCard(
                icon: "arrow.up.circle.fill",
                title: "Monthly Income",
                value: "$8,450",
                change: "+5.2%",
                isPositive: true
            )
            
            statCard(
                icon: "arrow.down.circle.fill",
                title: "Monthly Expenses",
                value: "$4,230",
                change: "-3.1%",
                isPositive: true
            )
        }
    }
    
    private func statCard(
        icon: String,
        title: String,
        value: String,
        change: String,
        isPositive: Bool
    ) -> some View {
        Card(elevation: .medium) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                HStack {
                    Image(systemName: icon)
                        .font(.system(size: theme.spacing.iconSizeLarge))
                        .foregroundColor(theme.colors.primary)
                    
                    Spacer()
                    
                    changeIndicator(change: change, isPositive: isPositive)
                }
                
                Text(title)
                    .font(theme.typography.labelMedium)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
                
                Text(value)
                    .font(theme.typography.headingLarge)
                    .foregroundColor(theme.colors.onSurface)
            }
        }
    }
    
    private func changeIndicator(change: String, isPositive: Bool) -> some View {
        Text(change)
            .font(theme.typography.labelSmall)
            .foregroundColor(isPositive ? theme.colors.success : theme.colors.error)
            .padding(.horizontal, theme.spacing.xs)
            .padding(.vertical, theme.spacing.xxs)
            .background(
                (isPositive ? theme.colors.success : theme.colors.error)
                    .opacity(0.15)
            )
            .cornerRadius(theme.radius.chip)
    }
    
    // MARK: - Charts Section
    
    private var chartsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Overview")
                .font(theme.typography.headingMedium)
                .foregroundColor(theme.colors.onBackground)
            
            HStack(spacing: theme.spacing.md) {
                // Balance chart placeholder
                Card(elevation: .medium) {
                    VStack(alignment: .leading, spacing: theme.spacing.md) {
                        Text("Balance Trend")
                            .font(theme.typography.labelLarge)
                            .foregroundColor(theme.colors.onSurface)
                        
                        // Placeholder for actual chart
                        RoundedRectangle(cornerRadius: theme.radius.sm)
                            .fill(theme.colors.surfaceVariant)
                            .frame(height: 200)
                            .overlay(
                                Text("Line Chart")
                                    .font(theme.typography.bodySmall)
                                    .foregroundColor(theme.colors.onSurfaceTertiary)
                            )
                    }
                }
                
                // Category breakdown placeholder
                Card(elevation: .medium) {
                    VStack(alignment: .leading, spacing: theme.spacing.md) {
                        Text("Spending by Category")
                            .font(theme.typography.labelLarge)
                            .foregroundColor(theme.colors.onSurface)
                        
                        // Placeholder for actual chart
                        RoundedRectangle(cornerRadius: theme.radius.sm)
                            .fill(theme.colors.surfaceVariant)
                            .frame(height: 200)
                            .overlay(
                                Text("Donut Chart")
                                    .font(theme.typography.bodySmall)
                                    .foregroundColor(theme.colors.onSurfaceTertiary)
                            )
                    }
                }
            }
        }
    }
    
    // MARK: - Recent Transactions
    
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            HStack {
                Text("Recent Transactions")
                    .font(theme.typography.headingMedium)
                    .foregroundColor(theme.colors.onBackground)
                
                Spacer()
                
                Button("View All") {
                    // Action
                }
                .font(theme.typography.labelMedium)
                .foregroundColor(theme.colors.primary)
            }
            
            Card(elevation: .medium, padding: .none) {
                VStack(spacing: 0) {
                    ForEach(0..<5) { index in
                        transactionRow(
                            title: "Transaction \(index + 1)",
                            category: ["Groceries", "Transport", "Entertainment", "Bills", "Shopping"][index],
                            date: "Oct \(17 - index)",
                            amount: "$\(Int.random(in: 20...300))",
                            isExpense: index != 1
                        )
                        
                        if index < 4 {
                            Divider()
                                .padding(.leading, theme.spacing.cardPadding)
                        }
                    }
                }
            }
        }
    }
    
    private func transactionRow(
        title: String,
        category: String,
        date: String,
        amount: String,
        isExpense: Bool
    ) -> some View {
        HStack(spacing: theme.spacing.md) {
            // Icon
            Circle()
                .fill(theme.colors.primary.opacity(0.15))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: isExpense ? "arrow.down" : "arrow.up")
                        .font(.system(size: theme.spacing.iconSizeSmall))
                        .foregroundColor(theme.colors.primary)
                )
            
            // Info
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(title)
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.onSurface)
                
                HStack(spacing: theme.spacing.xs) {
                    Text(category)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.onSurfaceSecondary)
                    
                    Text("•")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.onSurfaceTertiary)
                    
                    Text(date)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.onSurfaceTertiary)
                }
            }
            
            Spacer()
            
            // Amount
            Text(isExpense ? "-\(amount)" : "+\(amount)")
                .font(theme.typography.labelLarge)
                .foregroundColor(isExpense ? theme.colors.error : theme.colors.success)
        }
        .padding(theme.spacing.cardPadding)
    }
    
    // MARK: - Theme Toggle
    
    private var themeToggle: some View {
        Button(action: toggleTheme) {
            Label(
                currentTheme.name,
                systemImage: "paintpalette.fill"
            )
        }
    }
    
    private func toggleTheme() {
        withAnimation(.easeInOut(duration: 0.3)) {
            if currentTheme is VibrantTheme {
                currentTheme = NeutralTheme()
            } else {
                currentTheme = VibrantTheme()
            }
        }
    }
}

// MARK: - Preview

#Preview("Example Integration - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        ExampleDashboard(
            currentTheme: .constant(VibrantTheme()),
            showingSettings: .constant(false)
        )
    }
    .frame(width: 1200, height: 800)
}

#Preview("Example Integration - Neutral") {
    ThemeProvider(theme: NeutralTheme()) {
        ExampleDashboard(
            currentTheme: .constant(NeutralTheme()),
            showingSettings: .constant(false)
        )
    }
    .frame(width: 1200, height: 800)
}
