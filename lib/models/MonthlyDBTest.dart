/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the MonthlyDBTest type in your schema. */
@immutable
class MonthlyDBTest extends Model {
  static const classType = const _MonthlyDBTestModelType();
  final String id;
  final String? _month;
  final int? _total_time;
  final int? _avg_att;
  final int? _avg_med;
  final String? _firsts_name;
  final int? _first_amt;
  final String? _second_name;
  final int? _second_amt;
  final int? _con_score;
  final int? _spacetime_score;
  final int? _exec_score;
  final int? _mem_score;
  final int? _ling_score;
  final int? _cal_score;
  final int? _reac_score;
  final int? _orient_score;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MonthlyDBTestModelIdentifier get modelIdentifier {
      return MonthlyDBTestModelIdentifier(
        id: id
      );
  }
  
  String get month {
    try {
      return _month!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int? get total_time {
    return _total_time;
  }
  
  int? get avg_att {
    return _avg_att;
  }
  
  int? get avg_med {
    return _avg_med;
  }
  
  String? get firsts_name {
    return _firsts_name;
  }
  
  int? get first_amt {
    return _first_amt;
  }
  
  String? get second_name {
    return _second_name;
  }
  
  int? get second_amt {
    return _second_amt;
  }
  
  int? get con_score {
    return _con_score;
  }
  
  int? get spacetime_score {
    return _spacetime_score;
  }
  
  int? get exec_score {
    return _exec_score;
  }
  
  int? get mem_score {
    return _mem_score;
  }
  
  int? get ling_score {
    return _ling_score;
  }
  
  int? get cal_score {
    return _cal_score;
  }
  
  int? get reac_score {
    return _reac_score;
  }
  
  int? get orient_score {
    return _orient_score;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const MonthlyDBTest._internal({required this.id, required month, total_time, avg_att, avg_med, firsts_name, first_amt, second_name, second_amt, con_score, spacetime_score, exec_score, mem_score, ling_score, cal_score, reac_score, orient_score, createdAt, updatedAt}): _month = month, _total_time = total_time, _avg_att = avg_att, _avg_med = avg_med, _firsts_name = firsts_name, _first_amt = first_amt, _second_name = second_name, _second_amt = second_amt, _con_score = con_score, _spacetime_score = spacetime_score, _exec_score = exec_score, _mem_score = mem_score, _ling_score = ling_score, _cal_score = cal_score, _reac_score = reac_score, _orient_score = orient_score, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory MonthlyDBTest({String? id, required String month, int? total_time, int? avg_att, int? avg_med, String? firsts_name, int? first_amt, String? second_name, int? second_amt, int? con_score, int? spacetime_score, int? exec_score, int? mem_score, int? ling_score, int? cal_score, int? reac_score, int? orient_score}) {
    return MonthlyDBTest._internal(
      id: id == null ? UUID.getUUID() : id,
      month: month,
      total_time: total_time,
      avg_att: avg_att,
      avg_med: avg_med,
      firsts_name: firsts_name,
      first_amt: first_amt,
      second_name: second_name,
      second_amt: second_amt,
      con_score: con_score,
      spacetime_score: spacetime_score,
      exec_score: exec_score,
      mem_score: mem_score,
      ling_score: ling_score,
      cal_score: cal_score,
      reac_score: reac_score,
      orient_score: orient_score);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MonthlyDBTest &&
      id == other.id &&
      _month == other._month &&
      _total_time == other._total_time &&
      _avg_att == other._avg_att &&
      _avg_med == other._avg_med &&
      _firsts_name == other._firsts_name &&
      _first_amt == other._first_amt &&
      _second_name == other._second_name &&
      _second_amt == other._second_amt &&
      _con_score == other._con_score &&
      _spacetime_score == other._spacetime_score &&
      _exec_score == other._exec_score &&
      _mem_score == other._mem_score &&
      _ling_score == other._ling_score &&
      _cal_score == other._cal_score &&
      _reac_score == other._reac_score &&
      _orient_score == other._orient_score;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("MonthlyDBTest {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("month=" + "$_month" + ", ");
    buffer.write("total_time=" + (_total_time != null ? _total_time!.toString() : "null") + ", ");
    buffer.write("avg_att=" + (_avg_att != null ? _avg_att!.toString() : "null") + ", ");
    buffer.write("avg_med=" + (_avg_med != null ? _avg_med!.toString() : "null") + ", ");
    buffer.write("firsts_name=" + "$_firsts_name" + ", ");
    buffer.write("first_amt=" + (_first_amt != null ? _first_amt!.toString() : "null") + ", ");
    buffer.write("second_name=" + "$_second_name" + ", ");
    buffer.write("second_amt=" + (_second_amt != null ? _second_amt!.toString() : "null") + ", ");
    buffer.write("con_score=" + (_con_score != null ? _con_score!.toString() : "null") + ", ");
    buffer.write("spacetime_score=" + (_spacetime_score != null ? _spacetime_score!.toString() : "null") + ", ");
    buffer.write("exec_score=" + (_exec_score != null ? _exec_score!.toString() : "null") + ", ");
    buffer.write("mem_score=" + (_mem_score != null ? _mem_score!.toString() : "null") + ", ");
    buffer.write("ling_score=" + (_ling_score != null ? _ling_score!.toString() : "null") + ", ");
    buffer.write("cal_score=" + (_cal_score != null ? _cal_score!.toString() : "null") + ", ");
    buffer.write("reac_score=" + (_reac_score != null ? _reac_score!.toString() : "null") + ", ");
    buffer.write("orient_score=" + (_orient_score != null ? _orient_score!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  MonthlyDBTest copyWith({String? month, int? total_time, int? avg_att, int? avg_med, String? firsts_name, int? first_amt, String? second_name, int? second_amt, int? con_score, int? spacetime_score, int? exec_score, int? mem_score, int? ling_score, int? cal_score, int? reac_score, int? orient_score}) {
    return MonthlyDBTest._internal(
      id: id,
      month: month ?? this.month,
      total_time: total_time ?? this.total_time,
      avg_att: avg_att ?? this.avg_att,
      avg_med: avg_med ?? this.avg_med,
      firsts_name: firsts_name ?? this.firsts_name,
      first_amt: first_amt ?? this.first_amt,
      second_name: second_name ?? this.second_name,
      second_amt: second_amt ?? this.second_amt,
      con_score: con_score ?? this.con_score,
      spacetime_score: spacetime_score ?? this.spacetime_score,
      exec_score: exec_score ?? this.exec_score,
      mem_score: mem_score ?? this.mem_score,
      ling_score: ling_score ?? this.ling_score,
      cal_score: cal_score ?? this.cal_score,
      reac_score: reac_score ?? this.reac_score,
      orient_score: orient_score ?? this.orient_score);
  }
  
  MonthlyDBTest.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _month = json['month'],
      _total_time = (json['total_time'] as num?)?.toInt(),
      _avg_att = (json['avg_att'] as num?)?.toInt(),
      _avg_med = (json['avg_med'] as num?)?.toInt(),
      _firsts_name = json['firsts_name'],
      _first_amt = (json['first_amt'] as num?)?.toInt(),
      _second_name = json['second_name'],
      _second_amt = (json['second_amt'] as num?)?.toInt(),
      _con_score = (json['con_score'] as num?)?.toInt(),
      _spacetime_score = (json['spacetime_score'] as num?)?.toInt(),
      _exec_score = (json['exec_score'] as num?)?.toInt(),
      _mem_score = (json['mem_score'] as num?)?.toInt(),
      _ling_score = (json['ling_score'] as num?)?.toInt(),
      _cal_score = (json['cal_score'] as num?)?.toInt(),
      _reac_score = (json['reac_score'] as num?)?.toInt(),
      _orient_score = (json['orient_score'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'month': _month, 'total_time': _total_time, 'avg_att': _avg_att, 'avg_med': _avg_med, 'firsts_name': _firsts_name, 'first_amt': _first_amt, 'second_name': _second_name, 'second_amt': _second_amt, 'con_score': _con_score, 'spacetime_score': _spacetime_score, 'exec_score': _exec_score, 'mem_score': _mem_score, 'ling_score': _ling_score, 'cal_score': _cal_score, 'reac_score': _reac_score, 'orient_score': _orient_score, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'month': _month, 'total_time': _total_time, 'avg_att': _avg_att, 'avg_med': _avg_med, 'firsts_name': _firsts_name, 'first_amt': _first_amt, 'second_name': _second_name, 'second_amt': _second_amt, 'con_score': _con_score, 'spacetime_score': _spacetime_score, 'exec_score': _exec_score, 'mem_score': _mem_score, 'ling_score': _ling_score, 'cal_score': _cal_score, 'reac_score': _reac_score, 'orient_score': _orient_score, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryModelIdentifier<MonthlyDBTestModelIdentifier> MODEL_IDENTIFIER = QueryModelIdentifier<MonthlyDBTestModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField MONTH = QueryField(fieldName: "month");
  static final QueryField TOTAL_TIME = QueryField(fieldName: "total_time");
  static final QueryField AVG_ATT = QueryField(fieldName: "avg_att");
  static final QueryField AVG_MED = QueryField(fieldName: "avg_med");
  static final QueryField FIRSTS_NAME = QueryField(fieldName: "firsts_name");
  static final QueryField FIRST_AMT = QueryField(fieldName: "first_amt");
  static final QueryField SECOND_NAME = QueryField(fieldName: "second_name");
  static final QueryField SECOND_AMT = QueryField(fieldName: "second_amt");
  static final QueryField CON_SCORE = QueryField(fieldName: "con_score");
  static final QueryField SPACETIME_SCORE = QueryField(fieldName: "spacetime_score");
  static final QueryField EXEC_SCORE = QueryField(fieldName: "exec_score");
  static final QueryField MEM_SCORE = QueryField(fieldName: "mem_score");
  static final QueryField LING_SCORE = QueryField(fieldName: "ling_score");
  static final QueryField CAL_SCORE = QueryField(fieldName: "cal_score");
  static final QueryField REAC_SCORE = QueryField(fieldName: "reac_score");
  static final QueryField ORIENT_SCORE = QueryField(fieldName: "orient_score");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MonthlyDBTest";
    modelSchemaDefinition.pluralName = "MonthlyDBTests";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.MONTH,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.TOTAL_TIME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.AVG_ATT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.AVG_MED,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.FIRSTS_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.FIRST_AMT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.SECOND_NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.SECOND_AMT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.CON_SCORE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.SPACETIME_SCORE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.EXEC_SCORE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.MEM_SCORE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.LING_SCORE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.CAL_SCORE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.REAC_SCORE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: MonthlyDBTest.ORIENT_SCORE,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _MonthlyDBTestModelType extends ModelType<MonthlyDBTest> {
  const _MonthlyDBTestModelType();
  
  @override
  MonthlyDBTest fromJson(Map<String, dynamic> jsonData) {
    return MonthlyDBTest.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'MonthlyDBTest';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [MonthlyDBTest] in your schema.
 */
@immutable
class MonthlyDBTestModelIdentifier implements ModelIdentifier<MonthlyDBTest> {
  final String id;

  /** Create an instance of MonthlyDBTestModelIdentifier using [id] the primary key. */
  const MonthlyDBTestModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'MonthlyDBTestModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MonthlyDBTestModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}