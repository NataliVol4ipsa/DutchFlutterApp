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
    r'consequetiveCorrectAnswers': PropertySchema(
      id: 0,
      name: r'consequetiveCorrectAnswers',
      type: IsarType.long,
    ),
    r'dontShowAgain': PropertySchema(
      id: 1,
      name: r'dontShowAgain',
      type: IsarType.bool,
    ),
    r'easinessFactor': PropertySchema(
      id: 2,
      name: r'easinessFactor',
      type: IsarType.double,
    ),
    r'exerciseType': PropertySchema(
      id: 3,
      name: r'exerciseType',
      type: IsarType.byte,
      enumMap: _DbWordProgressexerciseTypeEnumValueMap,
    ),
    r'intervalDays': PropertySchema(
      id: 4,
      name: r'intervalDays',
      type: IsarType.long,
    ),
    r'lastPracticed': PropertySchema(
      id: 5,
      name: r'lastPracticed',
      type: IsarType.dateTime,
    ),
    r'nextReviewDate': PropertySchema(
      id: 6,
      name: r'nextReviewDate',
      type: IsarType.dateTime,
    ),
  },
  estimateSize: _dbWordProgressEstimateSize,
  serialize: _dbWordProgressSerialize,
  deserialize: _dbWordProgressDeserialize,
  deserializeProp: _dbWordProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'nextReviewDate': IndexSchema(
      id: 4152658090540413903,
      name: r'nextReviewDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'nextReviewDate',
          type: IndexType.value,
          caseSensitive: false,
        ),
      ],
    ),
  },
  links: {
    r'word': LinkSchema(
      id: -9079802764190181655,
      name: r'word',
      target: r'DbWord',
      single: true,
    ),
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
  writer.writeLong(offsets[0], object.consequetiveCorrectAnswers);
  writer.writeBool(offsets[1], object.dontShowAgain);
  writer.writeDouble(offsets[2], object.easinessFactor);
  writer.writeByte(offsets[3], object.exerciseType.index);
  writer.writeLong(offsets[4], object.intervalDays);
  writer.writeDateTime(offsets[5], object.lastPracticed);
  writer.writeDateTime(offsets[6], object.nextReviewDate);
}

DbWordProgress _dbWordProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DbWordProgress();
  object.consequetiveCorrectAnswers = reader.readLong(offsets[0]);
  object.dontShowAgain = reader.readBool(offsets[1]);
  object.easinessFactor = reader.readDouble(offsets[2]);
  object.exerciseType =
      _DbWordProgressexerciseTypeValueEnumMap[reader.readByteOrNull(
        offsets[3],
      )] ??
      ExerciseTypeDetailed.flipCardDutchEnglish;
  object.id = id;
  object.intervalDays = reader.readLong(offsets[4]);
  object.lastPracticed = reader.readDateTimeOrNull(offsets[5]);
  object.nextReviewDate = reader.readDateTime(offsets[6]);
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
      return (reader.readDouble(offset)) as P;
    case 3:
      return (_DbWordProgressexerciseTypeValueEnumMap[reader.readByteOrNull(
                offset,
              )] ??
              ExerciseTypeDetailed.flipCardDutchEnglish)
          as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DbWordProgressexerciseTypeEnumValueMap = {
  'flipCardDutchEnglish': 0,
  'flipCardEnglishDutch': 1,
  'deHetPick': 2,
  'basicWrite': 3,
};
const _DbWordProgressexerciseTypeValueEnumMap = {
  0: ExerciseTypeDetailed.flipCardDutchEnglish,
  1: ExerciseTypeDetailed.flipCardEnglishDutch,
  2: ExerciseTypeDetailed.deHetPick,
  3: ExerciseTypeDetailed.basicWrite,
};

Id _dbWordProgressGetId(DbWordProgress object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dbWordProgressGetLinks(DbWordProgress object) {
  return [object.word];
}

void _dbWordProgressAttach(
  IsarCollection<dynamic> col,
  Id id,
  DbWordProgress object,
) {
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

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhere>
  anyNextReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'nextReviewDate'),
      );
    });
  }
}

extension DbWordProgressQueryWhere
    on QueryBuilder<DbWordProgress, DbWordProgress, QWhereClause> {
  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause> idEqualTo(
    Id id,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
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
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause>
  nextReviewDateEqualTo(DateTime nextReviewDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.equalTo(
          indexName: r'nextReviewDate',
          value: [nextReviewDate],
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause>
  nextReviewDateNotEqualTo(DateTime nextReviewDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nextReviewDate',
                lower: [],
                upper: [nextReviewDate],
                includeUpper: false,
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nextReviewDate',
                lower: [nextReviewDate],
                includeLower: false,
                upper: [],
              ),
            );
      } else {
        return query
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nextReviewDate',
                lower: [nextReviewDate],
                includeLower: false,
                upper: [],
              ),
            )
            .addWhereClause(
              IndexWhereClause.between(
                indexName: r'nextReviewDate',
                lower: [],
                upper: [nextReviewDate],
                includeUpper: false,
              ),
            );
      }
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause>
  nextReviewDateGreaterThan(DateTime nextReviewDate, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'nextReviewDate',
          lower: [nextReviewDate],
          includeLower: include,
          upper: [],
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause>
  nextReviewDateLessThan(DateTime nextReviewDate, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'nextReviewDate',
          lower: [],
          upper: [nextReviewDate],
          includeUpper: include,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterWhereClause>
  nextReviewDateBetween(
    DateTime lowerNextReviewDate,
    DateTime upperNextReviewDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IndexWhereClause.between(
          indexName: r'nextReviewDate',
          lower: [lowerNextReviewDate],
          includeLower: includeLower,
          upper: [upperNextReviewDate],
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DbWordProgressQueryFilter
    on QueryBuilder<DbWordProgress, DbWordProgress, QFilterCondition> {
  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  consequetiveCorrectAnswersEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'consequetiveCorrectAnswers',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  consequetiveCorrectAnswersGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'consequetiveCorrectAnswers',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  consequetiveCorrectAnswersLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'consequetiveCorrectAnswers',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  consequetiveCorrectAnswersBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'consequetiveCorrectAnswers',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  dontShowAgainEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'dontShowAgain', value: value),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  easinessFactorEqualTo(double value, {double epsilon = Query.epsilon}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'easinessFactor',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  easinessFactorGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'easinessFactor',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  easinessFactorLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'easinessFactor',
          value: value,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  easinessFactorBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'easinessFactor',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          epsilon: epsilon,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  exerciseTypeEqualTo(ExerciseTypeDetailed value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'exerciseType', value: value),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  exerciseTypeGreaterThan(ExerciseTypeDetailed value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'exerciseType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  exerciseTypeLessThan(ExerciseTypeDetailed value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'exerciseType',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  exerciseTypeBetween(
    ExerciseTypeDetailed lower,
    ExerciseTypeDetailed upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'exerciseType',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'id'),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'id'),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition> idEqualTo(
    Id? value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  idGreaterThan(Id? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  idLessThan(Id? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  intervalDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'intervalDays', value: value),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  intervalDaysGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'intervalDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  intervalDaysLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'intervalDays',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  intervalDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'intervalDays',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  lastPracticedIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastPracticed'),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  lastPracticedIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastPracticed'),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  lastPracticedEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastPracticed', value: value),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  lastPracticedGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastPracticed',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  lastPracticedLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastPracticed',
          value: value,
        ),
      );
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
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastPracticed',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  nextReviewDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'nextReviewDate', value: value),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  nextReviewDateGreaterThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'nextReviewDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  nextReviewDateLessThan(DateTime value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'nextReviewDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition>
  nextReviewDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'nextReviewDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension DbWordProgressQueryObject
    on QueryBuilder<DbWordProgress, DbWordProgress, QFilterCondition> {}

extension DbWordProgressQueryLinks
    on QueryBuilder<DbWordProgress, DbWordProgress, QFilterCondition> {
  QueryBuilder<DbWordProgress, DbWordProgress, QAfterFilterCondition> word(
    FilterQuery<DbWord> q,
  ) {
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
  sortByConsequetiveCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consequetiveCorrectAnswers', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
  sortByConsequetiveCorrectAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consequetiveCorrectAnswers', Sort.desc);
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
  sortByEasinessFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easinessFactor', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
  sortByEasinessFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easinessFactor', Sort.desc);
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
  sortByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
  sortByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
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
  sortByNextReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewDate', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
  sortByNextReviewDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewDate', Sort.desc);
    });
  }
}

extension DbWordProgressQuerySortThenBy
    on QueryBuilder<DbWordProgress, DbWordProgress, QSortThenBy> {
  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
  thenByConsequetiveCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consequetiveCorrectAnswers', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
  thenByConsequetiveCorrectAnswersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'consequetiveCorrectAnswers', Sort.desc);
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
  thenByEasinessFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easinessFactor', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
  thenByEasinessFactorDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'easinessFactor', Sort.desc);
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
  thenByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
  thenByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
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
  thenByNextReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewDate', Sort.asc);
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QAfterSortBy>
  thenByNextReviewDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewDate', Sort.desc);
    });
  }
}

extension DbWordProgressQueryWhereDistinct
    on QueryBuilder<DbWordProgress, DbWordProgress, QDistinct> {
  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
  distinctByConsequetiveCorrectAnswers() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'consequetiveCorrectAnswers');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
  distinctByDontShowAgain() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dontShowAgain');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
  distinctByEasinessFactor() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'easinessFactor');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
  distinctByExerciseType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'exerciseType');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
  distinctByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalDays');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
  distinctByLastPracticed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastPracticed');
    });
  }

  QueryBuilder<DbWordProgress, DbWordProgress, QDistinct>
  distinctByNextReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextReviewDate');
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

  QueryBuilder<DbWordProgress, int, QQueryOperations>
  consequetiveCorrectAnswersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'consequetiveCorrectAnswers');
    });
  }

  QueryBuilder<DbWordProgress, bool, QQueryOperations> dontShowAgainProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dontShowAgain');
    });
  }

  QueryBuilder<DbWordProgress, double, QQueryOperations>
  easinessFactorProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'easinessFactor');
    });
  }

  QueryBuilder<DbWordProgress, ExerciseTypeDetailed, QQueryOperations>
  exerciseTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'exerciseType');
    });
  }

  QueryBuilder<DbWordProgress, int, QQueryOperations> intervalDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalDays');
    });
  }

  QueryBuilder<DbWordProgress, DateTime?, QQueryOperations>
  lastPracticedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastPracticed');
    });
  }

  QueryBuilder<DbWordProgress, DateTime, QQueryOperations>
  nextReviewDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextReviewDate');
    });
  }
}
