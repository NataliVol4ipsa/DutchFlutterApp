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
  links: {
    r'infinitiveWordLink': LinkSchema(
      id: -6869018904746690929,
      name: r'infinitiveWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'completedParticipleWordLink': LinkSchema(
      id: 2925586776349908944,
      name: r'completedParticipleWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'auxiliaryVerbWordLink': LinkSchema(
      id: -5416583608631941957,
      name: r'auxiliaryVerbWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'imperativeInformalWordLink': LinkSchema(
      id: 2526322179776357605,
      name: r'imperativeInformalWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'imperativeFormalWordLink': LinkSchema(
      id: -2582388636105809405,
      name: r'imperativeFormalWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'presentParticipleInflectedWordLink': LinkSchema(
      id: -957063975582349306,
      name: r'presentParticipleInflectedWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'presentParticipleUninflectedWordLink': LinkSchema(
      id: -4066882692891584544,
      name: r'presentParticipleUninflectedWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'presentTenseIkWordLink': LinkSchema(
      id: 1132262491728583645,
      name: r'presentTenseIkWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'presentTenseJijVraagWordLink': LinkSchema(
      id: 6080994870735691119,
      name: r'presentTenseJijVraagWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'presentTenseJijWordLink': LinkSchema(
      id: 6046332180716145527,
      name: r'presentTenseJijWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'presentTenseUWordLink': LinkSchema(
      id: 367695985700668419,
      name: r'presentTenseUWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'presentTenseHijZijHetWordLink': LinkSchema(
      id: 5341215205920297925,
      name: r'presentTenseHijZijHetWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'presentTenseWijWordLink': LinkSchema(
      id: -4144995450280634094,
      name: r'presentTenseWijWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'presentTenseJullieWordLink': LinkSchema(
      id: 8989526346177713088,
      name: r'presentTenseJullieWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'presentTenseZijWordLink': LinkSchema(
      id: 4920168097231411324,
      name: r'presentTenseZijWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'pastTenseIkWordLink': LinkSchema(
      id: 2410542549093834804,
      name: r'pastTenseIkWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'pastTenseJijWordLink': LinkSchema(
      id: -6521227507500288815,
      name: r'pastTenseJijWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'pastTenseHijZijHetWordLink': LinkSchema(
      id: -4185507879591423848,
      name: r'pastTenseHijZijHetWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'pastTenseWijWordLink': LinkSchema(
      id: -6406801222160768798,
      name: r'pastTenseWijWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'pastTenseJullieWordLink': LinkSchema(
      id: -2981284127217257686,
      name: r'pastTenseJullieWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'pastTenseZijWordLink': LinkSchema(
      id: -818166472771055977,
      name: r'pastTenseZijWordLink',
      target: r'DbDutchWord',
      single: true,
    ),
    r'wordLink': LinkSchema(
      id: -8002486889839183342,
      name: r'wordLink',
      target: r'DbWord',
      single: true,
      linkName: r'verbDetailsLink',
    )
  },
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
  return [
    object.infinitiveWordLink,
    object.completedParticipleWordLink,
    object.auxiliaryVerbWordLink,
    object.imperativeInformalWordLink,
    object.imperativeFormalWordLink,
    object.presentParticipleInflectedWordLink,
    object.presentParticipleUninflectedWordLink,
    object.presentTenseIkWordLink,
    object.presentTenseJijVraagWordLink,
    object.presentTenseJijWordLink,
    object.presentTenseUWordLink,
    object.presentTenseHijZijHetWordLink,
    object.presentTenseWijWordLink,
    object.presentTenseJullieWordLink,
    object.presentTenseZijWordLink,
    object.pastTenseIkWordLink,
    object.pastTenseJijWordLink,
    object.pastTenseHijZijHetWordLink,
    object.pastTenseWijWordLink,
    object.pastTenseJullieWordLink,
    object.pastTenseZijWordLink,
    object.wordLink
  ];
}

void _dbWordVerbDetailsAttach(
    IsarCollection<dynamic> col, Id id, DbWordVerbDetails object) {
  object.id = id;
  object.infinitiveWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'infinitiveWordLink', id);
  object.completedParticipleWordLink.attach(col,
      col.isar.collection<DbDutchWord>(), r'completedParticipleWordLink', id);
  object.auxiliaryVerbWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'auxiliaryVerbWordLink', id);
  object.imperativeInformalWordLink.attach(col,
      col.isar.collection<DbDutchWord>(), r'imperativeInformalWordLink', id);
  object.imperativeFormalWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'imperativeFormalWordLink', id);
  object.presentParticipleInflectedWordLink.attach(
      col,
      col.isar.collection<DbDutchWord>(),
      r'presentParticipleInflectedWordLink',
      id);
  object.presentParticipleUninflectedWordLink.attach(
      col,
      col.isar.collection<DbDutchWord>(),
      r'presentParticipleUninflectedWordLink',
      id);
  object.presentTenseIkWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'presentTenseIkWordLink', id);
  object.presentTenseJijVraagWordLink.attach(col,
      col.isar.collection<DbDutchWord>(), r'presentTenseJijVraagWordLink', id);
  object.presentTenseJijWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'presentTenseJijWordLink', id);
  object.presentTenseUWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'presentTenseUWordLink', id);
  object.presentTenseHijZijHetWordLink.attach(col,
      col.isar.collection<DbDutchWord>(), r'presentTenseHijZijHetWordLink', id);
  object.presentTenseWijWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'presentTenseWijWordLink', id);
  object.presentTenseJullieWordLink.attach(col,
      col.isar.collection<DbDutchWord>(), r'presentTenseJullieWordLink', id);
  object.presentTenseZijWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'presentTenseZijWordLink', id);
  object.pastTenseIkWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'pastTenseIkWordLink', id);
  object.pastTenseJijWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'pastTenseJijWordLink', id);
  object.pastTenseHijZijHetWordLink.attach(col,
      col.isar.collection<DbDutchWord>(), r'pastTenseHijZijHetWordLink', id);
  object.pastTenseWijWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'pastTenseWijWordLink', id);
  object.pastTenseJullieWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'pastTenseJullieWordLink', id);
  object.pastTenseZijWordLink.attach(
      col, col.isar.collection<DbDutchWord>(), r'pastTenseZijWordLink', id);
  object.wordLink.attach(col, col.isar.collection<DbWord>(), r'wordLink', id);
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
    on QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QFilterCondition> {
  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      infinitiveWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'infinitiveWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      infinitiveWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'infinitiveWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      completedParticipleWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'completedParticipleWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      completedParticipleWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'completedParticipleWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      auxiliaryVerbWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'auxiliaryVerbWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      auxiliaryVerbWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'auxiliaryVerbWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      imperativeInformalWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'imperativeInformalWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      imperativeInformalWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'imperativeInformalWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      imperativeFormalWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'imperativeFormalWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      imperativeFormalWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'imperativeFormalWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentParticipleInflectedWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentParticipleInflectedWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentParticipleInflectedWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleInflectedWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentParticipleUninflectedWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentParticipleUninflectedWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentParticipleUninflectedWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentParticipleUninflectedWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseIkWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentTenseIkWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseIkWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentTenseIkWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseJijVraagWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentTenseJijVraagWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseJijVraagWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentTenseJijVraagWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseJijWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentTenseJijWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseJijWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentTenseJijWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseUWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentTenseUWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseUWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentTenseUWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseHijZijHetWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentTenseHijZijHetWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseHijZijHetWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'presentTenseHijZijHetWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseWijWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentTenseWijWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseWijWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentTenseWijWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseJullieWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentTenseJullieWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseJullieWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentTenseJullieWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseZijWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'presentTenseZijWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      presentTenseZijWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'presentTenseZijWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseIkWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastTenseIkWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseIkWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastTenseIkWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseJijWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastTenseJijWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseJijWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastTenseJijWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseHijZijHetWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastTenseHijZijHetWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseHijZijHetWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastTenseHijZijHetWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseWijWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastTenseWijWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseWijWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastTenseWijWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseJullieWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastTenseJullieWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseJullieWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastTenseJullieWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseZijWordLink(FilterQuery<DbDutchWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'pastTenseZijWordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      pastTenseZijWordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'pastTenseZijWordLink', 0, true, 0, true);
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      wordLink(FilterQuery<DbWord> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'wordLink');
    });
  }

  QueryBuilder<DbWordVerbDetails, DbWordVerbDetails, QAfterFilterCondition>
      wordLinkIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'wordLink', 0, true, 0, true);
    });
  }
}

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
