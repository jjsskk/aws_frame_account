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

import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'MonthlyDBTest.dart';
import 'Test.dart';
import 'Todo.dart';
import 'UserDBTest.dart';
import 'InstitutionAnnouncementTable.dart';
import 'InstitutionAnnouncementTableConnection.dart';
import 'InstitutionCommentBoardTable.dart';
import 'InstitutionCommentBoardTableConnection.dart';
import 'InstitutionCommentConversationTable.dart';
import 'InstitutionCommentConversationTableConnection.dart';
import 'InstitutionEssentialCareTable.dart';
import 'InstitutionEssentialCareTableConnection.dart';
import 'InstitutionEventScheduleTable.dart';
import 'InstitutionEventScheduleTableConnection.dart';
import 'InstitutionFoodTable.dart';
import 'InstitutionFoodTableConnection.dart';
import 'InstitutionNewsTable.dart';
import 'InstitutionNewsTableConnection.dart';
import 'InstitutionShuttleTimeTable.dart';
import 'InstitutionShuttleTimeTableConnection.dart';

export 'InstitutionAnnouncementTable.dart';
export 'InstitutionAnnouncementTableConnection.dart';
export 'InstitutionCommentBoardTable.dart';
export 'InstitutionCommentBoardTableConnection.dart';
export 'InstitutionCommentConversationTable.dart';
export 'InstitutionCommentConversationTableConnection.dart';
export 'InstitutionEssentialCareTable.dart';
export 'InstitutionEssentialCareTableConnection.dart';
export 'InstitutionEventScheduleTable.dart';
export 'InstitutionEventScheduleTableConnection.dart';
export 'InstitutionFoodTable.dart';
export 'InstitutionFoodTableConnection.dart';
export 'InstitutionNewsTable.dart';
export 'InstitutionNewsTableConnection.dart';
export 'InstitutionShuttleTimeTable.dart';
export 'InstitutionShuttleTimeTableConnection.dart';
export 'MonthlyDBTest.dart';
export 'Test.dart';
export 'Todo.dart';
export 'UserDBTest.dart';

class ModelProvider implements amplify_core.ModelProviderInterface {
  @override
  String version = "ac66706c4ff4123ac22042b708a85755";
  @override
  List<amplify_core.ModelSchema> modelSchemas = [MonthlyDBTest.schema, Test.schema, Todo.schema, UserDBTest.schema];
  @override
  List<amplify_core.ModelSchema> customTypeSchemas = [InstitutionAnnouncementTable.schema, InstitutionAnnouncementTableConnection.schema, InstitutionCommentBoardTable.schema, InstitutionCommentBoardTableConnection.schema, InstitutionCommentConversationTable.schema, InstitutionCommentConversationTableConnection.schema, InstitutionEssentialCareTable.schema, InstitutionEssentialCareTableConnection.schema, InstitutionEventScheduleTable.schema, InstitutionEventScheduleTableConnection.schema, InstitutionFoodTable.schema, InstitutionFoodTableConnection.schema, InstitutionNewsTable.schema, InstitutionNewsTableConnection.schema, InstitutionShuttleTimeTable.schema, InstitutionShuttleTimeTableConnection.schema];
  static final ModelProvider _instance = ModelProvider();

  static ModelProvider get instance => _instance;
  
  amplify_core.ModelType getModelTypeByModelName(String modelName) {
    switch(modelName) {
      case "MonthlyDBTest":
        return MonthlyDBTest.classType;
      case "Test":
        return Test.classType;
      case "Todo":
        return Todo.classType;
      case "UserDBTest":
        return UserDBTest.classType;
      default:
        throw Exception("Failed to find model in model provider for model name: " + modelName);
    }
  }
}


class ModelFieldValue<T> {
  const ModelFieldValue.value(this.value);

  final T value;
}
