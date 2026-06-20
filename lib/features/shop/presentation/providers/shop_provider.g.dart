// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopRepositoryHash() => r'65695bd06271d0907151585ce80ad51ba60fe8f1';

/// See also [shopRepository].
@ProviderFor(shopRepository)
final shopRepositoryProvider = AutoDisposeProvider<ShopRepository>.internal(
  shopRepository,
  name: r'shopRepositoryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$shopRepositoryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef ShopRepositoryRef = AutoDisposeProviderRef<ShopRepository>;
String _$shopHash() => r'49901e76b15b6f3a6709a2ab7a13e1127fdd0b25';

/// See also [Shop].
@ProviderFor(Shop)
final shopProvider =
    AutoDisposeAsyncNotifierProvider<Shop, List<ShopItemEntity>>.internal(
  Shop.new,
  name: r'shopProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$shopHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$Shop = AutoDisposeAsyncNotifier<List<ShopItemEntity>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
