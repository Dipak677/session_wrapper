/// A controller that manages session timeout based on user inactivity.
class SessionController {
  int _sessionCounter = 0;
  bool _isSessionStarted = false;

  /// The duration (in seconds) after which the session is considered expired.
  final int timeoutInSeconds;

  /// Callback invoked when the session timeout duration is reached.
  final void Function() onSessionExpired;

  /// Creates a [SessionController] with a [timeoutInSeconds] value and a
  /// [onSessionExpired] callback that will be triggered when session expires.
  SessionController({
    required this.timeoutInSeconds,
    required this.onSessionExpired,
  });

  /// Returns the current session counter in seconds.
  int get counter => _sessionCounter;

  /// Indicates whether the session is currently active.
  bool get isSessionStarted => _isSessionStarted;

  /// Starts the session and resets the session counter.
  void startSession() {
    _sessionCounter = 0;
    _isSessionStarted = true;
  }

  /// Resets the session counter back to 0 without stopping the session.
  void resetSession() {
    _sessionCounter = 0;
  }

  /// Stops the session and resets the session counter.
  void stopSession() {
    _sessionCounter = 0;
    _isSessionStarted = false;
  }

  /// Increments the session counter every second. If the counter exceeds
  /// [timeoutInSeconds], the session is stopped and [onSessionExpired] is called.
  void tick() {
    if (!_isSessionStarted) {
      resetSession();
      return;
    }

    _sessionCounter++;

    // debugPrint("::SESSION COUNTER:: $_sessionCounter");

    if (_sessionCounter >= timeoutInSeconds) {
      stopSession();
      onSessionExpired();
    }
  }
}
