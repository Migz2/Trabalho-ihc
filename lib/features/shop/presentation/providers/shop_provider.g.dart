// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$shopRepositoryHash() => r'cf31e2c4f80d1e2c5e2e2c4f80d1e2c5e2e2c4f';

class ShopRepositoryProvider extends Provider<ShopRepository> {
  ShopRepositoryProvider() : super.internal(
        shopRepository,
        name: r'shopRepositoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$shopRepositoryHash,
      );

  @override
  ProxyProviderElement<ShopRepository> createElement() {
    return _ShopRepositoryProviderElement(this);
  }
}

class _ShopRepositoryProviderElement extends ProxyProviderElement<ShopRepository> {
  _ShopRepositoryProviderElement(super.provider);

  @override
  String get debugLabel => super.debugLabel ?? '(${provider.runtimeType})';
}

// ignore: unused_element
const shopRepositoryProvider = ShopRepositoryProvider();
String _$ShopHash() => r'5e2e2c4f80d1e2c5e2e2c4f80d1e2c5e2e2c4f';

/// See also [Shop].
class ShopProvider extends AsyncNotifierProvider<Shop, List<ShopItemEntity>> {
  ShopProvider() : super.internal(
        Shop.new,
        name: r'shopProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product') ? null : _$ShopHash,
      );

  @override
  AsyncNotifierProviderElement<Shop, List<ShopItemEntity>> createElement() {
    return _ShopProviderElement(this);
  }
}

class _ShopProviderElement
    extends AsyncNotifierProviderElement<Shop, List<ShopItemEntity>> {
  _ShopProviderElement(super.provider);

  @override
  String get debugLabel => super.debugLabel ?? '(${provider.runtimeType})';
}

// ignore: unused_element
const shopProvider = ShopProvider();
