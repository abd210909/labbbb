import 'package:flutter_test/flutter_test.dart';
import 'package:posts_app/main.dart';

void main() {
  testWidgets('MyApp builds home picker', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Posts App'), findsOneWidget);
    expect(find.text('With Provider'), findsOneWidget);
    expect(find.text('Without Provider'), findsOneWidget);
  });
}
