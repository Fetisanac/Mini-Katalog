import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/models/product.dart';

void main() {
  testWidgets('Mini katalog sepete urun ekler', (WidgetTester tester) async {
    clearCart();

    await tester.pumpWidget(const MyApp());

    expect(find.text('Game Gear'), findsOneWidget);
    expect(find.text('RGB Oyuncu Kulakligi'), findsOneWidget);

    await tester.tap(find.text('Mouse'));
    await tester.pump();

    expect(find.text('Ultra Hafif Mouse'), findsOneWidget);
    expect(find.text('RGB Oyuncu Kulakligi'), findsNothing);

    await tester.tap(find.text('Tum'));
    await tester.pump();

    await tester.tap(find.byIcon(Icons.add_shopping_cart).first);
    await tester.pump();

    await tester.tap(find.byIcon(Icons.shopping_cart_outlined).first);
    await tester.pumpAndSettle();

    expect(find.text('Sepet'), findsOneWidget);
    expect(find.text('RGB Oyuncu Kulakligi'), findsOneWidget);
    expect(cartProductCount, 1);
  });
}
