// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postsListControllerHash() =>
    r'2fce7d72bc02e444d23cc61ff34ccb61f9520757';

/// See also [PostsListController].
@ProviderFor(PostsListController)
final postsListControllerProvider =
    AutoDisposeAsyncNotifierProvider<PostsListController, List<Post>>.internal(
  PostsListController.new,
  name: r'postsListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$postsListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PostsListController = AutoDisposeAsyncNotifier<List<Post>>;
String _$tagListControllerHash() => r'82473edb166238d22fe44a287039c871c76414d4';

/// See also [TagListController].
@ProviderFor(TagListController)
final tagListControllerProvider = AutoDisposeAsyncNotifierProvider<
    TagListController, List<TagCatalog>>.internal(
  TagListController.new,
  name: r'tagListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TagListController = AutoDisposeAsyncNotifier<List<TagCatalog>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
