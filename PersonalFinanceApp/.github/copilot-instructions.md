---
applyTo: "**/*.swift"
---

# Project Overview

This project is a modern macOS desktop application for comprehensive personal finance management, featuring transaction tracking, expense analysis, asset management, and financial goal setting.

Core features:

- Net worth overview (donut gauge) + available balance and income/expenses line chart.
- Sidebar navigation: Dashboard, Income & Expenses, Assets & Goals.
- Cards for income sources, spending categories, notifications, and goals.
- Assets pie chart + table; goals list with progress.
- Transactions table with filters (category/date/status) and import (CSV/OFX/QIF).

## Architecture

Architecture

Pattern: MVVM with a light Coordinator/Router (NavigationSplitView) or TCA if preferred.

Modules (targets or groups):

- AppShell (entry, routing, theme provider)
- DesignSystem (tokens, primitives, icons)
- Features/Dashboard
- Features/IncomeExpenses
- Features/AssetsGoals
- DataKit (SwiftData models, importing, persistence)

## Libraries and Frameworks

- macOS 14+ (Sonoma) using SwiftUI + SwiftData; 
- charts via Swift Charts.

## Coding Standards

- Follow the Swift API Design Guidelines.
- Use meaningful names for variables, functions, and types.
- Write unit tests for all new features and bug fixes.
- Document public APIs using Swift's documentation comments.