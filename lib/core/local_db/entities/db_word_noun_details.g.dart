// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'db_word_noun_details.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDbWordNounDetailsCollection on Isar {
  IsarCollection<DbWordNounDetails> get dbWordNounDetails => this.collection();
}

const DbWordNounDetailsSchema = CollectionSchema(
  name: r'DbWordNounDetails',
  id: -8698838510644924431,
  properties: {
    r'deHet': PropertySchema(
      id: 0,
      name: r'deHet',
      type: IsarType.byte,
      enumMap: _DbWordNounDetailsdeHetEnumValueMap,
    )
  },
  estimateSize: _dbWordNounDetailsEstimateSize,
  serialize: _dbWordNounDetailsSerialize,
  deserialize: _dbWordNounDetailsDeserialize,
  deserializeProp: _dbWordNounDetailsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'pluralFormWordLink': LinkSchema(
      id: 6152691643258032883,
      name: r'pluralFormWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'diminutiveWordLink': LinkSchema(
      id: -4634521518231499657,
      name: r'diminutiveWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'wordLink': LinkSchema(
      id: -6618022876907777054,
      name: r'wordLink',
      target: r'DbWord',
      single: true,
      linkName: r'nounDetailsLink',
    )
  },
  embeddedSchemas: {},
  getId: _dbWordNounDetailsGetId,
  getLinks: _dbWordNounDetailsGetLinks,
  attach: _dbWordNounDetailsAttach,
  version: '3.1.0+1',
);

int _dbWordNounDetailsEstimateSize(
  DbWordNounDetails object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dbWordNounDetailsSerialize(
  DbWordNounDetails object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeByte(offsets[0], object.deHet.index);
}

DbWordNounDetails _dbWordNounDetailsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DbWordNounDetails();
  object.deHet =
      _DbWordNounDetailsdeHetValueEnumMap[reader.readByteOrNull(offsets[0])] ??
          DeHetType.none;
  object.id = id;
  return object;
}

P _dbWordNounDetailsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (_DbWordNounDetailsdeHetValueEnumMap[
              reader.readByteOrNull(offset)] ??
          DeHetType.none) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DbWordNounDetailsdeHetEnumValueMap = {
  'none': 0,
  'de': 1,
  'het': 2,
};
const _DbWordNounDetailsdeHetValueEnumMap = {
  0: DeHetType.none,
  1: DeHetType.de,
  2: DeHetType.het,
};

Id _dbWordNounDetailsGetId(DbWordNounDetails object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _dbWordNounDetailsGetLinks(
    DbWordNounDetails object) {
  return [
    object.pluralFormWordLink,
    object.diminutiveWordLink,
    object.wordLink
  ];
}

void _dbWordNounDetailsAttach(
    IsarCollection<dynamic> col, Id id, DbWordNounDetails object) {
  object.id = id;
  object.pluralFormWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'pluralFormWordLink', id);
  object.diminutiveWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'diminutiveWordLink', id);
  object.wordLink.attach(col, col.isar.collection<DbWord>(), r'wordLink', id);
}

extension DbWordNounDetailsQueryWhereSort
    on QueryBuilder<DbWordNounDetails, DbWordNounDetails, QWhere> {
  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DbWordNounDetailsQueryWhere
    on QueryBuilder<DbWordNounDetails, DbWordNounDetails, QWhereClause> {
  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterWhereClause>
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

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterWhereClause>
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

extension DbWordNounDetailsQueryFilter
    on QueryBuilder<DbWordNounDetails, DbWordNounDetails, QFilterCondition> {
  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      deHetEqualTo(DeHetType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deHet',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      deHetGreaterThan(
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

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      deHetLessThan(
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

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      deHetBetween(
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

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
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

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
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

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
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

extension DbWordNounDetailsQueryObject
    on QueryBuilder<DbWordNounDetails, DbWordNounDetails, QFilterCondition> {}

extension DbWordNounDetailsQueryLinks
    on QueryBuilder<DbWordNounDetails, DbWordNounDetails, QFilterCondition> {
  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      pluralFormWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pluralFormWordLink');
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      pluralFormWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pluralFormWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      diminutiveWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'diminutiveWordLink');
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      diminutiveWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'diminutiveWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      wordLink(FilterQuery<DbWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'wordLink');
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterFilterCondition>
      wordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'wordLink', 0, true, 0, true);
    });
  }
}

extension DbWordNounDetailsQuerySortBy
    on QueryBuilder<DbWordNounDetails, DbWordNounDetails, QSortBy> {
  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterSortBy>
      sortByDeHet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deHet', Sort.asc);
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterSortBy>
      sortByDeHetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deHet', Sort.desc);
    });
  }
}

extension DbWordNounDetailsQuerySortThenBy
    on QueryBuilder<DbWordNounDetails, DbWordNounDetails, QSortThenBy> {
  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterSortBy>
      thenByDeHet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deHet', Sort.asc);
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterSortBy>
      thenByDeHetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deHet', Sort.desc);
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }
}

extension DbWordNounDetailsQueryWhereDistinct
    on QueryBuilder<DbWordNounDetails, DbWordNounDetails, QDistinct> {
  QueryBuilder<DbWordNounDetails, DbWordNounDetails, QDistinct>
      distinctByDeHet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deHet');
    });
  }
}

extension DbWordNounDetailsQueryProperty
    on QueryBuilder<DbWordNounDetails, DbWordNounDetails, QQueryProperty> {
  QueryBuilder<DbWordNounDetails, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DbWordNounDetails, DeHetType, QQueryOperations> deHetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deHet');
    });
  }
}
