import 'package:flutter_enterprise_app/features/product/domain/entities/product.dart';
import 'package:hive/hive.dart';

part 'order.g.dart';

@HiveType(typeId: 2) // Ensure this typeId is unique
class Order extends HiveObject {
  @HiveField(0)
  final List<Product> items;

  @HiveField(1)
  final double totalPrice;

  @HiveField(2)
  final DateTime orderDate;

  Order({
    required this.items,
    required this.totalPrice,
    required this.orderDate,
  });
}
