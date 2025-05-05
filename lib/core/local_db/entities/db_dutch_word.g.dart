// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_dutch_word.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDbDutchWordCollection on Isar {
  IsarCollection<DbDutchWord> get dbDutchWords => this.collection();
}

const DbDutchWordSchema = CollectionSchema(
  name: r'DbDutchWord',
  id: 361822241573683924,
  properties: {
    r'audioCode': PropertySchema(
      id: 0,
      name: r'audioCode',
      type: IsarType.string,
    ),
    r'word': PropertySchema(
      id: 1,
      name: r'word',
      type: IsarType.string,
    )
  },
  estimateSize: _dbDutchWordEstimateSize,
  serialize: _dbDutchWordSerialize,
  deserialize: _dbDutchWordDeserialize,
  deserializeProp: _dbDutchWordDeserializeProp,
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
  links: {},
  embeddedSchemas: {},
  getId: _dbDutchWordGetId,
  getLinks: _dbDutchWordGetLinks,
  attach: _dbDutchWordAttach,
  version: '3.1.0+1',
);

int _dbDutchWordEstimateSize(
  DbDutchWord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.audioCode.length * 3;
  bytesCount += 3 + object.word.length * 3;
  return bytesCount;
}

void _dbDutchWordSerialize(
  DbDutchWord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.audioCode);
  writer.writeString(offsets[1], object.word);
}

DbDutchWord _dbDutchWordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DbDutchWord();
  object.audioCode = reader.readString(offsets[0]);
  object.id = id;
  object.word = reader.readString(offsets[1]);
  return object;
}

P _dbDutchWordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dbDutchWordGetId(DbDutchWord object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dbDutchWordGetLinks(DbDutchWord object) {
  return [];
}

void _dbDutchWordAttach(
    IsarCollection<dynamic> col, Id id, DbDutchWord object) {
  object.id = id;
}

extension DbDutchWordByIndex on IsarCollection<DbDutchWord> {
  Future<DbDutchWord?> getByWord(String word) {
    return getByIndex(r'word', [word]);
  }

  DbDutchWord? getByWordSync(String word) {
    return getByIndexSync(r'word', [word]);
  }

  Future<bool> deleteByWord(String word) {
    return deleteByIndex(r'word', [word]);
  }

  bool deleteByWordSync(String word) {
    return deleteByIndexSync(r'word', [word]);
  }

  Future<List<DbDutchWord?>> getAllByWord(List<String> wordValues) {
    final values = wordValues.map((e) => [e]).toList();
    return getAllByIndex(r'word', values);
  }

  List<DbDutchWord?> getAllByWordSync(List<String> wordValues) {
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

  Future<Id> putByWord(DbDutchWord object) {
    return putByIndex(r'word', object);
  }

  Id putByWordSync(DbDutchWord object, {bool saveLinks = true}) {
    return putByIndexSync(r'word', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByWord(List<DbDutchWord> objects) {
    return putAllByIndex(r'word', objects);
  }

  List<Id> putAllByWordSync(List<DbDutchWord> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'word', objects, saveLinks: saveLinks);
  }
}

extension DbDutchWordQueryWhereSort
    on QueryBuilder<DbDutchWord, DbDutchWord, QWhere> {
  QueryBuilder<DbDutchWord, DbDutchWord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DbDutchWordQueryWhere
    on QueryBuilder<DbDutchWord, DbDutchWord, QWhereClause> {
  QueryBuilder<DbDutchWord, DbDutchWord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterWhereClause> idBetween(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterWhereClause> wordEqualTo(
      String word) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'word',
        value: [word],
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterWhereClause> wordNotEqualTo(
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

extension DbDutchWordQueryFilter
    on QueryBuilder<DbDutchWord, DbDutchWord, QFilterCondition> {
  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'audioCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'audioCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'audioCode',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'audioCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'audioCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioCode',
        value: '',
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioCode',
        value: '',
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> wordEqualTo(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> wordGreaterThan(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> wordLessThan(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> wordBetween(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> wordStartsWith(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> wordEndsWith(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> wordContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'word',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> wordMatches(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> wordIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'word',
        value: '',
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      wordIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'word',
        value: '',
      ));
    });
  }
}

extension DbDutchWordQueryObject
    on QueryBuilder<DbDutchWord, DbDutchWord, QFilterCondition> {}

extension DbDutchWordQueryLinks
    on QueryBuilder<DbDutchWord, DbDutchWord, QFilterCondition> {}

extension DbDutchWordQuerySortBy
    on QueryBuilder<DbDutchWord, DbDutchWord, QSortBy> {
  QueryBuilder<DbDutchWord, DbDutchWord, QAfterSortBy> sortByAudioCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioCode', Sort.asc);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterSortBy> sortByAudioCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioCode', Sort.desc);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterSortBy> sortByWord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'word', Sort.asc);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterSortBy> sortByWordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'word', Sort.desc);
    });
  }
}

extension DbDutchWordQuerySortThenBy
    on QueryBuilder<DbDutchWord, DbDutchWord, QSortThenBy> {
  QueryBuilder<DbDutchWord, DbDutchWord, QAfterSortBy> thenByAudioCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioCode', Sort.asc);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterSortBy> thenByAudioCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioCode', Sort.desc);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterSortBy> thenByWord() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'word', Sort.asc);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterSortBy> thenByWordDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'word', Sort.desc);
    });
  }
}

extension DbDutchWordQueryWhereDistinct
    on QueryBuilder<DbDutchWord, DbDutchWord, QDistinct> {
  QueryBuilder<DbDutchWord, DbDutchWord, QDistinct> distinctByAudioCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QDistinct> distinctByWord(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'word', caseSensitive: caseSensitive);
    });
  }
}

extension DbDutchWordQueryProperty
    on QueryBuilder<DbDutchWord, DbDutchWord, QQueryProperty> {
  QueryBuilder<DbDutchWord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DbDutchWord, String, QQueryOperations> audioCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioCode');
    });
  }

  QueryBuilder<DbDutchWord, String, QQueryOperations> wordProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'word');
    });
  }
}
