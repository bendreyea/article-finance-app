# DesignSystem Module

A self-contained, environment-driven theming system for SwiftUI macOS applications. This module provides a complete design foundation with zero hardcoded values in components.

## Architecture

```
DesignSystem/
├── Tokens/              # Design token definitions
│   ├── AppTheme.swift   # Theme protocol
│   ├── ColorTokens.swift
│   ├── SpacingTokens.swift
│   ├── RadiusTokens.swift
│   ├── TypographyTokens.swift
│   └── ShadowTokens.swift
├── Themes/              # Concrete theme implementations
│   ├── VibrantTheme.swift
│   └── NeutralTheme.swift
├── Components/          # Themed UI components
│   ├── Card.swift
│   ├── CardPreview.swift
│   └── FinanceDashboardExample.swift
└── ThemeProvider.swift  # Environment injection
```

## Features

✅ **100% Environment-Driven**: All styling comes from `@Environment(\.theme)`  
✅ **Zero Hardcoded Values**: Components never hardcode colors, spacing, or typography  
✅ **Type-Safe Tokens**: Compile-time safety for all design decisions  
✅ **Hot-Swappable Themes**: Change themes at runtime without rebuilding  
✅ **Preview Support**: Side-by-side theme comparisons in Xcode previews  
✅ **Comprehensive Tokens**: Colors, spacing, radius, typography, shadows  

## Quick Start

### 1. Apply a Theme to Your App

```swift
import SwiftUI

@main
struct PersonalFinanceApp3App: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .themed(VibrantTheme()) // or NeutralTheme()
        }
    }
}
```

### 2. Build Theme-Aware Components

```swift
import SwiftUI

struct MyView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.lg) {
            Text("Hello World")
                .font(theme.typography.headingLarge)
                .foregroundColor(theme.colors.textPrimary)
            
            Card(style: .elevated) {
                Text("Card content")
                    .foregroundColor(theme.colors.textSecondary)
            }
        }
        .padding(theme.spacing.xl)
        .background(theme.colors.background)
    }
}
```

### 3. Use the Card Component

```swift
// Elevated card with shadow
Card(style: .elevated) {
    VStack {
        Text("Title")
        Text("Content")
    }
}

// Outlined card with border
Card(style: .outlined, padding: .large) {
    Text("Outlined content")
}

// Convenience initializers
Card.elevated {
    Text("Quick elevated card")
}
```

## Available Themes

### VibrantTheme
- Bold, high-contrast colors
- Bright accent colors (blue, purple)
- Stronger shadows
- Larger corner radii
- Modern, energetic feel

### NeutralTheme
- Subtle, muted colors
- Refined blue-gray accents
- Softer shadows
- Conservative corner radii
- Professional, elegant feel

## Design Tokens

### ColorTokens
```swift
theme.colors.background          // Primary background
theme.colors.surface             // Card/surface backgrounds
theme.colors.textPrimary         // Main text color
theme.colors.accentPrimary       // Primary accent
theme.colors.success             // Success state
theme.colors.chartPrimary        // Chart color palette
// ... and many more
```

### SpacingTokens
```swift
theme.spacing.xxs   // 2pt
theme.spacing.xs    // 4pt
theme.spacing.sm    // 8pt
theme.spacing.md    // 12pt
theme.spacing.lg    // 16pt
theme.spacing.xl    // 24pt
theme.spacing.xxl   // 32pt
theme.spacing.xxxl  // 48pt
```

### RadiusTokens
```swift
theme.radius.none   // 0pt
theme.radius.sm     // 4-6pt
theme.radius.md     // 8-10pt
theme.radius.lg     // 12-14pt
theme.radius.xl     // 16-18pt
theme.radius.full   // 9999pt (pill)
```

### TypographyTokens
```swift
theme.typography.displayLarge    // 48pt bold
theme.typography.headingMedium   // 20pt semibold
theme.typography.bodyMedium      // 14pt regular
theme.typography.labelSmall      // 10pt medium
theme.typography.monoMedium      // 14pt monospace
// ... and more
```

### ShadowTokens
```swift
theme.shadow.none   // No shadow
theme.shadow.sm     // Subtle shadow
theme.shadow.md     // Medium shadow
theme.shadow.lg     // Large shadow
theme.shadow.xl     // Extra large shadow
```

## Creating Custom Themes

Implement the `AppTheme` protocol:

```swift
public struct MyCustomTheme: AppTheme {
    public let name = "Custom"
    
    public let colors = ColorTokens(
        background: .white,
        // ... define all required colors
    )
    
    public let spacing = SpacingTokens()
    public let radius = RadiusTokens(md: 10, lg: 15)
    public let typography = TypographyTokens()
    public let shadow = ShadowTokens()
    
    public init() {}
}
```

## Component Guidelines

### ❌ Never Do This
```swift
// WRONG: Hardcoded values
Text("Title")
    .font(.system(size: 18))
    .foregroundColor(.blue)
    .padding(16)
```

### ✅ Always Do This
```swift
// CORRECT: Theme-driven values
@Environment(\.theme) private var theme

Text("Title")
    .font(theme.typography.headingMedium)
    .foregroundColor(theme.colors.textPrimary)
    .padding(theme.spacing.lg)
```

## Previews

All components include comprehensive SwiftUI previews:

```swift
#Preview("Side-by-Side") {
    HStack {
        MyView().themed(VibrantTheme())
        MyView().themed(NeutralTheme())
    }
}

#Preview("Vibrant Only") {
    MyView().themed(VibrantTheme())
}
```

## Testing

```swift
func testComponentWithTheme() {
    let view = MyView()
        .themed(VibrantTheme())
    
    // Test with VibrantTheme
    // ...
    
    let neutralView = MyView()
        .themed(NeutralTheme())
    
    // Test with NeutralTheme
    // ...
}
```

## Best Practices

1. **Always use `@Environment(\.theme)`** in custom views
2. **Never hardcode** color, spacing, font, or shadow values
3. **Use semantic color names** (e.g., `textPrimary` not `gray900`)
4. **Leverage token scales** (e.g., `spacing.md`, not arbitrary values)
5. **Create reusable components** that consume theme tokens
6. **Test with multiple themes** to ensure flexibility
7. **Document custom theme requirements** if extending the system

## Integration with Existing Code

To migrate existing views:

1. Add `@Environment(\.theme) private var theme`
2. Replace hardcoded values with theme tokens
3. Test with both themes to verify appearance
4. Add previews showing both themes

## License

Part of the PersonalFinanceApp3 project.
