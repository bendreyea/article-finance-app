import SwiftUI

/// Example view demonstrating the DesignSystem in a realistic finance app context
struct FinanceDashboardExample: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                // Header
                headerSection
                
                // Stats Cards
                statsGrid
                
                // Recent Transactions
                transactionsCard
                
                // Budget Overview
                budgetCard
            }
            .padding(theme.spacing.xl)
        }
        .background(theme.colors.background)
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Dashboard")
                .font(theme.typography.displayMedium)
                .foregroundColor(theme.colors.textPrimary)
            
            Text("Welcome back, here's your financial overview")
                .font(theme.typography.bodyMedium)
                .foregroundColor(theme.colors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var statsGrid: some View {
        HStack(spacing: theme.spacing.lg) {
            statCard(
                title: "Net Worth",
                value: "$45,280",
                change: "+12.5%",
                isPositive: true
            )
            
            statCard(
                title: "Monthly Income",
                value: "$8,450",
                change: "+5.2%",
                isPositive: true
            )
            
            statCard(
                title: "Expenses",
                value: "$3,280",
                change: "-8.1%",
                isPositive: true
            )
        }
    }
    
    private func statCard(title: String, value: String, change: String, isPositive: Bool) -> some View {
        Card(style: .elevated, padding: .medium) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(title)
                    .font(theme.typography.labelMedium)
                    .foregroundColor(theme.colors.textSecondary)
                
                Text(value)
                    .font(theme.typography.headingLarge)
                    .foregroundColor(theme.colors.textPrimary)
                
                HStack(spacing: theme.spacing.xs) {
                    Image(systemName: isPositive ? "arrow.up.right" : "arrow.down.right")
                        .font(theme.typography.labelSmall)
                    Text(change)
                        .font(theme.typography.labelMedium)
                }
                .foregroundColor(isPositive ? theme.colors.success : theme.colors.error)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var transactionsCard: some View {
        Card(style: .elevated) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                HStack {
                    Text("Recent Transactions")
                        .font(theme.typography.headingMedium)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Spacer()
                    
                    Button("View All") {}
                        .font(theme.typography.labelMedium)
                        .foregroundColor(theme.colors.accentPrimary)
                }
                
                VStack(spacing: theme.spacing.md) {
                    transactionRow(
                        icon: "cart.fill",
                        title: "Grocery Shopping",
                        category: "Food & Dining",
                        amount: "-$127.50",
                        isExpense: true
                    )
                    
                    Divider()
                        .background(theme.colors.borderSubtle)
                    
                    transactionRow(
                        icon: "dollarsign.circle.fill",
                        title: "Salary Deposit",
                        category: "Income",
                        amount: "+$4,200.00",
                        isExpense: false
                    )
                    
                    Divider()
                        .background(theme.colors.borderSubtle)
                    
                    transactionRow(
                        icon: "fuelpump.fill",
                        title: "Gas Station",
                        category: "Transportation",
                        amount: "-$45.00",
                        isExpense: true
                    )
                }
            }
        }
    }
    
    private func transactionRow(
        icon: String,
        title: String,
        category: String,
        amount: String,
        isExpense: Bool
    ) -> some View {
        HStack(spacing: theme.spacing.md) {
            Circle()
                .fill(theme.colors.accentPrimary.opacity(0.1))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(theme.colors.accentPrimary)
                        .font(.system(size: 18))
                )
            
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(title)
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.textPrimary)
                
                Text(category)
                    .font(theme.typography.labelSmall)
                    .foregroundColor(theme.colors.textTertiary)
            }
            
            Spacer()
            
            Text(amount)
                .font(theme.typography.bodyLarge)
                .foregroundColor(isExpense ? theme.colors.textPrimary : theme.colors.success)
        }
    }
    
    private var budgetCard: some View {
        Card(style: .outlined) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                Text("Budget Overview")
                    .font(theme.typography.headingMedium)
                    .foregroundColor(theme.colors.textPrimary)
                
                budgetItem(
                    category: "Food & Dining",
                    spent: 450,
                    budget: 600,
                    color: theme.colors.chartPrimary[0]
                )
                
                budgetItem(
                    category: "Transportation",
                    spent: 180,
                    budget: 200,
                    color: theme.colors.chartPrimary[1]
                )
                
                budgetItem(
                    category: "Entertainment",
                    spent: 95,
                    budget: 150,
                    color: theme.colors.chartPrimary[2]
                )
            }
        }
    }
    
    private func budgetItem(category: String, spent: Double, budget: Double, color: Color) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack {
                Text(category)
                    .font(theme.typography.bodyMedium)
                    .foregroundColor(theme.colors.textPrimary)
                
                Spacer()
                
                Text("$\(Int(spent)) / $\(Int(budget))")
                    .font(theme.typography.labelMedium)
                    .foregroundColor(theme.colors.textSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: theme.radius.full)
                        .fill(theme.colors.backgroundTertiary)
                        .frame(height: 6)
                    
                    RoundedRectangle(cornerRadius: theme.radius.full)
                        .fill(color)
                        .frame(width: geometry.size.width * (spent / budget), height: 6)
                }
            }
            .frame(height: 6)
        }
    }
}

#Preview("Finance Dashboard - Vibrant") {
    FinanceDashboardExample()
        .themed(VibrantTheme())
        .frame(width: 800, height: 900)
}

#Preview("Finance Dashboard - Neutral") {
    FinanceDashboardExample()
        .themed(NeutralTheme())
        .frame(width: 800, height: 900)
}

#Preview("Finance Dashboard - Side by Side") {
    HStack(spacing: 40) {
        ScrollView {
            FinanceDashboardExample()
                .themed(VibrantTheme())
        }
        .frame(maxHeight: 900)
        
        ScrollView {
            FinanceDashboardExample()
                .themed(NeutralTheme())
        }
        .frame(maxHeight: 900)
    }
    .padding()
    .frame(minWidth: 1700, minHeight: 900)
}
