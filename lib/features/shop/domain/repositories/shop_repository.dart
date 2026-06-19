import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';

abstract class ShopRepository {
  Future<List<ShopItemEntity>> getAllItems();
  Future<ShopItemEntity?> getItem(String id);
  Future<void> saveItem(ShopItemEntity item);
  Future<void> saveAllItems(List<ShopItemEntity> items);
  Future<List<ShopItemEntity>> getOwnedItems();
  Future<List<ShopItemEntity>> getEquippedItems();
}
