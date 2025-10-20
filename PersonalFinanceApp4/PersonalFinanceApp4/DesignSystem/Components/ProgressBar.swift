//
//  ProgressBar.swift
//  PersonalFinanceApp4
//
//  Created on 17 October 2025.
//

import SwiftUI

/// Size variants for the progress bar
public enum ProgressBarSize {
    case small
    case medium
    case large
    
    var height: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 10
        case .large: return 14
        }
    }
    
    var labelFont: Font {
        switch self {
        case .small: return .system(size: 11)
        case .medium: return .system(size: 12)
        case .large: return .system(size: 14)
        }
    }
}

/// A themed progress bar component with percentage display
public struct ProgressBar: View {
    @Environment(\.theme) private var theme
    
    // MARK: - Properties
    
    public let progress: Double // 0.0 to 1.0
    public let size: ProgressBarSize
    public let showPercentage: Bool
    public let color: ProgressBarColor
    public let animated: Bool
    
    @State private var animatedProgress: Double = 0
    
    // MARK: - Initialization
    
    public init(
        progress: Double,
        size: ProgressBarSize = .medium,
        showPercentage: Bool = true,
        color: ProgressBarColor = .primary,
        animated: Bool = true
    ) {
        self.progress = min(max(progress, 0), 1) // Clamp between 0 and 1
        self.size = size
        self.showPercentage = showPercentage
        self.color = color
        self.animated = animated
    }
    
    // MARK: - Body
    
    public var body: some View {
        HStack(spacing: theme.spacing.sm) {
            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background track
                    RoundedRectangle(cornerRadius: size.height / 2)
                        .fill(theme.colors.surfaceVariant)
                        .frame(height: size.height)
                    
                    // Filled progress
                    RoundedRectangle(cornerRadius: size.height / 2)
                        .fill(barColor)
                        .frame(
                            width: geometry.size.width * (animated ? animatedProgress : progress),
                            height: size.height
                        )
                }
            }
            .frame(height: size.height)
            
            // Percentage label
            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(size.labelFont)
                    .foregroundColor(theme.colors.onSurfaceSecondary)
                    .fontWeight(.medium)
                    .frame(width: 40, alignment: .trailing)
            }
        }
        .onAppear {
            if animated {
                withAnimation(.easeOut(duration: 0.8)) {
                    animatedProgress = progress
                }
            }
        }
        .onChange(of: progress) { oldValue, newValue in
            if animated {
                withAnimation(.easeOut(duration: 0.5)) {
                    animatedProgress = newValue
                }
            }
        }
    }
    
    // MARK: - Color Selection
    
    private var barColor: Color {
        switch color {
        case .primary:
            return theme.colors.primary
        case .success:
            return theme.colors.success
        case .warning:
            return theme.colors.warning
        case .error:
            return theme.colors.error
        case .info:
            return theme.colors.info
        case .secondary:
            return theme.colors.secondary
        case .custom(let customColor):
            return customColor
        }
    }
}

/// Color options for progress bar
public enum ProgressBarColor {
    case primary
    case success
    case warning
    case error
    case info
    case secondary
    case custom(Color)
}

// MARK: - Previews

#Preview("ProgressBar - All Sizes") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 32) {
            Text("Progress Bar Sizes")
                .font(.system(size: 24, weight: .bold))
            
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Small (75%)")
                        .font(.caption)
                    ProgressBar(progress: 0.75, size: .small)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Medium (50%)")
                        .font(.caption)
                    ProgressBar(progress: 0.5, size: .medium)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Large (90%)")
                        .font(.caption)
                    ProgressBar(progress: 0.9, size: .large)
                }
            }
            .frame(width: 400)
        }
        .padding()
    }
    .frame(width: 500, height: 400)
}

#Preview("ProgressBar - All Colors") {
    ThemeProvider(theme: NeutralTheme()) {
        VStack(spacing: 32) {
            Text("Progress Bar Colors")
                .font(.system(size: 24, weight: .bold))
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Primary")
                        .font(.caption)
                    ProgressBar(progress: 0.65, color: .primary)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Success")
                        .font(.caption)
                    ProgressBar(progress: 0.85, color: .success)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Warning")
                        .font(.caption)
                    ProgressBar(progress: 0.45, color: .warning)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Error")
                        .font(.caption)
                    ProgressBar(progress: 0.25, color: .error)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Info")
                        .font(.caption)
                    ProgressBar(progress: 0.55, color: .info)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Secondary")
                        .font(.caption)
                    ProgressBar(progress: 0.70, color: .secondary)
                }
            }
            .frame(width: 400)
        }
        .padding()
    }
    .frame(width: 500, height: 600)
}

#Preview("ProgressBar - Without Percentage") {
    ThemeProvider(theme: VibrantTheme()) {
        VStack(spacing: 32) {
            Text("Without Percentage Labels")
                .font(.system(size: 24, weight: .bold))
            
            VStack(alignment: .leading, spacing: 16) {
                ProgressBar(progress: 0.33, showPercentage: false)
                ProgressBar(progress: 0.66, showPercentage: false, color: .success)
                ProgressBar(progress: 0.90, showPercentage: false, color: .warning)
            }
            .frame(width: 400)
        }
        .padding()
    }
    .frame(width: 500, height: 300)
}

#Preview("ProgressBar - Different Values") {
    ThemeProvider(theme: NeutralTheme()) {
        VStack(spacing: 32) {
            Text("Different Progress Values")
                .font(.system(size: 24, weight: .bold))
            
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Just Started (10%)")
                        .font(.caption2)
                    ProgressBar(progress: 0.1, color: .error)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Quarter Way (25%)")
                        .font(.caption2)
                    ProgressBar(progress: 0.25, color: .warning)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Half Way (50%)")
                        .font(.caption2)
                    ProgressBar(progress: 0.5, color: .info)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Three Quarters (75%)")
                        .font(.caption2)
                    ProgressBar(progress: 0.75, color: .primary)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Almost Done (95%)")
                        .font(.caption2)
                    ProgressBar(progress: 0.95, color: .success)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Complete (100%)")
                        .font(.caption2)
                    ProgressBar(progress: 1.0, color: .success)
                }
            }
            .frame(width: 400)
        }
        .padding()
    }
    .frame(width: 500, height: 600)
}

#Preview("ProgressBar - Side by Side Themes") {
    HStack(spacing: 24) {
        ThemeProvider(theme: VibrantTheme()) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Vibrant Theme")
                    .font(.headline)
                
                ProgressBar(progress: 0.35, size: .small)
                ProgressBar(progress: 0.65, size: .medium, color: .success)
                ProgressBar(progress: 0.85, size: .large, color: .warning)
            }
            .padding()
            .frame(width: 350)
        }
        
        ThemeProvider(theme: NeutralTheme()) {
            VStack(alignment: .leading, spacing: 20) {
                Text("Neutral Theme")
                    .font(.headline)
                
                ProgressBar(progress: 0.35, size: .small)
                ProgressBar(progress: 0.65, size: .medium, color: .success)
                ProgressBar(progress: 0.85, size: .large, color: .warning)
            }
            .padding()
            .frame(width: 350)
        }
    }
    .padding()
    .frame(width: 800, height: 300)
}
