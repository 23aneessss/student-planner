PLANORA Flutter UI Enhancement Prompt

You are working inside the PLANORA repository, a Flutter and Dart mobile app for student planning. Your job is to improve the UI and interface quality of this app without damaging its architecture, state management, routing, persistence, or runtime stability.

This is not a web project. Do not think in HTML, CSS, Tailwind, React, or generic SaaS landing-page patterns. Think in Flutter widgets, ThemeData, layout systems, animation primitives, and reusable mobile components.

Core repo context:
- Stack: Flutter, Dart, Riverpod, Drift, GoRouter, Google Fonts
- Product: mobile-first student planner with home, tasks, calendar, Pomodoro, stats, grades, and profile flows
- Design priority: the app should feel intentional, premium, calm, and custom on mobile
- Constraint: keep the app production-safe, compilable, and coherent with the existing product

Non-negotiable engineering constraints:
- Do not break Riverpod providers, Drift database behavior, GoRouter navigation, or compile-time config
- Do not replace stable architecture just to achieve a visual effect
- Prefer reusable widgets and theme tokens over one-off styling
- Preserve safe areas, keyboard behavior, scrolling, and tap target quality
- Any visual enhancement must still pass `flutter analyze`

Primary files to inspect first:
- `lib/theme/tokens.dart`
- `lib/core/widgets/gradient_scaffold.dart`
- `lib/core/widgets/planora_bottom_action_bar.dart`
- `lib/router/router.dart`
- `lib/features/home/home_screen.dart`
- other `lib/features/**` screens only when extending the design language consistently

Repo-specific asset contract:
- Home background art: `assets/images/backgrounds/home_shell_bg.png`
- Bottom bar icons:
  - `assets/icons/nav/home.png`
  - `assets/icons/nav/tasks.png`
  - `assets/icons/nav/calendar.png`
  - `assets/icons/nav/stats.png`
  - `assets/icons/nav/profile.png`
- If custom assets are missing, keep graceful fallbacks so the app still runs

The user's visual reference is the source of truth:
- a deep blue atmospheric background with embedded cloud art
- a floating lavender bottom action bar
- white inner circular or pill-shaped nav buttons
- a selected destination that expands to show icon + label
- soft outline-style icons

Do not procedurally recreate custom art if the user already has a background image. Use the asset directly.

Flutter-specific translation of the design brief:

Typography:
- Avoid generic defaults such as Inter, Roboto, Arial, or system-looking Material typography when doing a meaningful redesign
- Use the existing `google_fonts` dependency to choose a deliberate, characterful font pairing suited to a student planner
- Use at most two font families: one for display or headings, one for UI/body if needed
- Prioritize legibility on mobile, but do not flatten the interface into bland utility typography
- If typography changes, centralize them in `lib/theme/tokens.dart`

Color and theme:
- Do not drift into generic AI gradients or random colorful surfaces
- PLANORA already has a strong twilight palette direction; refine it instead of replacing it with an unrelated aesthetic
- Keep one dominant atmosphere and a controlled accent system
- In Flutter, use shared tokens, `ThemeData`, and helper constants instead of web concepts like CSS variables
- Add new tokens only when they improve consistency across screens

Motion:
- Avoid noisy micro-interaction spam
- Use Flutter-native motion patterns such as `AnimatedContainer`, `AnimatedOpacity`, `AnimatedSlide`, `TweenAnimationBuilder`, `Hero`, or a single `AnimationController` when needed
- Prioritize 1-2 high-impact moments:
  - a clean page-load reveal
  - a polished nav-state transition
  - a subtle section entrance or state change
- Motion should reinforce hierarchy, presence, and touch response
- Keep durations restrained, usually around 180ms to 320ms
- No gimmicky bounce unless it clearly fits the screen

Backgrounds and atmosphere:
- Avoid flat filler backgrounds
- Use layered Flutter composition: `Stack`, `Positioned`, `DecoratedBox`, gradient layers, image assets, soft overlays, and selective blur when justified
- On the home shell, the user background image should lead the scene
- On other screens, preserve the same world and tone without copying the home screen blindly
- Do not cover good background art with unnecessary opaque cards or heavy chrome

Navigation and shell:
- Do not revert to a stock `BottomNavigationBar` look
- Use or refine `lib/core/widgets/planora_bottom_action_bar.dart`
- The bottom action bar should feel like a designed object, not a default component
- Match the user's icon family and proportions as closely as the provided assets allow
- Keep navigation calm, readable, and thumb-friendly

Layout and composition:
- Avoid dashboard-card mosaics unless the screen truly needs card separation
- Prefer one dominant visual idea per screen
- Let spacing, scale, silhouette, and rhythm carry the design before adding more UI devices
- Keep the home screen atmospheric first, productive second
- Preserve breathing room near the top and around primary content
- Use cards only when they clarify interaction or grouping

Avoid these failure modes:
- generic mobile SaaS UI
- default Material 3 look with minor color changes
- random gradients with no art direction
- too many pills, chips, and boxed sections competing for attention
- overuse of white cards that erase the mood of the screen
- typography that feels copied from any modern startup template
- animation everywhere but no visual thesis

Working method for this repo:
1. Define a visual thesis in one sentence before editing
2. Name the exact files to change
3. Reuse existing architecture and widgets where possible
4. Implement the shell first, then the home screen, then propagate carefully
5. Keep fallbacks for missing assets
6. Verify with `dart format` and `flutter analyze`

Definition of done:
- The UI feels designed for PLANORA specifically, not generated from a generic template
- The home shell respects the user's background art and custom iconography
- The bottom action bar feels much closer to the user's reference
- The design language can extend to the rest of the app without fighting the codebase
- The repo remains stable and analyzable
