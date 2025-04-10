import 'dart:async';
import 'package:flutter/material.dart';
import 'package:session_wrapper/src/session_controller.dart';

/// A widget that wraps around the app or a specific screen
/// to track user activity and manage session timeout.
class SessionWrapper extends StatefulWidget {
  /// The child widget that this wrapper surrounds.
  final Widget child;

  /// The [SessionController] that handles session logic like timeout and reset.
  final SessionController controller;

  /// Creates a [SessionWrapper].
  ///
  /// Requires a [controller] for session management and a [child] widget to wrap.
  const SessionWrapper({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  State<SessionWrapper> createState() => _SessionWrapperState();
}

class _SessionWrapperState extends State<SessionWrapper> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Starts a periodic timer that ticks every second
  /// and notifies the controller to update session state.
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      widget.controller.tick();
    });
  }

  /// Resets the session timer if the widget is still in the widget tree.
  void _resetIfMounted() {
    if (mounted) {
      widget.controller.resetSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        // Triggered on any user interaction (touch).
        // debugPrint("::TRIGGER::");
        _resetIfMounted();
      },
      child: widget.child,
    );
  }
}
