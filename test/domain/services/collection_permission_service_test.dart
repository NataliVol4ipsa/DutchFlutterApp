import 'package:dutch_app/domain/services/collection_permission_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── canCreateCollection ───────────────────────────────────────────────────
  group('CollectionPermissionService.canCreateCollection', () {
    test('returns false for null name', () {
      expect(CollectionPermissionService.canCreateCollection(null), isFalse);
    });

    test('returns false for empty string', () {
      expect(CollectionPermissionService.canCreateCollection(''), isFalse);
    });

    test('returns false for whitespace-only string', () {
      expect(CollectionPermissionService.canCreateCollection('   '), isFalse);
    });

    test('returns false for exact default collection name', () {
      expect(
        CollectionPermissionService.canCreateCollection('Default collection'),
        isFalse,
      );
    });

    test('returns false for default collection name in uppercase', () {
      expect(
        CollectionPermissionService.canCreateCollection('DEFAULT COLLECTION'),
        isFalse,
      );
    });

    test(
      'returns false for default collection name with surrounding spaces',
      () {
        expect(
          CollectionPermissionService.canCreateCollection(
            '  Default collection  ',
          ),
          isFalse,
        );
      },
    );

    test('returns true for a regular collection name', () {
      expect(
        CollectionPermissionService.canCreateCollection('My Words'),
        isTrue,
      );
    });

    test('returns true for a name that partially matches default', () {
      expect(
        CollectionPermissionService.canCreateCollection('Default'),
        isTrue,
      );
    });
  });

  // ── isDefaultCollectionName ───────────────────────────────────────────────
  group('CollectionPermissionService.isDefaultCollectionName', () {
    test('returns true for exact default name', () {
      expect(
        CollectionPermissionService.isDefaultCollectionName(
          'Default collection',
        ),
        isTrue,
      );
    });

    test('returns true case-insensitively', () {
      expect(
        CollectionPermissionService.isDefaultCollectionName(
          'default collection',
        ),
        isTrue,
      );
      expect(
        CollectionPermissionService.isDefaultCollectionName(
          'DEFAULT COLLECTION',
        ),
        isTrue,
      );
    });

    test('returns false for different name', () {
      expect(
        CollectionPermissionService.isDefaultCollectionName('My Words'),
        isFalse,
      );
    });

    test('ignores leading/trailing whitespace', () {
      expect(
        CollectionPermissionService.isDefaultCollectionName(
          '  Default collection  ',
        ),
        isTrue,
      );
    });
  });

  // ── canRenameCollection ───────────────────────────────────────────────────
  group('CollectionPermissionService.canRenameCollection', () {
    setUp(() {
      CollectionPermissionService.defaultCollectionId = 1;
    });

    test('returns false for the default collection id', () {
      expect(
        CollectionPermissionService.canRenameCollection(
          CollectionPermissionService.defaultCollectionId,
        ),
        isFalse,
      );
    });

    test('returns true for a non-default collection id', () {
      expect(CollectionPermissionService.canRenameCollection(42), isTrue);
    });
  });
}
