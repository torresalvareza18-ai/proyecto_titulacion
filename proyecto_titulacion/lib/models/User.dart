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


/** This is an auto generated class representing the User type in your schema. */
class User extends amplify_core.Model {
  static const classType = const _UserModelType();
  final String id;
  final String? _email;
  final String? _name;
  final String? _avatarUrl;
  final List<String>? _preferences;
  final String? _fcmToken;
  final String? _snsEndpointsArn;
  final String? _subscriptionArn;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final List<Notifications>? _notifications;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserModelIdentifier get modelIdentifier {
      return UserModelIdentifier(
        id: id
      );
  }
  
  String get email {
    try {
      return _email!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get name {
    return _name;
  }
  
  String? get avatarUrl {
    return _avatarUrl;
  }
  
  List<String>? get preferences {
    return _preferences;
  }
  
  String? get fcmToken {
    return _fcmToken;
  }
  
  String? get snsEndpointsArn {
    return _snsEndpointsArn;
  }
  
  String? get subscriptionArn {
    return _subscriptionArn;
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
  
  List<Notifications>? get notifications {
    return _notifications;
  }
  
  const User._internal({required this.id, required email, name, avatarUrl, preferences, fcmToken, snsEndpointsArn, subscriptionArn, required createdAt, required updatedAt, notifications}): _email = email, _name = name, _avatarUrl = avatarUrl, _preferences = preferences, _fcmToken = fcmToken, _snsEndpointsArn = snsEndpointsArn, _subscriptionArn = subscriptionArn, _createdAt = createdAt, _updatedAt = updatedAt, _notifications = notifications;
  
  factory User({String? id, required String email, String? name, String? avatarUrl, List<String>? preferences, String? fcmToken, String? snsEndpointsArn, String? subscriptionArn, required amplify_core.TemporalDateTime createdAt, required amplify_core.TemporalDateTime updatedAt, List<Notifications>? notifications}) {
    return User._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      email: email,
      name: name,
      avatarUrl: avatarUrl,
      preferences: preferences != null ? List<String>.unmodifiable(preferences) : preferences,
      fcmToken: fcmToken,
      snsEndpointsArn: snsEndpointsArn,
      subscriptionArn: subscriptionArn,
      createdAt: createdAt,
      updatedAt: updatedAt,
      notifications: notifications != null ? List<Notifications>.unmodifiable(notifications) : notifications);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is User &&
      id == other.id &&
      _email == other._email &&
      _name == other._name &&
      _avatarUrl == other._avatarUrl &&
      DeepCollectionEquality().equals(_preferences, other._preferences) &&
      _fcmToken == other._fcmToken &&
      _snsEndpointsArn == other._snsEndpointsArn &&
      _subscriptionArn == other._subscriptionArn &&
      _createdAt == other._createdAt &&
      _updatedAt == other._updatedAt &&
      DeepCollectionEquality().equals(_notifications, other._notifications);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("User {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("email=" + "$_email" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("avatarUrl=" + "$_avatarUrl" + ", ");
    buffer.write("preferences=" + (_preferences != null ? _preferences!.toString() : "null") + ", ");
    buffer.write("fcmToken=" + "$_fcmToken" + ", ");
    buffer.write("snsEndpointsArn=" + "$_snsEndpointsArn" + ", ");
    buffer.write("subscriptionArn=" + "$_subscriptionArn" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  User copyWith({String? email, String? name, String? avatarUrl, List<String>? preferences, String? fcmToken, String? snsEndpointsArn, String? subscriptionArn, amplify_core.TemporalDateTime? createdAt, amplify_core.TemporalDateTime? updatedAt, List<Notifications>? notifications}) {
    return User._internal(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferences: preferences ?? this.preferences,
      fcmToken: fcmToken ?? this.fcmToken,
      snsEndpointsArn: snsEndpointsArn ?? this.snsEndpointsArn,
      subscriptionArn: subscriptionArn ?? this.subscriptionArn,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notifications: notifications ?? this.notifications);
  }
  
  User copyWithModelFieldValues({
    ModelFieldValue<String>? email,
    ModelFieldValue<String?>? name,
    ModelFieldValue<String?>? avatarUrl,
    ModelFieldValue<List<String>?>? preferences,
    ModelFieldValue<String?>? fcmToken,
    ModelFieldValue<String?>? snsEndpointsArn,
    ModelFieldValue<String?>? subscriptionArn,
    ModelFieldValue<amplify_core.TemporalDateTime>? createdAt,
    ModelFieldValue<amplify_core.TemporalDateTime>? updatedAt,
    ModelFieldValue<List<Notifications>?>? notifications
  }) {
    return User._internal(
      id: id,
      email: email == null ? this.email : email.value,
      name: name == null ? this.name : name.value,
      avatarUrl: avatarUrl == null ? this.avatarUrl : avatarUrl.value,
      preferences: preferences == null ? this.preferences : preferences.value,
      fcmToken: fcmToken == null ? this.fcmToken : fcmToken.value,
      snsEndpointsArn: snsEndpointsArn == null ? this.snsEndpointsArn : snsEndpointsArn.value,
      subscriptionArn: subscriptionArn == null ? this.subscriptionArn : subscriptionArn.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
      notifications: notifications == null ? this.notifications : notifications.value
    );
  }
  
  User.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _email = json['email'],
      _name = json['name'],
      _avatarUrl = json['avatarUrl'],
      _preferences = json['preferences']?.cast<String>(),
      _fcmToken = json['fcmToken'],
      _snsEndpointsArn = json['snsEndpointsArn'],
      _subscriptionArn = json['subscriptionArn'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _notifications = json['notifications']  is Map
        ? (json['notifications']['items'] is List
          ? (json['notifications']['items'] as List)
              .where((e) => e != null)
              .map((e) => Notifications.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['notifications'] is List
          ? (json['notifications'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Notifications.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null);
  
  Map<String, dynamic> toJson() => {
    'id': id, 'email': _email, 'name': _name, 'avatarUrl': _avatarUrl, 'preferences': _preferences, 'fcmToken': _fcmToken, 'snsEndpointsArn': _snsEndpointsArn, 'subscriptionArn': _subscriptionArn, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'notifications': _notifications?.map((Notifications? e) => e?.toJson()).toList()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'email': _email,
    'name': _name,
    'avatarUrl': _avatarUrl,
    'preferences': _preferences,
    'fcmToken': _fcmToken,
    'snsEndpointsArn': _snsEndpointsArn,
    'subscriptionArn': _subscriptionArn,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'notifications': _notifications
  };

  static final amplify_core.QueryModelIdentifier<UserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final EMAIL = amplify_core.QueryField(fieldName: "email");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final AVATARURL = amplify_core.QueryField(fieldName: "avatarUrl");
  static final PREFERENCES = amplify_core.QueryField(fieldName: "preferences");
  static final FCMTOKEN = amplify_core.QueryField(fieldName: "fcmToken");
  static final SNSENDPOINTSARN = amplify_core.QueryField(fieldName: "snsEndpointsArn");
  static final SUBSCRIPTIONARN = amplify_core.QueryField(fieldName: "subscriptionArn");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final NOTIFICATIONS = amplify_core.QueryField(
    fieldName: "notifications",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Notifications'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "User";
    modelSchemaDefinition.pluralName = "Users";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PUBLIC,
        operations: const [
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.EMAIL,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.NAME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.AVATARURL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.PREFERENCES,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.FCMTOKEN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.SNSENDPOINTSARN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.SUBSCRIPTIONARN,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.CREATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: User.UPDATEDAT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: User.NOTIFICATIONS,
      isRequired: false,
      ofModelName: 'Notifications',
      associatedKey: Notifications.USERID
    ));
  });
}

class _UserModelType extends amplify_core.ModelType<User> {
  const _UserModelType();
  
  @override
  User fromJson(Map<String, dynamic> jsonData) {
    return User.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'User';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [User] in your schema.
 */
class UserModelIdentifier implements amplify_core.ModelIdentifier<User> {
  final String id;

  /** Create an instance of UserModelIdentifier using [id] the primary key. */
  const UserModelIdentifier({
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
  String toString() => 'UserModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}