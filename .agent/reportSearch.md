PLANORA UI Notes For Flutter Refinement

Reference cues from the user's home screen:
- Background is not a generic gradient-only scaffold. It is a composed artwork with clouds already embedded in the scene.
- The bottom action bar is a rounded lavender capsule floating above the bottom edge.
- Each destination is inside a white circular or pill-shaped touch target.
- The active item is wider and includes both icon and label.
- The icon family is outline-based and visually soft, not heavy or filled.
- The bar uses five destinations: Home, Tasks, Calendar, Stats, Profile.

Practical repo decisions:
- Treat the background as an image-first asset, not a rebuilt decoration system.
- Keep the shell resilient by falling back to Flutter icons and gradients if assets are absent.
- Use a dedicated reusable nav widget instead of `BottomNavigationBar`.
- Prefer PNG exports for custom nav icons in this repo for the fastest drop-in workflow.

Exact asset locations:
- `assets/images/backgrounds/home_shell_bg.png`
- `assets/icons/nav/home.png`
- `assets/icons/nav/tasks.png`
- `assets/icons/nav/calendar.png`
- `assets/icons/nav/stats.png`
- `assets/icons/nav/profile.png`

Important constraint:
- UI refinement should not disturb state, sync, local database behavior, or navigation rules outside the shell styling itself.
