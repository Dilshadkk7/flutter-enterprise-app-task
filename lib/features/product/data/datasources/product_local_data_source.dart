import 'package:flutter_enterprise_app/core/persistence/hive_service.dart';
import 'package:flutter_enterprise_app/features/product/data/models/product_model.dart';
import 'package:hive/hive.dart';

abstract class ProductLocalDataSource {
  Future<List<ProductModel>> getLastProducts();
  Future<void> cacheProducts(List<ProductModel> products);
}

// Caches product list locally using Hive [cite: 30]
class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final HiveService hiveService;

  ProductLocalDataSourceImpl({required this.hiveService});

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final box = await hiveService.openBox<ProductModel>(HiveService.productBoxName);
    await box.clear();
    await box.addAll(products);
  }

  @override
  Future<List<ProductModel>> getLastProducts() async {
    final box = await hiveService.openBox<ProductModel>(HiveService.productBoxName);
    return box.values.toList();
  }
}