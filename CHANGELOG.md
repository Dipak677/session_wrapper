## [0.0.1] - 2025-04-10

### Added
- A complete session timeout mechanism using `SessionController` and `SessionWrapper`.
- `SessionController`:
  - Manages session state.
  - Triggers a callback (`onSessionExpired`) when the session times out.
- `SessionWrapper`:
  - Wraps around any widget to detect user interaction and reset the session timer.
  - Uses `Listener` and a periodic timer for session ticking.

### UI Example
- Added `SessionWrapperExample`:
  - Demonstrates session timeout reset with a tap on the screen.
  - Changes background color on interaction.
  - Displays a dialog on session expiration using a `GlobalKey<NavigatorState>`.

### Changed
- Main function updated to start the session and inject global navigator key for showing dialogs on timeout.

### Notes
- Session expires after 10 seconds of inactivity by default.
- Background color helps visually track activity interaction.

## [0.0.2] - 2025-04-10
- gif added for preview