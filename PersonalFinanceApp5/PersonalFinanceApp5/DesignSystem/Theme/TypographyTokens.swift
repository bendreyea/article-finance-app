import SwiftUI

/// Typography token representing a complete text style
public struct TypographyToken {
    public let font: Font
    public let size: CGFloat
    public let weight: Font.Weight
    public let lineHeight: CGFloat
    public let letterSpacing: CGFloat
    
    public init(
        font: Font,
        size: CGFloat,
        weight: Font.Weight,
        lineHeight: CGFloat,
        letterSpacing: CGFloat = 0
    ) {
        self.font = font
        self.size = size
        self.weight = weight
        self.lineHeight = lineHeight
        self.letterSpacing = letterSpacing
    }
}

/// Typography tokens for consistent text styles
public struct TypographyTokens {
    // MARK: - Display
    public let displayLarge: TypographyToken
    public let displayMedium: TypographyToken
    public let displaySmall: TypographyToken
    
    // MARK: - Headline
    public let headlineLarge: TypographyToken
    public let headlineMedium: TypographyToken
    public let headlineSmall: TypographyToken
    
    // MARK: - Title
    public let titleLarge: TypographyToken
    public let titleMedium: TypographyToken
    public let titleSmall: TypographyToken
    
    // MARK: - Body
    public let bodyLarge: TypographyToken
    public let bodyMedium: TypographyToken
    public let bodySmall: TypographyToken
    
    // MARK: - Label
    public let labelLarge: TypographyToken
    public let labelMedium: TypographyToken
    public let labelSmall: TypographyToken
    
    public init(
        displayLarge: TypographyToken,
        displayMedium: TypographyToken,
        displaySmall: TypographyToken,
        headlineLarge: TypographyToken,
        headlineMedium: TypographyToken,
        headlineSmall: TypographyToken,
        titleLarge: TypographyToken,
        titleMedium: TypographyToken,
        titleSmall: TypographyToken,
        bodyLarge: TypographyToken,
        bodyMedium: TypographyToken,
        bodySmall: TypographyToken,
        labelLarge: TypographyToken,
        labelMedium: TypographyToken,
        labelSmall: TypographyToken
    ) {
        self.displayLarge = displayLarge
        self.displayMedium = displayMedium
        self.displaySmall = displaySmall
        self.headlineLarge = headlineLarge
        self.headlineMedium = headlineMedium
        self.headlineSmall = headlineSmall
        self.titleLarge = titleLarge
        self.titleMedium = titleMedium
        self.titleSmall = titleSmall
        self.bodyLarge = bodyLarge
        self.bodyMedium = bodyMedium
        self.bodySmall = bodySmall
        self.labelLarge = labelLarge
        self.labelMedium = labelMedium
        self.labelSmall = labelSmall
    }
}

// MARK: - Default Typography Scale
extension TypographyTokens {
    public static var defaultScale: TypographyTokens {
        TypographyTokens(
            displayLarge: TypographyToken(
                font: .system(size: 57, weight: .regular),
                size: 57,
                weight: .regular,
                lineHeight: 64
            ),
            displayMedium: TypographyToken(
                font: .system(size: 45, weight: .regular),
                size: 45,
                weight: .regular,
                lineHeight: 52
            ),
            displaySmall: TypographyToken(
                font: .system(size: 36, weight: .regular),
                size: 36,
                weight: .regular,
                lineHeight: 44
            ),
            headlineLarge: TypographyToken(
                font: .system(size: 32, weight: .semibold),
                size: 32,
                weight: .semibold,
                lineHeight: 40
            ),
            headlineMedium: TypographyToken(
                font: .system(size: 28, weight: .semibold),
                size: 28,
                weight: .semibold,
                lineHeight: 36
            ),
            headlineSmall: TypographyToken(
                font: .system(size: 24, weight: .semibold),
                size: 24,
                weight: .semibold,
                lineHeight: 32
            ),
            titleLarge: TypographyToken(
                font: .system(size: 22, weight: .medium),
                size: 22,
                weight: .medium,
                lineHeight: 28
            ),
            titleMedium: TypographyToken(
                font: .system(size: 16, weight: .medium),
                size: 16,
                weight: .medium,
                lineHeight: 24,
                letterSpacing: 0.15
            ),
            titleSmall: TypographyToken(
                font: .system(size: 14, weight: .medium),
                size: 14,
                weight: .medium,
                lineHeight: 20,
                letterSpacing: 0.1
            ),
            bodyLarge: TypographyToken(
                font: .system(size: 16, weight: .regular),
                size: 16,
                weight: .regular,
                lineHeight: 24,
                letterSpacing: 0.5
            ),
            bodyMedium: TypographyToken(
                font: .system(size: 14, weight: .regular),
                size: 14,
                weight: .regular,
                lineHeight: 20,
                letterSpacing: 0.25
            ),
            bodySmall: TypographyToken(
                font: .system(size: 12, weight: .regular),
                size: 12,
                weight: .regular,
                lineHeight: 16,
                letterSpacing: 0.4
            ),
            labelLarge: TypographyToken(
                font: .system(size: 14, weight: .medium),
                size: 14,
                weight: .medium,
                lineHeight: 20,
                letterSpacing: 0.1
            ),
            labelMedium: TypographyToken(
                font: .system(size: 12, weight: .medium),
                size: 12,
                weight: .medium,
                lineHeight: 16,
                letterSpacing: 0.5
            ),
            labelSmall: TypographyToken(
                font: .system(size: 11, weight: .medium),
                size: 11,
                weight: .medium,
                lineHeight: 16,
                letterSpacing: 0.5
            )
        )
    }
}
