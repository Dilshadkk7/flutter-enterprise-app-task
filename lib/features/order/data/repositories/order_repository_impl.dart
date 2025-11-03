import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/order/data/datasources/order_local_data_source.dart';
import 'package:flutter_enterprise_app/features/order/domain/entities/order.dart';
import 'package:flutter_enterprise_app/features/order/domain/repositories/order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderLocalDataSource localDataSource;

  OrderRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Order>>> getOrders() async {
    try {
      final orders = await localDataSource.getOrders();
      // Sort by date descending
      orders.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return Right(orders);
    } catch (e) {
      return Left(CacheFailure(message: 'Could not load order history.'));
    }
  }
}
