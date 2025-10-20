import SwiftUI

/// Example integration showing how to use the DesignSystem in your app
///
/// This file demonstrates:
/// - App-level theme injection
/// - Building views with theme tokens
/// - Creating custom components
/// - Runtime theme switching

// MARK: - App Entry Point Example

/*
@main
struct PersonalFinanceApp: App {
    var body: some Scene {
        WindowGroup {
            ThemeProvider(theme: VibrantTheme()) {
                MainAppView()
            }
        }
        .windowStyle(.hiddenTitleBar)
    }
}
*/

// MARK: - Main App View

struct MainAppView: View {
    @Environment(\.theme) private var theme
    @State private var selectedTheme: ThemeOption = .vibrant
    
    var body: some View {
        ThemeProvider(theme: selectedTheme.theme) {
            NavigationSplitView {
                sidebarContent
            } detail: {
                detailContent
            }
            .background(theme.colors.background)
        }
    }
    
    private var sidebarContent: some View {
        VStack(spacing: theme.spacing.md) {
            // App Logo
            Text("💰 Finance")
                .font(theme.typography.headlineMedium.font)
                .foregroundColor(theme.colors.primary)
                .padding(theme.spacing.lg)
            
            // Navigation Items
            navigationItem(icon: "chart.pie.fill", title: "Dashboard")
            navigationItem(icon: "dollarsign.circle.fill", title: "Transactions")
            navigationItem(icon: "chart.bar.fill", title: "Reports")
            navigationItem(icon: "gearshape.fill", title: "Settings")
            
            Spacer()
            
            // Theme Switcher
            themeSwitcher
        }
        .frame(width: 200)
        .background(theme.colors.surface)
    }
    
    private func navigationItem(icon: String, title: String) -> some View {
        HStack(spacing: theme.spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(theme.colors.primary)
                .frame(width: 24)
            
            Text(title)
                .font(theme.typography.bodyMedium.font)
                .foregroundColor(theme.colors.textPrimary)
            
            Spacer()
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.vertical, theme.spacing.sm)
        .background(theme.colors.backgroundSecondary.opacity(0.5))
        .cornerRadius(theme.radius.sm)
        .padding(.horizontal, theme.spacing.md)
    }
    
    private var themeSwitcher: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            Text("Theme")
                .font(theme.typography.labelSmall.font)
                .foregroundColor(theme.colors.textTertiary)
                .padding(.horizontal, theme.spacing.md)
            
            Picker("", selection: $selectedTheme) {
                Text("Vibrant").tag(ThemeOption.vibrant)
                Text("Neutral").tag(ThemeOption.neutral)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, theme.spacing.md)
        }
        .padding(.bottom, theme.spacing.lg)
    }
    
    private var detailContent: some View {
        DashboardExample()
    }
}

// MARK: - Dashboard Example

struct DashboardExample: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.lg) {
                // Header
                headerSection
                
                // Metrics Cards
                metricsSection
                
                // Chart Card
                chartSection
                
                // Recent Transactions
                transactionsSection
            }
            .padding(theme.spacing.xl)
        }
        .background(theme.colors.background)
    }
    
    // MARK: - Header
    
    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                Text("Dashboard")
                    .font(theme.typography.displaySmall.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                Text("Welcome back! Here's your financial overview.")
                    .font(theme.typography.bodyMedium.font)
                    .foregroundColor(theme.colors.textSecondary)
            }
            
            Spacer()
            
            // Action Button
            Button(action: {}) {
                HStack(spacing: theme.spacing.xs) {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Transaction")
                }
                .font(theme.typography.labelMedium.font)
                .foregroundColor(theme.colors.textInverse)
                .padding(.horizontal, theme.spacing.md)
                .padding(.vertical, theme.spacing.sm)
                .background(theme.colors.primary)
                .cornerRadius(theme.radius.md)
            }
            .buttonStyle(.plain)
        }
    }
    
    // MARK: - Metrics
    
    private var metricsSection: some View {
        HStack(spacing: theme.spacing.md) {
            metricCard(
                title: "Total Balance",
                value: "$45,678.90",
                change: "+12.5%",
                isPositive: true
            )
            
            metricCard(
                title: "Monthly Income",
                value: "$5,200.00",
                change: "+8.2%",
                isPositive: true
            )
            
            metricCard(
                title: "Monthly Expenses",
                value: "$3,450.00",
                change: "-5.3%",
                isPositive: true
            )
        }
    }
    
    private func metricCard(
        title: String,
        value: String,
        change: String,
        isPositive: Bool
    ) -> some View {
        Card(padding: .lg, shadow: .md, hasBorder: false, cornerRadius: .md) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text(title)
                    .font(theme.typography.labelMedium.font)
                    .foregroundColor(theme.colors.textSecondary)
                
                Text(value)
                    .font(theme.typography.headlineMedium.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                HStack(spacing: theme.spacing.xxs) {
                    Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                        .font(.system(size: 10, weight: .bold))
                    Text(change)
                        .font(theme.typography.labelSmall.font)
                }
                .foregroundColor(isPositive ? theme.colors.success : theme.colors.error)
                .padding(.horizontal, theme.spacing.xs)
                .padding(.vertical, theme.spacing.xxs)
                .background(
                    (isPositive ? theme.colors.successBackground : theme.colors.errorBackground)
                )
                .cornerRadius(theme.radius.sm)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    // MARK: - Chart
    
    private var chartSection: some View {
        Card(padding: .lg, shadow: .md, hasBorder: false, cornerRadius: .md) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                HStack {
                    Text("Spending Breakdown")
                        .font(theme.typography.titleLarge.font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Spacer()
                    
                    Text("This Month")
                        .font(theme.typography.labelMedium.font)
                        .foregroundColor(theme.colors.textTertiary)
                }
                
                // Simulated chart bars
                VStack(spacing: theme.spacing.md) {
                    chartBar(category: "Housing", amount: "$1,200", percentage: 0.35)
                    chartBar(category: "Food & Dining", amount: "$850", percentage: 0.25)
                    chartBar(category: "Transportation", amount: "$650", percentage: 0.19)
                    chartBar(category: "Entertainment", amount: "$400", percentage: 0.12)
                    chartBar(category: "Other", amount: "$350", percentage: 0.10)
                }
            }
        }
    }
    
    private func chartBar(category: String, amount: String, percentage: Double) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            HStack {
                Text(category)
                    .font(theme.typography.bodyMedium.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                Spacer()
                
                Text(amount)
                    .font(theme.typography.bodyMedium.font)
                    .foregroundColor(theme.colors.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: theme.radius.sm)
                        .fill(theme.colors.backgroundSecondary)
                    
                    RoundedRectangle(cornerRadius: theme.radius.sm)
                        .fill(
                            LinearGradient(
                                colors: [theme.colors.primary, theme.colors.primary.opacity(0.7)],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * percentage)
                }
            }
            .frame(height: 10)
        }
    }
    
    // MARK: - Transactions
    
    private var transactionsSection: some View {
        Card(padding: .lg, shadow: .md, hasBorder: false, cornerRadius: .md) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Recent Transactions")
                    .font(theme.typography.titleLarge.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                VStack(spacing: theme.spacing.sm) {
                    transactionRow(
                        name: "Grocery Store",
                        date: "Today",
                        amount: "-$125.50",
                        category: "Food",
                        isExpense: true
                    )
                    
                    transactionRow(
                        name: "Salary Deposit",
                        date: "Yesterday",
                        amount: "+$5,200.00",
                        category: "Income",
                        isExpense: false
                    )
                    
                    transactionRow(
                        name: "Electric Bill",
                        date: "2 days ago",
                        amount: "-$85.00",
                        category: "Utilities",
                        isExpense: true
                    )
                }
            }
        }
    }
    
    private func transactionRow(
        name: String,
        date: String,
        amount: String,
        category: String,
        isExpense: Bool
    ) -> some View {
        HStack(spacing: theme.spacing.md) {
            // Icon
            Circle()
                .fill(isExpense ? theme.colors.errorBackground : theme.colors.successBackground)
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: isExpense ? "arrow.down" : "arrow.up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isExpense ? theme.colors.error : theme.colors.success)
                )
            
            // Details
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(name)
                    .font(theme.typography.bodyMedium.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                HStack(spacing: theme.spacing.xs) {
                    Text(category)
                        .font(theme.typography.labelSmall.font)
                        .foregroundColor(theme.colors.textTertiary)
                    
                    Text("•")
                        .foregroundColor(theme.colors.textTertiary)
                    
                    Text(date)
                        .font(theme.typography.labelSmall.font)
                        .foregroundColor(theme.colors.textTertiary)
                }
            }
            
            Spacer()
            
            // Amount
            Text(amount)
                .font(theme.typography.titleSmall.font)
                .foregroundColor(isExpense ? theme.colors.error : theme.colors.success)
        }
        .padding(theme.spacing.sm)
        .background(theme.colors.backgroundSecondary.opacity(0.5))
        .cornerRadius(theme.radius.sm)
    }
}

// MARK: - Theme Option Enum

enum ThemeOption: String, CaseIterable {
    case vibrant
    case neutral
    
    var theme: AppTheme {
        switch self {
        case .vibrant: return VibrantTheme()
        case .neutral: return NeutralTheme()
        }
    }
}

// MARK: - Preview

#Preview("Full App Example") {
    ThemeProvider(theme: VibrantTheme()) {
        MainAppView()
    }
    .frame(width: 1200, height: 800)
}

#Preview("Dashboard Only - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        DashboardExample()
    }
    .frame(width: 900, height: 800)
}

#Preview("Dashboard Only - Neutral") {
    ThemeProvider(theme: NeutralTheme()) {
        DashboardExample()
    }
    .frame(width: 900, height: 800)
}
