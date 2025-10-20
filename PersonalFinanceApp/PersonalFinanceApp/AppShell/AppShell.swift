import SwiftUI

/// Main application shell with navigation and theming
public struct AppShell: View {
    @State private var appState = AppState()
    @State private var themeManager = ThemeManager(theme: VibrantTheme())
    
    public init() {}
    
    public var body: some View {
        ThemeProvider(theme: themeManager.currentTheme) {
            NavigationSplitView {
                SidebarView(selection: $appState.selectedSection)
            } detail: {
                DetailView(
                    selectedSection: appState.selectedSection,
                    dateRange: $appState.dateRange,
                    searchText: $appState.searchText
                )
            }
            .navigationSplitViewStyle(.balanced)
            .environment(appState)
            .environment(themeManager)
        }
    }
}

/// Application state management
@Observable
public class AppState {
    public var selectedSection: AppSection = .dashboard
    public var dateRange: DateRange = .month
    public var searchText: String = ""
    
    public init() {}
}

/// App sections for navigation
public enum AppSection: String, CaseIterable, Identifiable {
    case dashboard = "Dashboard"
    case incomeExpenses = "Income & Expenses"
    case assetsGoals = "Assets & Goals"
    
    public var id: String { rawValue }
    
    public var icon: String {
        switch self {
        case .dashboard:
            return "rectangle.grid.2x2"
        case .incomeExpenses:
            return "chart.line.uptrend.xyaxis"
        case .assetsGoals:
            return "target"
        }
    }
    
    public var description: String {
        switch self {
        case .dashboard:
            return "Overview of your financial status"
        case .incomeExpenses:
            return "Track income and expense transactions"
        case .assetsGoals:
            return "Manage assets and financial goals"
        }
    }
}

/// Date range options for filtering
public enum DateRange: String, CaseIterable, Identifiable {
    case week = "7 Days"
    case month = "30 Days"
    case quarter = "90 Days"
    case year = "1 Year"
    
    public var id: String { rawValue }
    
    public var days: Int {
        switch self {
        case .week: return 7
        case .month: return 30
        case .quarter: return 90
        case .year: return 365
        }
    }
}

/// Sidebar navigation view
private struct SidebarView: View {
    @Environment(\.theme) private var theme
    @Environment(ThemeManager.self) private var themeManager
    @Binding var selection: AppSection
    
    var body: some View {
        List(AppSection.allCases, selection: $selection) { section in
            NavigationLink(value: section) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(section.rawValue)
                            .font(theme.typography.calloutFont)
                            .foregroundColor(theme.colors.textPrimary)
                        
                        Text(section.description)
                            .font(theme.typography.captionFont)
                            .foregroundColor(theme.colors.textSecondary)
                            .lineLimit(2)
                    }
                } icon: {
                    Image(systemName: section.icon)
                        .foregroundColor(theme.colors.primary)
                        .frame(width: 20)
                }
            }
        }
        .navigationTitle("Personal Finance")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                themeToggleButton
            }
        }
    }
    
    private var themeToggleButton: some View {
        Button(action: toggleTheme) {
            Image(systemName: themeManager.currentTheme.name == "Vibrant" ? "sun.max" : "moon")
                .foregroundColor(theme.colors.primary)
        }
        .help("Toggle theme")
    }
    
    private func toggleTheme() {
        let newTheme: AppTheme = themeManager.currentTheme.name == "Vibrant" 
            ? NeutralTheme() 
            : VibrantTheme()
        themeManager.setTheme(newTheme)
    }
}

/// Detail view with toolbar and content
private struct DetailView: View {
    @Environment(\.theme) private var theme
    @Environment(AppState.self) private var appState
    
    let selectedSection: AppSection
    @Binding var dateRange: DateRange
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Top toolbar
            TopToolbar(
                selectedSection: selectedSection,
                dateRange: $dateRange,
                searchText: $searchText
            )
            
            // Main content
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(theme.colors.background)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedSection {
        case .dashboard:
            DashboardView(dateRange: dateRange, searchText: searchText)
        case .incomeExpenses:
            IncomeExpensesView(dateRange: dateRange, searchText: searchText)
        case .assetsGoals:
            AssetsGoalsView(dateRange: dateRange, searchText: searchText)
        }
    }
}

/// Top toolbar with date range and search
private struct TopToolbar: View {
    @Environment(\.theme) private var theme
    
    let selectedSection: AppSection
    @Binding var dateRange: DateRange
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: theme.spacing.lg) {
                // Section title
                VStack(alignment: .leading, spacing: 2) {
                    Text(selectedSection.rawValue)
                        .font(theme.typography.title2Font)
                        .foregroundColor(theme.colors.textPrimary)
                    
                    Text(selectedSection.description)
                        .font(theme.typography.captionFont)
                        .foregroundColor(theme.colors.textSecondary)
                }
                
                Spacer()
                
                // Date range picker
                Picker("Date Range", selection: $dateRange) {
                    ForEach(DateRange.allCases) { range in
                        Text(range.rawValue).tag(range)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 320)
                
                // Search field
                SearchField(text: $searchText, placeholder: searchPlaceholder)
                    .frame(width: 200)
            }
            .padding(theme.spacing.md)
            .background(theme.colors.surface)
            
            Divider()
        }
    }
    
    private var searchPlaceholder: String {
        switch selectedSection {
        case .dashboard:
            return "Search overview..."
        case .incomeExpenses:
            return "Search transactions..."
        case .assetsGoals:
            return "Search assets & goals..."
        }
    }
}

/// Custom search field component
private struct SearchField: View {
    @Environment(\.theme) private var theme
    @Binding var text: String
    let placeholder: String
    
    var body: some View {
        HStack(spacing: theme.spacing.sm) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(theme.colors.textSecondary)
                .font(.system(size: 14))
            
            TextField(placeholder, text: $text)
                .font(theme.typography.bodyFont)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: { text = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(theme.colors.textSecondary)
                        .font(.system(size: 14))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, theme.spacing.sm)
        .padding(.vertical, theme.spacing.xs)
        .background(theme.colors.surfaceVariant)
        .cornerRadius(theme.radius.input)
    }
}