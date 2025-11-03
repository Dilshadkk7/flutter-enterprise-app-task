import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/features/order/domain/entities/order.dart';

abstract class OrderRepository {
  Future<dartz.Either<Failure, List<Order>>> getOrders();
}
