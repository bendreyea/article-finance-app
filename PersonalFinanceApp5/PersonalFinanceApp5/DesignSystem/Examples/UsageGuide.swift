import SwiftUI

/// Quick Reference Guide for DesignSystem Usage
///
/// This file contains practical examples of common patterns when using the DesignSystem.
/// Copy and adapt these snippets for your own components.

// MARK: - 1. Basic Theme Access

struct BasicThemeAccess: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        Text("Hello, World!")
            .font(theme.typography.bodyMedium.font)
            .foregroundColor(theme.colors.textPrimary)
            .padding(theme.spacing.md)
    }
}

// MARK: - 2. Custom Button Component

struct ThemedButton: View {
    @Environment(\.theme) private var theme
    @State private var isHovered = false
    
    let title: String
    let action: () -> Void
    let style: ButtonStyleType
    
    enum ButtonStyleType {
        case primary, secondary, outline
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(theme.typography.labelMedium.font)
                .foregroundColor(textColor)
                .padding(.horizontal, theme.spacing.md)
                .padding(.vertical, theme.spacing.sm)
                .background(backgroundColor)
                .cornerRadius(theme.radius.md)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.radius.md)
                        .strokeBorder(borderColor, lineWidth: style == .outline ? 1 : 0)
                )
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            isHovered = hovering
        }
    }
    
    private var backgroundColor: Color {
        switch style {
        case .primary:
            return isHovered ? theme.colors.primaryHover : theme.colors.primary
        case .secondary:
            return isHovered ? theme.colors.backgroundTertiary : theme.colors.backgroundSecondary
        case .outline:
            return isHovered ? theme.colors.backgroundSecondary : .clear
        }
    }
    
    private var textColor: Color {
        style == .primary ? theme.colors.textInverse : theme.colors.textPrimary
    }
    
    private var borderColor: Color {
        style == .outline ? theme.colors.border : .clear
    }
}

// MARK: - 3. Status Badge Component

struct ExampleStatusBadge: View {
    @Environment(\.theme) private var theme
    
    let text: String
    let status: StatusType
    
    enum StatusType {
        case success, warning, error, info
        
        func colors(from theme: AppTheme) -> (text: Color, background: Color) {
            switch self {
            case .success:
                return (theme.colors.success, theme.colors.successBackground)
            case .warning:
                return (theme.colors.warning, theme.colors.warningBackground)
            case .error:
                return (theme.colors.error, theme.colors.errorBackground)
            case .info:
                return (theme.colors.info, theme.colors.infoBackground)
            }
        }
    }
    
    var body: some View {
        let colors = status.colors(from: theme)
        
        Text(text)
            .font(theme.typography.labelSmall.font)
            .foregroundColor(colors.text)
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xxs)
            .background(colors.background)
            .cornerRadius(theme.radius.sm)
    }
}

// MARK: - 4. List Row Component

struct ThemedListRow<Content: View>: View {
    @Environment(\.theme) private var theme
    @State private var isHovered = false
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding(theme.spacing.md)
            .background(
                isHovered ? theme.colors.surfaceHover : theme.colors.surface
            )
            .cornerRadius(theme.radius.sm)
            .overlay(
                RoundedRectangle(cornerRadius: theme.radius.sm)
                    .strokeBorder(theme.colors.borderSubtle, lineWidth: 1)
            )
            .onHover { hovering in
                isHovered = hovering
            }
    }
}

// MARK: - 5. Input Field Component

struct ThemedTextField: View {
    @Environment(\.theme) private var theme
    @FocusState private var isFocused: Bool
    
    let label: String
    @Binding var text: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xs) {
            Text(label)
                .font(theme.typography.labelMedium.font)
                .foregroundColor(theme.colors.textSecondary)
            
            TextField("", text: $text)
                .textFieldStyle(.plain)
                .font(theme.typography.bodyMedium.font)
                .foregroundColor(theme.colors.textPrimary)
                .padding(theme.spacing.sm)
                .background(theme.colors.backgroundSecondary)
                .cornerRadius(theme.radius.sm)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.radius.sm)
                        .strokeBorder(
                            isFocused ? theme.colors.borderFocus : theme.colors.border,
                            lineWidth: isFocused ? 2 : 1
                        )
                )
                .focused($isFocused)
        }
    }
}

// MARK: - 6. Section Header Component

struct SectionHeader: View {
    @Environment(\.theme) private var theme
    
    let title: String
    let subtitle: String?
    let action: (() -> Void)?
    let actionTitle: String?
    
    init(
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }
    
    var body: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: theme.spacing.xxs) {
                Text(title)
                    .font(theme.typography.titleLarge.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(theme.typography.bodySmall.font)
                        .foregroundColor(theme.colors.textSecondary)
                }
            }
            
            Spacer()
            
            if let action = action, let actionTitle = actionTitle {
                Button(action: action) {
                    Text(actionTitle)
                        .font(theme.typography.labelMedium.font)
                        .foregroundColor(theme.colors.primary)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

// MARK: - 7. Metric Card Component

struct MetricCard: View {
    @Environment(\.theme) private var theme
    
    let title: String
    let value: String
    let trend: TrendInfo?
    let icon: String?
    
    struct TrendInfo {
        let value: String
        let isPositive: Bool
    }
    
    var body: some View {
        Card(padding: .lg, shadow: .md) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                // Header
                HStack {
                    if let icon = icon {
                        Image(systemName: icon)
                            .font(.system(size: 20))
                            .foregroundColor(theme.colors.primary)
                    }
                    
                    Text(title)
                        .font(theme.typography.labelMedium.font)
                        .foregroundColor(theme.colors.textSecondary)
                    
                    Spacer()
                }
                
                // Value
                Text(value)
                    .font(theme.typography.displaySmall.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                // Trend
                if let trend = trend {
                    HStack(spacing: theme.spacing.xxs) {
                        Image(systemName: trend.isPositive ? "arrow.up.right" : "arrow.down.right")
                            .font(.system(size: 10, weight: .bold))
                        Text(trend.value)
                            .font(theme.typography.labelSmall.font)
                    }
                    .foregroundColor(trend.isPositive ? theme.colors.success : theme.colors.error)
                    .padding(.horizontal, theme.spacing.xs)
                    .padding(.vertical, theme.spacing.xxs)
                    .background(
                        trend.isPositive ? theme.colors.successBackground : theme.colors.errorBackground
                    )
                    .cornerRadius(theme.radius.sm)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - 8. Empty State Component

struct EmptyState: View {
    @Environment(\.theme) private var theme
    
    let icon: String
    let title: String
    let description: String
    let actionTitle: String?
    let action: (() -> Void)?
    
    var body: some View {
        VStack(spacing: theme.spacing.lg) {
            Image(systemName: icon)
                .font(.system(size: 48))
                .foregroundColor(theme.colors.textTertiary)
            
            VStack(spacing: theme.spacing.xs) {
                Text(title)
                    .font(theme.typography.titleLarge.font)
                    .foregroundColor(theme.colors.textPrimary)
                
                Text(description)
                    .font(theme.typography.bodyMedium.font)
                    .foregroundColor(theme.colors.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            if let action = action, let actionTitle = actionTitle {
                ThemedButton(title: actionTitle, action: action, style: .primary)
            }
        }
        .padding(theme.spacing.xxl)
        .frame(maxWidth: 400)
    }
}

// MARK: - 9. Divider Component

struct ThemedDivider: View {
    @Environment(\.theme) private var theme
    
    let style: DividerStyle
    
    enum DividerStyle {
        case standard, subtle, bold
        
        func color(from theme: AppTheme) -> Color {
            switch self {
            case .standard: return theme.colors.border
            case .subtle: return theme.colors.borderSubtle
            case .bold: return theme.colors.textTertiary
            }
        }
    }
    
    var body: some View {
        Rectangle()
            .fill(style.color(from: theme))
            .frame(height: 1)
    }
}

// MARK: - 10. Toast Notification Component

struct Toast: View {
    @Environment(\.theme) private var theme
    
    let message: String
    let type: ToastType
    
    enum ToastType {
        case success, warning, error, info
        
        func icon() -> String {
            switch self {
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            case .info: return "info.circle.fill"
            }
        }
        
        func colors(from theme: AppTheme) -> (text: Color, icon: Color, background: Color) {
            switch self {
            case .success:
                return (theme.colors.textPrimary, theme.colors.success, theme.colors.successBackground)
            case .warning:
                return (theme.colors.textPrimary, theme.colors.warning, theme.colors.warningBackground)
            case .error:
                return (theme.colors.textPrimary, theme.colors.error, theme.colors.errorBackground)
            case .info:
                return (theme.colors.textPrimary, theme.colors.info, theme.colors.infoBackground)
            }
        }
    }
    
    var body: some View {
        let colors = type.colors(from: theme)
        
        HStack(spacing: theme.spacing.sm) {
            Image(systemName: type.icon())
                .font(.system(size: 16))
                .foregroundColor(colors.icon)
            
            Text(message)
                .font(theme.typography.bodyMedium.font)
                .foregroundColor(colors.text)
            
            Spacer()
        }
        .padding(theme.spacing.md)
        .background(colors.background)
        .cornerRadius(theme.radius.md)
        .shadow(
            color: theme.shadows.md.color,
            radius: theme.shadows.md.radius,
            x: theme.shadows.md.x,
            y: theme.shadows.md.y
        )
    }
}

// MARK: - Usage Examples Preview

struct UsageExamplesPreview: View {
    @Environment(\.theme) private var theme
    @State private var textInput = ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: theme.spacing.xl) {
                // Buttons
                HStack(spacing: theme.spacing.md) {
                    ThemedButton(title: "Primary", action: {}, style: .primary)
                    ThemedButton(title: "Secondary", action: {}, style: .secondary)
                    ThemedButton(title: "Outline", action: {}, style: .outline)
                }
                
                // Status Badges
                HStack(spacing: theme.spacing.sm) {
                    ExampleStatusBadge(text: "Success", status: .success)
                    ExampleStatusBadge(text: "Warning", status: .warning)
                    ExampleStatusBadge(text: "Error", status: .error)
                    ExampleStatusBadge(text: "Info", status: .info)
                }
                
                // Metric Card
                MetricCard(
                    title: "Total Balance",
                    value: "$45,678.90",
                    trend: MetricCard.TrendInfo(value: "+12.5%", isPositive: true),
                    icon: "dollarsign.circle.fill"
                )
                .frame(width: 300)
                
                // Section Header
                SectionHeader(
                    title: "Recent Transactions",
                    subtitle: "Last 30 days",
                    actionTitle: "View All",
                    action: {}
                )
                
                // Input Field
                ThemedTextField(label: "Account Name", text: $textInput)
                    .frame(width: 300)
                
                // Toast Notifications
                VStack(spacing: theme.spacing.sm) {
                    Toast(message: "Transaction saved successfully", type: .success)
                    Toast(message: "Budget limit approaching", type: .warning)
                    Toast(message: "Failed to sync data", type: .error)
                    Toast(message: "New update available", type: .info)
                }
                .frame(width: 350)
                
                // Empty State
                EmptyState(
                    icon: "tray",
                    title: "No Transactions",
                    description: "You haven't added any transactions yet. Start by adding your first transaction.",
                    actionTitle: "Add Transaction",
                    action: {}
                )
            }
            .padding(theme.spacing.xl)
        }
        .background(theme.colors.background)
    }
}

// MARK: - Previews

#Preview("Usage Examples - Vibrant") {
    ThemeProvider(theme: VibrantTheme()) {
        UsageExamplesPreview()
    }
    .frame(width: 800, height: 1000)
}

#Preview("Usage Examples - Neutral") {
    ThemeProvider(theme: NeutralTheme()) {
        UsageExamplesPreview()
    }
    .frame(width: 800, height: 1000)
}
