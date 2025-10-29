import 'package:dartz/dartz.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/cart/domain/repositories/cart_repository.dart';

// Use case for placing a mock order
class PlaceOrder implements UseCase<void, NoParams> {
  final CartRepository repository;
  PlaceOrder(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.placeOrder();
  }
}