import 'package:flutter_enterprise_app/features/cart/data/models/cart_item_model.dart';
import 'package:flutter_enterprise_app/features/order/domain/entities/order.dart';
import 'package:flutter_enterprise_app/features/product/data/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

// Manages Hive initialization and boxes [cite: 30, 31]
class HiveService {
  // Box names
  static const String productBoxName = 'products';
  static const String cartBoxName = 'cart';
  static const String orderBoxName = 'orders';

  Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Register Adapters
    // These require generated files
    Hive.registerAdapter(ProductModelAdapter());
    Hive.registerAdapter(CartItemModelAdapter());
    Hive.registerAdapter(OrderAdapter());
  }

  Future<Box<T>> openBox<T>(String name) async {
    return await Hive.openBox<T>(name);
  }
}
