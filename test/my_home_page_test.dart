import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:item_tracker/providers/item_provider.dart';
import 'package:item_tracker/ui/home/home_page.dart';
import 'package:provider/provider.dart';

void main() {
  Widget createTestWidget() {
    return ChangeNotifierProvider(
      create: (context) => ItemProvider(),
      child: const MaterialApp(
        home: MyHomePage(title: 'Item Tracker'),
      ),
    );
  }

  group('MyHomePage Widget Tests', () {
    testWidgets('should display the title', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.text('Item Tracker'), findsOneWidget);
    });

    testWidgets('should display no items initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(ListTile), findsNothing);
      expect(
          find.text(
              "No items in the list!\nUse \"+\" icon button to add new item"),
          findsOneWidget);
    });

    testWidgets('should add an item', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap the add button to open the add item dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter item details
      await tester.enterText(find.byType(TextFormField).at(0), 'Test Item');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'Test Description');

      // Submit the form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify the item is added
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text('Test Item'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
    });

    testWidgets('should update an item', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap the add button to open the add item dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter item details
      await tester.enterText(find.byType(TextFormField).at(0), 'Test Item');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'Test Description');

      // Submit the form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Tap the edit button to open the update item dialog
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pumpAndSettle();

      // Update item details
      await tester.enterText(find.byType(TextFormField).at(0), 'Updated Item');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'Updated Description');

      // Submit the form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify the item is updated
      expect(find.text('Updated Item'), findsOneWidget);
      expect(find.text('Updated Description'), findsOneWidget);
    });

    testWidgets('should remove an item', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      // Tap the add button to open the add item dialog
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Enter item details
      await tester.enterText(find.byType(TextFormField).at(0), 'Test Item');
      await tester.enterText(
          find.byType(TextFormField).at(1), 'Test Description');

      // Submit the form
      await tester.tap(find.text('Submit'));
      await tester.pumpAndSettle();

      // Verify the item is added
      expect(find.byType(ListTile), findsOneWidget);

      // Tap the delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Verify the item is removed
      expect(find.byType(ListTile), findsNothing);
      expect(
          find.text(
              "No items in the list!\nUse \"+\" icon button to add new item"),
          findsOneWidget);
    });
  });
}
