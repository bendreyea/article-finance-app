import SwiftUI

/// Design system typography tokens
public struct TypographyTokens {
    // MARK: - Display
    public let displayLarge: Font
    public let displayMedium: Font
    public let displaySmall: Font
    
    // MARK: - Headings
    public let headingLarge: Font
    public let headingMedium: Font
    public let headingSmall: Font
    
    // MARK: - Body
    public let bodyLarge: Font
    public let bodyMedium: Font
    public let bodySmall: Font
    
    // MARK: - Labels
    public let labelLarge: Font
    public let labelMedium: Font
    public let labelSmall: Font
    
    // MARK: - Monospace
    public let monoMedium: Font
    public let monoSmall: Font
    
    public init(
        displayLarge: Font = .system(size: 48, weight: .bold),
        displayMedium: Font = .system(size: 36, weight: .bold),
        displaySmall: Font = .system(size: 28, weight: .semibold),
        headingLarge: Font = .system(size: 24, weight: .semibold),
        headingMedium: Font = .system(size: 20, weight: .semibold),
        headingSmall: Font = .system(size: 16, weight: .semibold),
        bodyLarge: Font = .system(size: 16, weight: .regular),
        bodyMedium: Font = .system(size: 14, weight: .regular),
        bodySmall: Font = .system(size: 12, weight: .regular),
        labelLarge: Font = .system(size: 14, weight: .medium),
        labelMedium: Font = .system(size: 12, weight: .medium),
        labelSmall: Font = .system(size: 10, weight: .medium),
        monoMedium: Font = .system(size: 14, design: .monospaced),
        monoSmall: Font = .system(size: 12, design: .monospaced)
    ) {
        self.displayLarge = displayLarge
        self.displayMedium = displayMedium
        self.displaySmall = displaySmall
        self.headingLarge = headingLarge
        self.headingMedium = headingMedium
        self.headingSmall = headingSmall
        self.bodyLarge = bodyLarge
        self.bodyMedium = bodyMedium
        self.bodySmall = bodySmall
        self.labelLarge = labelLarge
        self.labelMedium = labelMedium
        self.labelSmall = labelSmall
        self.monoMedium = monoMedium
        self.monoSmall = monoSmall
    }
}
