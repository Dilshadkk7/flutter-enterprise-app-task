import 'package:flutter_enterprise_app/core/persistence/hive_service.dart';
import 'package:flutter_enterprise_app/features/order/domain/entities/order.dart';
import 'package:hive/hive.dart';

abstract class OrderLocalDataSource {
  Future<void> saveOrder(Order order);
  Future<List<Order>> getOrders();
}

class OrderLocalDataSourceImpl implements OrderLocalDataSource {
  final HiveService hiveService;

  OrderLocalDataSourceImpl({required this.hiveService});

  @override
  Future<void> saveOrder(Order order) async {
    final box = await hiveService.openBox<Order>(HiveService.orderBoxName);
    await box.add(order);
  }

  @override
  Future<List<Order>> getOrders() async {
    final box = await hiveService.openBox<Order>(HiveService.orderBoxName);
    return box.values.toList();
  }
}
