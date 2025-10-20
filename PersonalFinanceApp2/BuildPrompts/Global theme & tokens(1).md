You are a senior macOS SwiftUI engineer. Generate a self‑contained DesignSystem module for a SwiftUI app with environment‑driven theming. Provide:

- AppTheme protocol and token structs (colors, spacing, radius, typography, shadow).
- Two concrete themes: VibrantTheme and NeutralTheme.
- ThemeProvider view and EnvironmentKey glue.
- A Card component that reads tokens from @Environment(\.theme) and NEVER hardcodes values.
- SwiftUI previews that show both themes side‑by‑side.