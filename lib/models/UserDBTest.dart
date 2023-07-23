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


/** This is an auto generated class representing the UserDBTest type in your schema. */
@immutable
class UserDBTest extends Model {
  static const classType = const _UserDBTestModelType();
  final String id;
  final int? _birth;
  final String? _name;
  final String? _organization;
  final String? _sex;
  final TemporalDateTime? _createdAt;
  final TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserDBTestModelIdentifier get modelIdentifier {
      return UserDBTestModelIdentifier(
        id: id
      );
  }
  
  int get birth {
    try {
      return _birth!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get name {
    return _name;
  }
  
  String? get organization {
    return _organization;
  }
  
  String? get sex {
    return _sex;
  }
  
  TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const UserDBTest._internal({required this.id, required birth, name, organization, sex, createdAt, updatedAt}): _birth = birth, _name = name, _organization = organization, _sex = sex, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory UserDBTest({String? id, required int birth, String? name, String? organization, String? sex, TemporalDateTime? createdAt, TemporalDateTime? updatedAt}) {
    return UserDBTest._internal(
      id: id == null ? UUID.getUUID() : id,
      birth: birth,
      name: name,
      organization: organization,
      sex: sex,
      createdAt: createdAt == null? TemporalDateTime.now() : createdAt,
      updatedAt: updatedAt==null? TemporalDateTime.now() : updatedAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserDBTest &&
      id == other.id &&
      _birth == other._birth &&
      _name == other._name &&
      _organization == other._organization &&
      _sex == other._sex &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserDBTest {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("birth=" + (_birth != null ? _birth!.toString() : "null") + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("organization=" + "$_organization" + ", ");
    buffer.write("sex=" + "$_sex" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserDBTest copyWith({int? birth, String? name, String? organization, String? sex, TemporalDateTime? createdAt, TemporalDateTime? updatedAt}) {
    return UserDBTest._internal(
      id: id,
      birth: birth ?? this.birth,
      name: name ?? this.name,
      organization: organization ?? this.organization,
      sex: sex ?? this.sex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt);
  }
  
  UserDBTest.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _birth = (json['birth'] as num?)?.toInt(),
      _name = json['name'],
      _organization = json['organization'],
      _sex = json['sex'],
      _createdAt = json['createdAt'] != null ? TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'birth': _birth, 'name': _name, 'organization': _organization, 'sex': _sex, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id, 'birth': _birth, 'name': _name, 'organization': _organization, 'sex': _sex, 'createdAt': _createdAt, 'updatedAt': _updatedAt
  };

  static final QueryModelIdentifier<UserDBTestModelIdentifier> MODEL_IDENTIFIER = QueryModelIdentifier<UserDBTestModelIdentifier>();
  static final QueryField ID = QueryField(fieldName: "id");
  static final QueryField BIRTH = QueryField(fieldName: "birth");
  static final QueryField NAME = QueryField(fieldName: "name");
  static final QueryField ORGANIZATION = QueryField(fieldName: "organization");
  static final QueryField SEX = QueryField(fieldName: "sex");
  static final QueryField CREATEDAT = QueryField(fieldName: "createdAt");
  static final QueryField UPDATEDAT = QueryField(fieldName: "updatedAt");
  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserDBTest";
    modelSchemaDefinition.pluralName = "UserDBTests";
    
    modelSchemaDefinition.authRules = [
      AuthRule(
        authStrategy: AuthStrategy.PUBLIC,
        operations: [
          ModelOperation.CREATE,
          ModelOperation.UPDATE,
          ModelOperation.DELETE,
          ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserDBTest.BIRTH,
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserDBTest.NAME,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserDBTest.ORGANIZATION,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserDBTest.SEX,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserDBTest.CREATEDAT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.field(
      key: UserDBTest.UPDATEDAT,
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _UserDBTestModelType extends ModelType<UserDBTest> {
  const _UserDBTestModelType();
  
  @override
  UserDBTest fromJson(Map<String, dynamic> jsonData) {
    return UserDBTest.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserDBTest';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserDBTest] in your schema.
 */
@immutable
class UserDBTestModelIdentifier implements ModelIdentifier<UserDBTest> {
  final String id;

  /** Create an instance of UserDBTestModelIdentifier using [id] the primary key. */
  const UserDBTestModelIdentifier({
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
  String toString() => 'UserDBTestModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserDBTestModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}