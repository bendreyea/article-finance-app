import SwiftUI

// MARK: - App Shell

/// Main app shell with NavigationSplitView, toolbar, and theme injection
public struct AppShell: View {
    @StateObject private var appState = AppState()
    
    public init() {}
    
    public var body: some View {
        ThemeProvider(theme: appState.selectedTheme.makeTheme()) {
            NavigationSplitView {
                // Sidebar
                AppSidebar()
                    .environmentObject(appState)
            } detail: {
                // Detail Content
                VStack(spacing: 0) {
                    // Toolbar
                    AppToolbar()
                        .environmentObject(appState)
                    
                    Divider()
                        .background(appState.selectedTheme.makeTheme().colors.border)
                    
                    // Main Content
                    contentView
                        .environmentObject(appState)
                }
            }
            .navigationSplitViewStyle(.balanced)
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch appState.selectedDestination {
        case .dashboard:
            DashboardView()
        case .incomeExpenses:
            IncomeExpensesView()
        case .assetsGoals:
            AssetsGoalsView()
        }
    }
}

// MARK: - Preview

#Preview("App Shell - Vibrant Theme") {
    AppShell()
        .frame(width: 1400, height: 900)
}

#Preview("App Shell - Dashboard") {
    AppShell()
        .frame(width: 1400, height: 900)
}

#Preview("App Shell - Transactions") {
    AppShell()
        .frame(width: 1400, height: 900)
}

#Preview("App Shell - Assets") {
    AppShell()
        .frame(width: 1400, height: 900)
}
