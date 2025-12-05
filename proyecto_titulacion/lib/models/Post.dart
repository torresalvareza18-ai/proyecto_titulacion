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
import 'package:collection/collection.dart';


/** This is an auto generated class representing the Post type in your schema. */
class Post extends amplify_core.Model {
  static const classType = const _PostModelType();
  final String id;
  final String? _type;
  final String? _title;
  final String? _description;
  final List<String>? _images;
  final List<String>? _tags;
  final List<amplify_core.TemporalDate>? _dates;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final String? _authorId;
  final String? _authorName;
  final String? _authorMiddle;
  final String? _authorFamily;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  PostModelIdentifier get modelIdentifier {
      return PostModelIdentifier(
        id: id
      );
  }
  
  String? get type {
    return _type;
  }
  
  String get title {
    try {
      return _title!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get description {
    try {
      return _description!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<String>? get images {
    return _images;
  }
  
  List<String>? get tags {
    return _tags;
  }
  
  List<amplify_core.TemporalDate>? get dates {
    return _dates;
  }
  
  amplify_core.TemporalDateTime get createdAt {
    try {
      return _createdAt!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get updatedAt {
    try {
      return _updatedAt!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get authorId {
    try {
      return _authorId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get authorName {
    return _authorName;
  }
  
  String? get authorMiddle {
    return _authorMiddle;
  }
  
  String? get authorFamily {
    return _authorFamily;
  }
  
  const Post._internal({required this.id, type, required title, required description, images, tags, dates, required createdAt, required updatedAt, required authorId, authorName, authorMiddle, authorFamily}): _type = type, _title = title, _description = description, _images = images, _tags = tags, _dates = dates, _createdAt = createdAt, _updatedAt = updatedAt, _authorId = authorId, _authorName = authorName, _authorMiddle = authorMiddle, _authorFamily = authorFamily;
  
  factory Post({String? id, String? type, required String title, required String description, List<String>? images, List<String>? tags, List<amplify_core.TemporalDate>? dates, required amplify_core.TemporalDateTime createdAt, required amplify_core.TemporalDateTime updatedAt, required String authorId, String? authorName, String? authorMiddle, String? authorFamily}) {
    return Post._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      type: type,
      title: title,
      description: description,
      images: images != null ? List<String>.unmodifiable(images) : images,
      tags: tags != null ? List<String>.unmodifiable(tags) : tags,
      dates: dates != null ? List<amplify_core.TemporalDate>.unmodifiable(dates) : dates,
      createdAt: createdAt,
      updatedAt: updatedAt,
      authorId: authorId,
      authorName: authorName,
      authorMiddle: authorMiddle,
      authorFamily: authorFamily);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Post &&
      id == other.id &&
      _type == other._type &&
      _title == other._title &&
      _description == other._description &&
      DeepCollectionEquality().equals(_images, other._images) &&
      DeepCollectionEquality().equals(_tags, other._tags) &&
      DeepCollectionEquality().equals(_dates, other._dates) &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt &&
      _authorId == other._authorId &&
      _authorName == other._authorName &&
      _authorMiddle == other._authorMiddle &&
      _authorFamily == other._authorFamily;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Post {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("type=" + "$_type" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("images=" + (_images != null ? _images!.toString() : "null") + ", ");
    buffer.write("tags=" + (_tags != null ? _tags!.toString() : "null") + ", ");
    buffer.write("dates=" + (_dates != null ? _dates!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("authorId=" + "$_authorId" + ", ");
    buffer.write("authorName=" + "$_authorName" + ", ");
    buffer.write("authorMiddle=" + "$_authorMiddle" + ", ");
    buffer.write("authorFamily=" + "$_authorFamily");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Post copyWith({String? type, String? title, String? description, List<String>? images, List<String>? tags, List<amplify_core.TemporalDate>? dates, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, String? authorId, String? authorName, String? authorMiddle, String? authorFamily}) {
    return Post._internal(
      id: id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      images: images ?? this.images,
      tags: tags ?? this.tags,
      dates: dates ?? this.dates,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      authorId: authorId ?? this.authorId,
      authorName: authorName ?? this.authorName,
      authorMiddle: authorMiddle ?? this.authorMiddle,
      authorFamily: authorFamily ?? this.authorFamily);
  }
  
  Post copyWithModelFieldValues({
    ModelFieldValue<String?>? type,
    ModelFieldValue<String>? title,
    ModelFieldValue<String>? description,
    ModelFieldValue<List<String>?>? images,
    ModelFieldValue<List<String>?>? tags,
    ModelFieldValue<List<amplify_core.TemporalDate>?>? dates,
    ModelFieldValue<amplify_core.TemporalDateTime>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime>? updatedAt,
    ModelFieldValue<String>? authorId,
    ModelFieldValue<String?>? authorName,
    ModelFieldValue<String?>? authorMiddle,
    ModelFieldValue<String?>? authorFamily
  }) {
    return Post._internal(
      id: id,
      type: type == null ? this.type : type.value,
      title: title == null ? this.title : title.value,
      description: description == null ? this.description : description.value,
      images: images == null ? this.images : images.value,
      tags: tags == null ? this.tags : tags.value,
      dates: dates == null ? this.dates : dates.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
      authorId: authorId == null ? this.authorId : authorId.value,
      authorName: authorName == null ? this.authorName : authorName.value,
      authorMiddle: authorMiddle == null ? this.authorMiddle : authorMiddle.value,
      authorFamily: authorFamily == null ? this.authorFamily : authorFamily.value
    );
  }
  
  Post.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _type = json['type'],
      _title = json['title'],
      _description = json['description'],
      _images = json['images']?.cast<String>(),
      _tags = json['tags']?.cast<String>(),
      _dates = (json['dates'] as List?)?.map((e) => amplify_core.TemporalDate.fromString(e)).toList(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _authorId = json['authorId'],
      _authorName = json['authorName'],
      _authorMiddle = json['authorMiddle'],
      _authorFamily = json['authorFamily'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'type': _type, 'title': _title, 'description': _description, 'images': _images, 'tags': _tags, 'dates': _dates?.map((e) => e.format()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'authorId': _authorId, 'authorName': _authorName, 'authorMiddle': _authorMiddle, 'authorFamily': _authorFamily
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'type': _type,
    'title': _title,
    'description': _description,
    'images': _images,
    'tags': _tags,
    'dates': _dates,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'authorId': _authorId,
    'authorName': _authorName,
    'authorMiddle': _authorMiddle,
    'authorFamily': _authorFamily
  };

  static final amplify_core.QueryModelIdentifier<PostModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<PostModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final IMAGES = amplify_core.QueryField(fieldName: "images");
  static final TAGS = amplify_core.QueryField(fieldName: "tags");
  static final DATES = amplify_core.QueryField(fieldName: "dates");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final AUTHORID = amplify_core.QueryField(fieldName: "authorId");
  static final AUTHORNAME = amplify_core.QueryField(fieldName: "authorName");
  static final AUTHORMIDDLE = amplify_core.QueryField(fieldName: "authorMiddle");
  static final AUTHORFAMILY = amplify_core.QueryField(fieldName: "authorFamily");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Post";
    modelSchemaDefinition.pluralName = "Posts";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        operations: const [
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["type", "createdAt"], name: "postsByDate")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.TYPE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.TITLE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.DESCRIPTION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.IMAGES,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.TAGS,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.DATES,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.date.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.CREATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.UPDATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.AUTHORID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.AUTHORNAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.AUTHORMIDDLE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Post.AUTHORFAMILY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}

class _PostModelType extends amplify_core.ModelType<Post> {
  const _PostModelType();
  
  @override
  Post fromJson(Map<String, dynamic> jsonData) {
    return Post.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Post';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Post] in your schema.
 */
class PostModelIdentifier implements amplify_core.ModelIdentifier<Post> {
  final String id;

  /** Create an instance of PostModelIdentifier using [id] the primary key. */
  const PostModelIdentifier({
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
  String toString() => 'PostModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is PostModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}