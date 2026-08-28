import 'package:flutter_test/flutter_test.dart';
import 'package:locked_in/main.dart';
import 'package:locked_in/core/app_state.dart';

void main() {
  testWidgets('fresh app renders onboarding', (tester) async {
    final state = AppState();
    await tester.pumpWidget(LockedInApp(state: state));
    expect(find.text('LOCKED IN'), findsOneWidget);
    expect(find.text('START PERSONALISATION'), findsOneWidget);
  });
}
