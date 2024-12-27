// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_word_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDbWordProgressCollection on Isar {
  IsarCollection<DbWordProgress> get dbWordProgress => this.collection();
}

const DbWordProgressSchema = CollectionSchema(
  name: r'DbWordProgress',
  id: -3375110943617339225,
  properties: {
    r'correctAnswers': PropertySchema(
      id: 0,
      name: r'correctAnswers',
      type: IsarType.long,
    ),
    r'dontShowAgain': PropertySchema(
      id: 1,
      name: r'dontShowAgain',
      type: IsarType.bool,
    ),
    r'exerciseType': PropertySchema(
      id: 2,
      name: r'exerciseType',
      type: IsarType.byte,
      enumMap: _DbWordProgressexerciseTypeEnumValueMap,
    ),
    r'lastPracticed': PropertySchema(
      id: 3,
      name: r'lastPracticed',
      type: IsarType.dateTime,
    ),
    r'wrongAnswers': PropertySchema(
      id: 4,
      name: r'wrongAnswers',
      type: IsarType.long,
    )
  },
  estimateSize: _dbWordProgressEstimateSize,
  serialize: _dbWordProgressSerialize,
  deserialize: _dbWordProgressDeserialize,
  deserializeProp: _dbWordProgressDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'word': LinkSchema(
      id: -9079802764190181655,
      name: r'word',
      target: r'DbWord',
      single: true,
    )
  },
  embeddedSchemas: {},
  getId: _dbWordProgressGetId,
  getLinks: _dbWordProgressGetLinks,
  attach: _dbWordProgressAttach,
  version: '3.1.0+1',
);

int _dbWordProgressEstimateSize(
  DbWordProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dbWordProgressSerialize(
  DbWordProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.correctAnswers);
  writer.writeBool(offsets[1], object.dontShowAgain);
  writer.writeByte(offsets[2], object.exerciseType.index);
  writer.writeDateTime(offsets[3], object.lastPracticed);
  writer.writeLong(offsets[4], object.wrongAnswers);
}

DbWordProgress _dbWordProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DbWordProgress();
  object.correctAnswers = reader.readLong(offsets[0]);
  object.dontShowAgain = reader.readBool(offsets[1]);
  object.exerciseType = _DbWordProgressexerciseTypeValueEnumMap[
          reader.readByteOrNull(offsets[2])] ??
      ExerciseType.flipCard;
  object.id = id;
  object.lastPracticed = reader.readDateTimeOrNull(offsets[3]);
  object.wrongAnswers = reader.readLong(offsets[4]);
  return object;
}

P _dbWordProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readBool(offset)) as P;
    case 2:
      return (_DbWordProgressexerciseTypeValueEnumMap[
              reader.readByteOrNull(offset)] ??
          ExerciseType.flipCard) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DbWordProgressexerciseTypeEnumValueMap = {
  'flipCard': 0,
  'basicWrite': 1,
  'deHetPick': 2,
  'pluralFormPick': 3,
  'pluralFormWrite': 4,
  'basicOnePick': 5,
  'basicManyPick': 6,
};
const _DbWordProgressexerciseTypeValueEnumMap = {
  0: ExerciseType.flipCard,
  1: ExerciseType.basicWrite,
  2: ExerciseType.deHetPick,
  3: ExerciseType.pluralFormPick,
  4: ExerciseType.pluralFormWrite,
  5: ExerciseType.basicOnePick,
  6: ExerciseType.basicManyPick,
};

Id _dbWordProgressGetId(DbWordProgress object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dbWordProgressGetLinks(DbWordProgress object) {
  return [object.word];
}

void _dbWordProgressAttach(
    IsarCollection<dynamic> col, Id id, DbWordProgress object) {
  object.id = id;
  object.word.attach(col, col.isar.collection<DbWord>(), r'word', id);
}

extension DbWordProgressQueryWhereSort
    on QueryBuilder<DbWordProgress, DbWordProgress, QWhere> {
  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DbWordProgressQueryWhere
    on QueryBuilder<DbWordProgress, DbWordProgress, QWhereClause> {
  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause> idBetween(
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

extension DbWordProgressQueryFilter
    on QueryBuilder<DbWordProgress, DbWordProgress, QFilterCondition> {
  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      correctAnswersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'correctAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      correctAnswersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'correctAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      correctAnswersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'correctAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      correctAnswersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'correctAnswers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      dontShowAgainEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dontShowAgain',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      exerciseTypeEqualTo(ExerciseType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'exerciseType',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      exerciseTypeGreaterThan(
    ExerciseType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'exerciseType',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      exerciseTypeLessThan(
    ExerciseType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'exerciseType',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      exerciseTypeBetween(
    ExerciseType lower,
    ExerciseType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'exerciseType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
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

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      lastPracticedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastPracticed',
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      lastPracticedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastPracticed',
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      lastPracticedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastPracticed',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      lastPracticedGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastPracticed',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      lastPracticedLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastPracticed',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      lastPracticedBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastPracticed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      wrongAnswersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrongAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      wrongAnswersGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wrongAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      wrongAnswersLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wrongAnswers',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      wrongAnswersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wrongAnswers',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DbWordProgressQueryObject
    on QueryBuilder<DbWordProgress, DbWordProgress, QFilterCondition> {}

extension DbWordProgressQueryLinks
    on QueryBuilder<DbWordProgress, DbWordProgress, QFilterCondition> {
  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition> word(
      FilterQuery<DbWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'word');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
      wordIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'word', 0, true, 0, true);
    });
  }
}

extension DbWordProgressQuerySortBy
    on QueryBuilder<DbWordProgress, DbWordProgress, QSortBy> {
  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      sortByCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctAnswers', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      sortByCorrectAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctAnswers', Sort.desc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      sortByDontShowAgain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontShowAgain', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      sortByDontShowAgainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontShowAgain', Sort.desc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      sortByExerciseType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseType', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      sortByExerciseTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseType', Sort.desc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      sortByLastPracticed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticed', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      sortByLastPracticedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticed', Sort.desc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      sortByWrongAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrongAnswers', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      sortByWrongAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrongAnswers', Sort.desc);
    });
  }
}

extension DbWordProgressQuerySortThenBy
    on QueryBuilder<DbWordProgress, DbWordProgress, QSortThenBy> {
  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      thenByCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctAnswers', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      thenByCorrectAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctAnswers', Sort.desc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      thenByDontShowAgain() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontShowAgain', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      thenByDontShowAgainDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dontShowAgain', Sort.desc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      thenByExerciseType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseType', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      thenByExerciseTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'exerciseType', Sort.desc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      thenByLastPracticed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticed', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      thenByLastPracticedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastPracticed', Sort.desc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      thenByWrongAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrongAnswers', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
      thenByWrongAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrongAnswers', Sort.desc);
    });
  }
}

extension DbWordProgressQueryWhereDistinct
    on QueryBuilder<DbWordProgress, DbWordProgress, QDistinct> {
  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
      distinctByCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correctAnswers');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
      distinctByDontShowAgain() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dontShowAgain');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
      distinctByExerciseType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseType');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
      distinctByLastPracticed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPracticed');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
      distinctByWrongAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wrongAnswers');
    });
  }
}

extension DbWordProgressQueryProperty
    on QueryBuilder<DbWordProgress, DbWordProgress, QQueryProperty> {
  QueryBuilder<DbWordProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DbWordProgress, int, QQueryOperations> correctAnswersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correctAnswers');
    });
  }

  QueryBuilder<DbWordProgress, bool, QQueryOperations> dontShowAgainProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dontShowAgain');
    });
  }

  QueryBuilder<DbWordProgress, ExerciseType, QQueryOperations>
      exerciseTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseType');
    });
  }

  QueryBuilder<DbWordProgress, DateTime?, QQueryOperations>
      lastPracticedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPracticed');
    });
  }

  QueryBuilder<DbWordProgress, int, QQueryOperations> wrongAnswersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wrongAnswers');
    });
  }
}
