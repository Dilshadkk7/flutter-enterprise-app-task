import 'package:flutter_enterprise_app/core/persistence/hive_service.dart';
import 'package:flutter_enterprise_app/features/cart/data/models/cart_item_model.dart';
import 'package:flutter_enterprise_app/features/product/data/models/product_model.dart';
import 'package:hive/hive.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
  Future<void> clearCart();
}

// Persists cart data between app restarts using Hive [cite: 31]
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final HiveService hiveService;

  CartLocalDataSourceImpl({required this.hiveService});

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final box = await hiveService.openBox<CartItemModel>(HiveService.cartBoxName);
    return box.values.toList();
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    final box = await hiveService.openBox<CartItemModel>(HiveService.cartBoxName);
    await box.clear();
    // Hive models must be stored by key
    for (var item in items) {
      await box.put(item.product.id, item);
    }
  }

  @override
  Future<void> clearCart() async {
    final box = await hiveService.openBox<CartItemModel>(HiveService.cartBoxName);
    await box.clear();
  }
}