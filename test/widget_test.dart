import 'package:flutter_test/flutter_test.dart';
import 'package:cat_directory_app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const CatDirectoryApp());
    expect(find.byType(CatDirectoryApp), findsOneWidget);
  });
}
