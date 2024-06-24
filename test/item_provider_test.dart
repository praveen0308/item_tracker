import 'package:flutter_test/flutter_test.dart';
import 'package:item_tracker/providers/item_provider.dart';

void main() {
  group('ItemProvider Tests', () {
    late ItemProvider itemProvider;

    setUp(() {
      itemProvider = ItemProvider();
    });

    test('Initial state', () {
      expect(itemProvider.items, isEmpty);
      expect(itemProvider.uniqueId, equals(0));
    });

    test('Add item', () {
      itemProvider.addItem('Test Item', 'Test Description');
      expect(itemProvider.items.length, equals(1));
      expect(itemProvider.items[0].name, equals('Test Item'));
      expect(itemProvider.items[0].description, equals('Test Description'));
      expect(itemProvider.uniqueId, equals(1));
    });

    test('Update item', () {
      itemProvider.addItem('Test Item', 'Test Description');
      itemProvider.updateItem(1, 'Updated Item', 'Updated Description');
      expect(itemProvider.items[0].name, equals('Updated Item'));
      expect(itemProvider.items[0].description, equals('Updated Description'));
    });

    test('Remove item', () {
      itemProvider.addItem('Test Item', 'Test Description');
      itemProvider.removeItem(1);
      expect(itemProvider.items, isEmpty);
    });

  });
}
