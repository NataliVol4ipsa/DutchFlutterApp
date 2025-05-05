// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_english_word.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDbEnglishWordCollection on Isar {
  IsarCollection<DbEnglishWord> get dbEnglishWords => this.collection();
}

const DbEnglishWordSchema = CollectionSchema(
  name: r'DbEnglishWord',
  id: -5073376925514074965,
  properties: {
    r'word': PropertySchema(
      id: 0,
      name: r'word',
      type: IsarType.string,
    )
  },
  estimateSize: _dbEnglishWordEstimateSize,
  serialize: _dbEnglishWordSerialize,
  deserialize: _dbEnglishWordDeserialize,
  deserializeProp: _dbEnglishWordDeserializeProp,
  idName: r'id',
  indexes: {
    r'word': IndexSchema(
      id: -2031626334120420267,
      name: r'word',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'word',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {
    r'words': LinkSchema(
      id: 3179852848815915298,
      name: r'words',
      target: r'DbWord',
      single: false,
      linkName: r'englishWordLinks',
    )
  },
  embeddedSchemas: {},
  getId: _dbEnglishWordGetId,
  getLinks: _dbEnglishWordGetLinks,
  attach: _dbEnglishWordAttach,
  version: '3.1.0+1',
);

int _dbEnglishWordEstimateSize(
  DbEnglishWord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.word.length * 3;
  return bytesCount;
}

void _dbEnglishWordSerialize(
  DbEnglishWord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.word);
}

DbEnglishWord _dbEnglishWordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DbEnglishWord();
  object.id = id;
  object.word = reader.readString(offsets[0]);
  return object;
}

P _dbEnglishWordDeserializeProp<P>(
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

Id _dbEnglishWordGetId(DbEnglishWord object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dbEnglishWordGetLinks(DbEnglishWord object) {
  return [object.words];
}

void _dbEnglishWordAttach(
    IsarCollection<dynamic> col, Id id, DbEnglishWord object) {
  object.id = id;
  object.words.attach(col, col.isar.collection<DbWord>(), r'words', id);
}

extension DbEnglishWordByIndex on IsarCollection<DbEnglishWord> {
  Future<DbEnglishWord?> getByWord(String word) {
    return getByIndex(r'word', [word]);
  }

  DbEnglishWord? getByWordSync(String word) {
    return getByIndexSync(r'word', [word]);
  }

  Future<bool> deleteByWord(String word) {
    return deleteByIndex(r'word', [word]);
  }

  bool deleteByWordSync(String word) {
    return deleteByIndexSync(r'word', [word]);
  }

  Future<List<DbEnglishWord?>> getAllByWord(List<String> wordValues) {
    final values = wordValues.map((e) => [e]).toList();
    return getAllByIndex(r'word', values);
  }

  List<DbEnglishWord?> getAllByWordSync(List<String> wordValues) {
    final values = wordValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'word', values);
  }

  Future<int> deleteAllByWord(List<String> wordValues) {
    final values = wordValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'word', values);
  }

  int deleteAllByWordSync(List<String> wordValues) {
    final values = wordValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'word', values);
  }

  Future<Id> putByWord(DbEnglishWord object) {
    return putByIndex(r'word', object);
  }

  Id putByWordSync(DbEnglishWord object, {bool saveLinks = true}) {
    return putByIndexSync(r'word', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByWord(List<DbEnglishWord> objects) {
    return putAllByIndex(r'word', objects);
  }

  List<Id> putAllByWordSync(List<DbEnglishWord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'word', objects, saveLinks: saveLinks);
  }
}

extension DbEnglishWordQueryWhereSort
    on QueryBuilder<DbEnglishWord, DbEnglishWord, QWhere> {
  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DbEnglishWordQueryWhere
    on QueryBuilder<DbEnglishWord, DbEnglishWord, QWhereClause> {
  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterWhereClause> idNotEqualTo(
      Id id) {
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

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterWhereClause> idBetween(
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

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterWhereClause> wordEqualTo(
      String word) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'word',
        value: [word],
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterWhereClause> wordNotEqualTo(
      String word) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'word',
              lower: [],
              upper: [word],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'word',
              lower: [word],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'word',
              lower: [word],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'word',
              lower: [],
              upper: [word],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DbEnglishWordQueryFilter
    on QueryBuilder<DbEnglishWord, DbEnglishWord, QFilterCondition> {
  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      idGreaterThan(
    Id? value, {
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

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition> wordEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition> wordBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'word',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition> wordMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'word',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'word',
        value: '',
      ));
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'word',
        value: '',
      ));
    });
  }
}

extension DbEnglishWordQueryObject
    on QueryBuilder<DbEnglishWord, DbEnglishWord, QFilterCondition> {}

extension DbEnglishWordQueryLinks
    on QueryBuilder<DbEnglishWord, DbEnglishWord, QFilterCondition> {
  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition> words(
      FilterQuery<DbWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'words');
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', length, true, length, true);
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', 0, true, 0, true);
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', 0, true, length, include);
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
      wordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', length, include, 999999, true);
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterFilterCondition>
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

extension DbEnglishWordQuerySortBy
    on QueryBuilder<DbEnglishWord, DbEnglishWord, QSortBy> {
  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterSortBy> sortByWord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'word', Sort.asc);
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterSortBy> sortByWordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'word', Sort.desc);
    });
  }
}

extension DbEnglishWordQuerySortThenBy
    on QueryBuilder<DbEnglishWord, DbEnglishWord, QSortThenBy> {
  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterSortBy> thenByWord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'word', Sort.asc);
    });
  }

  QueryBuilder<DbEnglishWord, DbEnglishWord, QAfterSortBy> thenByWordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'word', Sort.desc);
    });
  }
}

extension DbEnglishWordQueryWhereDistinct
    on QueryBuilder<DbEnglishWord, DbEnglishWord, QDistinct> {
  QueryBuilder<DbEnglishWord, DbEnglishWord, QDistinct> distinctByWord(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'word', caseSensitive: caseSensitive);
    });
  }
}

extension DbEnglishWordQueryProperty
    on QueryBuilder<DbEnglishWord, DbEnglishWord, QQueryProperty> {
  QueryBuilder<DbEnglishWord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DbEnglishWord, String, QQueryOperations> wordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'word');
    });
  }
}
