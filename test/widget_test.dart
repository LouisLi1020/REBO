import 'package:flutter_test/flutter_test.dart';
import 'package:rebo/app.dart';

void main() {
  testWidgets('ReboApp builds', (tester) async {
    await tester.pumpWidget(const ReboApp());
    expect(find.text('Red Button'), findsOneWidget);
  });
}
