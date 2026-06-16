import 'package:honey/core/constants/hive_keys.dart';
import 'package:honey/core/errors/app_exceptions.dart';
import 'package:honey/core/services/hive_service.dart';
import 'package:honey/features/shop/data/datasources/shop_catalog.dart';
import 'package:honey/features/shop/data/models/shop_item_model.dart';
import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';
import 'package:honey/features/shop/domain/repositories/shop_repository.dart';

class ShopRepositoryImpl implements ShopRepository {
  static const String _tag = 'ShopRepositoryImpl';

  @override
  Future<List<ShopItemEntity>> getAllItems() async {
    try {
      final box = HiveService.getBox(HiveKeys.shopBox);

      // Check if catalog was initialized
      final initialized = box.get(HiveKeys.shopCatalogInitializedKey, defaultValue: false);

      if (!initialized) {
        // First time: populate with catalog
        final models = ShopCatalog.initialCatalog
            .map((entity) => ShopItemModel.fromEntity(entity))
            .toList();

        for (final model in models) {
          box.put(model.id, model);
        }
        await box.put(HiveKeys.shopCatalogInitializedKey, true);

        return ShopCatalog.initialCatalog;
      } else {
        // Load from Hive
        final allKeys = box.keys.where((k) => k is String && k != HiveKeys.shopCatalogInitializedKey);
        final models = <ShopItemModel>[];

        for (final key in allKeys) {
          final model = box.get(key) as ShopItemModel?;
          if (model != null) {
            models.add(model);
          }
        }

        // If no items found, populate from catalog
        if (models.isEmpty) {
          final catalogModels = ShopCatalog.initialCatalog
              .map((entity) => ShopItemModel.fromEntity(entity))
              .toList();

          for (final model in catalogModels) {
            box.put(model.id, model);
          }
          await box.put(HiveKeys.shopCatalogInitializedKey, true);

          return ShopCatalog.initialCatalog;
        }

        return models.map((m) => m.toEntity()).toList();
      }
    } catch (e) {
      throw HiveException('Failed to get all items: $e');
    }
  }

  @override
  Future<ShopItemEntity?> getItem(String id) async {
    try {
      final box = HiveService.getBox(HiveKeys.shopBox);
      final model = box.get(id) as ShopItemModel?;
      return model?.toEntity();
    } catch (e) {
      throw HiveException('Failed to get item $id: $e');
    }
  }

  @override
  Future<void> saveItem(ShopItemEntity item) async {
    try {
      final box = HiveService.getBox(HiveKeys.shopBox);
      final model = ShopItemModel.fromEntity(item);
      await box.put(item.id, model);
    } catch (e) {
      throw HiveException('Failed to save item: $e');
    }
  }

  @override
  Future<void> saveAllItems(List<ShopItemEntity> items) async {
    try {
      final box = HiveService.getBox(HiveKeys.shopBox);
      for (final item in items) {
        final model = ShopItemModel.fromEntity(item);
        await box.put(item.id, model);
      }
    } catch (e) {
      throw HiveException('Failed to save all items: $e');
    }
  }

  @override
  Future<List<ShopItemEntity>> getOwnedItems() async {
    final allItems = await getAllItems();
    return allItems.where((item) => item.owned).toList();
  }

  @override
  Future<List<ShopItemEntity>> getEquippedItems() async {
    final allItems = await getAllItems();
    return allItems.where((item) => item.equipped).toList();
  }
}
