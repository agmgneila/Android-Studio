import 'package:flutter_test/flutter_test.dart';
import 'package:ritmo/main.dart';

void main() {
  testWidgets('muestra los hábitos y permite cambiar de sección',
      (tester) async {
    await tester.pumpWidget(const RitmoApp());
    expect(find.text('Tu semana, con intención'), findsOneWidget);
    await tester.tap(find.text('Progreso'));
    await tester.pumpAndSettle();
    expect(find.text('Progreso semanal'), findsOneWidget);
  });
}
