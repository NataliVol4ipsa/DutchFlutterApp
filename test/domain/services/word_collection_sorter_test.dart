// ignore_for_file: avoid_relative_lib_imports

import 'package:dutch_app/domain/models/word_collection.dart';
import 'package:dutch_app/domain/services/collection_permission_service.dart';
import 'package:dutch_app/domain/services/word_collection_sorter.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_collection_model.dart';
import 'package:flutter_test/flutter_test.dart';

// ── helpers ─────────────────────────────────────────────────────────────────

WordCollection _makeCollection(int id, String name, {DateTime? lastUpdated}) =>
    WordCollection(id, name, lastUpdated: lastUpdated);

SelectableWordCollectionModel _makeSelectable(
  int id,
  String name, {
  DateTime? lastUpdated,
}) => SelectableWordCollectionModel(id, name, null, lastUpdated: lastUpdated);

// ── tests ────────────────────────────────────────────────────────────────────

void main() {
  final defaultId = 1;

  setUp(() {
    CollectionPermissionService.defaultCollectionId = defaultId;
  });

  // ── sortCollections (WordCollection list) ─────────────────────────────────
  group('WordCollectionSorter.sortCollections', () {
    test('default collection is always sorted first', () {
      final now = DateTime.now();
      final collections = [
        _makeCollection(2, 'Alpha', lastUpdated: now),
        _makeCollection(defaultId, 'Default', lastUpdated: now),
        _makeCollection(3, 'Beta', lastUpdated: now),
      ];

      WordCollectionSorter.sortCollections(collections);

      expect(collections.first.id, defaultId);
    });

    test('non-default collections are sorted by lastUpdated descending', () {
      final now = DateTime.now();
      final collections = [
        _makeCollection(
          2,
          'Old',
          lastUpdated: now.subtract(const Duration(days: 10)),
        ),
        _makeCollection(3, 'New', lastUpdated: now),
        _makeCollection(
          4,
          'Mid',
          lastUpdated: now.subtract(const Duration(days: 5)),
        ),
      ];

      WordCollectionSorter.sortCollections(collections);

      expect(collections.map((c) => c.name).toList(), ['New', 'Mid', 'Old']);
    });

    test('ties in lastUpdated are broken by name ascending', () {
      final now = DateTime.now();
      final collections = [
        _makeCollection(2, 'Zebra', lastUpdated: now),
        _makeCollection(3, 'Apple', lastUpdated: now),
        _makeCollection(4, 'Mango', lastUpdated: now),
      ];

      WordCollectionSorter.sortCollections(collections);

      expect(collections.map((c) => c.name).toList(), [
        'Apple',
        'Mango',
        'Zebra',
      ]);
    });

    test('null lastUpdated is treated as oldest', () {
      final now = DateTime.now();
      final collections = [
        _makeCollection(2, 'NullDate'), // null lastUpdated
        _makeCollection(3, 'HasDate', lastUpdated: now),
      ];

      WordCollectionSorter.sortCollections(collections);

      expect(collections.first.name, 'HasDate');
      expect(collections.last.name, 'NullDate');
    });

    test(
      'default collection comes first even when others have newer dates',
      () {
        final now = DateTime.now();
        final collections = [
          _makeCollection(
            2,
            'VeryNew',
            lastUpdated: now.add(const Duration(days: 365)),
          ),
          _makeCollection(defaultId, 'Default', lastUpdated: now),
        ];

        WordCollectionSorter.sortCollections(collections);

        expect(collections.first.id, defaultId);
      },
    );
  });

  // ── sort (SelectableWordCollectionModel list) ─────────────────────────────
  group('WordCollectionSorter.sort (SelectableWordCollectionModel)', () {
    test('sorts by lastUpdated descending', () {
      final now = DateTime.now();
      final collections = [
        _makeSelectable(
          1,
          'Old',
          lastUpdated: now.subtract(const Duration(days: 10)),
        ),
        _makeSelectable(2, 'New', lastUpdated: now),
      ];

      WordCollectionSorter.sort(collections);

      expect(collections.first.name, 'New');
    });

    test('ties broken by name ascending', () {
      final now = DateTime.now();
      final collections = [
        _makeSelectable(1, 'Zebra', lastUpdated: now),
        _makeSelectable(2, 'Apple', lastUpdated: now),
      ];

      WordCollectionSorter.sort(collections);

      expect(collections.first.name, 'Apple');
    });

    test('null lastUpdated treated as oldest', () {
      final now = DateTime.now();
      final collections = [
        _makeSelectable(1, 'NullDate'),
        _makeSelectable(2, 'HasDate', lastUpdated: now),
      ];

      WordCollectionSorter.sort(collections);

      expect(collections.first.name, 'HasDate');
    });
  });
}
