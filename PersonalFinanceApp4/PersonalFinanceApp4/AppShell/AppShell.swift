//
//  AppShell.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// Main app shell with NavigationSplitView, sidebar, toolbar, and content area
struct AppShell: View {
    @Environment(\.theme) private var theme
    @State private var dataService = MockDataService()
    
    // MARK: - Navigation State
    @State private var selectedDestination: NavigationDestination = .dashboard
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    
    // MARK: - Filter State
    @State private var selectedDateRange: DateRange = .month
    @State private var searchQuery: String = ""
    
    private var filter: DataFilter {
        DataFilter(dateRange: selectedDateRange, searchQuery: searchQuery)
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar
            sidebarContent
        } detail: {
            // Detail/Content Area
            detailContent
        }
    }
    
    // MARK: - Sidebar
    
    private var sidebarContent: some View {
        List(NavigationDestination.allCases, selection: $selectedDestination) { destination in
            NavigationLink(value: destination) {
                Label {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(destination.title)
                            .font(theme.typography.bodyLarge)
                        
                        Text(destination.subtitle)
                            .font(theme.typography.labelSmall)
                            .foregroundColor(theme.colors.onSurfaceSecondary)
                    }
                } icon: {
                    Image(systemName: destination.icon)
                        .font(.system(size: 18))
                        .foregroundColor(theme.colors.primary)
                }
            }
            .listItemTint(theme.colors.primary.opacity(0.1))
        }
        .navigationTitle("Personal Finance")
        .navigationSplitViewColumnWidth(min: 250, ideal: 280, max: 350)
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    Task {
                        await dataService.refresh()
                    }
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
            }
        }
    }
    
    // MARK: - Detail Content
    
    @ViewBuilder
    private var detailContent: some View {
        VStack(spacing: 0) {
            // Top Toolbar
            topToolbar
            
            Divider()
            
            // Content based on selection
            contentView
        }
        .navigationTitle(selectedDestination.title)
    }
    
    // MARK: - Top Toolbar
    
    private var topToolbar: some View {
        HStack(spacing: theme.spacing.lg) {
            // Date Range Picker
            Picker("Date Range", selection: $selectedDateRange) {
                ForEach(DateRange.allCases) { range in
                    Text(range.title).tag(range)
                }
            }
            .pickerStyle(.segmented)
            .frame(maxWidth: 500)
            
            Spacer()
            
            // Search Field
            HStack(spacing: theme.spacing.xs) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(theme.colors.onSurfaceSecondary)
                
                TextField("Search...", text: $searchQuery)
                    .textFieldStyle(.plain)
                    .font(theme.typography.bodyMedium)
                
                if !searchQuery.isEmpty {
                    Button {
                        searchQuery = ""
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(theme.colors.onSurfaceSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(theme.colors.surfaceVariant)
            .cornerRadius(theme.radius.input)
            .frame(width: 300)
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surface)
    }
    
    // MARK: - Content View
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedDestination {
        case .dashboard:
            DashboardView(
                dataService: dataService,
                filter: filter
            )
            
        case .incomeExpenses:
            IncomeExpensesView(
                dataService: dataService,
                filter: filter
            )
            
        case .assetsGoals:
            AssetsGoalsView(
                dataService: dataService,
                filter: filter
            )
        }
    }
}

// MARK: - Previews

#Preview("AppShell - Vibrant Theme") {
    ThemeProvider(theme: VibrantTheme()) {
        AppShell()
    }
    .frame(width: 1400, height: 900)
}

#Preview("AppShell - Neutral Theme") {
    ThemeProvider(theme: NeutralTheme()) {
        AppShell()
    }
    .frame(width: 1400, height: 900)
}

#Preview("AppShell - Dashboard") {
    ThemeProvider(theme: VibrantTheme()) {
        AppShell()
    }
    .frame(width: 1400, height: 900)
}

#Preview("AppShell - Income & Expenses") {
    struct PreviewWrapper: View {
        @State private var shell = AppShell()
        
        var body: some View {
            ThemeProvider(theme: NeutralTheme()) {
                shell
                    .onAppear {
                        // Can't directly set private state, but preview shows default
                    }
            }
        }
    }
    
    return PreviewWrapper()
        .frame(width: 1400, height: 900)
}
