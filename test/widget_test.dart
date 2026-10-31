import 'package:flutter_test/flutter_test.dart';
import 'package:proj01/main.dart';

void main() {
  testWidgets('play through the first morning and a conversation', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();

    // Intro appears as an overlay
    expect(find.textContaining('Someone in town was murdered'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Start the day is automatic after closing the intro; claims are shown
    expect(find.text('Seer'), findsOneWidget);
    await tester.tap(find.text('Alice'));
    await tester.pumpAndSettle();
    expect(find.textContaining('As the Seer'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();

    // Voting opens after the conversations phase
    await tester.tap(find.text('Go to the vote'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Tap someone to execute them'), findsOneWidget);

    // Executing Jerry ends the game with a win (report first, then the ending)
    await tester.tap(find.text('Jerry'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Execute'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Jerry was executed'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Justice'), findsOneWidget);
    expect(find.text('Play again'), findsOneWidget);
  });

  testWidgets('execution result, then night report, then conversations', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Play'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Go to the vote'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Alice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Execute'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Alice was executed'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Frank was killed by the Possessed'), findsOneWidget);
    await tester.tap(find.text('Close'));
    await tester.pumpAndSettle();
    expect(find.text('Go to the vote'), findsOneWidget);
    expect(find.textContaining('Day 2'), findsOneWidget);
  });
}
