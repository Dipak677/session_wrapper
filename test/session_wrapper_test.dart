import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Assuming session_wrapper.dart exports SessionController and SessionWrapper
import 'package:session_wrapper/session_wrapper.dart';

void main() {
  group('SessionController Tests', () {
    late bool sessionExpired;
    late SessionController controller;

    setUp(() {
      sessionExpired = false;
      controller = SessionController(
        timeoutInSeconds: 3,
        onSessionExpired: () {
          sessionExpired = true;
        },
      );
    });

    test('initial state is correct', () {
      expect(controller.counter, 0);
      expect(controller.isSessionStarted, false);
    });

    test('startSession initializes session correctly', () {
      controller.startSession();
      expect(controller.isSessionStarted, true);
      expect(controller.counter, 0);
    });

    test('resetSession resets the counter', () {
      controller.startSession();
      controller.tick();
      expect(controller.counter, 1);
      controller.resetSession();
      expect(controller.counter, 0);
    });

    test('stopSession stops session and resets counter', () {
      controller.startSession();
      controller.tick();
      controller.stopSession();
      expect(controller.isSessionStarted, false);
      expect(controller.counter, 0);
    });

    test('tick increments counter and triggers expiry at timeout', () {
      controller.startSession();
      controller.tick(); // 1
      controller.tick(); // 2
      controller.tick(); // 3 (should expire)
      expect(sessionExpired, true);
      expect(controller.isSessionStarted, false);
    });

    test('tick does not increment if session not started', () {
      controller.tick();
      expect(controller.counter, 0);
      expect(sessionExpired, false);
    });
  });

  group('SessionWrapper Tests', () {
    testWidgets('resets session counter on pointer down', (WidgetTester tester) async {
      final controller = SessionController(
        timeoutInSeconds: 5,
        onSessionExpired: () {},
      );

      controller.startSession();
      controller.tick(); // counter: 1

      await tester.pumpWidget(
        MaterialApp(
          home: SessionWrapper(
            controller: controller,
            child: const Scaffold(body: Text('Tap here')),
          ),
        ),
      );

      // Simulate user tap (which should reset session)
      await tester.tap(find.text('Tap here'));
      await tester.pumpAndSettle();

      expect(controller.counter, 0);
    });

    testWidgets('session ticks every second', (WidgetTester tester) async {
      final controller = SessionController(
        timeoutInSeconds: 3,
        onSessionExpired: () {},
      );

      controller.startSession();

      await tester.pumpWidget(
        MaterialApp(
          home: SessionWrapper(
            controller: controller,
            child: const Scaffold(body: Text('App')),
          ),
        ),
      );

      await tester.pump(const Duration(seconds: 1));
      expect(controller.counter, 1);

      await tester.pump(const Duration(seconds: 1));
      expect(controller.counter, 2);

      await tester.pump(const Duration(seconds: 1));
      expect(controller.counter, 3);
    });
  });
}
