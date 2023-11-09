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

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the InstitutionShuttleTimeTable type in your schema. */
class InstitutionShuttleTimeTable {
  final String? _INSTITUTION_ID;
  final String? _IMAGE_URL;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  String get INSTITUTION_ID {
    try {
      return _INSTITUTION_ID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get IMAGE_URL {
    return _IMAGE_URL;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const InstitutionShuttleTimeTable._internal({required INSTITUTION_ID, IMAGE_URL, createdAt, updatedAt}): _INSTITUTION_ID = INSTITUTION_ID, _IMAGE_URL = IMAGE_URL, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory InstitutionShuttleTimeTable({required String INSTITUTION_ID, String? IMAGE_URL, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionShuttleTimeTable._internal(
      INSTITUTION_ID: INSTITUTION_ID,
      IMAGE_URL: IMAGE_URL,
      createdAt: createdAt,
      updatedAt: updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InstitutionShuttleTimeTable &&
      _INSTITUTION_ID == other._INSTITUTION_ID &&
      _IMAGE_URL == other._IMAGE_URL &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("InstitutionShuttleTimeTable {");
    buffer.write("INSTITUTION_ID=" + "$_INSTITUTION_ID" + ", ");
    buffer.write("IMAGE_URL=" + "$_IMAGE_URL" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  InstitutionShuttleTimeTable copyWith({String? INSTITUTION_ID, String? IMAGE_URL, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt}) {
    return InstitutionShuttleTimeTable._internal(
      INSTITUTION_ID: INSTITUTION_ID ?? this.INSTITUTION_ID,
      IMAGE_URL: IMAGE_URL ?? this.IMAGE_URL,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  InstitutionShuttleTimeTable copyWithModelFieldValues({
    ModelFieldValue<String>? INSTITUTION_ID,
    ModelFieldValue<String?>? IMAGE_URL,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt
  }) {
    return InstitutionShuttleTimeTable._internal(
      INSTITUTION_ID: INSTITUTION_ID == null ? this.INSTITUTION_ID : INSTITUTION_ID.value,
      IMAGE_URL: IMAGE_URL == null ? this.IMAGE_URL : IMAGE_URL.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value
    );
  }
  
  InstitutionShuttleTimeTable.fromJson(Map<String, dynamic> json)  
    : _INSTITUTION_ID = json['INSTITUTION_ID'],
      _IMAGE_URL = json['IMAGE_URL'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'INSTITUTION_ID': _INSTITUTION_ID, 'IMAGE_URL': _IMAGE_URL, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'INSTITUTION_ID': _INSTITUTION_ID,
    'IMAGE_URL': _IMAGE_URL,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "InstitutionShuttleTimeTable";
    modelSchemaDefinition.pluralName = "InstitutionShuttleTimeTables";
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'INSTITUTION_ID',
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'IMAGE_URL',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'createdAt',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.customTypeField(
      fieldName: 'updatedAt',
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}