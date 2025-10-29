import 'package:dartz/dartz.dart';
import 'package:flutter_enterprise_app/core/utils/failure.dart';
import 'package:flutter_enterprise_app/core/utils/usecase.dart';
import 'package:flutter_enterprise_app/features/cart/domain/entities/cart.dart';
import 'package:flutter_enterprise_app/features/cart/domain/repositories/cart_repository.dart';

class GetCart implements UseCase<Cart, NoParams> {
  final CartRepository repository;
  GetCart(this.repository);

  @override
  Future<Either<Failure, Cart>> call(NoParams params) async {
    return await repository.getCart();
  }
}