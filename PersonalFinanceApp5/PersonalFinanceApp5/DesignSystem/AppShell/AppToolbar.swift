import SwiftUI

// MARK: - Toolbar Components

/// Date range segmented control for toolbar
struct DateRangeControl: View {
    @Environment(\.theme) private var theme
    @Binding var selectedRange: DateRange
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(DateRange.allCases) { range in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedRange = range
                    }
                }) {
                    Text(range.rawValue)
                        .font(theme.typography.labelMedium.font)
                        .foregroundColor(
                            selectedRange == range
                                ? theme.colors.primary
                                : theme.colors.textSecondary
                        )
                        .padding(.horizontal, theme.spacing.sm)
                        .padding(.vertical, theme.spacing.xs)
                        .background(
                            selectedRange == range
                                ? theme.colors.primary.opacity(0.12)
                                : Color.clear
                        )
                        .cornerRadius(theme.radius.sm)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(theme.spacing.xxs)
        .background(theme.colors.backgroundSecondary)
        .cornerRadius(theme.radius.sm)
    }
}

/// Search field component for toolbar
struct SearchField: View {
    @Environment(\.theme) private var theme
    @Binding var text: String
    let placeholder: String
    let isEnabled: Bool
    
    init(
        text: Binding<String>,
        placeholder: String = "Search...",
        isEnabled: Bool = true
    ) {
        self._text = text
        self.placeholder = placeholder
        self.isEnabled = isEnabled
    }
    
    var body: some View {
        HStack(spacing: theme.spacing.xs) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 13, weight: .medium))
                .foregroundColor(
                    isEnabled
                        ? theme.colors.textTertiary
                        : theme.colors.textTertiary.opacity(0.4)
                )
            
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(theme.typography.bodyMedium.font)
                .foregroundColor(theme.colors.textPrimary)
                .disabled(!isEnabled)
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 13))
                        .foregroundColor(theme.colors.textTertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.vertical, theme.spacing.xs)
        .frame(width: 250)
        .background(
            isEnabled
                ? theme.colors.backgroundSecondary
                : theme.colors.backgroundSecondary.opacity(0.5)
        )
        .cornerRadius(theme.radius.sm)
        .overlay(
            RoundedRectangle(cornerRadius: theme.radius.sm)
                .strokeBorder(
                    theme.colors.border.opacity(0.3),
                    lineWidth: 1
                )
        )
    }
}

/// App toolbar for navigation bar
struct AppToolbar: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        HStack(spacing: theme.spacing.lg) {
            // Date Range Control
            DateRangeControl(selectedRange: $appState.dateRange)
            
            Spacer()
            
            // Search Field
            SearchField(
                text: $appState.searchText,
                placeholder: searchPlaceholder,
                isEnabled: appState.selectedDestination.supportsSearch
            )
            
            // Refresh Button
            Button(action: {
                appState.dataService.refresh()
            }) {
                Image(systemName: "arrow.clockwise")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(theme.colors.textSecondary)
            }
            .buttonStyle(.plain)
            .disabled(appState.dataService.isLoading)
            
            // Theme Selector
            Menu {
                ForEach(ThemeSelection.allCases, id: \.self) { theme in
                    Button(theme.displayName) {
                        appState.selectedTheme = theme
                    }
                }
            } label: {
                HStack(spacing: theme.spacing.xs) {
                    Image(systemName: "paintbrush.fill")
                        .font(.system(size: 12))
                    
                    Text(appState.selectedTheme.displayName)
                        .font(theme.typography.labelMedium.font)
                }
                .foregroundColor(theme.colors.textSecondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, theme.spacing.lg)
        .padding(.vertical, theme.spacing.md)
        .background(theme.colors.surface)
    }
    
    private var searchPlaceholder: String {
        switch appState.selectedDestination {
        case .dashboard:
            return "Search..."
        case .incomeExpenses:
            return "Search transactions..."
        case .assetsGoals:
            return "Search goals..."
        }
    }
}

// MARK: - Sidebar

/// Navigation sidebar component
struct AppSidebar: View {
    @Environment(\.theme) private var theme
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                    Text("Finance App")
                        .font(theme.typography.titleLarge.font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text("Personal Dashboard")
                        .font(theme.typography.labelSmall.font)
                        .foregroundColor(theme.colors.textTertiary)
                }
                
                Spacer()
            }
            .padding(theme.spacing.lg)
            .background(theme.colors.surface)
            
            Divider()
                .background(theme.colors.border)
            
            // Navigation Items
            ScrollView {
                VStack(spacing: theme.spacing.xs) {
                    ForEach(NavigationDestination.allCases) { destination in
                        navigationButton(destination)
                    }
                }
                .padding(theme.spacing.md)
            }
            
            Spacer()
            
            // Footer Stats
            Divider()
                .background(theme.colors.border)
            
            footerStats
        }
        .frame(width: 260)
        .background(theme.colors.backgroundSecondary)
    }
    
    private func navigationButton(_ destination: NavigationDestination) -> some View {
        Button(action: {
            appState.navigate(to: destination)
        }) {
            HStack(spacing: theme.spacing.sm) {
                Image(systemName: destination.icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(
                        appState.selectedDestination == destination
                            ? theme.colors.primary
                            : theme.colors.textSecondary
                    )
                    .frame(width: 24)
                
                Text(destination.displayName)
                    .font(theme.typography.bodyMedium.font)
                    .foregroundColor(
                        appState.selectedDestination == destination
                            ? theme.colors.primary
                            : theme.colors.textPrimary
                    )
                
                Spacer()
                
                if appState.selectedDestination == destination {
                    Circle()
                        .fill(theme.colors.primary)
                        .frame(width: 6, height: 6)
                }
            }
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.sm)
            .background(
                appState.selectedDestination == destination
                    ? theme.colors.primary.opacity(0.1)
                    : Color.clear
            )
            .cornerRadius(theme.radius.sm)
        }
        .buttonStyle(.plain)
    }
    
    private var footerStats: some View {
        VStack(spacing: theme.spacing.sm) {
            statRow(
                label: "Net Worth",
                value: formatCurrency(appState.dataService.totalAssets)
            )
            
            statRow(
                label: "Cash Flow",
                value: formatCurrency(appState.dataService.netCashFlow),
                color: appState.dataService.netCashFlow >= 0
                    ? theme.colors.success
                    : theme.colors.error
            )
            
            statRow(
                label: "Goals",
                value: "\(appState.dataService.completedGoals)/\(appState.dataService.goals.count)"
            )
            
            Text("Updated \(timeAgo(appState.dataService.lastUpdated))")
                .font(theme.typography.labelSmall.font)
                .foregroundColor(theme.colors.textTertiary)
                .padding(.top, theme.spacing.xs)
        }
        .padding(theme.spacing.lg)
    }
    
    private func statRow(label: String, value: String, color: Color? = nil) -> some View {
        HStack {
            Text(label)
                .font(theme.typography.labelSmall.font)
                .foregroundColor(theme.colors.textSecondary)
            
            Spacer()
            
            Text(value)
                .font(theme.typography.labelMedium.font)
                .foregroundColor(color ?? theme.colors.textPrimary)
                .monospacedDigit()
        }
    }
    
    private func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        
        if abs(value) >= 1_000_000 {
            formatter.maximumFractionDigits = 1
            let suffix = value >= 0 ? "M" : "M"
            return (formatter.string(from: NSNumber(value: abs(value) / 1_000_000))?.replacingOccurrences(of: ".0", with: "") ?? "$0") + suffix
        } else if abs(value) >= 1_000 {
            formatter.maximumFractionDigits = 1
            let suffix = "K"
            return (formatter.string(from: NSNumber(value: abs(value) / 1_000))?.replacingOccurrences(of: ".0", with: "") ?? "$0") + suffix
        } else {
            formatter.maximumFractionDigits = 0
            return formatter.string(from: NSNumber(value: value)) ?? "$0"
        }
    }
    
    private func timeAgo(_ date: Date) -> String {
        let seconds = Int(Date().timeIntervalSince(date))
        
        if seconds < 60 {
            return "just now"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes)m ago"
        } else if seconds < 86400 {
            let hours = seconds / 3600
            return "\(hours)h ago"
        } else {
            let days = seconds / 86400
            return "\(days)d ago"
        }
    }
}
