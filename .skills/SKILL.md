---
name: planora-flutter-ui
description: Use when refining PLANORA's Flutter UI, especially the home shell, custom backgrounds, bottom action bar, typography, motion, spacing, and mobile visual polish.
---

# PLANORA Flutter UI Skill

Use this skill when the task is about improving the visual design of this repo without rewriting its product architecture.

## Scope

This skill is for:
- home screen polish
- custom background integration
- bottom navigation or action bar refinement
- typography, spacing, and surface cleanup
- Flutter-native motion and transitions
- extending the repo's visual language across Flutter screens

This skill is not for:
- backend changes
- sync protocol changes
- data model redesign
- large navigation rewrites unless the UI explicitly requires them

## Start Here

Always read:
- `.agent/prompt.md`
- `.agent/reportSearch.md`

Then inspect the current implementation in:
- `lib/theme/tokens.dart`
- `lib/core/widgets/gradient_scaffold.dart`
- `lib/core/widgets/planora_bottom_action_bar.dart`
- `lib/router/router.dart`
- `lib/features/home/home_screen.dart`

## Repo-Specific Rules

- Preserve Riverpod, Drift, and GoRouter behavior.
- Default to asset-driven visuals when the user provides art.
- Do not recreate a custom background if the user already has one.
- Use a graceful fallback when image assets are missing.
- Keep the shell mobile-first and visually quiet.
- Replace generic Material navigation patterns with reusable custom widgets when they are central to the brand feel.
- Translate web-style design advice into Flutter primitives, not HTML/CSS habits.
- If typography is redesigned, centralize it in `lib/theme/tokens.dart`.
- Do not default to bland Material typography just because it is already there.
- Avoid generic AI-looking dashboards and card grids.

## Asset Contract

Use these paths:
- `assets/images/backgrounds/home_shell_bg.png`
- `assets/icons/nav/home.png`
- `assets/icons/nav/tasks.png`
- `assets/icons/nav/calendar.png`
- `assets/icons/nav/stats.png`
- `assets/icons/nav/profile.png`

Assume the user may replace these files directly.

## Visual Standard

- One strong atmospheric background
- Minimal chrome
- Lavender used intentionally, not everywhere
- White interactive surfaces over deep blue backgrounds
- Soft outline iconography
- Pill-shaped active navigation treatment
- Strong spacing and calm vertical rhythm
- One dominant visual idea per screen
- Motion used sparingly but noticeably
- A custom mobile feel, not a stock Flutter demo feel

## Flutter Translation Rules

- Replace web notions like CSS variables with shared constants, `ThemeData`, and reusable theme tokens.
- Prefer `Stack`, `Positioned`, `DecoratedBox`, gradients, assets, and subtle overlays for atmosphere.
- Prefer `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSlide`, `TweenAnimationBuilder`, and selective controller-based motion for polish.
- Avoid adding dependencies for styling unless the repo truly needs them.
- Keep durations restrained and touch-friendly.

## Working Method

Before editing, define:
- visual thesis
- file targets
- fallback behavior when assets are absent

When implementing:
- change the shell first
- then refine the home screen
- then extend the language carefully to other screens if needed

Before finishing:
- run `dart format`
- run `flutter analyze`
- document where the user should place their own assets
