import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:prepexami/src/app.dart';

void main() {
  testWidgets('shows setup guidance without runtime configuration', (
    tester,
  ) async {
    await tester.pumpWidget(const PrepExamiApp());
    expect(find.text('Connect PrepExami'), findsOneWidget);
    expect(find.textContaining('SUPABASE_URL'), findsOneWidget);
  });

  testWidgets('landing page fits a narrow mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(302, 783);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: LandingScreen()));
    await tester.pumpAndSettle();

    expect(
      find.text('Master your exams\nthrough pure practice.'),
      findsOneWidget,
    );
    expect(find.text('Full Exam Practice'), findsOneWidget);
    expect(find.text('Concept & Topic Drills'), findsOneWidget);
    final layoutException = tester.takeException();
    expect(layoutException, isNull);
  });

  testWidgets('exam selector fits its reference mobile viewport', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(344, 806);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: SelectExamScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Select Exam'), findsOneWidget);
    expect(find.text('IBPS PO'), findsOneWidget);
    expect(find.text('Continue with IBPS PO'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('account settings uses placeholders and saves changes', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: AccountSettingsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Account Settings'), findsOneWidget);
    expect(find.text('PREPEXAMI STUDENT'), findsOneWidget);
    expect(find.text('student@example.com'), findsWidgets);
    expect(find.textContaining('MOUSUM'), findsNothing);

    await tester.tap(find.text('Save Changes'));
    await tester.pumpAndSettle();
    expect(find.text('Account changes saved on this device.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('signed-in home fits a narrow mobile viewport', (tester) async {
    tester.view.physicalSize = const Size(320, 780);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const MaterialApp(home: SignedInHomeScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Hi, Student 👋'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Exam Simulation'),
      150,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Exam Simulation'), findsOneWidget);
    expect(find.text('Concept Drills'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
