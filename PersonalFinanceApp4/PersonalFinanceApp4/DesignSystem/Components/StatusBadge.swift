//
//  StatusBadge.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// A colored badge component for displaying transaction status.
/// Shows status text with appropriate color coding from the theme.
///
/// Example usage:
/// ```swift
/// StatusBadge(status: .paid)
/// StatusBadge(status: .late)
/// ```
public struct StatusBadge: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    private let status: TransactionStatus
    private let size: BadgeSize
    
    // MARK: - Computed Properties
    
    /// Color for the status badge
    private var statusColor: Color {
        switch status {
        case .paid:
            return theme.colors.success
        case .due:
            return theme.colors.warning
        case .late:
            return theme.colors.error
        }
    }
    
    /// Icon for the status
    private var statusIcon: String {
        switch status {
        case .paid:
            return "checkmark.circle.fill"
        case .due:
            return "clock.fill"
        case .late:
            return "exclamationmark.triangle.fill"
        }
    }
    
    // MARK: - Initialization
    
    public init(status: TransactionStatus, size: BadgeSize = .medium) {
        self.status = status
        self.size = size
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: size.iconSpacing(theme)) {
            Image(systemName: statusIcon)
                .font(.system(size: size.iconSize(theme)))
            
            Text(status.rawValue)
                .font(size.font(theme))
        }
        .foregroundColor(statusColor)
        .padding(.horizontal, size.horizontalPadding(theme))
        .padding(.vertical, size.verticalPadding(theme))
        .background(statusColor.opacity(0.15))
        .cornerRadius(size.cornerRadius(theme))
    }
}

// MARK: - Badge Size

/// Size variants for StatusBadge
public enum BadgeSize {
    case small
    case medium
    case large
    
    func font(_ theme: AppTheme) -> Font {
        switch self {
        case .small: return theme.typography.labelSmall
        case .medium: return theme.typography.labelMedium
        case .large: return theme.typography.labelLarge
        }
    }
    
    func iconSize(_ theme: AppTheme) -> CGFloat {
        switch self {
        case .small: return theme.spacing.iconSizeSmall - 2
        case .medium: return theme.spacing.iconSizeSmall
        case .large: return theme.spacing.iconSize
        }
    }
    
    func iconSpacing(_ theme: AppTheme) -> CGFloat {
        switch self {
        case .small: return theme.spacing.xxs
        case .medium: return theme.spacing.xs
        case .large: return theme.spacing.xs
        }
    }
    
    func horizontalPadding(_ theme: AppTheme) -> CGFloat {
        switch self {
        case .small: return theme.spacing.xs
        case .medium: return theme.spacing.sm
        case .large: return theme.spacing.md
        }
    }
    
    func verticalPadding(_ theme: AppTheme) -> CGFloat {
        switch self {
        case .small: return theme.spacing.xxs
        case .medium: return theme.spacing.xs
        case .large: return theme.spacing.sm
        }
    }
    
    func cornerRadius(_ theme: AppTheme) -> CGFloat {
        switch self {
        case .small: return theme.radius.sm
        case .medium: return theme.radius.md
        case .large: return theme.radius.lg
        }
    }
}

// MARK: - Previews

#Preview("StatusBadge - All Statuses") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 20) {
            Text("Status Badges")
                .font(.system(size: 24, weight: .bold))
            
            VStack(spacing: 16) {
                StatusBadge(status: .paid)
                StatusBadge(status: .due)
                StatusBadge(status: .late)
            }
        }
        .padding(40)
    }
    .frame(width: 300, height: 300)
}

#Preview("StatusBadge - Sizes") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 20) {
            Text("Badge Sizes")
                .font(.system(size: 24, weight: .bold))
            
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Small:")
                        .frame(width: 80, alignment: .leading)
                    StatusBadge(status: .paid, size: .small)
                    StatusBadge(status: .due, size: .small)
                    StatusBadge(status: .late, size: .small)
                }
                
                HStack {
                    Text("Medium:")
                        .frame(width: 80, alignment: .leading)
                    StatusBadge(status: .paid, size: .medium)
                    StatusBadge(status: .due, size: .medium)
                    StatusBadge(status: .late, size: .medium)
                }
                
                HStack {
                    Text("Large:")
                        .frame(width: 80, alignment: .leading)
                    StatusBadge(status: .paid, size: .large)
                    StatusBadge(status: .due, size: .large)
                    StatusBadge(status: .late, size: .large)
                }
            }
        }
        .padding(40)
    }
    .frame(width: 600, height: 350)
}

#Preview("StatusBadge - Themes") {
    HStack(spacing: 0) {
        ThemeProvider(theme: VibrantTheme()) {
            VStack(spacing: 16) {
                Text("Vibrant Theme")
                    .font(.system(size: 18, weight: .semibold))
                
                StatusBadge(status: .paid)
                StatusBadge(status: .due)
                StatusBadge(status: .late)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        
        Divider()
        
        ThemeProvider(theme: NeutralTheme()) {
            VStack(spacing: 16) {
                Text("Neutral Theme")
                    .font(.system(size: 18, weight: .semibold))
                
                StatusBadge(status: .paid)
                StatusBadge(status: .due)
                StatusBadge(status: .late)
            }
            .padding(40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    .frame(width: 600, height: 300)
}
