import 'package:flutter_test/flutter_test.dart';
import 'package:bitki_bakim_rehberi/main.dart';

void main() {
  testWidgets('Uygulama açılıyor testi', (WidgetTester tester) async {
    await tester.pumpWidget(const PlantCareApp());

    expect(find.text('Bitki Bakım Rehberi'), findsOneWidget);
  });
}