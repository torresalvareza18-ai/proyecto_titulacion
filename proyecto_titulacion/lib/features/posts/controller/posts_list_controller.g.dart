// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postsListControllerHash() =>
    r'fdadb277690334143becd8a8191da053d759ddcb';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$PostsListController
    extends BuildlessAutoDisposeAsyncNotifier<List<Post>> {
  late final String tagName;

  FutureOr<List<Post>> build(
    String tagName,
  );
}

/// See also [PostsListController].
@ProviderFor(PostsListController)
const postsListControllerProvider = PostsListControllerFamily();

/// See also [PostsListController].
class PostsListControllerFamily extends Family<AsyncValue<List<Post>>> {
  /// See also [PostsListController].
  const PostsListControllerFamily();

  /// See also [PostsListController].
  PostsListControllerProvider call(
    String tagName,
  ) {
    return PostsListControllerProvider(
      tagName,
    );
  }

  @override
  PostsListControllerProvider getProviderOverride(
    covariant PostsListControllerProvider provider,
  ) {
    return call(
      provider.tagName,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'postsListControllerProvider';
}

/// See also [PostsListController].
class PostsListControllerProvider extends AutoDisposeAsyncNotifierProviderImpl<
    PostsListController, List<Post>> {
  /// See also [PostsListController].
  PostsListControllerProvider(
    this.tagName,
  ) : super.internal(
          () => PostsListController()..tagName = tagName,
          from: postsListControllerProvider,
          name: r'postsListControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postsListControllerHash,
          dependencies: PostsListControllerFamily._dependencies,
          allTransitiveDependencies:
              PostsListControllerFamily._allTransitiveDependencies,
        );

  final String tagName;

  @override
  bool operator ==(Object other) {
    return other is PostsListControllerProvider && other.tagName == tagName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, tagName.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  FutureOr<List<Post>> runNotifierBuild(
    covariant PostsListController notifier,
  ) {
    return notifier.build(
      tagName,
    );
  }
}

String _$tagListControllerHash() => r'a371f22a8a4de5fa295f0dd7d521c653615beddc';

/// See also [TagListController].
@ProviderFor(TagListController)
final tagListControllerProvider =
    AsyncNotifierProvider<TagListController, List<TagCatalog>>.internal(
  TagListController.new,
  name: r'tagListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$tagListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$TagListController = AsyncNotifier<List<TagCatalog>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
