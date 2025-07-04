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
  links: {
    r'words': LinkSchema(
      id: -5342020939926090335,
      name: r'words',
      target: r'DbWord',
      single: false,
      linkName: r'dutchWordLink',
    ),
    r'pluralFormWords': LinkSchema(
      id: 252001335742526826,
      name: r'pluralFormWords',
      target: r'DbWordNounDetails',
      single: false,
      linkName: r'pluralFormWordLink',
    ),
    r'diminutiveWords': LinkSchema(
      id: 2466636593009372208,
      name: r'diminutiveWords',
      target: r'DbWordNounDetails',
      single: false,
      linkName: r'diminutiveWordLink',
    ),
    r'infinitiveVerbs': LinkSchema(
      id: 1577582989783596292,
      name: r'infinitiveVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'infinitiveWordLink',
    ),
    r'completedParticiples': LinkSchema(
      id: 3122449177042617869,
      name: r'completedParticiples',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'completedParticipleWordLink',
    ),
    r'auxiliaryVerbs': LinkSchema(
      id: -1224713215534773344,
      name: r'auxiliaryVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'auxiliaryVerbWordLink',
    ),
    r'imperativeInformalVerbs': LinkSchema(
      id: 7986089376064439607,
      name: r'imperativeInformalVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'imperativeInformalWordLink',
    ),
    r'imperativeFormalVerbs': LinkSchema(
      id: 3113813517160809749,
      name: r'imperativeFormalVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'imperativeFormalWordLink',
    ),
    r'presentParticipleInflectedVerbs': LinkSchema(
      id: 6748198384082531924,
      name: r'presentParticipleInflectedVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'presentParticipleInflectedWordLink',
    ),
    r'presentParticipleUninflectedVerbs': LinkSchema(
      id: -6904686369612939258,
      name: r'presentParticipleUninflectedVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'presentParticipleUninflectedWordLink',
    ),
    r'presentIkVerbs': LinkSchema(
      id: -8234783745496610211,
      name: r'presentIkVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'presentTenseIkWordLink',
    ),
    r'presentJijVraagVerbs': LinkSchema(
      id: -5135423320330883408,
      name: r'presentJijVraagVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'presentTenseJijVraagWordLink',
    ),
    r'presentJijVerbs': LinkSchema(
      id: -3260467922314165846,
      name: r'presentJijVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'presentTenseJijWordLink',
    ),
    r'presentUVerbs': LinkSchema(
      id: 8475409024159787567,
      name: r'presentUVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'presentTenseUWordLink',
    ),
    r'presentHijZijHetVerbs': LinkSchema(
      id: -4022779025579163246,
      name: r'presentHijZijHetVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'presentTenseHijZijHetWordLink',
    ),
    r'presentWijVerbs': LinkSchema(
      id: -3702925717203282022,
      name: r'presentWijVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'presentTenseWijWordLink',
    ),
    r'presentJullieVerbs': LinkSchema(
      id: 8437193898956494008,
      name: r'presentJullieVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'presentTenseJullieWordLink',
    ),
    r'presentZijVerbs': LinkSchema(
      id: -469375496626317184,
      name: r'presentZijVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'presentTenseZijWordLink',
    ),
    r'pastIkVerbs': LinkSchema(
      id: 3163609402973007197,
      name: r'pastIkVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'pastTenseIkWordLink',
    ),
    r'pastJijVerbs': LinkSchema(
      id: 7447375991199634003,
      name: r'pastJijVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'pastTenseJijWordLink',
    ),
    r'pastHijZijHetVerbs': LinkSchema(
      id: 1506938080121978269,
      name: r'pastHijZijHetVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'pastTenseHijZijHetWordLink',
    ),
    r'pastWijVerbs': LinkSchema(
      id: -8162402807878604074,
      name: r'pastWijVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'pastTenseWijWordLink',
    ),
    r'pastJullieVerbs': LinkSchema(
      id: -6702451901109988356,
      name: r'pastJullieVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'pastTenseJullieWordLink',
    ),
    r'pastZijVerbs': LinkSchema(
      id: 7039030132262526367,
      name: r'pastZijVerbs',
      target: r'DbWordVerbDetails',
      single: false,
      linkName: r'pastTenseZijWordLink',
    )
  },
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
  {
    final value = object.audioCode;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
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
  object.audioCode = reader.readStringOrNull(offsets[0]);
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
      return (reader.readStringOrNull(offset)) as P;
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
  return [
    object.words,
    object.pluralFormWords,
    object.diminutiveWords,
    object.infinitiveVerbs,
    object.completedParticiples,
    object.auxiliaryVerbs,
    object.imperativeInformalVerbs,
    object.imperativeFormalVerbs,
    object.presentParticipleInflectedVerbs,
    object.presentParticipleUninflectedVerbs,
    object.presentIkVerbs,
    object.presentJijVraagVerbs,
    object.presentJijVerbs,
    object.presentUVerbs,
    object.presentHijZijHetVerbs,
    object.presentWijVerbs,
    object.presentJullieVerbs,
    object.presentZijVerbs,
    object.pastIkVerbs,
    object.pastJijVerbs,
    object.pastHijZijHetVerbs,
    object.pastWijVerbs,
    object.pastJullieVerbs,
    object.pastZijVerbs
  ];
}

void _dbDutchWordAttach(
    IsarCollection<dynamic> col, Id id, DbDutchWord object) {
  object.id = id;
  object.words.attach(col, col.isar.collection<DbWord>(), r'words', id);
  object.pluralFormWords.attach(
      col, col.isar.collection<DbWordNounDetails>(), r'pluralFormWords', id);
  object.diminutiveWords.attach(
      col, col.isar.collection<DbWordNounDetails>(), r'diminutiveWords', id);
  object.infinitiveVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'infinitiveVerbs', id);
  object.completedParticiples.attach(col,
      col.isar.collection<DbWordVerbDetails>(), r'completedParticiples', id);
  object.auxiliaryVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'auxiliaryVerbs', id);
  object.imperativeInformalVerbs.attach(col,
      col.isar.collection<DbWordVerbDetails>(), r'imperativeInformalVerbs', id);
  object.imperativeFormalVerbs.attach(col,
      col.isar.collection<DbWordVerbDetails>(), r'imperativeFormalVerbs', id);
  object.presentParticipleInflectedVerbs.attach(
      col,
      col.isar.collection<DbWordVerbDetails>(),
      r'presentParticipleInflectedVerbs',
      id);
  object.presentParticipleUninflectedVerbs.attach(
      col,
      col.isar.collection<DbWordVerbDetails>(),
      r'presentParticipleUninflectedVerbs',
      id);
  object.presentIkVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'presentIkVerbs', id);
  object.presentJijVraagVerbs.attach(col,
      col.isar.collection<DbWordVerbDetails>(), r'presentJijVraagVerbs', id);
  object.presentJijVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'presentJijVerbs', id);
  object.presentUVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'presentUVerbs', id);
  object.presentHijZijHetVerbs.attach(col,
      col.isar.collection<DbWordVerbDetails>(), r'presentHijZijHetVerbs', id);
  object.presentWijVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'presentWijVerbs', id);
  object.presentJullieVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'presentJullieVerbs', id);
  object.presentZijVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'presentZijVerbs', id);
  object.pastIkVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'pastIkVerbs', id);
  object.pastJijVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'pastJijVerbs', id);
  object.pastHijZijHetVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'pastHijZijHetVerbs', id);
  object.pastWijVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'pastWijVerbs', id);
  object.pastJullieVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'pastJullieVerbs', id);
  object.pastZijVerbs.attach(
      col, col.isar.collection<DbWordVerbDetails>(), r'pastZijVerbs', id);
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
      audioCodeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'audioCode',
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'audioCode',
      ));
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeEqualTo(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeGreaterThan(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeLessThan(
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      audioCodeBetween(
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
    on QueryBuilder<DbDutchWord, DbDutchWord, QFilterCondition> {
  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> words(
      FilterQuery<DbWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'words');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      wordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> wordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      wordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      wordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      wordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'words', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
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

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> pluralFormWords(
      FilterQuery<DbWordNounDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pluralFormWords');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pluralFormWordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pluralFormWords', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pluralFormWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pluralFormWords', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pluralFormWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pluralFormWords', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pluralFormWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pluralFormWords', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pluralFormWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pluralFormWords', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pluralFormWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pluralFormWords', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> diminutiveWords(
      FilterQuery<DbWordNounDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'diminutiveWords');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      diminutiveWordsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'diminutiveWords', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      diminutiveWordsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'diminutiveWords', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      diminutiveWordsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'diminutiveWords', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      diminutiveWordsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'diminutiveWords', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      diminutiveWordsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'diminutiveWords', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      diminutiveWordsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'diminutiveWords', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> infinitiveVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'infinitiveVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      infinitiveVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'infinitiveVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      infinitiveVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'infinitiveVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      infinitiveVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'infinitiveVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      infinitiveVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'infinitiveVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      infinitiveVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'infinitiveVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      infinitiveVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'infinitiveVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      completedParticiples(FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'completedParticiples');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      completedParticiplesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'completedParticiples', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      completedParticiplesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completedParticiples', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      completedParticiplesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completedParticiples', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      completedParticiplesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'completedParticiples', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      completedParticiplesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'completedParticiples', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      completedParticiplesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'completedParticiples', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> auxiliaryVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'auxiliaryVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      auxiliaryVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'auxiliaryVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      auxiliaryVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'auxiliaryVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      auxiliaryVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'auxiliaryVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      auxiliaryVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'auxiliaryVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      auxiliaryVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'auxiliaryVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      auxiliaryVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'auxiliaryVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeInformalVerbs(FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'imperativeInformalVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeInformalVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'imperativeInformalVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeInformalVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'imperativeInformalVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeInformalVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'imperativeInformalVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeInformalVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'imperativeInformalVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeInformalVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'imperativeInformalVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeInformalVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'imperativeInformalVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeFormalVerbs(FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'imperativeFormalVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeFormalVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'imperativeFormalVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeFormalVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'imperativeFormalVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeFormalVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'imperativeFormalVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeFormalVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'imperativeFormalVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeFormalVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'imperativeFormalVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      imperativeFormalVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'imperativeFormalVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleInflectedVerbs(FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentParticipleInflectedVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleInflectedVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleInflectedVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleInflectedVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleInflectedVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleInflectedVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleInflectedVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleInflectedVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleInflectedVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleInflectedVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleInflectedVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleInflectedVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentParticipleInflectedVerbs', lower,
          includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleUninflectedVerbs(FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentParticipleUninflectedVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleUninflectedVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleUninflectedVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleUninflectedVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleUninflectedVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleUninflectedVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleUninflectedVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleUninflectedVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleUninflectedVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleUninflectedVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleUninflectedVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentParticipleUninflectedVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentParticipleUninflectedVerbs', lower,
          includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> presentIkVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentIkVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentIkVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentIkVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentIkVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentIkVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentIkVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentIkVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentIkVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentIkVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentIkVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentIkVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentIkVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentIkVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVraagVerbs(FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentJijVraagVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVraagVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentJijVraagVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVraagVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentJijVraagVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVraagVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentJijVraagVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVraagVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentJijVraagVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVraagVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentJijVraagVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVraagVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentJijVraagVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> presentJijVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentJijVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentJijVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentJijVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentJijVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentJijVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentJijVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJijVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentJijVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> presentUVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentUVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentUVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentUVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentUVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentUVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentUVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentUVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentUVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentUVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentUVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentUVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentUVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentUVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentHijZijHetVerbs(FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentHijZijHetVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentHijZijHetVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentHijZijHetVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentHijZijHetVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentHijZijHetVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentHijZijHetVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentHijZijHetVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentHijZijHetVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentHijZijHetVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentHijZijHetVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentHijZijHetVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentHijZijHetVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentHijZijHetVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> presentWijVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentWijVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentWijVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentWijVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentWijVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentWijVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentWijVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentWijVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentWijVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentWijVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentWijVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentWijVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentWijVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentWijVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJullieVerbs(FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentJullieVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJullieVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentJullieVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJullieVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentJullieVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJullieVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentJullieVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJullieVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentJullieVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJullieVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentJullieVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentJullieVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentJullieVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> presentZijVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentZijVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentZijVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentZijVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentZijVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentZijVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentZijVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentZijVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentZijVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentZijVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentZijVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentZijVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      presentZijVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentZijVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> pastIkVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastIkVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastIkVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastIkVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastIkVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastIkVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastIkVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastIkVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastIkVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastIkVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastIkVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastIkVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastIkVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pastIkVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> pastJijVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastJijVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJijVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastJijVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJijVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastJijVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJijVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastJijVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJijVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastJijVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJijVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastJijVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJijVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pastJijVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastHijZijHetVerbs(FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastHijZijHetVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastHijZijHetVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pastHijZijHetVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastHijZijHetVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastHijZijHetVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastHijZijHetVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastHijZijHetVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastHijZijHetVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastHijZijHetVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastHijZijHetVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pastHijZijHetVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastHijZijHetVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pastHijZijHetVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> pastWijVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastWijVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastWijVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastWijVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastWijVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastWijVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastWijVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastWijVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastWijVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastWijVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastWijVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastWijVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastWijVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pastWijVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> pastJullieVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastJullieVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJullieVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastJullieVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJullieVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastJullieVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJullieVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastJullieVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJullieVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastJullieVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJullieVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pastJullieVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastJullieVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pastJullieVerbs', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition> pastZijVerbs(
      FilterQuery<DbWordVerbDetails> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastZijVerbs');
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastZijVerbsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastZijVerbs', length, true, length, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastZijVerbsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastZijVerbs', 0, true, 0, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastZijVerbsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastZijVerbs', 0, false, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastZijVerbsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastZijVerbs', 0, true, length, include);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastZijVerbsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastZijVerbs', length, include, 999999, true);
    });
  }

  QueryBuilder<DbDutchWord, DbDutchWord, QAfterFilterCondition>
      pastZijVerbsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'pastZijVerbs', lower, includeLower, upper, includeUpper);
    });
  }
}

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

  QueryBuilder<DbDutchWord, String?, QQueryOperations> audioCodeProperty() {
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
