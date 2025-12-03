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

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;


/** This is an auto generated class representing the TagCatalog type in your schema. */
class TagCatalog extends amplify_core.Model {
  static const classType = const _TagCatalogModelType();
  final String id;
  final String? _label;
  final String? _value;
  final String? _iconName;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  TagCatalogModelIdentifier get modelIdentifier {
      return TagCatalogModelIdentifier(
        id: id
      );
  }
  
  String get label {
    try {
      return _label!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get value {
    try {
      return _value!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get iconName {
    return _iconName;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const TagCatalog._internal({required this.id, required label, required value, iconName, createdAt, updatedAt}): _label = label, _value = value, _iconName = iconName, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory TagCatalog({String? id, required String label, required String value, String? iconName}) {
    return TagCatalog._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      label: label,
      value: value,
      iconName: iconName);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TagCatalog &&
      id == other.id &&
      _label == other._label &&
      _value == other._value &&
      _iconName == other._iconName;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("TagCatalog {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("label=" + "$_label" + ", ");
    buffer.write("value=" + "$_value" + ", ");
    buffer.write("iconName=" + "$_iconName" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  TagCatalog copyWith({String? label, String? value, String? iconName}) {
    return TagCatalog._internal(
      id: id,
      label: label ?? this.label,
      value: value ?? this.value,
      iconName: iconName ?? this.iconName);
  }
  
  TagCatalog copyWithModelFieldValues({
    ModelFieldValue<String>? label,
    ModelFieldValue<String>? value,
    ModelFieldValue<String?>? iconName
  }) {
    return TagCatalog._internal(
      id: id,
      label: label == null ? this.label : label.value,
      value: value == null ? this.value : value.value,
      iconName: iconName == null ? this.iconName : iconName.value
    );
  }
  
  TagCatalog.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _label = json['label'],
      _value = json['value'],
      _iconName = json['iconName'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'label': _label, 'value': _value, 'iconName': _iconName, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'label': _label,
    'value': _value,
    'iconName': _iconName,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<TagCatalogModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<TagCatalogModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final LABEL = amplify_core.QueryField(fieldName: "label");
  static final VALUE = amplify_core.QueryField(fieldName: "value");
  static final ICONNAME = amplify_core.QueryField(fieldName: "iconName");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TagCatalog";
    modelSchemaDefinition.pluralName = "TagCatalogs";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: TagCatalog.LABEL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: TagCatalog.VALUE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: TagCatalog.ICONNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _TagCatalogModelType extends amplify_core.ModelType<TagCatalog> {
  const _TagCatalogModelType();
  
  @override
  TagCatalog fromJson(Map<String, dynamic> jsonData) {
    return TagCatalog.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'TagCatalog';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [TagCatalog] in your schema.
 */
class TagCatalogModelIdentifier implements amplify_core.ModelIdentifier<TagCatalog> {
  final String id;

  /** Create an instance of TagCatalogModelIdentifier using [id] the primary key. */
  const TagCatalogModelIdentifier({
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
  String toString() => 'TagCatalogModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is TagCatalogModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}