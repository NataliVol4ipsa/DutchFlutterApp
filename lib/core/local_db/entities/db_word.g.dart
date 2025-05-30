// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_word.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDbWordCollection on Isar {
  IsarCollection<DbWord> get dbWords => this.collection();
}

const DbWordSchema = CollectionSchema(
  name: r'DbWord',
  id: -6180754930698214218,
  properties: {
    r'audioCode': PropertySchema(
      id: 0,
      name: r'audioCode',
      type: IsarType.string,
    ),
    r'contextExample': PropertySchema(
      id: 1,
      name: r'contextExample',
      type: IsarType.string,
    ),
    r'contextExampleTranslation': PropertySchema(
      id: 2,
      name: r'contextExampleTranslation',
      type: IsarType.string,
    ),
    r'deHet': PropertySchema(
      id: 3,
      name: r'deHet',
      type: IsarType.byte,
      enumMap: _DbWorddeHetEnumValueMap,
    ),
    r'pluralForm': PropertySchema(
      id: 4,
      name: r'pluralForm',
      type: IsarType.string,
    ),
    r'type': PropertySchema(
      id: 5,
      name: r'type',
      type: IsarType.byte,
      enumMap: _DbWordtypeEnumValueMap,
    ),
    r'userNote': PropertySchema(
      id: 6,
      name: r'userNote',
      type: IsarType.string,
    )
  },
  estimateSize: _dbWordEstimateSize,
  serialize: _dbWordSerialize,
  deserialize: _dbWordDeserialize,
  deserializeProp: _dbWordDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'collection': LinkSchema(
      id: -8955838127233442545,
      name: r'collection',
      target: r'DbWordCollection',
      single: true,
    ),
    r'progress': LinkSchema(
      id: 8075695890059373153,
      name: r'progress',
      target: r'DbWordProgress',
      single: false,
      linkName: r'word',
    ),
    r'dutchWordLink': LinkSchema(
      id: -9211722451160612912,
      name: r'dutchWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'englishWordLinks': LinkSchema(
      id: 6243495803116140330,
      name: r'englishWordLinks',
      target: r'DbEnglishWord',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _dbWordGetId,
  getLinks: _dbWordGetLinks,
  attach: _dbWordAttach,
  version: '3.1.0+1',
);

int _dbWordEstimateSize(
  DbWord object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.audioCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.contextExample;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.contextExampleTranslation;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.pluralForm;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.userNote;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _dbWordSerialize(
  DbWord object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.audioCode);
  writer.writeString(offsets[1], object.contextExample);
  writer.writeString(offsets[2], object.contextExampleTranslation);
  writer.writeByte(offsets[3], object.deHet.index);
  writer.writeString(offsets[4], object.pluralForm);
  writer.writeByte(offsets[5], object.type.index);
  writer.writeString(offsets[6], object.userNote);
}

DbWord _dbWordDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DbWord();
  object.audioCode = reader.readStringOrNull(offsets[0]);
  object.contextExample = reader.readStringOrNull(offsets[1]);
  object.contextExampleTranslation = reader.readStringOrNull(offsets[2]);
  object.deHet = _DbWorddeHetValueEnumMap[reader.readByteOrNull(offsets[3])] ??
      DeHetType.none;
  object.id = id;
  object.pluralForm = reader.readStringOrNull(offsets[4]);
  object.type = _DbWordtypeValueEnumMap[reader.readByteOrNull(offsets[5])] ??
      WordType.unspecified;
  object.userNote = reader.readStringOrNull(offsets[6]);
  return object;
}

P _dbWordDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (_DbWorddeHetValueEnumMap[reader.readByteOrNull(offset)] ??
          DeHetType.none) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (_DbWordtypeValueEnumMap[reader.readByteOrNull(offset)] ??
          WordType.unspecified) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DbWorddeHetEnumValueMap = {
  'none': 0,
  'de': 1,
  'het': 2,
};
const _DbWorddeHetValueEnumMap = {
  0: DeHetType.none,
  1: DeHetType.de,
  2: DeHetType.het,
};
const _DbWordtypeEnumValueMap = {
  'unspecified': 0,
  'noun': 1,
  'adjective': 2,
  'verb': 3,
  'adverb': 4,
  'preposition': 5,
  'interjection': 6,
  'conjunction': 7,
  'fixedConjunction': 8,
  'pronoun': 9,
  'numeral': 10,
  'phrase': 11,
  'article': 12,
};
const _DbWordtypeValueEnumMap = {
  0: WordType.unspecified,
  1: WordType.noun,
  2: WordType.adjective,
  3: WordType.verb,
  4: WordType.adverb,
  5: WordType.preposition,
  6: WordType.interjection,
  7: WordType.conjunction,
  8: WordType.fixedConjunction,
  9: WordType.pronoun,
  10: WordType.numeral,
  11: WordType.phrase,
  12: WordType.article,
};

Id _dbWordGetId(DbWord object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dbWordGetLinks(DbWord object) {
  return [
    object.collection,
    object.progress,
    object.dutchWordLink,
    object.englishWordLinks
  ];
}

void _dbWordAttach(IsarCollection<dynamic> col, Id id, DbWord object) {
  object.id = id;
  object.collection
      .attach(col, col.isar.collection<DbWordCollection>(), r'collection', id);
  object.progress
      .attach(col, col.isar.collection<DbWordProgress>(), r'progress', id);
  object.dutchWordLink
      .attach(col, col.isar.collection<DbDutchWord>(), r'dutchWordLink', id);
  object.englishWordLinks.attach(
      col, col.isar.collection<DbEnglishWord>(), r'englishWordLinks', id);
}

extension DbWordQueryWhereSort on QueryBuilder<DbWord, DbWord, QWhere> {
  QueryBuilder<DbWord, DbWord, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DbWordQueryWhere on QueryBuilder<DbWord, DbWord, QWhereClause> {
  QueryBuilder<DbWord, DbWord, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DbWord, DbWord, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterWhereClause> idBetween(
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

extension DbWordQueryFilter on QueryBuilder<DbWord, DbWord, QFilterCondition> {
  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'audioCode',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'audioCode',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeEqualTo(
    String? value, {
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

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeGreaterThan(
    String? value, {
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

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeLessThan(
    String? value, {
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

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeBetween(
    String? lower,
    String? upper, {
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

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeStartsWith(
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

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeEndsWith(
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

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'audioCode',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'audioCode',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'audioCode',
        value: '',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> audioCodeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'audioCode',
        value: '',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> contextExampleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contextExample',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contextExample',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> contextExampleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contextExample',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> contextExampleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contextExample',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> contextExampleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contextExample',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> contextExampleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contextExample',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> contextExampleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contextExample',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> contextExampleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contextExample',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> contextExampleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contextExample',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> contextExampleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contextExample',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> contextExampleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contextExample',
        value: '',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contextExample',
        value: '',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'contextExampleTranslation',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'contextExampleTranslation',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contextExampleTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contextExampleTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contextExampleTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contextExampleTranslation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contextExampleTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contextExampleTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationContains(String value,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contextExampleTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contextExampleTranslation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contextExampleTranslation',
        value: '',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      contextExampleTranslationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contextExampleTranslation',
        value: '',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> deHetEqualTo(
      DeHetType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deHet',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> deHetGreaterThan(
    DeHetType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deHet',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> deHetLessThan(
    DeHetType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deHet',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> deHetBetween(
    DeHetType lower,
    DeHetType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deHet',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'pluralForm',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'pluralForm',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pluralForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pluralForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pluralForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pluralForm',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'pluralForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'pluralForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'pluralForm',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'pluralForm',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pluralForm',
        value: '',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> pluralFormIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'pluralForm',
        value: '',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> typeEqualTo(
      WordType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> typeGreaterThan(
    WordType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> typeLessThan(
    WordType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> typeBetween(
    WordType lower,
    WordType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userNote',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userNote',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userNote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userNote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userNote',
        value: '',
      ));
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> userNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userNote',
        value: '',
      ));
    });
  }
}

extension DbWordQueryObject on QueryBuilder<DbWord, DbWord, QFilterCondition> {}

extension DbWordQueryLinks on QueryBuilder<DbWord, DbWord, QFilterCondition> {
  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> collection(
      FilterQuery<DbWordCollection> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'collection');
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> collectionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'collection', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> progress(
      FilterQuery<DbWordProgress> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'progress');
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> progressLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'progress', length, true, length, true);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> progressIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'progress', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> progressIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'progress', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> progressLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'progress', 0, true, length, include);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> progressLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'progress', length, include, 999999, true);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> progressLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'progress', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> dutchWordLink(
      FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'dutchWordLink');
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> dutchWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'dutchWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition> englishWordLinks(
      FilterQuery<DbEnglishWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'englishWordLinks');
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      englishWordLinksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'englishWordLinks', length, true, length, true);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      englishWordLinksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'englishWordLinks', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      englishWordLinksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'englishWordLinks', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      englishWordLinksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'englishWordLinks', 0, true, length, include);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      englishWordLinksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'englishWordLinks', length, include, 999999, true);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterFilterCondition>
      englishWordLinksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'englishWordLinks', lower, includeLower, upper, includeUpper);
    });
  }
}

extension DbWordQuerySortBy on QueryBuilder<DbWord, DbWord, QSortBy> {
  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByAudioCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioCode', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByAudioCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioCode', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByContextExample() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextExample', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByContextExampleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextExample', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByContextExampleTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextExampleTranslation', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy>
      sortByContextExampleTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextExampleTranslation', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByDeHet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deHet', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByDeHetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deHet', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByPluralForm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pluralForm', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByPluralFormDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pluralForm', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByUserNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userNote', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> sortByUserNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userNote', Sort.desc);
    });
  }
}

extension DbWordQuerySortThenBy on QueryBuilder<DbWord, DbWord, QSortThenBy> {
  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByAudioCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioCode', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByAudioCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'audioCode', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByContextExample() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextExample', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByContextExampleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextExample', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByContextExampleTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextExampleTranslation', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy>
      thenByContextExampleTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextExampleTranslation', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByDeHet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deHet', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByDeHetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deHet', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByPluralForm() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pluralForm', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByPluralFormDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'pluralForm', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByUserNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userNote', Sort.asc);
    });
  }

  QueryBuilder<DbWord, DbWord, QAfterSortBy> thenByUserNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userNote', Sort.desc);
    });
  }
}

extension DbWordQueryWhereDistinct on QueryBuilder<DbWord, DbWord, QDistinct> {
  QueryBuilder<DbWord, DbWord, QDistinct> distinctByAudioCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'audioCode', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DbWord, DbWord, QDistinct> distinctByContextExample(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contextExample',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DbWord, DbWord, QDistinct> distinctByContextExampleTranslation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contextExampleTranslation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DbWord, DbWord, QDistinct> distinctByDeHet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deHet');
    });
  }

  QueryBuilder<DbWord, DbWord, QDistinct> distinctByPluralForm(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'pluralForm', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DbWord, DbWord, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }

  QueryBuilder<DbWord, DbWord, QDistinct> distinctByUserNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userNote', caseSensitive: caseSensitive);
    });
  }
}

extension DbWordQueryProperty on QueryBuilder<DbWord, DbWord, QQueryProperty> {
  QueryBuilder<DbWord, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DbWord, String?, QQueryOperations> audioCodeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'audioCode');
    });
  }

  QueryBuilder<DbWord, String?, QQueryOperations> contextExampleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contextExample');
    });
  }

  QueryBuilder<DbWord, String?, QQueryOperations>
      contextExampleTranslationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contextExampleTranslation');
    });
  }

  QueryBuilder<DbWord, DeHetType, QQueryOperations> deHetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deHet');
    });
  }

  QueryBuilder<DbWord, String?, QQueryOperations> pluralFormProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pluralForm');
    });
  }

  QueryBuilder<DbWord, WordType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }

  QueryBuilder<DbWord, String?, QQueryOperations> userNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userNote');
    });
  }
}
