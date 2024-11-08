// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_word_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDbWordCollectionCollection on Isar {
  IsarCollection<DbWordCollection> get dbWordCollections => this.collection();
}

const DbWordCollectionSchema = CollectionSchema(
  name: r'DbWordCollection',
  id: -5732899757398745101,
  properties: {
    r'name': PropertySchema(
      id: 0,
      name: r'name',
      type: IsarType.string,
    )
  },
  estimateSize: _dbWordCollectionEstimateSize,
  serialize: _dbWordCollectionSerialize,
  deserialize: _dbWordCollectionDeserialize,
  deserializeProp: _dbWordCollectionDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'parentCollection': LinkSchema(
      id: -2840749376969866624,
      name: r'parentCollection',
      target: r'DbWordCollection',
      single: true,
    ),
    r'words': LinkSchema(
      id: -100550191124026551,
      name: r'words',
      target: r'DbWord',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _dbWordCollectionGetId,
  getLinks: _dbWordCollectionGetLinks,
  attach: _dbWordCollectionAttach,
  version: '3.1.0+1',
);

int _dbWordCollectionEstimateSize(
  DbWordCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _dbWordCollectionSerialize(
  DbWordCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.name);
}

DbWordCollection _dbWordCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DbWordCollection();
  object.id = id;
  object.name = reader.readString(offsets[0]);
  return object;
}

P _dbWordCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dbWordCollectionGetId(DbWordCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dbWordCollectionGetLinks(DbWordCollection object) {
  return [object.parentCollection, object.words];
}

void _dbWordCollectionAttach(
    IsarCollection<dynamic> col, Id id, DbWordCollection object) {
  object.id = id;
  object.parentCollection.attach(
      col, col.isar.collection<DbWordCollection>(), r'parentCollection', id);
  object.words.attach(col, col.isar.collection<DbWord>(), r'words', id);
}

extension DbWordCollectionQueryWhereSort
    on QueryBuilder<DbWordCollection, DbWordCollection, QWhere> {
  QueryBuilder<DbWordCollection, DbWordCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DbWordCollectionQueryWhere
    on QueryBuilder<DbWordCollection, DbWordCollection, QWhereClause> {
  QueryBuilder<DbWordCollection, DbWordCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DbWordCollectionQueryFilter
    on QueryBuilder<DbWordCollection, DbWordCollection, QFilterCondition> {
  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      nameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      nameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }
}

extension DbWordCollectionQueryObject
    on QueryBuilder<DbWordCollection, DbWordCollection, QFilterCondition> {}

extension DbWordCollectionQueryLinks
    on QueryBuilder<DbWordCollection, DbWordCollection, QFilterCondition> {
  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      parentCollection(FilterQuery<DbWordCollection> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'parentCollection');
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      parentCollectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'parentCollection', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition> words(
      FilterQuery<DbWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'words');
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      wordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', length, true, length, true);
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      wordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      wordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      wordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', 0, true, length, include);
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      wordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', length, include, 999999, true);
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterFilterCondition>
      wordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'words', lower, includeLower, upper, includeUpper);
    });
  }
}

extension DbWordCollectionQuerySortBy
    on QueryBuilder<DbWordCollection, DbWordCollection, QSortBy> {
  QueryBuilder<DbWordCollection, DbWordCollection, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterSortBy>
      sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension DbWordCollectionQuerySortThenBy
    on QueryBuilder<DbWordCollection, DbWordCollection, QSortThenBy> {
  QueryBuilder<DbWordCollection, DbWordCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<DbWordCollection, DbWordCollection, QAfterSortBy>
      thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension DbWordCollectionQueryWhereDistinct
    on QueryBuilder<DbWordCollection, DbWordCollection, QDistinct> {
  QueryBuilder<DbWordCollection, DbWordCollection, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }
}

extension DbWordCollectionQueryProperty
    on QueryBuilder<DbWordCollection, DbWordCollection, QQueryProperty> {
  QueryBuilder<DbWordCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DbWordCollection, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }
}
