# DesignSystem Architecture Diagram

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         YOUR APP                                 │
│                                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │              PersonalFinanceApp4App                     │    │
│  │  @State var currentTheme: AppTheme = VibrantTheme()    │    │
│  └────────────────────────────────────────────────────────┘    │
│                            │                                     │
│                            ▼                                     │
│  ┌────────────────────────────────────────────────────────┐    │
│  │          ThemeProvider(theme: currentTheme)            │    │
│  │                                                         │    │
│  │  • Injects theme into environment                      │    │
│  │  • Sets background color                               │    │
│  │  • Propagates to all descendants                       │    │
│  └────────────────────────────────────────────────────────┘    │
│                            │                                     │
│                            ▼                                     │
│  ┌────────────────────────────────────────────────────────┐    │
│  │         SwiftUI Environment System                      │    │
│  │         EnvironmentValues.theme                         │    │
│  └────────────────────────────────────────────────────────┘    │
│                            │                                     │
│           ┌────────────────┼────────────────┐                   │
│           ▼                ▼                ▼                   │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐           │
│  │   ViewA      │ │   ViewB      │ │   ViewC      │           │
│  │ @Environment │ │ @Environment │ │ @Environment │           │
│  │   (\.theme)  │ │   (\.theme)  │ │   (\.theme)  │           │
│  └──────────────┘ └──────────────┘ └──────────────┘           │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## Theme Protocol Structure

```
┌────────────────────────────────────────────────────┐
│              AppTheme (Protocol)                    │
│                                                     │
│  • name: String                                    │
│  • colors: ColorTokens                             │
│  • spacing: SpacingTokens                          │
│  • radius: RadiusTokens                            │
│  • typography: TypographyTokens                    │
│  • shadows: ShadowTokens                           │
└────────────────────────────────────────────────────┘
                    ▲              ▲
                    │              │
        ┌───────────┘              └───────────┐
        │                                      │
┌──────────────────┐                  ┌──────────────────┐
│  VibrantTheme    │                  │  NeutralTheme    │
│                  │                  │                  │
│ Dark backgrounds │                  │ Light backgrounds│
│ Bold purple/cyan │                  │ Slate blue/taupe │
│ High contrast    │                  │ Subtle contrast  │
│ Dramatic shadows │                  │ Gentle shadows   │
│ Rounded corners  │                  │ Clean corners    │
│ SF Rounded fonts │                  │ SF System fonts  │
└──────────────────┘                  └──────────────────┘
```

## Token System Hierarchy

```
┌─────────────────────────────────────────────────────────────┐
│                      Theme Tokens                            │
└─────────────────────────────────────────────────────────────┘
           │
           ├─► ColorTokens (23 colors)
           │   ├─ Primary: primary, primaryVariant, onPrimary
           │   ├─ Secondary: secondary, secondaryVariant, onSecondary
           │   ├─ Backgrounds: background, backgroundElevated, surface
           │   ├─ Content: onBackground, onSurface, onSurfaceSecondary
           │   ├─ Semantic: success, warning, error, info
           │   ├─ Borders: border, borderSubtle
           │   └─ Shadows: shadowLight, shadowMedium, shadowHeavy
           │
           ├─► SpacingTokens (15 values)
           │   ├─ Base Scale: xxxs (2) → xxxl (64)
           │   └─ Semantic: cardPadding, sectionSpacing, iconSize
           │
           ├─► RadiusTokens (12 values)
           │   ├─ Base Scale: none (0) → full (9999)
           │   └─ Semantic: card, button, input, chip
           │
           ├─► TypographyTokens (15+ styles)
           │   ├─ Display: large, medium, small
           │   ├─ Heading: large, medium, small
           │   ├─ Body: large, medium, small
           │   ├─ Label: large, medium, small
           │   └─ Special: caption, overline, mono
           │
           └─► ShadowTokens (11 shadows)
               ├─ Base Scale: none, xs, sm, md, lg, xl, xxl
               └─ Semantic: card, cardHover, modal, dropdown
```

## Component Token Flow

```
┌──────────────────────────────────────────────────────────┐
│                      Card Component                       │
└──────────────────────────────────────────────────────────┘
                           │
                           ▼
           ┌───────────────────────────────┐
           │  @Environment(\.theme) var theme  │
           └───────────────────────────────┘
                           │
           ┌───────────────┼───────────────┐
           │               │               │
           ▼               ▼               ▼
    ┌──────────┐    ┌──────────┐    ┌──────────┐
    │  Styling  │    │  Layout   │    │  Effects  │
    └──────────┘    └──────────┘    └──────────┘
         │               │               │
         ▼               ▼               ▼
    
    .background(        .padding(       .shadow(
      theme.colors       theme.spacing   color: theme.colors.shadowMedium,
        .surface)          .cardPadding)  radius: theme.shadows.card.radius,
                                          x: theme.shadows.card.x,
    .cornerRadius(                        y: theme.shadows.card.y)
      theme.radius
        .card)
    
    .overlay(
      RoundedRectangle()
        .strokeBorder(
          theme.colors.border,
          lineWidth: 1)
    )

    ✅ ZERO HARDCODED VALUES
```

## Theme Switching Flow

```
User Action (Button Click)
        │
        ▼
┌─────────────────────┐
│  Update @State var  │
│  currentTheme       │
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│  ThemeProvider      │
│  .environment(      │
│    \.theme,         │
│    currentTheme)    │
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│  Environment Update │
│  Propagates Down    │
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│  All @Environment   │
│  properties refresh │
└─────────────────────┘
        │
        ▼
┌─────────────────────┐
│  SwiftUI Re-renders │
│  with new theme     │
└─────────────────────┘
        │
        ▼
    ✅ Updated UI
```

## Data Flow Diagram

```
┌────────────────────────────────────────────────────────────┐
│                    Data Flow                                │
└────────────────────────────────────────────────────────────┘

App State                    Environment                  View
─────────                    ───────────                  ────

┌──────────┐                                          ┌─────────┐
│ @State   │                                          │ MyView  │
│ theme:   │                                          │         │
│ AppTheme │ ─────► ThemeProvider ─────► ┌──────┐ ──►│ Reads   │
│          │         (injects)            │ \.theme│   │ theme   │
└──────────┘                              └──────┘    │ tokens  │
     │                                                 └─────────┘
     │                                                      │
     │ User changes theme                                  │
     │                                                      │
     ▼                                                      ▼
┌──────────┐         Update triggers         ┌──────────────────┐
│ theme =  │ ────────────────────────────────►│ View re-renders  │
│ Neutral  │         re-injection             │ with new colors  │
│ Theme()  │                                  │ spacing, fonts   │
└──────────┘                                  └──────────────────┘
```

## Preview System

```
┌─────────────────────────────────────────────────────┐
│              Preview Configurations                  │
└─────────────────────────────────────────────────────┘
                        │
        ┌───────────────┼───────────────┐
        ▼               ▼               ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐
│ #Preview     │ │ #Preview     │ │ #Preview     │
│ "Vibrant"    │ │ "Neutral"    │ │ "Side by     │
│              │ │              │ │  Side"       │
└──────────────┘ └──────────────┘ └──────────────┘
       │                │                 │
       ▼                ▼                 ▼
ThemeProvider    ThemeProvider    DesignSystemPreviews
  .vibrant()       .neutral()      (comparison view)
       │                │                 │
       ▼                ▼                 ▼
   MyView()         MyView()        Both themes
                                    side-by-side
```

## File Dependencies

```
AppTheme.swift (Protocol)
    ▲
    │ implements
    ├─── VibrantTheme.swift ──┐
    │                          ├─── uses tokens ──┐
    └─── NeutralTheme.swift ──┘                   │
                                                   ▼
┌──────────────────────────────────────────────────────────┐
│                    Token Files                            │
│  • ColorTokens.swift                                     │
│  • SpacingTokens.swift                                   │
│  • RadiusTokens.swift                                    │
│  • TypographyTokens.swift                                │
│  • ShadowTokens.swift                                    │
└──────────────────────────────────────────────────────────┘
                    ▲
                    │ uses
                    │
┌─────────────────────────────────────┐
│ ThemeEnvironmentKey.swift            │
│  • Defines EnvironmentKey            │
│  • Extends EnvironmentValues         │
│  • Adds .withTheme() modifier        │
└─────────────────────────────────────┘
                    ▲
                    │ uses
                    │
┌─────────────────────────────────────┐
│ ThemeProvider.swift                  │
│  • Container view                    │
│  • Injects theme                     │
│  • Preview helpers                   │
└─────────────────────────────────────┘
                    ▲
                    │ uses
                    │
┌─────────────────────────────────────┐
│ Card.swift (Example Component)       │
│  • Reads from @Environment(\.theme)  │
│  • Zero hardcoded values             │
└─────────────────────────────────────┘
```

## Integration Points

```
Your macOS App
       │
       ├─► App Entry (@main)
       │       └─► ThemeProvider wrapper
       │
       ├─► ContentView
       │       └─► @Environment(\.theme)
       │
       ├─► Feature Modules
       │       ├─► Dashboard
       │       │     └─► Uses theme.colors, theme.spacing
       │       ├─► IncomeExpenses
       │       │     └─► Uses theme.typography, theme.radius
       │       └─► AssetsGoals
       │             └─► Uses theme.shadows, theme.colors
       │
       └─► Shared Components
               ├─► Card (from DesignSystem)
               ├─► DonutGauge (custom, themed)
               ├─► LineChart (custom, themed)
               └─► TransactionRow (custom, themed)
```

---

**Legend**:
- `┌─┐ └─┘` = Container/Module
- `─►` = Data flow / Dependency
- `▲ ▼` = Hierarchy / Inheritance
- `│ ├ └` = Tree structure
