import 'package:honey/features/focus/presentation/providers/user_provider.dart';
import 'package:honey/features/shop/domain/entities/purchase_result_entity.dart';
import 'package:honey/features/shop/domain/entities/shop_item_entity.dart';
import 'package:honey/features/shop/domain/repositories/shop_repository.dart';
import 'package:honey/features/shop/domain/usecases/calculate_bonuses_usecase.dart';
import 'package:honey/features/shop/domain/usecases/equip_item_usecase.dart';
import 'package:honey/features/shop/domain/usecases/purchase_item_usecase.dart';
import 'package:honey/features/shop/data/repositories/shop_repository_impl.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'shop_provider.g.dart';

@riverpod
ShopRepository shopRepository(ShopRepositoryRef ref) {
  return ShopRepositoryImpl();
}

@riverpod
class Shop extends _$Shop {
  late final ShopRepository _repository;
  final _purchaseUseCase = PurchaseItemUseCase();
  final _equipUseCase = EquipItemUseCase();
  final _calculateBonusesUseCase = CalculateBonusesUseCase();

  @override
  Future<List<ShopItemEntity>> build() async {
    _repository = ref.watch(shopRepositoryProvider);
    return await _repository.getAllItems();
  }

  Future<void> _saveAllItems(List<ShopItemEntity> items) async {
    await _repository.saveAllItems(items);
    state = AsyncData(items);
  }

  Future<PurchaseResultEntity> purchase(String itemId) async {
    final items = state.maybeWhen(
      data: (items) => items,
      orElse: () => <ShopItemEntity>[],
    );

    final item = items.firstWhere((i) => i.id == itemId);
    final userState = ref.read(userProvider);

    int userCoins = await userState.maybeWhen(
      data: (user) => user.coins,
      orElse: () => 0,
    );

    final result = _purchaseUseCase.purchase(
      itemId: itemId,
      item: item,
      userCoins: userCoins,
    );

    if (result.success) {
      // Update user coins
      await ref.read(userProvider.notifier).spendCoins(result.coinsSpent);

      // Update item in shop
      final updatedItem = result.item!;
      final updatedItems =
          items.map((i) => i.id == itemId ? updatedItem : i).toList();

      await _saveAllItems(updatedItems);
    }

    return result;
  }

  Future<void> equip(String itemId) async {
    final items = state.maybeWhen(
      data: (items) => items,
      orElse: () => <ShopItemEntity>[],
    );

    final updatedItems = _equipUseCase.equip(
      itemId: itemId,
      allItems: items,
    );

    await _saveAllItems(updatedItems);
  }

  List<ShopItemEntity> get ownedItems {
    return state.maybeWhen(
      data: (items) => items.where((item) => item.owned).toList(),
      orElse: () => <ShopItemEntity>[],
    );
  }

  List<ShopItemEntity> get equippedItems {
    return state.maybeWhen(
      data: (items) => items.where((item) => item.equipped).toList(),
      orElse: () => <ShopItemEntity>[],
    );
  }

  BonusResult get currentBonuses {
    return _calculateBonusesUseCase.calculateBonuses(equippedItems);
  }
}
