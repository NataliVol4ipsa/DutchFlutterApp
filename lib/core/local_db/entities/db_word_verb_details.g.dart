// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_word_verb_details.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDbWordVerbDetailsCollection on Isar {
  IsarCollection<DbWordVerbDetails> get dbWordVerbDetails => this.collection();
}

const DbWordVerbDetailsSchema = CollectionSchema(
  name: r'DbWordVerbDetails',
  id: 3393824139196805836,
  properties: {},
  estimateSize: _dbWordVerbDetailsEstimateSize,
  serialize: _dbWordVerbDetailsSerialize,
  deserialize: _dbWordVerbDetailsDeserialize,
  deserializeProp: _dbWordVerbDetailsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _dbWordVerbDetailsGetId,
  getLinks: _dbWordVerbDetailsGetLinks,
  attach: _dbWordVerbDetailsAttach,
  version: '3.1.0+1',
);

int _dbWordVerbDetailsEstimateSize(
  DbWordVerbDetails object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dbWordVerbDetailsSerialize(
  DbWordVerbDetails object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {}
DbWordVerbDetails _dbWordVerbDetailsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DbWordVerbDetails();
  object.id = id;
  return object;
}

P _dbWordVerbDetailsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dbWordVerbDetailsGetId(DbWordVerbDetails object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dbWordVerbDetailsGetLinks(
    DbWordVerbDetails object) {
  return [];
}

void _dbWordVerbDetailsAttach(
    IsarCollection<dynamic> col, Id id, DbWordVerbDetails object) {
  object.id = id;
}

extension DbWordVerbDetailsQueryWhereSort
    on QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QWhere> {
  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DbWordVerbDetailsQueryWhere
    on QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QWhereClause> {
  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterWhereClause>
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

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterWhereClause>
      idBetween(
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

extension DbWordVerbDetailsQueryFilter
    on QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QFilterCondition> {
  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
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

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
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

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      idBetween(
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
}

extension DbWordVerbDetailsQueryObject
    on QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QFilterCondition> {}

extension DbWordVerbDetailsQueryLinks
    on QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QFilterCondition> {}

extension DbWordVerbDetailsQuerySortBy
    on QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QSortBy> {}

extension DbWordVerbDetailsQuerySortThenBy
    on QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QSortThenBy> {
  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DbWordVerbDetailsQueryWhereDistinct
    on QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QDistinct> {}

extension DbWordVerbDetailsQueryProperty
    on QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QQueryProperty> {
  QueryBuilder<DbWordVerbDetails, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }
}
