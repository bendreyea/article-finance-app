# DesignSystem Module

A self-contained, environment-driven theming system for SwiftUI applications. This module provides a complete design token system with zero hardcoded values.

## Overview

The DesignSystem module implements a comprehensive theming architecture based on:

- **Token-based design**: All visual properties defined through structured tokens
- **Environment-driven**: Themes injected via SwiftUI's environment system
- **Zero hardcoding**: Components read ALL styling from `@Environment(\.theme)`
- **Type-safe**: Protocol-based approach ensures consistency

## Architecture

```
DesignSystem/
├── AppTheme.swift              # Main protocol
├── ThemeProvider.swift         # Environment container
├── ThemeEnvironmentKey.swift   # Environment key infrastructure
├── Tokens/
│   ├── ColorTokens.swift       # Color palette
│   ├── SpacingTokens.swift     # Layout spacing
│   ├── RadiusTokens.swift      # Corner radius
│   ├── TypographyTokens.swift  # Text styles
│   └── ShadowTokens.swift      # Elevation shadows
├── Themes/
│   ├── VibrantTheme.swift      # Bold, colorful theme
│   └── NeutralTheme.swift      # Subtle, professional theme
├── Components/
│   └── Card.swift              # Example themed component
└── DesignSystemPreviews.swift  # Comprehensive previews
```

## Token Categories

### ColorTokens
Comprehensive color palette with semantic naming:
- Primary/Secondary colors with variants
- Background and surface colors
- Content colors (on-surface, secondary, tertiary)
- Semantic colors (success, warning, error, info)
- Border colors
- Shadow colors

### SpacingTokens
8pt grid system with semantic helpers:
- Base scale: xxxs (2pt) → xxxl (64pt)
- Semantic: cardPadding, sectionSpacing, componentSpacing
- Icon sizes: small, regular, large

### RadiusTokens
Border radius scale:
- Base scale: none (0) → full (9999)
- Semantic: card, button, input, chip

### TypographyTokens
Complete type scale:
- Display styles (large, medium, small)
- Heading styles (large, medium, small)
- Body styles (large, medium, small)
- Label styles (large, medium, small)
- Special: caption, overline, mono
- Line heights and font weights

### ShadowTokens
Elevation system:
- Base scale: none → xxl
- Semantic: card, cardHover, modal, dropdown
- Each shadow includes: radius, x, y, opacity

## Usage

### 1. Setup ThemeProvider at App Root

```swift
@main
struct PersonalFinanceApp: App {
    @State private var currentTheme: AppTheme = VibrantTheme()
    
    var body: some Scene {
        WindowGroup {
            ThemeProvider(theme: currentTheme) {
                ContentView()
            }
        }
    }
}
```

### 2. Access Theme in Views

```swift
struct MyView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            Text("Hello")
                .font(theme.typography.headingLarge)
                .foregroundColor(theme.colors.onSurface)
        }
        .padding(theme.spacing.cardPadding)
        .background(theme.colors.surface)
        .cornerRadius(theme.radius.card)
    }
}
```

### 3. Use Themed Components

```swift
Card(elevation: .medium, padding: .standard) {
    VStack(alignment: .leading, spacing: 12) {
        Text("Balance")
            .font(theme.typography.labelMedium)
            .foregroundColor(theme.colors.onSurfaceSecondary)
        
        Text("$12,345.67")
            .font(theme.typography.headingLarge)
            .foregroundColor(theme.colors.onSurface)
    }
}
```

### 4. Create Custom Themed Components

```swift
struct CustomButton: View {
    @Environment(\.theme) private var theme
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(theme.typography.labelLarge)
                .foregroundColor(theme.colors.onPrimary)
                .padding(.horizontal, theme.spacing.lg)
                .padding(.vertical, theme.spacing.md)
                .background(theme.colors.primary)
                .cornerRadius(theme.radius.button)
        }
        .buttonStyle(.plain)
    }
}
```

## Available Themes

### VibrantTheme
Bold, energetic design with:
- Deep dark backgrounds
- Vibrant purple and cyan accents
- High contrast text
- Dramatic shadows
- Rounded corners
- Modern typography with SF Rounded

### NeutralTheme
Professional, subtle design with:
- Light, airy backgrounds
- Refined slate blue and taupe accents
- Comfortable reading contrast
- Gentle shadows
- Subtle corners
- Classic typography

## Theme Switching

```swift
struct SettingsView: View {
    @State private var selectedTheme: ThemeSelection = .vibrant
    
    enum ThemeSelection {
        case vibrant, neutral
    }
    
    var currentTheme: AppTheme {
        switch selectedTheme {
        case .vibrant: return VibrantTheme()
        case .neutral: return NeutralTheme()
        }
    }
    
    var body: some View {
        ThemeProvider(theme: currentTheme) {
            // Your content here
        }
    }
}
```

## Creating New Themes

Implement the `AppTheme` protocol:

```swift
public struct MyCustomTheme: AppTheme {
    public let name = "Custom"
    
    public let colors: ColorTokens
    public let spacing: SpacingTokens
    public let radius: RadiusTokens
    public let typography: TypographyTokens
    public let shadows: ShadowTokens
    
    public init() {
        self.colors = ColorTokens(
            // Define all color tokens...
        )
        // Define other tokens...
    }
}
```

## Best Practices

### ✅ DO
- Always read styling from `@Environment(\.theme)`
- Use semantic token names (e.g., `cardPadding`, not `lg`)
- Create reusable themed components
- Use `ThemeProvider` at the app root
- Test components with both themes

### ❌ DON'T
- Hardcode colors, spacing, or other values
- Use magic numbers
- Override theme values arbitrarily
- Access tokens without Environment
- Mix hardcoded and themed styling

## Previews

The module includes comprehensive previews:

```swift
#Preview("Vibrant Theme") {
    ThemeProvider.vibrant {
        MyView()
    }
}

#Preview("Neutral Theme") {
    ThemeProvider.neutral {
        MyView()
    }
}

#Preview("Side by Side") {
    DesignSystemPreviews()
}
```

## Integration with Project

This DesignSystem integrates with the PersonalFinanceApp4 architecture:

1. **AppShell**: Use `ThemeProvider` in the main app entry point
2. **Features**: All feature modules access theme via environment
3. **Components**: Build reusable components that read from theme
4. **DataKit**: Use theme colors for data visualization (charts, gauges)

## Extensions

The system is designed for easy extension:

- Add new token types (e.g., AnimationTokens)
- Create new themes by implementing AppTheme
- Build new themed components in Components/
- Add theme-specific assets or resources

## Performance

- Themes are value types (structs) for efficiency
- Environment access is optimized by SwiftUI
- No runtime overhead from token lookups
- Preview helpers enable fast iteration

## Testing

Test components with different themes:

```swift
func testComponentWithVibrantTheme() {
    let theme = VibrantTheme()
    let view = MyView()
        .withTheme(theme)
    // Assert appearance...
}
```

---

**Version**: 1.0.0  
**Created**: October 17, 2025  
**Platform**: macOS 14+ (Sonoma)  
**Framework**: SwiftUI
