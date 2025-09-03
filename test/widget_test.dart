// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:easy_saves/network_service.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easy_saves/main.dart';

void main() {
  testWidgets('Test de MyApp avec service', (WidgetTester tester) async {
    final connectivityService = ConnectivityService();

    await tester.pumpWidget(MyApp(connectivityService));

    // Simule une frame pour afficher les widgets
    await tester.pump();

    // Tu peux tester la présence d’un texte, bouton, etc.
    expect(find.text('Bienvenue'), findsOneWidget);
  });


  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
}
