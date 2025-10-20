# DesignSystem Module

A self-contained, environment-driven theming system for SwiftUI macOS applications.

## 📁 Module Structure

```
DesignSystem/
├── Theme/                    # Core theme definitions
│   ├── AppTheme.swift       # Protocol defining theme interface
│   ├── ColorTokens.swift    # Color palette tokens
│   ├── SpacingTokens.swift  # Spacing scale tokens
│   ├── RadiusTokens.swift   # Border radius tokens
│   ├── TypographyTokens.swift # Typography scale tokens
│   └── ShadowTokens.swift   # Shadow elevation tokens
├── Themes/                   # Concrete theme implementations
│   ├── VibrantTheme.swift   # Bold, energetic theme
│   └── NeutralTheme.swift   # Subtle, professional theme
├── Environment/              # SwiftUI environment integration
│   └── ThemeEnvironment.swift # ThemeProvider & EnvironmentKey
├── Components/               # Themed UI components
│   └── Card.swift           # Card component with theme support
└── Previews/                 # SwiftUI previews
    ├── ThemeShowcase.swift  # Comprehensive theme comparison
    └── CardPreview.swift    # Card component demonstrations
```

## 🎨 Features

- **Protocol-Based Theming**: `AppTheme` protocol ensures consistency across all themes
- **Token System**: Organized tokens for colors, spacing, radius, typography, and shadows
- **Environment-Driven**: Uses SwiftUI's environment to inject themes throughout the view hierarchy
- **No Hardcoded Values**: All components read from `@Environment(\.theme)` 
- **Two Complete Themes**: Vibrant and Neutral themes ready to use
- **Reusable Components**: Card component demonstrates proper theme integration
- **Comprehensive Previews**: Side-by-side theme comparisons

## 🚀 Quick Start

### 1. Apply Theme to Your App

```swift
import SwiftUI

@main
struct YourApp: App {
    var body: some Scene {
        WindowGroup {
            ThemeProvider(theme: VibrantTheme()) {
                ContentView()
            }
        }
    }
}
```

### 2. Access Theme in Views

```swift
import SwiftUI

struct MyView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack(spacing: theme.spacing.md) {
            Text("Hello World")
                .font(theme.typography.headlineLarge.font)
                .foregroundColor(theme.colors.textPrimary)
        }
        .padding(theme.spacing.lg)
        .background(theme.colors.surface)
        .cornerRadius(theme.radius.md)
        .shadow(
            color: theme.shadows.md.color,
            radius: theme.shadows.md.radius,
            x: theme.shadows.md.x,
            y: theme.shadows.md.y
        )
    }
}
```

### 3. Use Themed Components

```swift
import SwiftUI

struct DashboardView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        Card(padding: .lg, shadow: .md, hasBorder: true) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                Text("Net Worth")
                    .font(theme.typography.titleMedium.font)
                    .foregroundColor(theme.colors.textSecondary)
                
                Text("$45,678.90")
                    .font(theme.typography.displaySmall.font)
                    .foregroundColor(theme.colors.primary)
            }
        }
    }
}
```

## 🎭 Available Themes

### VibrantTheme
- Bold, energetic colors with electric blue primary
- Prominent shadows for depth
- Moderate corner radius (6-18pt)
- Perfect for modern, engaging interfaces

### NeutralTheme
- Subtle, professional colors with slate blue primary
- Soft shadows for elegance
- Gentle corner radius (4-12pt)
- Ideal for conservative, business applications

## 🧩 Token Categories

### Colors
- **Primary**: Main brand colors with hover/active states
- **Backgrounds**: Page and section backgrounds (3 levels)
- **Surfaces**: Card and elevated surfaces with hover state
- **Text**: Primary, secondary, tertiary, and inverse text
- **Borders**: Standard, focus, and subtle borders
- **Semantic**: Success, warning, error, info (with backgrounds)
- **Charts**: 5 distinct colors for data visualization

### Spacing
- Scale: 2, 4, 8, 12, 16, 24, 32, 48, 64pt
- Tokens: xxxs, xxs, xs, sm, md, lg, xl, xxl, xxxl

### Radius
- Scale: 0, 4-18pt, full (9999pt)
- Tokens: none, sm, md, lg, xl, full

### Typography
- **Display**: 36-57pt (large headings)
- **Headline**: 24-32pt (section headers)
- **Title**: 14-22pt (subsections)
- **Body**: 12-16pt (content text)
- **Label**: 11-14pt (UI labels)

### Shadows
- 5 elevation levels: none, sm, md, lg, xl
- Each includes color, radius, and offset

## 🏗️ Creating Custom Themes

```swift
import SwiftUI

struct MyCustomTheme: AppTheme {
    let name = "Custom"
    
    let colors = ColorTokens(
        primary: Color(red: 0.2, green: 0.5, blue: 0.8),
        // ... configure all color tokens
    )
    
    let spacing = SpacingTokens()
    let radius = RadiusTokens()
    let typography = TypographyTokens.defaultScale
    
    let shadows = ShadowTokens(
        none: ShadowToken(color: .clear, radius: 0),
        // ... configure all shadow tokens
    )
}
```

## 🔄 Switching Themes at Runtime

```swift
struct SettingsView: View {
    @State private var currentTheme: AppTheme = VibrantTheme()
    
    var body: some View {
        ThemeProvider(theme: currentTheme) {
            VStack {
                Text("Theme Settings")
                
                Button("Vibrant") {
                    currentTheme = VibrantTheme()
                }
                
                Button("Neutral") {
                    currentTheme = NeutralTheme()
                }
            }
        }
    }
}
```

## 🎨 Component Guidelines

When creating themed components:

1. **Always use `@Environment(\.theme)`** - Never hardcode values
2. **Read tokens from theme** - Use `theme.colors.primary`, not `Color.blue`
3. **Support hover states** - Use `theme.colors.surfaceHover` for interactions
4. **Apply semantic colors** - Use `theme.colors.success` for positive states
5. **Follow spacing scale** - Use `theme.spacing.md` for consistent layout
6. **Use shadow tokens** - Apply `theme.shadows.md` for elevation

## 📸 Previews

The module includes comprehensive previews:

- **ThemeShowcase**: Side-by-side comparison of all theme features
- **CardPreview**: Financial app card examples with both themes

Open these files in Xcode to see live previews with both themes.

## 🧪 Testing

To verify theme integration:

1. Open `ThemeShowcase.swift` in Xcode
2. Enable Canvas preview
3. Compare Vibrant and Neutral themes side-by-side
4. Test hover states by interacting with cards

## 📝 Best Practices

- **Consistency**: Always use tokens instead of raw values
- **Semantic Naming**: Choose appropriate token names (`primary`, not `blue`)
- **Accessibility**: Ensure sufficient color contrast for text
- **Performance**: Themes are lightweight structs—no performance concerns
- **Reusability**: Create components that work with any theme

## 🔮 Extending the System

### Adding New Token Categories

```swift
public struct AnimationTokens {
    public let fast: Double
    public let normal: Double
    public let slow: Double
}

// Add to AppTheme protocol
public protocol AppTheme {
    var animations: AnimationTokens { get }
    // ... existing properties
}
```

### Creating New Components

```swift
struct Button: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        Text("Button")
            .padding(theme.spacing.md)
            .background(theme.colors.primary)
            .cornerRadius(theme.radius.md)
    }
}
```

## 📦 Integration

This module is designed to be self-contained. Simply:

1. Copy the `DesignSystem/` folder to your project
2. Add files to your Xcode project
3. Import and use in your app

## 🤝 Contributing

When adding new features:

- Maintain protocol conformance for all themes
- Update previews to showcase new features
- Follow Swift API Design Guidelines
- Document public APIs with clear comments

---

**Version**: 1.0.0  
**Platform**: macOS 14+ (Sonoma)  
**Framework**: SwiftUI  
**License**: MIT
