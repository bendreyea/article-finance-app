# DesignSystem Quick Start Guide

Get up and running with the DesignSystem module in 5 minutes.

## Step 1: Integrate into Your App (2 min)

Open your app's main entry point (e.g., `PersonalFinanceApp4App.swift`) and wrap your root view with `ThemeProvider`:

```swift
import SwiftUI

@main
struct PersonalFinanceApp4App: App {
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

## Step 2: Update Your ContentView (1 min)

Add the `@Environment` property to access the theme:

```swift
struct ContentView: View {
    @Environment(\.theme) private var theme
    
    var body: some View {
        VStack {
            Text("Hello, themed world!")
                .font(theme.typography.headingLarge)
                .foregroundColor(theme.colors.onBackground)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(theme.colors.background)
    }
}
```

## Step 3: Use the Card Component (1 min)

Replace your existing cards or containers:

```swift
Card {
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

## Step 4: View the Previews (1 min)

Open `DesignSystemPreviews.swift` in Xcode and check the Canvas to see:
- Side-by-side theme comparison
- Individual theme previews
- Component examples

## Step 5: Add Theme Switching (Optional)

Add a button to toggle between themes:

```swift
struct SettingsView: View {
    @Binding var currentTheme: AppTheme
    
    var body: some View {
        Button("Toggle Theme") {
            withAnimation {
                if currentTheme is VibrantTheme {
                    currentTheme = NeutralTheme()
                } else {
                    currentTheme = VibrantTheme()
                }
            }
        }
    }
}
```

## Common Patterns

### Creating a Themed Button

```swift
Button(action: { /* action */ }) {
    Text("Submit")
        .font(theme.typography.labelLarge)
        .foregroundColor(theme.colors.onPrimary)
        .padding(.horizontal, theme.spacing.lg)
        .padding(.vertical, theme.spacing.md)
        .background(theme.colors.primary)
        .cornerRadius(theme.radius.button)
}
```

### Creating a Themed Section Header

```swift
Text("Income Sources")
    .font(theme.typography.headingMedium)
    .foregroundColor(theme.colors.onBackground)
    .padding(.bottom, theme.spacing.sm)
```

### Creating a Status Badge

```swift
Text("Active")
    .font(theme.typography.labelSmall)
    .foregroundColor(theme.colors.success)
    .padding(.horizontal, theme.spacing.xs)
    .padding(.vertical, theme.spacing.xxs)
    .background(theme.colors.success.opacity(0.15))
    .cornerRadius(theme.radius.chip)
```

## Token Reference Cheatsheet

### Spacing (8pt grid)
- `xxxs` = 2pt, `xxs` = 4pt, `xs` = 8pt
- `sm` = 12pt, `md` = 16pt, `lg` = 24pt
- `xl` = 32pt, `xxl` = 48pt, `xxxl` = 64pt

### Typography Scale
- Display: Large (57pt), Medium (45pt), Small (36pt)
- Heading: Large (32pt), Medium (24pt), Small (20pt)
- Body: Large (16pt), Medium (14pt), Small (12pt)

### Semantic Colors
- `primary` / `secondary` - Main brand colors
- `success` / `warning` / `error` / `info` - Status colors
- `onSurface` / `onSurfaceSecondary` / `onSurfaceTertiary` - Text hierarchy

### Common Patterns
- Card padding: `theme.spacing.cardPadding`
- Section spacing: `theme.spacing.sectionSpacing`
- Card radius: `theme.radius.card`
- Button radius: `theme.radius.button`

## Troubleshooting

**Q: My view isn't picking up the theme**  
A: Make sure you have `@Environment(\.theme) private var theme` at the top of your view.

**Q: Can I use themes in non-View code?**  
A: No, themes are designed for SwiftUI views. For business logic, pass specific values as parameters.

**Q: How do I test both themes?**  
A: Use the preview helpers:
```swift
#Preview("Vibrant") {
    ThemeProvider.vibrant {
        MyView()
    }
}
```

**Q: Can I mix hardcoded values with themes?**  
A: Technically yes, but it's strongly discouraged. It breaks consistency and makes theme switching incomplete.

## Next Steps

1. Convert existing views to use theme tokens
2. Build custom themed components
3. Create a custom theme for your brand
4. Add theme persistence (UserDefaults)
5. Explore the full DesignSystem/README.md for advanced usage

---

Happy theming! 🎨
