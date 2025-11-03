import 'package:dartz/dartz.dart' as dartz;
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/order/domain/entities/order.dart';
import 'package:flutter_enterprise_app/features/order/domain/repositories/order_repository.dart';

class GetOrders implements UseCase<List<Order>, NoParams> {
  final OrderRepository repository;

  GetOrders(this.repository);

  @override
  Future<dartz.Either<Failure, List<Order>>> call(NoParams params) async {
    return await repository.getOrders();
  }
}
