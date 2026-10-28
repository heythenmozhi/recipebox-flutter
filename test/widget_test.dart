
import 'package:flutter_test/flutter_test.dart';
import 'package:recipebox_flutter/main.dart';

void main() {
  testWidgets('RecipeBox app displays its navigation', (tester) async {
    await tester.pumpWidget(const RecipeBoxApp());

    expect(find.text('RecipeBox'), findsOneWidget);
    expect(find.text('Recipes'), findsOneWidget);
    expect(find.text('Favourites'), findsOneWidget);
    expect(find.text('Add Recipe'), findsOneWidget);
  });
}
