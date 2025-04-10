import 'dart:math';
import 'package:flutter/material.dart';
import 'package:session_wrapper/session_wrapper.dart';

final GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

SessionController sessionController = SessionController(
  timeoutInSeconds: 180,
  onSessionExpired: () {
    BuildContext? context = appNavigatorKey.currentContext;
    if (context != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text("Session Expired!"),
          content: Text("Your session has expired."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            )
          ],
        ),
      );
    }
  },
);

void main() {
  // ::START SESSION::
  sessionController.startSession();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: appNavigatorKey,
      home: SessionWrapper(
        controller: sessionController,
        child: SessionWrapperExample(),
      ),
    ),
  );
}

class SessionWrapperExample extends StatefulWidget {
  const SessionWrapperExample({super.key});

  @override
  State<SessionWrapperExample> createState() => _SessionWrapperExampleState();
}

class _SessionWrapperExampleState extends State<SessionWrapperExample> {
  Color _backgroundColor = Colors.white;

  void _changeBackgroundColor() {
    final Random random = Random();
    setState(() {
      _backgroundColor = Color.fromARGB(
        255,
        200 + random.nextInt(56),
        200 + random.nextInt(56),
        200 + random.nextInt(56),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Session Wrapper Example",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.deepPurple,
      ),
      body: GestureDetector(
        onTap: _changeBackgroundColor,
        child: Container(
          color: _backgroundColor,
          alignment: Alignment.center,
          child: Text(
            "Session is active.\nTap anywhere to reset timer.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
