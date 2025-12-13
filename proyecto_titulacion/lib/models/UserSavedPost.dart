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


/** This is an auto generated class representing the UserSavedPost type in your schema. */
class UserSavedPost extends amplify_core.Model {
  static const classType = const _UserSavedPostModelType();
  final String id;
  final String? _userId;
  final String? _postId;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final Post? _post;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserSavedPostModelIdentifier get modelIdentifier {
      return UserSavedPostModelIdentifier(
        id: id
      );
  }
  
  String get userId {
    try {
      return _userId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get postId {
    try {
      return _postId!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
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
  
  Post? get post {
    return _post;
  }
  
  const UserSavedPost._internal({required this.id, required userId, required postId, required createdAt, required updatedAt, post}): _userId = userId, _postId = postId, _createdAt = createdAt, _updatedAt = updatedAt, _post = post;
  
  factory UserSavedPost({String? id, required String userId, required String postId, required amplify_core.TemporalDateTime createdAt, required amplify_core.TemporalDateTime updatedAt, Post? post}) {
    return UserSavedPost._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userId: userId,
      postId: postId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      post: post);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserSavedPost &&
      id == other.id &&
      _userId == other._userId &&
      _postId == other._postId &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt &&
      _post == other._post;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserSavedPost {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userId=" + "$_userId" + ", ");
    buffer.write("postId=" + "$_postId" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserSavedPost copyWith({String? userId, String? postId, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, Post? post}) {
    return UserSavedPost._internal(
      id: id,
      userId: userId ?? this.userId,
      postId: postId ?? this.postId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      post: post ?? this.post);
  }
  
  UserSavedPost copyWithModelFieldValues({
    ModelFieldValue<String>? userId,
    ModelFieldValue<String>? postId,
    ModelFieldValue<amplify_core.TemporalDateTime>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime>? updatedAt,
    ModelFieldValue<Post?>? post
  }) {
    return UserSavedPost._internal(
      id: id,
      userId: userId == null ? this.userId : userId.value,
      postId: postId == null ? this.postId : postId.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
      post: post == null ? this.post : post.value
    );
  }
  
  UserSavedPost.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userId = json['userId'],
      _postId = json['postId'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _post = json['post'] != null
        ? json['post']['serializedData'] != null
          ? Post.fromJson(new Map<String, dynamic>.from(json['post']['serializedData']))
          : Post.fromJson(new Map<String, dynamic>.from(json['post']))
        : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userId': _userId, 'postId': _postId, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'post': _post?.toJson()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userId': _userId,
    'postId': _postId,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'post': _post
  };

  static final amplify_core.QueryModelIdentifier<UserSavedPostModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserSavedPostModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERID = amplify_core.QueryField(fieldName: "userId");
  static final POSTID = amplify_core.QueryField(fieldName: "postId");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final POST = amplify_core.QueryField(
    fieldName: "post",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Post'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserSavedPost";
    modelSchemaDefinition.pluralName = "UserSavedPosts";
    
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
      key: UserSavedPost.USERID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserSavedPost.POSTID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserSavedPost.CREATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserSavedPost.UPDATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: UserSavedPost.POST,
      isRequired: false,
      ofModelName: 'Post',
      associatedKey: Post.ID
    ));
  });
}

class _UserSavedPostModelType extends amplify_core.ModelType<UserSavedPost> {
  const _UserSavedPostModelType();
  
  @override
  UserSavedPost fromJson(Map<String, dynamic> jsonData) {
    return UserSavedPost.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserSavedPost';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserSavedPost] in your schema.
 */
class UserSavedPostModelIdentifier implements amplify_core.ModelIdentifier<UserSavedPost> {
  final String id;

  /** Create an instance of UserSavedPostModelIdentifier using [id] the primary key. */
  const UserSavedPostModelIdentifier({
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
  String toString() => 'UserSavedPostModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserSavedPostModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}